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

file_path <- "Data/Input/Gebrauchtwagen.csv"

Gebrauchtwagen <- read_delim(file_path, 
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
names(Gebrauchtwagen) # Gibt die Spaltennamen des Datensatzes zurück
Gebrauchtwagen$Typ # direkter zugriff auf eine Spalte
Gebrauchtwagen$Typ[1] # ich wähle die 1. Beobachtung aus der Spalte "Typ"

# Rückkehr zur Datenanalyse und -manipulation
# Einzigartige Fahrzeugtypen im Datensatz
unique(Gebrauchtwagen$Typ)  # Gibt alle einzigartigen Fahrzeugtypen zurück
length(unique(Gebrauchtwagen$Typ))  # Gibt die Anzahl der einzigartigen Fahrzeugtypen zurück

# Erstellen einer neuen Spalte: Alter der Fahrzeuge in Jahren
Gebrauchtwagen$alter_jahr <- round(Gebrauchtwagen$Alter / 12, digits = 2)  # Konvertiert das Alter in Jahre und rundet auf 2 Dezimalstellen
View(Gebrauchtwagen)  # Zeigt den aktualisierten Datensatz mit der neuen Spalte an

# Einen Überblick über die Daten verschaffen
head(Gebrauchtwagen)  # Zeigt die ersten Zeilen des Datensatzes an
tail(Gebrauchtwagen)  # zeigt die letzten 6 Zeilen)

##### Manipulation von Daten in R und dplyr #####

# Installieren des Pakets 'dplyr' für effiziente Datenmanipulation
# Das Paket wird nur einmal installiert und dann geladen.
install.packages("dplyr", dependencies = TRUE)
library(dplyr)  # Laden des 'dplyr' Pakets

# Überblick über die Spaltennamen des Datensatzes
names(Gebrauchtwagen)  # Zeigt alle Spaltennamen des Datensatzes 'Gebrauchtwagen'

# Filtern von Daten mit Bedingungen
# Beispiel: Fahrzeuge, die älter als 50 Monate sind und einen Wert größer als 15.000 Euro haben
df <- Gebrauchtwagen %>%  # Der Datensatz wird mit dem 'dplyr'-Paket bearbeitet
  filter(Alter > 50 & Wert > 15000)  # Nur Datensätze, die beide Bedingungen erfüllen, werden in 'df' gespeichert

# Ausgabe der gefilterten Daten
df  # Zeigt den gefilterten Datensatz 'df' an

# Filtern nach spezifischen Fahrzeugtypen
# Beispiel: Alle Fahrzeuge des Typs "5er BMW" filtern
df1 <- Gebrauchtwagen %>%
  filter(Typ == "5er BMW")  # Filtert alle Datensätze für den Fahrzeugtyp '5er BMW'

# Anzeige des gefilterten Datensatzes
View(df1)  # Öffnet den gefilterten Datensatz in einem neuen Fenster

# Gruppierung und Berechnung von aggregierten Werten
# Beispiel: Berechnen des durchschnittlichen Werts (Mittelwert) für jeden Fahrzeugtyp
Gebrauchtwagen %>%
  group_by(Typ) %>%
  summarize(Mittelwert = mean(Wert)) %>%  # Der Mittelwert wird in einer neuen Spalte 'Mittelwert' gespeichert
  arrange(Mittelwert)  # Sortiert die Daten aufsteigend nach dem Mittelwert

# Erstellung eines Barplots zur Verteilung der Fahrzeugtypen
anzahl <- table(Gebrauchtwagen$Typ)  # Erstellt eine Häufigkeitstabelle der Fahrzeugtypen
barplot(height = anzahl, main = "Verteilung der Fahrzeugtypen", 
        xlab = "Fahrzeugtypen", col = "lightblue", border = "black")  # Barplot der Verteilung

# Alternative Darstellung eines Barplots
plot(table(Gebrauchtwagen$Typ), type = "h", col = "red", lwd = 10, 
     yaxt="n", 
     ylab="Häufigkeit", xlab="Fahrzeugtypen",
     main = "Verteilung der Fahrzeugtypen")
axis(2, at = seq(0, 100, by = 10), las=2)

# FAZIT:
# In diesem Abschnitt haben wir gezeigt, wie man Daten mithilfe des 'dplyr'-Pakets
# manipuliert und filtert, sowie wie man verschiedene Aggregationsfunktionen wie Mittelwert
# auf Gruppierungen anwendet. Außerdem wurden unterschiedliche Möglichkeiten der
# Visualisierung von Daten demonstriert, wie Barplots, Histogramme und Scatterplots.