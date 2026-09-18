# Importieren des Datensatzes
# VORLESUNG 3

# Einmalig installieren, falls noch nicht vorhanden: dazu das # vor install.packages entfernen
# install.packages("readr")
library(readr)
file_path <- "Data/Input/Mietwohnungen2016.csv"

Mietwohnungen2016 <- read_delim(file_path, 
                                delim = ";", 
                                escape_double = FALSE, 
                                locale = locale(decimal_mark = ","), 
                                trim_ws = TRUE)
View(Mietwohnungen2016)

### gefühl für die Daten bekommen
head(Mietwohnungen2016)
str(Mietwohnungen2016)
unique(Mietwohnungen2016$Stadtteil)

# zeichnen einiger Grafiken zum besseren verständnis

plot(Mietwohnungen2016$Fläche, Mietwohnungen2016$Miete)
# das bild zeigt einen Scatterplot und dieser weißt auf einen Zusammenhang hin
# Pearsonsche Kor.
cor(Mietwohnungen2016$Fläche, Mietwohnungen2016$Miete, method = "pearson")
cor(Mietwohnungen2016$Fläche, Mietwohnungen2016$Miete, method = "spearman")

# Wiederholung der Faustregel aus VL3 (angelehnt an Fahrmeir et al.):
#   unter 0,5          schwache Korrelation
#   0,5 bis unter 0,8  mittlere Korrelation
#   0,8 bis 1          starke Korrelation
# Fläche und Miete: r = 0,95 (Pearson) und 0,94 (Spearman), also eine starke Korrelation.
# Das Vorzeichen zeigt die Richtung: positiv = gleichläufig, negativ = gegenläufig.

# Exkurs: Könnte der Zusammenhang auch Zufall sein?
# Idee: Wir mischen die Mieten zufällig neu (sample). Dann gehört keine Miete mehr
# zu ihrer Wohnung, jeder echte Zusammenhang ist zerstört. Das wiederholen wir
# 1.000-mal und sehen, wie groß die Korrelation allein durch Zufall wird.
set.seed(1)
zufall <- replicate(1000, cor(Mietwohnungen2016$Fläche, sample(Mietwohnungen2016$Miete)))
range(zufall)   # etwa -0,06 bis 0,05
hist(zufall, xlim = c(-1, 1), main = "Korrelationen nach zufälligem Mischen",
     xlab = "Korrelation")
abline(v = cor(Mietwohnungen2016$Fläche, Mietwohnungen2016$Miete), col = "red", lwd = 2)
# Die beobachtete Korrelation (0,95, rote Linie) liegt weit außerhalb der Zufallswerte.
# Zufall ist als Erklärung deshalb nicht plausibel.

# Wie groß Zufallswerte werden können, hängt von der Anzahl n der Beobachtungen ab.
# Beispiel: Ost-West-Lage und Miete, im Gesamtdatensatz r = -0,31.
# Wir ziehen eine kleine Stichprobe und mischen dort.
n_stichprobe <- 20   # anschließend mit 50 und 300 wiederholen
set.seed(42)
stichprobe <- Mietwohnungen2016[sample(nrow(Mietwohnungen2016), n_stichprobe), ]
r_beob   <- cor(stichprobe$WestOst, stichprobe$Miete)
r_zufall <- replicate(1000, cor(stichprobe$WestOst, sample(stichprobe$Miete)))
r_beob
quantile(r_zufall, probs = c(0.025, 0.975))   # Bereich, in dem 95 % der Zufallswerte liegen
# n = 20:  beobachtet -0,09, Zufallsbereich -0,43 bis 0,47: nicht von Zufall zu unterscheiden
# n = 50:  beobachtet -0,25, Zufallsbereich -0,26 bis 0,30: Grenzfall
# n = 300: beobachtet -0,29, Zufallsbereich -0,12 bis 0,12: kaum durch Zufall erklärbar

# Faustregel zum Merken: Zufallskorrelationen liegen meist innerhalb von +/- 2 / Wurzel(n).
2 / sqrt(c(20, 50, 300, nrow(Mietwohnungen2016)))   # 0,45  0,28  0,12  0,03
# Ausblick: In der induktiven Statistik heißt der Anteil der Mischungen, die
# mindestens so extrem sind wie der beobachtete Wert, p-Wert.


