## Vorlesung 2 

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

Gebrauchtwagen <- read_delim("Data/Input/Gebrauchtwagen.csv", 
                             delim = ";", escape_double = FALSE, 
                             locale = locale(decimal_mark = ","), 
                             trim_ws = TRUE)
View(Gebrauchtwagen)

? View # Hilfe Funktion nutzen
class(Gebrauchtwagen) # ergebnis: Metadaten des Datensatzes
str(Gebrauchtwagen) # structur und Klasse des Datensatzes 

# Aus dem Datensatz Daten auswählen:
Gebrauchtwagen[1, ] # zeigt die erste Zeile
Gebrauchtwagen[, 6] # 6. Spalte anzeigen
# der erste wert ist die Zeile und der 2. Wert ist Spalte

Gebrauchtwagen$Typ # direkter zugriff auf eine Spalte
Gebrauchtwagen$Typ[1] # ich wähle die 1. Beobachtung aus der Spalte "Typ"

# Rückkehr zur Datenanalyse und -manipulation
# Einzigartige Fahrzeugtypen im Datensatz
unique(gebrauchtwagen$Typ)  # Gibt alle einzigartigen Fahrzeugtypen zurück
length(unique(gebrauchtwagen$Typ))  # Gibt die Anzahl der einzigartigen Fahrzeugtypen zurück

# Erstellen einer neuen Spalte: Alter der Fahrzeuge in Jahren
gebrauchtwagen$alter_jahr <- gebrauchtwagen$Alter / 12  # Konvertiert das Alter in Jahre
View(gebrauchtwagen)  # Zeigt den aktualisierten Datensatz mit der neuen Spalte an

# Einen Überblick über die Daten verschaffen
head(gebrauchtwagen)  # Zeigt die ersten Zeilen des Datensatzes an
str(gebrauchtwagen)   # Zeigt die Struktur des Datensatzes an
tail(Gebrauchtwagen)  # zeigt die letzten 6 Zeilen)

# EINFÜHRUNG IN DIE DESKRIPTIVE STATISTIK

# 1. Verteilung der Daten verstehen
# Zusammenfassung der numerischen Variablen (Alter, Fahrleistung, Hubraum, Wert)
summary(gebrauchtwagen)

# 2. Maße der zentralen Tendenz
# Berechnen des Mittelwerts für einige numerische Variablen
mean(gebrauchtwagen$Alter)  # Durchschnittsalter der Fahrzeuge
mean(gebrauchtwagen$Fahr)   # Durchschnittliche Fahrleistung in Tausend Kilometern
mean(gebrauchtwagen$Hub)    # Durchschnittlicher Hubraum in Liter
mean(gebrauchtwagen$Wert)   # Durchschnittlicher Wert der Fahrzeuge in Euro

# Berechnen des Medians
median(gebrauchtwagen$Alter)  # Median des Alters
median(gebrauchtwagen$Fahr)   # Median der Fahrleistung
median(gebrauchtwagen$Hub)    # Median des Hubraums
median(gebrauchtwagen$Wert)   # Median des Fahrzeugwerts

# 3. Streuungsmaße
# Berechnen der Standardabweichung und Varianz
sd(gebrauchtwagen$Alter)  # Standardabweichung des Alters
sd(gebrauchtwagen$Fahr)   # Standardabweichung der Fahrleistung
sd(gebrauchtwagen$Hub)    # Standardabweichung des Hubraums
sd(gebrauchtwagen$Wert)   # Standardabweichung des Werts

var(gebrauchtwagen$Alter)  # Varianz des Alters
var(gebrauchtwagen$Fahr)   # Varianz der Fahrleistung
var(gebrauchtwagen$Hub)    # Varianz des Hubraums
var(gebrauchtwagen$Wert)   # Varianz des Werts

# 4. Minimum, Maximum und Spannweite (Range)
min(gebrauchtwagen$Alter)  # Mindestalter der Fahrzeuge
max(gebrauchtwagen$Alter)  # Höchstalter der Fahrzeuge
range(gebrauchtwagen$Alter)  # Spannweite des Alters

min(gebrauchtwagen$Fahr)  # Mindestfahrleistung
max(gebrauchtwagen$Fahr)  # Höchstfahrleistung
range(gebrauchtwagen$Fahr)  # Spannweite der Fahrleistung

# 5. Quartile und Interquartilsabstand (IQR)
quantile(gebrauchtwagen$Alter)  # Quartile des Alters
IQR(gebrauchtwagen$Alter)       # Interquartilsabstand des Alters

quantile(gebrauchtwagen$Fahr)  # Quartile der Fahrleistung
IQR(gebrauchtwagen$Fahr)       # Interquartilsabstand der Fahrleistung

# 6. Häufigkeitsverteilung
# Häufigkeiten der verschiedenen Fahrzeugtypen
table(gebrauchtwagen$Typ)
# Häufigkeitstabelle: Fahrzeugtypen und Alter
table(gebrauchtwagen$Typ, gebrauchtwagen$Alter)  # Erzeugt eine Kreuztabelle der Fahrzeugtypen und des Alters

