# -----------------------------------------------------------
# Vorlesung 7: Fallstudie Fahrgastzahlen der S-Bahn Hamburg
# -----------------------------------------------------------
# Wir rechnen alle Schritte der Hausarbeit einmal vollständig an der Station
# Jungfernstieg vor. Für Ihre eigene Station gehen Sie genauso vor, treffen die
# Entscheidungen zur Aufbereitung aber selbst und begründen sie.
# Gliederung wie in der Hausarbeit:
#   A  Einlesen und Aufbereiten
#   B1 Verteilung   B2 Normalverteilung   B3 Streuungszerlegung
#   B4 Kreuztabelle B5 Korrelation        B6 Regression
#   C  Vergleich mit einer zweiten Station
# Es werden nur Verfahren aus Statistik 1 und dieser Veranstaltung verwendet.

# Pakete
# Einmalig installieren, falls noch nicht vorhanden: dazu das # vor install.packages entfernen
# install.packages("readr")
library(readr)
# install.packages("corrplot")
library(corrplot)


# -----------------------------------------------------------
# A1 Daten einlesen
# -----------------------------------------------------------
# Die Datei ist Latin-1-kodiert (wegen der Umlaute), Trenner ist das Semikolon,
# Dezimalzeichen das Komma. Eine Zeile ist ein Halt eines Zuges an einer Station.
passagiere <- read_delim("Data/Input/Passagierzahlen.csv",
                         delim = ";",
                         locale = locale(encoding = "latin1", decimal_mark = ","),
                         trim_ws = TRUE)
passagiere <- as.data.frame(passagiere)   # als einfacher data.frame weiterarbeiten
dim(passagiere)                            # 610.670 Zeilen, 8 Spalten
str(passagiere)
table(passagiere$strKurzbezeichnung)       # 7 Linien
length(unique(passagiere$Station))         # 69 Stationen

# Unsere Station
station <- "Jungfernstieg"   # in der Hausarbeit steht hier Ihre Station
halte <- passagiere[passagiere$Station == station, ]
nrow(halte)                  # 15.753 Zeilen


# -----------------------------------------------------------
# A2 Abgeleitete Variablen
# -----------------------------------------------------------
halte$ankunft <- as.POSIXct(halte$dtmIstAnkunftDatum, format = "%d.%m.%Y %H:%M:%S",
                            tz = "Europe/Berlin")
halte$abfahrt <- as.POSIXct(halte$dtmIstAbfahrtDatum, format = "%d.%m.%Y %H:%M:%S",
                            tz = "Europe/Berlin")
range(halte$ankunft)                       # 10.12.2016 bis 01.04.2017, also Winterhalbjahr

halte$stunde <- as.integer(format(halte$ankunft, "%H"))
wochentag_nr <- as.integer(format(halte$ankunft, "%u"))   # 1 = Montag bis 7 = Sonntag
halte$wochentagtyp <- factor(ifelse(wochentag_nr <= 5, "Werktag",
                                    ifelse(wochentag_nr == 6, "Samstag", "Sonntag")),
                             levels = c("Werktag", "Samstag", "Sonntag"))
halte$tageszeit <- cut(halte$stunde, breaks = c(-1, 5, 9, 15, 19, 23),
                       labels = c("Nacht", "Morgenspitze", "Tag", "Abendspitze", "Abend"))
# Nacht 0 bis 5 Uhr, Morgenspitze 6 bis 9 Uhr, Tag 10 bis 15 Uhr,
# Abendspitze 16 bis 19 Uhr, Abend 20 bis 23 Uhr
halte$haltezeit_s <- as.numeric(difftime(halte$abfahrt, halte$ankunft, units = "secs"))
table(halte$tageszeit)
table(halte$wochentagtyp)


# -----------------------------------------------------------
# A3 Plausibilität prüfen und entscheiden
# -----------------------------------------------------------
# Prüfung 1: vollständig identische Zeilen (Doppelerfassung)
sum(duplicated(halte))       # 0 am Jungfernstieg
halte <- halte[!duplicated(halte), ]

