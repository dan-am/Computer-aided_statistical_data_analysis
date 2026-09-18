# Übungsblatt 2: Daten einlesen und bearbeiten mit dplyr (zu Vorlesung 2)
# Datensatz: Data/Input/Gebrauchtwagen.csv
# Schreiben Sie Ihren Code unter die jeweilige Aufgabe.
# Die Kontrollwerte zeigen Ihnen, ob Ihr Ergebnis stimmt.

# Einmalig installieren, falls noch nicht vorhanden: dazu das # vor install.packages entfernen
# install.packages("readr")
library(readr)
# install.packages("dplyr")
library(dplyr)

# Aufgabe 1: Einlesen
# Lesen Sie den Datensatz mit read_delim() ein (Trenner Semikolon, Dezimalzeichen Komma)
# und zeigen Sie die ersten Zeilen und die Größe an.
# Kontrollwert: 863 Zeilen, 6 Spalten


# Aufgabe 2: Überblick
# Welche Fahrzeugtypen gibt es, und wie viele sind es?
# Kontrollwert: 9 Typen


# Aufgabe 3: Filtern mit filter()
# 1. Alle Fahrzeuge mit einem Wert über 10.000 Euro.
# 2. Alle Fahrzeuge, deren Typ BMW oder Audi enthält.
#    Tipp: Schauen Sie zuerst mit unique() nach, wie die Typen genau heißen.
# 3. Alle Fahrzeuge, die älter als 50 Monate und teurer als 15.000 Euro sind.
# Kontrollwerte: 297, 286, 11 Fahrzeuge


# Aufgabe 4: Neue Variable mit mutate()
# Bilden Sie alter_jahr = Alter / 12, auf zwei Stellen gerundet.
# Wie alt sind die Fahrzeuge im Mittel in Jahren?
# Kontrollwert: 5.74


# Aufgabe 5: Gruppieren mit group_by() und summarize()
# Berechnen Sie mittleres Alter und mittleren Wert je Typ, sortiert nach dem Alter.
# Kontrollwerte: jüngster Typ Opel Vectra (48,8 Monate), ältester Mazda 323 (92,1 Monate)

