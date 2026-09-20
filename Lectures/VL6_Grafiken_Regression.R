# Notwendige Bibliotheken laden
# Einmalig installieren, falls noch nicht vorhanden: dazu das # vor install.packages entfernen
# install.packages("readr")
library(readr)
# install.packages("ggplot2")
library(ggplot2)
# install.packages("dplyr")
library(dplyr)
# install.packages("corrplot")
library(corrplot)

# 1. Datensatz einlesen
file_path <- "Data/Input/Mietwohnungen2016.csv" # Pfad zur Datei anpassen
Mietwohnungen2016 <- read_delim(file_path,
                                delim = ";",
                                escape_double = FALSE,
                                locale = locale(decimal_mark = ","),
                                trim_ws = TRUE)

# 2. Erste Dateninspektion
# Zeigt die ersten Zeilen des Datensatzes
head(Mietwohnungen2016)

# Gibt eine Übersicht über die Struktur des Datensatzes
str(Mietwohnungen2016)

# Zeigt eine Zusammenfassung der Daten (Min, Max, Median, Mean, etc.)
summary(Mietwohnungen2016)

# 3. Fehlende Werte überprüfen
# Anzahl der fehlenden Werte in jeder Spalte
colSums(is.na(Mietwohnungen2016)) # hier fehlen keine Werte

# 4. Verteilung der numerischen Variablen visualisieren
# Histogramm für Mietpreise
ggplot(Mietwohnungen2016, aes(x = Miete)) +
  geom_histogram(binwidth = 50, fill = "blue", color = "black", alpha = 0.7) +
  ggtitle("Histogramm der Mietpreise") +
  xlab("Mietpreise (Euro)") +
  ylab("Häufigkeit")

hist(Mietwohnungen2016$Miete, freq = TRUE , breaks = 50, col = "blue",  # es wird die absolute Häufigkeit berechnet
     border = "black",
     main = "Histogramm der Mietpreise",
     xlab = "Mietpreise (Euro)",
     ylab = "Absolute Häufigkeit",
     ylim = c(0, 400))

# Boxplot für Mietpreise
ggplot(Mietwohnungen2016, aes(y = Miete)) +
  geom_boxplot(fill = "orange", color = "black") +
  ggtitle("Boxplot der Mietpreise") +
  ylab("Mietpreise (Euro)")

boxplot(Mietwohnungen2016$Miete, horizontal = FALSE, col = "orange", border = "black",
        main = "Boxplot der Mietpreise",
        ylab = "Mietpreise (Euro)") # vertikaler Boxplot: die Miete steht auf der y-Achse

# Boxplot für Mietpreise nach Stadtteilen
ggplot(Mietwohnungen2016, aes(y = Miete, x = Stadtteil)) +
  geom_boxplot(fill = "orange", color = "black") +
  ggtitle("Boxplot der Mietpreise nach Stadtteilen") +
  xlab("Stadtteile") +
  ylab("Mietpreise (Euro)") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5)) # Stadtteilnamen senkrecht, damit sie lesbar bleiben

boxplot(Miete ~ Stadtteil, data = Mietwohnungen2016, horizontal = FALSE, col = "orange", border = "black",
        main = "Boxplot der Mietpreise nach Stadtteilen",
        xlab = "Stadtteile",
        ylab = "Mietpreise (Euro)",
        las = 2) # las = 2: Achsenbeschriftung senkrecht

# 5. Empirische kumulative Verteilungsfunktion (ECDF)
# Die ECDF zeigt Anteile in den Daten (kumulierte relative Häufigkeiten), keine
# Wahrscheinlichkeiten. Die Verteilungsfunktion einer Wahrscheinlichkeitsverteilung behandelt VL6.
ggplot(Mietwohnungen2016, aes(x = Miete)) +
  stat_ecdf(geom = "step") +
  ggtitle("Empirische kumulative Verteilungsfunktion der Mietpreise") +
  xlab("Mietpreise (Euro)") +
  ylab("Anteil der Wohnungen bis zu dieser Miete")

plot(ecdf(Mietwohnungen2016$Miete),
     main = "Empirische Verteilungsfunktion der Mietpreise",
     xlab = "Mietpreise (Euro)", ylab = "Anteil der Wohnungen bis zu dieser Miete")