# Prüfung 2: derselbe Zug zur selben Zeit mehrfach, aber mit verschiedenen Zählwerten
schluessel <- paste(halte$Zugnr, halte$dtmIstAnkunftDatum)
sum(duplicated(schluessel))  # 161 Halte stehen mehrfach im Datensatz
mehrfach <- schluessel %in% schluessel[duplicated(schluessel)]
head(halte[mehrfach, c("Zugnr", "strKurzbezeichnung", "dtmIstAnkunftDatum",
                       "Einsteiger", "Aussteiger")][order(schluessel[mehrfach]), ], 6)
# Entscheidung und Begründung: S-Bahn-Züge fahren oft aus zwei oder drei gekoppelten
# Zugteilen. Wir nehmen an, dass jeder Zugteil getrennt gezählt wurde, und addieren
# die Zählwerte je Halt. Wer stattdessen von einer Doppelerfassung ausgeht, entfernt
# die zusätzlichen Zeilen. Beides ist vertretbar, wenn es begründet wird.
summen <- rowsum(halte[, c("Einsteiger", "Aussteiger")], schluessel)   # Summe je Halt
halte  <- halte[!duplicated(schluessel), ]                              # eine Zeile je Halt
halte[, c("Einsteiger", "Aussteiger")] <- summen[paste(halte$Zugnr, halte$dtmIstAnkunftDatum), ]
nrow(halte)                  # 15.592 Halte

# Prüfung 3: Halte ohne Einsteiger
mean(halte$Einsteiger == 0)  # 1,6 %
table(halte$tageszeit[halte$Einsteiger == 0])
# Die meisten Halte ohne Einsteiger liegen in der Morgenspitze: Morgens kommen die
# Menschen in der Innenstadt an, kaum jemand steigt ein. Plausibel, wir behalten sie.
# Hinweis für Ihre Station: An Endstationen enden Züge. In ankommende Züge, die dort
# enden, steigt niemand ein. Dort sind viele Nullwerte normal und kein Fehler.

# Prüfung 4: Haltezeiten
summary(halte$haltezeit_s)   # Median 47 Sekunden, Maximum 1.630 Sekunden
auffaellig <- halte$haltezeit_s < 0 | halte$haltezeit_s > 600
halte[auffaellig, c("Zugnr", "strKurzbezeichnung", "dtmIstAnkunftDatum",
                    "haltezeit_s", "Einsteiger")]
# Drei Halte dauern 12 bis 27 Minuten statt knapp einer Minute. Das deutet auf eine
# Betriebsstörung hin; die Zählwerte sind dann nicht mit normalen Halten vergleichbar.
# Entscheidung: Wir schließen Halte über 10 Minuten aus.
halte <- halte[!auffaellig, ]
nrow(halte)                  # 15.589 Halte

# Prüfung 5: sehr hohe Zählwerte
head(halte[order(-halte$Einsteiger), c("dtmIstAnkunftDatum", "strKurzbezeichnung",
                                       "Einsteiger")], 6)
# Die höchsten Werte (bis 357 Einsteiger) liegen an Adventssamstagen und im
# Weihnachtsgeschäft. Sie sind plausibel. Entscheidung: Wir behalten sie.


# -----------------------------------------------------------
# B1 Verteilung der Einsteiger
# -----------------------------------------------------------
e <- halte$Einsteiger
length(e)                    # n = 15.589
mean(e)                      # 31,91
median(e)                    # 25
sd(e)                        # 27,60
quantile(e)                  # Quartile 12, 25 und 44
IQR(e)                       # 32
quantile(e, probs = 0.9)     # 69

hist(e, freq = FALSE, breaks = 50, main = "Einsteiger je Halt am Jungfernstieg",
     xlab = "Einsteiger", ylab = "Dichte", col = "lightblue")
lines(density(e), col = "red", lwd = 2)
boxplot(e, horizontal = TRUE, main = "Einsteiger je Halt", xlab = "Einsteiger")
plot(ecdf(e), main = "Empirische Verteilungsfunktion der Einsteiger",
     xlab = "Einsteiger", ylab = "Anteil der Halte bis zu diesem Wert")
