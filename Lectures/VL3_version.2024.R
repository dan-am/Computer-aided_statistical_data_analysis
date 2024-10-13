# EINFÜHRUNG IN DIE DESKRIPTIVE STATISTIK

# Wiederholung einlesen der Daten
# 1. Datei in Moodle downloaden
# 2. im rechten unteren fenster zu der Datei navigieren (ggf. auf das Haus klicken)
# 3. wir installieren das notwendige Paket in R

# Einlesen des Datensatzes mit den spezifizierten Parametern
# delim = ";" bedeutet, dass die Werte durch Semikolons getrennt sind
# escape_double = FALSE stellt sicher, dass Anführungszeichen nicht doppelt berücksichtigt werden
# locale(decimal_mark = ",") definiert das Dezimaltrennzeichen als Komma
# trim_ws = TRUE entfernt überflüssige Leerzeichen

install.packages("readr", dependencies = TRUE) # bitte prüft, ob das Paket bereits installiert ist
library(readr)

# diese 3 Zeilen importieren die Daten
"/Data/Input/Gebrauchtwagen.csv" # hier muss euer dateipfad stehen

file_path <- "Data/Input/Gebrauchtwagen.csv"

Gebrauchtwagen <- read_delim(file_path, 
                             delim = ";", escape_double = FALSE, 
                             locale = locale(decimal_mark = ","), 
                             trim_ws = TRUE)
View(Gebrauchtwagen)

# 1. Verteilung der Daten verstehen
# Zusammenfassung der numerischen Variablen (Alter, Fahrleistung, Hubraum, Wert)
summary(Gebrauchtwagen)

# 2. Maße der zentralen Tendenz
# Berechnen des Mittelwerts für einige numerische Variablen
mean(Gebrauchtwagen$Alter[Gebrauchtwagen$Typ == "5er BMW"])  # Durchschnittsalter der Fahrzeuge vom Typ "5er BMW"

mean(Gebrauchtwagen$Alter)  # Durchschnittsalter der Fahrzeuge
mean(Gebrauchtwagen$Fahr)   # Durchschnittliche Fahrleistung in Tausend Kilometern
mean(Gebrauchtwagen$Hub)    # Durchschnittlicher Hubraum in Liter
mean(Gebrauchtwagen$Wert)   # Durchschnittlicher Wert der Fahrzeuge in Euro

# Berechnen des Medians
median(Gebrauchtwagen$Alter)  # Median des Alters
median(Gebrauchtwagen$Fahr)   # Median der Fahrleistung
median(Gebrauchtwagen$Hub)    # Median des Hubraums
median(Gebrauchtwagen$Wert)   # Median des Fahrzeugwerts

# 3. Streuungsmaße
# Berechnen der Standardabweichung und Varianz
sd(Gebrauchtwagen$Alter)  # Standardabweichung des Alters
sd(Gebrauchtwagen$Fahr)   # Standardabweichung der Fahrleistung
sd(Gebrauchtwagen$Hub)    # Standardabweichung des Hubraums
sd(Gebrauchtwagen$Wert)   # Standardabweichung des Werts

var(Gebrauchtwagen$Alter)  # Varianz des Alters
var(Gebrauchtwagen$Fahr)   # Varianz der Fahrleistung
var(Gebrauchtwagen$Hub)    # Varianz des Hubraums
var(Gebrauchtwagen$Wert)   # Varianz des Werts

# 4. Minimum, Maximum und Spannweite (Range)
min(Gebrauchtwagen$Alter)  # Mindestalter der Fahrzeuge
max(Gebrauchtwagen$Alter)  # Höchstalter der Fahrzeuge
range(Gebrauchtwagen$Alter)  # Spannweite des Alters

min(Gebrauchtwagen$Fahr)  # Mindestfahrleistung
max(Gebrauchtwagen$Fahr)  # Höchstfahrleistung
range(Gebrauchtwagen$Fahr)  # Spannweite der Fahrleistung

# 5. Quartile und Interquartilsabstand (IQR)
quantile(Gebrauchtwagen$Alter)  # Quartile des Alters
IQR(Gebrauchtwagen$Alter)       # Interquartilsabstand des Alters

quantile(Gebrauchtwagen$Fahr)  # Quartile der Fahrleistung
IQR(Gebrauchtwagen$Fahr)       # Interquartilsabstand der Fahrleistung

