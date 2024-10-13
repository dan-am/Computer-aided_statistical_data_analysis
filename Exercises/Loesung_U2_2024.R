# Übungseinheit 2: Datenmanipulation mit dplyr

# Aufgabe 1: Daten einlesen

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

unique(sort(Gebrauchtwagen$Typ)) # gibt die einzigartigen Werte der Spalte "typ" aus

# Aufgabe 2: Daten filtern
# Paket dplyr laden
library(dplyr)

# 1. Zeilen filtern, in denen eine Spalte größer als 100 ist (z.B. Wert > 100)
df_filtered <- Gebrauchtwagen %>%
  filter(Wert > 10000) # filtert die Daten nach einem Wert größer als 10000

df_filtered

# v1
Gebrauchtwagen %>%
  filter(Typ %in% c( "5er BMW","Audi A4","Audi A6")) # filtert die Daten nach den spezifizierten Typen
# v2
Gebrauchtwagen %>%
  filter(grepl("Audi|BMW", Typ)) # filtert die Daten nach den spezifizierten Typen

# Aufgabe 3: Gruppieren und Aggregieren

Gebrauchtwagen %>%
  group_by(Typ) %>%
  summarize(Mittelwert_Alter = mean(Alter),
            Mittelwert_Wert = mean(Wert)) %>%  # Der Mittelwert wird in einer neuen Spalte 'Mittelwert' gespeichert
  arrange(Mittelwert_Alter)  # Sortiert die Daten aufsteigend nach dem Mittelwert