# Deutung: Die Verteilung ist rechtsschief. Der Mittelwert (31,9) liegt über dem Median
# (25), weil wenige sehr volle Halte ihn nach oben ziehen. Das 90-%-Quantil von 69 heißt:
# Bei jedem zehnten Halt steigen mehr als 69 Personen ein. Für die Planung von
# Zuglängen und Bahnsteigpersonal ist dieser Wert wichtiger als der Mittelwert.


# -----------------------------------------------------------
# B2 Die Normalverteilung als Modell
# -----------------------------------------------------------
mw  <- mean(e)
s   <- sd(e)
q90 <- unname(quantile(e, probs = 0.9))
1 - pnorm(q90, mean = mw, sd = s)      # Modell:  9,0 % über dem 90-%-Quantil
mean(e > q90)                          # Daten:   9,7 %
1 - pnorm(2 * q90, mean = mw, sd = s)  # Modell:  0,006 % über 138 Einsteigern
mean(e > 2 * q90)                      # Daten:   0,53 %
pnorm(0, mean = mw, sd = s)            # Modell: 12,4 % negative Einsteigerzahlen
plot(ecdf(e), main = "Einsteiger: Daten und Normalverteilung", xlab = "Einsteiger",
     ylab = "Anteil (Daten) bzw. Wahrscheinlichkeit (Modell)")
curve(pnorm(x, mean = mw, sd = s), add = TRUE, col = "red", lwd = 2)
# Deutung: In der Mitte passt die Normalverteilung ordentlich. Sehr volle Halte
# unterschätzt sie aber um fast das Hundertfache, und sie erlaubt negative Zählwerte.
# Für Zählwerte mit rechtsschiefer Verteilung ist sie kein gutes Modell.


# -----------------------------------------------------------
# B3 Streuungszerlegung nach Tageszeit (Kern der Varianzanalyse)
# -----------------------------------------------------------
tapply(e, halte$tageszeit, mean)                # 12,5  21,6  32,8  55,8  23,9
tapply(halte$Aussteiger, halte$tageszeit, mean) # 16,4  43,6  35,7  35,0  14,2
boxplot(Einsteiger ~ tageszeit, data = halte, main = "Einsteiger nach Tageszeit",
        xlab = "", ylab = "Einsteiger")
P1 <- aov(Einsteiger ~ tageszeit, data = halte)
summary(P1)   # auf der Ebene der Streuungen lesen, wie in VL4: Sum Sq, Mean Sq, F value
sq <- summary(P1)[[1]][["Sum Sq"]]
sq[1] / sum(sq)   # eta2 = 0,25: Die Tageszeit erklärt ein Viertel der Streuung
# Deutung: Am Jungfernstieg steigen morgens wenige ein (21,6) und viele aus (43,6):
# Die Menschen kommen in die Innenstadt. In der Abendspitze kehrt sich das um
# (55,8 Einsteiger). Drei Viertel der Streuung liegen innerhalb der Tageszeiten.
# Pr(>F) und Sterne gehören zum F-Test der induktiven Statistik und werden nicht gedeutet.


# -----------------------------------------------------------
# B4 Kreuztabelle: Auslastung nach Wochentagtyp
# -----------------------------------------------------------
auslastung <- cut(e, breaks = c(-1, median(e), q90, Inf),
                  labels = c("gering", "mittel", "hoch"))
# gering: bis zum Median, mittel: bis zum 90-%-Quantil, hoch: darüber
tab <- table(halte$wochentagtyp, auslastung)
tab
round(prop.table(tab, margin = 1) * 100)   # Zeilenprozente
# Hohe Auslastung: werktags 12 %, samstags 7 %, sonntags 1 % der Halte.