# 6. Zusammenhang zwischen Zimmeranzahl und Mietpreise
# Scatterplot
# Die Zimmerzahl hat nur sechs Werte, die Punkte lägen genau übereinander.
# geom_jitter() verschiebt sie waagerecht ein wenig, damit man die Dichte sieht.
ggplot(Mietwohnungen2016, aes(x = Zimmer, y = Miete)) +
  geom_jitter(width = 0.2, height = 0, color = "darkgreen", alpha = 0.3) +
  ggtitle("Zusammenhang zwischen Zimmeranzahl und Mietpreise") +
  xlab("Zimmeranzahl") +
  ylab("Mietpreise (Euro)")

plot(jitter(Mietwohnungen2016$Zimmer), Mietwohnungen2016$Miete,
     xlab = "Zimmeranzahl (leicht verschoben)", ylab = "Mietpreise (Euro)")

# Korrelation zwischen Zimmeranzahl und Mietpreisen
cor(Mietwohnungen2016$Zimmer, Mietwohnungen2016$Miete)                       # Pearson: 0,79
cor(Mietwohnungen2016$Zimmer, Mietwohnungen2016$Miete, method = "spearman")  # Spearman: 0,83
# Faustregel aus VL3 (angelehnt an Fahrmeir et al.): unter 0,5 schwach,
# 0,5 bis unter 0,8 mittel, ab 0,8 stark.
# Pearson 0,79: mittlere Korrelation, knapp unter stark. Spearman 0,83: stark.
# Die Zimmerzahl hat nur sechs Stufen; Spearman nutzt die Rangfolge und passt hier gut.

# 7. Kreuztabelle: Stadtteil und Zimmeranzahl (Wiederholung aus VL4)
# Häufigkeitstabelle für Stadtteil und Zimmeranzahl
table_stadtteil_zimmer <- table(Mietwohnungen2016$Stadtteil, Mietwohnungen2016$Zimmer)
round(prop.table(table_stadtteil_zimmer, margin = 1) * 100)   # Zeilenprozente: Zimmerzahl je Stadtteil

# Chi-Quadrat-Größe und korrigierter Kontingenzkoeffizient, wie in VL4
n        <- sum(table_stadtteil_zimmer)
erwartet <- outer(rowSums(table_stadtteil_zimmer), colSums(table_stadtteil_zimmer)) / n
chi2     <- sum((table_stadtteil_zimmer - erwartet)^2 / erwartet)
chi2     # 974,0
k        <- min(dim(table_stadtteil_zimmer))
C_korr   <- sqrt(chi2 / (chi2 + n)) / sqrt((k - 1) / k)
C_korr   # 0,44: schwacher Zusammenhang, knapp an der Grenze zum mittleren
# Einordnung: chisq.test() würde dieselbe Chi-Quadrat-Größe liefern, dazu einen p-Wert
# aus der induktiven Statistik. Den brauchen wir hier nicht.

# Zweiter Teil: Streuungszerlegung und Regression
# 8. Streuungszerlegung (Kern der Varianzanalyse) für den Quadratmeterpreis, vgl. VL4
Mietwohnungen2016$qm_preis <- Mietwohnungen2016$Miete / Mietwohnungen2016$Fläche
tapply(Mietwohnungen2016$qm_preis, Mietwohnungen2016$Lage, mean)  # 6,98  8,33  9,78 Euro je m²

P3 <- aov(qm_preis ~ factor(Lage), data = Mietwohnungen2016)
summary(P3)   # auf der Ebene der Streuungen lesen, wie in VL4: Sum Sq, Mean Sq, F value
sq <- summary(P3)[[1]][["Sum Sq"]]
sq[1] / sum(sq)   # eta2 = 0,51: Die Lage erklärt die Hälfte der Streuung der Quadratmeterpreise

P4 <- aov(qm_preis ~ factor(Stadtteil), data = Mietwohnungen2016)
summary(P4)
sq <- summary(P4)[[1]][["Sum Sq"]]
sq[1] / sum(sq)   # eta2 = 0,32; bei der Miete selbst waren es nur 0,18 (VL4)
# Der Stadtteil erklärt den Preis je Quadratmeter besser als die Miete.
# Grund: Die Miete hängt stark von der Wohnungsgröße ab, und die ist je Stadtteil verschieden.
# Pr(>F) und Sterne gehören zum F-Test der induktiven Statistik und werden nicht gedeutet.

# 9. Einfache lineare Regression
# Ziel: die Miete durch die Zimmeranzahl beschreiben
linear_model <- lm(Miete ~ Zimmer, data = Mietwohnungen2016)