# gibt es zwischen den Zimmern und der Miete einen Zusammenhang
plot(Mietwohnungen2016$Zimmer, Mietwohnungen2016$Miete)
# Spearman Kor.
# spearman immer wenn ich Klassen oder Ordinale Merkmale hab
cor(Mietwohnungen2016$Zimmer, Mietwohnungen2016$Miete, method = "spearman")# 0,83: starke Korrelation
boxplot(  Mietwohnungen2016$Miete ~  Mietwohnungen2016$Zimmer, range = 0 ) # hier wird im Boxplot die Spannweite genommen
boxplot(  Mietwohnungen2016$Miete ~  Mietwohnungen2016$Zimmer)

hist(  Mietwohnungen2016$Fläche) # Histogramm der Fläche
hist(  Mietwohnungen2016$Miete) # Histogramm der Miete

# Wiederholung: einfache deskriptive Statistik
stripchart(Mietwohnungen2016$Miete ~  Mietwohnungen2016$Zimmer)
plot(Mietwohnungen2016$Miete, Mietwohnungen2016$Zimmer)

mean( Mietwohnungen2016$Miete)
median( Mietwohnungen2016$Miete)

var( Mietwohnungen2016$Miete)
sqrt(var( Mietwohnungen2016$Miete)) # wurzel aus der varianz , sqrt - quadratwurzel

quantile( Mietwohnungen2016$Miete, probs = 0.25)
quantile( Mietwohnungen2016$Miete, probs = 0.75)

summary(Mietwohnungen2016)


# 1. Beispiel: Streuungszerlegung, Miete nach Zimmerzahl
# Wie viel der Mietstreuung erklärt die Zimmerzahl?
# Die Gesamtstreuung zerfällt in die Streuung ZWISCHEN den Gruppenmittelwerten
# und die Streuung INNERHALB der Gruppen.
miete  <- Mietwohnungen2016$Miete
zimmer <- Mietwohnungen2016$Zimmer
gesamt_mw  <- mean(miete)
gruppen_mw <- tapply(miete, zimmer, mean)   # mittlere Miete je Zimmerzahl
gruppen_n  <- table(zimmer)
sq_gesamt    <- sum((miete - gesamt_mw)^2)
sq_zwischen  <- sum(gruppen_n * (gruppen_mw - gesamt_mw)^2)
sq_innerhalb <- sq_gesamt - sq_zwischen
eta2 <- sq_zwischen / sq_gesamt
eta2   # 0,66: Die Zimmerzahl erklärt 66 % der Streuung der Mieten.

# Dieselbe Zerlegung mit R: aov() steht für "analysis of variance", die Varianzanalyse.
# Sie beruht genau auf dieser Streuungszerlegung.
P1 <- aov(miete ~ factor(zimmer))   # factor(): die Zimmerzahl als Gruppe behandeln
summary(P1)
# So lesen wir die Ausgabe auf der Ebene der Streuungen:
#   Sum Sq, Zeile factor(zimmer): Streuung ZWISCHEN den Gruppen  (= sq_zwischen)
#   Sum Sq, Zeile Residuals:      Streuung INNERHALB der Gruppen (= sq_innerhalb)
#   Df:      Freiheitsgrade (Anzahl Gruppen - 1 bzw. n - Anzahl Gruppen)
#   Mean Sq: Sum Sq geteilt durch Df, also eine mittlere Streuung,
#            ähnlich wie die Varianz mit n - 1 im Nenner
#   F value: Verhältnis der mittleren Streuungen, zwischen / innerhalb. Hier etwa 2.018:
#            Die Gruppenmittelwerte streuen weit stärker als die Mieten innerhalb der Gruppen.
#            F wächst mit n; für die Stärke des Zusammenhangs nutzen wir deshalb eta2.
#   Pr(>F) und Sterne: gehören zum F-Test der induktiven Statistik, hier nicht gedeutet.
sq <- summary(P1)[[1]][["Sum Sq"]]
sq[1] / sum(sq)   # eta2 aus der aov-Ausgabe: 0,66, wie von Hand berechnet

# 2. Beispiel: Stadtteil, diesmal direkt mit aov()
stripchart(Mietwohnungen2016$Miete ~  Mietwohnungen2016$Stadtteil)
boxplot(  Mietwohnungen2016$Miete ~  Mietwohnungen2016$Stadtteil)
P2 <- aov(miete ~ factor(Mietwohnungen2016$Stadtteil))
summary(P2)
sq <- summary(P2)[[1]][["Sum Sq"]]
sq[1] / sum(sq)   # 0,18: Der Stadtteil erklärt 18 % der Mietstreuung.
# F value etwa 51: deutlich kleiner als bei der Zimmerzahl, passend zum kleineren eta2.