n        <- sum(tab)
erwartet <- outer(rowSums(tab), colSums(tab)) / n
chi2     <- sum((tab - erwartet)^2 / erwartet)
chi2     # 1.157,8
k        <- min(dim(tab))
C_korr   <- sqrt(chi2 / (chi2 + n)) / sqrt((k - 1) / k)
C_korr   # 0,32: schwacher Zusammenhang nach der Faustregel aus VL3
# Deutung: Werktags ist hohe Auslastung häufiger, als bei Unabhängigkeit zu erwarten
# wäre, sonntags viel seltener. Insgesamt ist der Zusammenhang aber schwach.


# -----------------------------------------------------------
# B5 Korrelation
# -----------------------------------------------------------
variablen <- halte[, c("Einsteiger", "Aussteiger", "haltezeit_s", "stunde")]
round(cor(variablen), 2)                       # Pearson
round(cor(variablen, method = "spearman"), 2)  # Spearman
corrplot(cor(variablen, method = "spearman"), method = "circle")
# Einsteiger und Aussteiger: Pearson 0,28, Spearman 0,39. Einsteiger und Stunde: 0,27
# bzw. 0,30. Haltezeit: praktisch kein Zusammenhang. Nach der Faustregel alles schwach.
# Spearman liegt höher, weil die Zählwerte schief verteilt sind; Ränge sind robuster.
# Die Stunde hängt nicht linear mit den Einsteigern zusammen (Spitze am Abend, Tal in
# der Nacht). Ein Korrelationskoeffizient erfasst so ein Tagesprofil nur schlecht.


# -----------------------------------------------------------
# B6 Regression
# -----------------------------------------------------------
modell_einfach <- lm(Einsteiger ~ Aussteiger, data = halte)
coef(modell_einfach)                  # 22,68 und 0,29
summary(modell_einfach)$r.squared     # 0,08
plot(halte$Aussteiger, halte$Einsteiger, xlab = "Aussteiger", ylab = "Einsteiger",
     main = "Einsteiger und Aussteiger je Halt", col = rgb(0, 0, 1, 0.2))
abline(modell_einfach, col = "red", lwd = 2)
# Je Aussteiger steigen im Mittel 0,29 Personen mehr ein. Die Aussteiger allein
# erklären aber nur 8 % der Streuung.

modell_erweitert <- lm(Einsteiger ~ Aussteiger + tageszeit + wochentagtyp, data = halte)
summary(modell_erweitert)             # nur Estimate und R-squared lesen, wie in VL5
summary(modell_erweitert)$r.squared   # 0,34
coef(modell_erweitert)
# Deutung der Koeffizienten (Vergleich jeweils mit Nacht bzw. Werktag):
#   Abendspitze +37,49 Einsteiger je Halt, Tag +14,55, Sonntag -15,56, Samstag -5,20.
# Tageszeit und Wochentag erhöhen R² von 0,08 auf 0,34.

plot(fitted(modell_erweitert), halte$Einsteiger,
     xlab = "Vorhergesagte Einsteiger", ylab = "Tatsächliche Einsteiger",
     main = "Beobachtete gegen vorhergesagte Einsteiger", col = rgb(0, 0, 1, 0.2))
abline(0, 1, col = "red", lwd = 2)
abweichung <- halte$Einsteiger - fitted(modell_erweitert)
head(halte[order(-abs(abweichung)), c("dtmIstAnkunftDatum", "Einsteiger")], 5)
# Am weitesten daneben liegt das Modell an Adventssamstagen: am 17.12.2016 um 18:38 Uhr
# 357 statt vorhergesagter 78 Einsteiger. Ereignisse wie das Weihnachtsgeschäft
# kennt das Modell nicht.