# Zusammenfassung des Modells
summary(linear_model)
# So lesen wir die Ausgabe:
#   Estimate: Achsenabschnitt (-6,18 Euro) und Steigung (259,61 Euro je Zimmer)
#   Multiple R-squared: 0,63 = Anteil der Streuung der Mieten, den das Modell erklärt
#   Std. Error, t value, Pr(>|t|), Sterne und die F-Statistik in der letzten Zeile
#   gehören zur induktiven Statistik und werden hier nicht gedeutet.

# Vergleich mit der Korrelation: Bei einer erklärenden Variablen gilt R² = r².
cor(Mietwohnungen2016$Miete, Mietwohnungen2016$Zimmer)     # 0,79
cor(Mietwohnungen2016$Miete, Mietwohnungen2016$Zimmer)^2   # 0,63

# Visualisierung der Regressionsgerade
# se = FALSE: kein graues Band. Das Band ist ein Konfidenzband aus der induktiven Statistik.
ggplot(Mietwohnungen2016, aes(x = Zimmer, y = Miete)) +
  geom_jitter(width = 0.2, height = 0, color = "blue", alpha = 0.3) +
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  ggtitle("Lineare Regression: Mietpreise vs. Zimmeranzahl") +
  xlab("Zimmeranzahl") +
  ylab("Mietpreise (Euro)")

# Welche Variable beschreibt die Miete besser: Zimmer oder Fläche?
modell_flaeche <- lm(Miete ~ Fläche, data = Mietwohnungen2016)
coef(modell_flaeche)                # -82,90 Euro und 9,31 Euro je m²
summary(modell_flaeche)$r.squared   # 0,89: Die Fläche erklärt die Miete deutlich besser

# Wie in VL4: Würde R² auch bei reinem Zufall so groß? Mieten mischen und neu schätzen.
set.seed(1)
max(replicate(1000, summary(lm(sample(Miete) ~ Fläche, data = Mietwohnungen2016))$r.squared))
# höchstens etwa 0,003: Das beobachtete R² von 0,89 ist durch Zufall nicht erklärbar.

# 10. Multiple Regression
# Ziel: die Miete durch Zimmeranzahl und Fläche gemeinsam beschreiben
multiple_model <- lm(Miete ~ Zimmer + Fläche, data = Mietwohnungen2016)

# Zusammenfassung des Modells: lesen wie oben, Estimate und R-squared
summary(multiple_model)
summary(multiple_model)$r.squared   # 0,898: Die Zimmerzahl bringt zur Fläche kaum etwas dazu (0,893)
coef(multiple_model)                # Zimmer -45,40 Euro, Fläche 10,51 Euro je m²
# Zimmer -45,40 Euro: Bei GLEICHER Fläche bedeutet ein Zimmer mehr kleinere Zimmer,
# und das senkt die Miete leicht. Ohne die Fläche im Modell waren es +259,61 Euro je Zimmer,
# weil mehr Zimmer meist mehr Fläche bedeuten.

# Grafische Kontrolle: Wie nah liegt die Vorhersage an der Wirklichkeit?
plot(fitted(multiple_model), Mietwohnungen2016$Miete,
     main = "Beobachtete gegen vorhergesagte Mieten",
     xlab = "Vorhergesagte Miete (Euro)", ylab = "Tatsächliche Miete (Euro)")
abline(0, 1, col = "red", lwd = 2)   # Punkte auf der Linie: Vorhersage stimmt genau
# Bei großen Wohnungen liegen die Punkte weiter von der Linie entfernt:
# Die Abweichungen streuen bei unter 60 m² um etwa 67 Euro, bei über 150 m² um etwa 253 Euro.

# 11. Korrelationen analysieren
# Nur Variablen, die inhaltlich metrisch sind. Nummer (laufende ID) und Ortskode
# (Code des Stadtteils) gehören nicht hinein: Ihre Zahlen haben keine Größenbedeutung.
kor_daten <- Mietwohnungen2016[, c("Miete", "Fläche", "Zimmer", "WestOst", "NordSüd")]
correlation_matrix <- cor(kor_daten)

# Korrelationen anzeigen
round(correlation_matrix, 2)
# Nach der Faustregel: Miete und Fläche 0,95 stark, Miete und Zimmer 0,79 mittel,
# Miete und WestOst -0,31 schwach, Miete und NordSüd -0,13 schwach.
cor(Mietwohnungen2016$Lage, Mietwohnungen2016$Miete, method = "spearman")
# 0,40: Die Lage ist ordinal (Stufen 1 bis 3), deshalb Spearman; schwacher Zusammenhang

# 12. Grafische Darstellung der Korrelationsmatrix
corrplot(correlation_matrix, method = "circle")