# 7. Korrelationsanalyse
# Untersuchen der Korrelation zwischen verschiedenen Variablen
cor(gebrauchtwagen$Alter, gebrauchtwagen$Fahr)  # Korrelation zwischen Alter und Fahrleistung
cor(gebrauchtwagen$Alter, gebrauchtwagen$Wert)  # Korrelation zwischen Alter und Wert

# 8. Grafische Darstellung der Verteilungen
# Erstellen von Histogrammen und Boxplots zur Visualisierung der Verteilungen

# Histogramm für das Alter der Fahrzeuge
hist(gebrauchtwagen$Alter, main = "Verteilung des Alters der Fahrzeuge", xlab = "Alter (Monate)", col = "lightblue", border = "black")

# Histogramm für die Fahrleistung der Fahrzeuge
hist(gebrauchtwagen$Fahr, main = "Verteilung der Fahrleistung der Fahrzeuge", xlab = "Fahrleistung (Tsd. km)", col = "lightgreen", border = "black")

# Boxplot für den Fahrzeugwert
boxplot(gebrauchtwagen$Wert, main = "Boxplot des Fahrzeugwerts", ylab = "Wert (Euro)", col = "lightyellow")

# Scatterplot zur Korrelation zwischen Alter und Fahrleistung
plot(gebrauchtwagen$Alter, gebrauchtwagen$Fahr, main = "Scatterplot: Alter vs. Fahrleistung", xlab = "Alter (Monate)", ylab = "Fahrleistung (Tsd. km)", col = "blue", pch = 19)

# Scatterplot zur Korrelation zwischen Alter und Fahrzeugwert
plot(gebrauchtwagen$Alter, gebrauchtwagen$Wert, main = "Scatterplot: Alter vs. Fahrzeugwert", xlab = "Alter (Monate)", ylab = "Wert (Euro)", col = "red", pch = 19)

# FAZIT
# In diesem Skript haben wir die Grundprinzipien der deskriptiven Statistik beschrieben
# und angewendet: zentrale Tendenzen (Mittelwert, Median), Streuungsmaße (Varianz, Standardabweichung),
# und die Korrelationen zwischen Variablen. Abschließend wurden grafische Darstellungen 
# genutzt, um die Datenverteilungen und Zusammenhänge visuell zu verstehen.


##### Manipulation von Daten in R und dplyr #####

# Installieren des Pakets 'dplyr' für effiziente Datenmanipulation
# Das Paket wird nur einmal installiert und dann geladen.
install.packages("dplyr", dependencies = TRUE)
library(dplyr)  # Laden des 'dplyr' Pakets

# Überblick über die Spaltennamen des Datensatzes
names(gebrauchtwagen)  # Zeigt alle Spaltennamen des Datensatzes 'gebrauchtwagen'

# Filtern von Daten mit Bedingungen
# Beispiel: Fahrzeuge, die älter als 50 Monate sind und einen Wert größer als 15.000 Euro haben
df <- gebrauchtwagen %>%
  filter(Alter > 50 & Wert > 15000)  # Nur Datensätze, die beide Bedingungen erfüllen, werden in 'df' gespeichert

# Ausgabe der gefilterten Daten
df

# Filtern nach spezifischen Fahrzeugtypen
# Beispiel: Alle Fahrzeuge des Typs "5er BMW" filtern
df1 <- gebrauchtwagen %>%
  filter(Typ == "5er BMW")  # Filtert alle Datensätze für den Fahrzeugtyp '5er BMW'

# Anzeige des gefilterten Datensatzes
View(df1)  # Öffnet den gefilterten Datensatz in einem neuen Fenster

# Gruppierung und Berechnung von aggregierten Werten
# Beispiel: Berechnen des durchschnittlichen Werts (Mittelwert) für jeden Fahrzeugtyp
gebrauchtwagen %>%
  group_by(Typ) %>%
  summarize(Mittelwert = mean(Wert)) %>%  # Der Mittelwert wird in einer neuen Spalte 'Mittelwert' gespeichert
  arrange(Mittelwert)  # Sortiert die Daten aufsteigend nach dem Mittelwert

##### Visualisierung von Daten #####

# Erstellung eines Barplots zur Verteilung der Fahrzeugtypen
anzahl <- table(gebrauchtwagen$Typ)  # Erstellt eine Häufigkeitstabelle der Fahrzeugtypen
barplot(height = anzahl, main = "Verteilung der Fahrzeugtypen", 
        xlab = "Fahrzeugtypen", col = "lightblue", border = "black")  # Barplot der Verteilung

# Alternative Darstellung eines Barplots
plot(table(gebrauchtwagen$Typ), type = "h", col = "red", lwd = 10, 
     main = "Verteilung der Fahrzeugtypen", xlab = "Fahrzeugtypen", ylab = "Häufigkeit")

# FAZIT:
# In diesem Abschnitt haben wir gezeigt, wie man Daten mithilfe des 'dplyr'-Pakets
# manipuliert und filtert, sowie wie man verschiedene Aggregationsfunktionen wie Mittelwert
# auf Gruppierungen anwendet. Außerdem wurden unterschiedliche Möglichkeiten der
# Visualisierung von Daten demonstriert, wie Barplots, Histogramme und Scatterplots.