# -----------------------------------------------------------
# C Vergleich mit einer zweiten Station
# -----------------------------------------------------------
# Damit wir A nicht Zeile für Zeile wiederholen, fassen wir die Aufbereitung in einer
# Funktion zusammen (Funktionen kennen Sie aus VL1). Sie enthält dieselben
# Entscheidungen wie oben.
aufbereiten <- function(daten, name) {
  h <- daten[daten$Station == name, ]
  h <- h[!duplicated(h), ]
  s <- paste(h$Zugnr, h$dtmIstAnkunftDatum)
  summen <- rowsum(h[, c("Einsteiger", "Aussteiger")], s)
  h <- h[!duplicated(s), ]
  h[, c("Einsteiger", "Aussteiger")] <- summen[paste(h$Zugnr, h$dtmIstAnkunftDatum), ]
  h$ankunft <- as.POSIXct(h$dtmIstAnkunftDatum, format = "%d.%m.%Y %H:%M:%S", tz = "Europe/Berlin")
  h$abfahrt <- as.POSIXct(h$dtmIstAbfahrtDatum, format = "%d.%m.%Y %H:%M:%S", tz = "Europe/Berlin")
  h$stunde  <- as.integer(format(h$ankunft, "%H"))
  w <- as.integer(format(h$ankunft, "%u"))
  h$wochentagtyp <- factor(ifelse(w <= 5, "Werktag", ifelse(w == 6, "Samstag", "Sonntag")),
                           levels = c("Werktag", "Samstag", "Sonntag"))
  h$tageszeit <- cut(h$stunde, breaks = c(-1, 5, 9, 15, 19, 23),
                     labels = c("Nacht", "Morgenspitze", "Tag", "Abendspitze", "Abend"))
  h$haltezeit_s <- as.numeric(difftime(h$abfahrt, h$ankunft, units = "secs"))
  h[h$haltezeit_s >= 0 & h$haltezeit_s <= 600, ]
}

kennzahlen <- function(h) {
  x   <- h$Einsteiger
  sq  <- summary(aov(Einsteiger ~ tageszeit, data = h))[[1]][["Sum Sq"]]
  tab <- table(h$wochentagtyp, cut(x, breaks = c(-1, median(x), quantile(x, 0.9), Inf)))
  erw <- outer(rowSums(tab), colSums(tab)) / sum(tab)
  chi <- sum((tab - erw)^2 / erw)
  k   <- min(dim(tab))
  c(n = nrow(h), Mittelwert = mean(x), Median = median(x),
    Q90 = unname(quantile(x, 0.9)), eta2 = sq[1] / sum(sq),
    C_korr = sqrt(chi / (chi + sum(tab))) / sqrt((k - 1) / k),
    R2 = summary(lm(Einsteiger ~ Aussteiger + tageszeit + wochentagtyp, data = h))$r.squared)
}

hbf <- aufbereiten(passagiere, "Hauptbahnhof")
round(rbind(Jungfernstieg = kennzahlen(halte), Hauptbahnhof = kennzahlen(hbf)), 2)
#                n  Mittelwert Median Q90  eta2  C_korr  R2
# Jungfernstieg  15.589  31,91    25    69  0,25   0,32   0,34
# Hauptbahnhof   31.211  62,49    53   123  0,08   0,22   0,11

profil_jf  <- tapply(halte$Einsteiger, halte$stunde, mean)
profil_hbf <- tapply(hbf$Einsteiger, hbf$stunde, mean)
plot(0:23, profil_hbf, type = "l", col = "blue", lwd = 2, ylim = c(0, max(profil_hbf)),
     xlab = "Stunde", ylab = "Mittlere Einsteiger je Halt", main = "Tagesprofil der Einsteiger")
lines(0:23, profil_jf, col = "red", lwd = 2)
legend("topleft", legend = c("Hauptbahnhof", "Jungfernstieg"), col = c("blue", "red"), lwd = 2)
# Deutung: Am Hauptbahnhof steigen doppelt so viele Menschen ein wie am Jungfernstieg,
# und das über den ganzen Tag verteilt. Als Umsteigeknoten hat er keine ausgeprägten
# Spitzen; die Tageszeit erklärt dort nur 8 % der Streuung, am Jungfernstieg 25 %.
# Der Jungfernstieg ist ein Ziel in der Innenstadt: morgens kommt man an, abends fährt
# man ab. Grenzen der Daten: Winterhalbjahr, keine Fahrtrichtung, Zählung nur in den
# Zügen mit Zählgeräten.