#---------------
# zurück zu Grafiken und der Erstellung eines Boxplots mit Dichte

# Histgramm, ECDF

hist(Mietwohnungen2016$Fläche, freq = FALSE , breaks = 25)
lines(density(Mietwohnungen2016$Fläche), type = "l" , col = 3, lwd = 2) # das ist die Kerndichteschätzung
lines(x = seq(0,320, by = 0.5),
      dnorm(seq(0,320, by = 0.5), 
            mean=  mean(Mietwohnungen2016$Fläche),
            sd= sd(Mietwohnungen2016$Fläche)
      ), col= 4 , lwd = 2
) # dichte der Normalverteilung zum Vergleich

plot(ecdf(Mietwohnungen2016$Fläche))
lines(ecdf(rnorm(10000, mean = mean(Mietwohnungen2016$Fläche), sd = sd(Mietwohnungen2016$Fläche))),col=2)
# diese bilder zeigen einmal die empirische Verteilungsfunktion
# das 2. zeigt die Verteilungsfunktion einer Normalverteilung mit:
# Mittelwert = Mittelwert(Fläche)
# Standardabweichung = Sd(Fläche)
# rnorm erzeugt zufällige normalverteilte werte r´(r)norm heißt randomised



# wie sieht die Standard-Normalverteilung aus
set.seed(1234) # wir setzen einen fixpunkt, so dass unsere Zufallszahlen immer gleich sind
hist(rnorm(10000), freq = FALSE)
lines(density(rnorm(1000)), col= 2 , lwd = 2) # dichte der Normalverteilung aus den zufälligen Zahlen 
# mit density bekomnme ich eine durchgezogene Linie
lines(seq(-5,5, by = 0.01),dnorm(seq(-5,5, by = 0.01)), col= 4 , lwd = 2)
# dnorm gibt mir die Dichte der Normalverteilung an das ist dei theoretische Dichte
# hier seht ihr das mit steigendem n die Dichte immer näher zur theoretischen Dichte der Normalverteilung konvergiert


# Zusammenhang zweier kategorialer Merkmale: die Kreuztabelle
# Kreuztabellen brauchen kategoriale Merkmale. Die metrische Miete teilen wir in Quartile.
# (Mit der Miete selbst entstünde eine Tabelle mit 4.136 Spalten, eine je Mietbetrag.)
miete_klasse <- cut(Mietwohnungen2016$Miete,
                    breaks = quantile(Mietwohnungen2016$Miete, probs = 0:4 / 4),
                    include.lowest = TRUE, labels = c("Q1", "Q2", "Q3", "Q4"))
tab <- table(Mietwohnungen2016$Stadtteil, miete_klasse)
round(prop.table(tab, margin = 1) * 100)   # Zeilenprozente: Mietklassen je Stadtteil
# Beispiel: In "Zeh" liegen 59 % der Wohnungen im teuersten Quartil, in "Hel" keine.

# Chi-Quadrat-Größe: Abstand zwischen den beobachteten Häufigkeiten und den
# Häufigkeiten, die bei Unabhängigkeit zu erwarten wären.
n        <- sum(tab)
erwartet <- outer(rowSums(tab), colSums(tab)) / n
chi2     <- sum((tab - erwartet)^2 / erwartet)
chi2   # 900,8; wächst mit n und ist deshalb allein schwer zu deuten

# Kontingenzkoeffizient nach Pearson und seine Korrektur auf den Bereich 0 bis 1
k      <- min(dim(tab))                # kleinere Anzahl von Zeilen oder Spalten
C      <- sqrt(chi2 / (chi2 + n))      # 0,39
C_max  <- sqrt((k - 1) / k)            # größtmöglicher Wert bei dieser Tabellengröße: 0,87
C_korr <- C / C_max
C_korr   # 0,45: 0 = kein Zusammenhang, 1 = vollständiger Zusammenhang
# Nach der Faustregel oben (für C_korr sinngemäß übertragen) ein schwacher
# Zusammenhang, knapp an der Grenze zum mittleren.

# Einordnung: Die Chi-Quadrat-Größe ist auch die Grundlage des Chi-Quadrat-Tests.
# Den Test und seinen p-Wert behandeln wir nicht, sie gehören zur induktiven Statistik.