# 6. Häufigkeitsverteilung
# Häufigkeiten der verschiedenen Fahrzeugtypen
sort(table(Gebrauchtwagen$Typ)) # Zählt die Häufigkeit der verschiedenen Fahrzeugtypen und sortiert sie
# Häufigkeitstabelle: Fahrzeugtypen und Alter
table(Gebrauchtwagen$Typ, trunc(Gebrauchtwagen$Alter/12) )  # Erzeugt eine Kreuztabelle der Fahrzeugtypen und des Alters
# erzeuge einen Scatterplot vom Alter und der Fahrleistung
plot(Gebrauchtwagen$Alter, Gebrauchtwagen$Fahr, 
     main = "Scatterplot: Alter vs. Fahrleistung", xlab = "Alter (Monate)", ylab = "Fahrleistung (Tsd. km)", col = "blue", pch = 19)

# 7. Korrelationsanalyse
# Untersuchen der Korrelation zwischen verschiedenen Variablen
plot(Gebrauchtwagen$Alter, Gebrauchtwagen$Fahr, 
     main = "Scatterplot: Alter vs. Fahrleistung", xlab = "Alter (Monate)", ylab = "Fahrleistung (Tsd. km)", col = "blue", pch = 19)
cor(Gebrauchtwagen$Alter, Gebrauchtwagen$Fahr)  # Korrelation zwischen Alter und Fahrleistung
plot(Gebrauchtwagen$Alter, sqrt(Gebrauchtwagen$Wert), 
     main = "Scatterplot: Alter vs. Wert", xlab = "Alter (Monate)", ylab = "Wert in EUR", col = "red", pch = 19)
cor(Gebrauchtwagen$Alter, Gebrauchtwagen$Wert, method = "spearman") # Korrelation zwischen Alter und Wert unter Verwendung des Spearman-Rangkorrelationskoeffizienten
cor(Gebrauchtwagen$Alter, Gebrauchtwagen$Wert, method = "pearson" ) # Korrelation zwischen Alter und Wert unter Verwendung des Pearson-Korrelationskoeffizienten
# Transformation der Wertvariable durch die Quadratwurzel
plot(Gebrauchtwagen$Alter, sqrt(Gebrauchtwagen$Wert), 
    main = "Scatterplot: Alter vs. sqrt(Wert)", xlab = "Alter (Monate)", ylab = "Wert in EUR", col = "green", pch = 19)
cor(Gebrauchtwagen$Alter, sqrt(Gebrauchtwagen$Wert), method = "pearson" ) # Korrelation zwischen Alter und Wert unter Verwendung des Pearson-Korrelationskoeffizienten

# 8. Grafische Darstellung der Verteilungen
# Erstellen von Histogrammen und Boxplots zur Visualisierung der Verteilungen

# Histogramm für das Alter der Fahrzeuge
hist(Gebrauchtwagen$Alter, main = "Verteilung des Alters der Fahrzeuge", xlab = "Alter (Monate)", col = "lightblue", border = "black")
abline(v = median(Gebrauchtwagen$Alter), col = "red", lwd = 2)  # Vertikale Linie für den Median
abline(v = mean(Gebrauchtwagen$Alter), col = "blue", lty = 2, lwd = 2)  # Vertikale Linie für den Mittelwert

# Histogramm für die Fahrleistung der Fahrzeuge
hist(Gebrauchtwagen$Fahr, main = "Verteilung der Fahrleistung der Fahrzeuge", xlab = "Fahrleistung (Tsd. km)", col = "lightgreen", border = "black")
abline(v = median(Gebrauchtwagen$Fahr), col = "red", lwd = 2)  # Vertikale Linie für den Median
abline(v = mean(Gebrauchtwagen$Fahr), col = "blue", lty = 2, lwd = 2)  # Vertikale Linie für den Mittelwert

# Boxplot für den Fahrzeugwert
boxplot(Gebrauchtwagen$Wert, main = "Boxplot des Fahrzeugwerts", ylab = "Wert (Euro)", col = "lightyellow")

# FAZIT
# In diesem Skript haben wir die Grundprinzipien der deskriptiven Statistik beschrieben
# und angewendet: zentrale Tendenzen (Mittelwert, Median), Streuungsmaße (Varianz, Standardabweichung),
# und die Korrelationen zwischen Variablen. Abschließend wurden grafische Darstellungen 
# genutzt, um die Datenverteilungen und Zusammenhänge visuell zu verstehen.
