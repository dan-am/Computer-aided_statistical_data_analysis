# Übungsblatt 2: Daten einlesen und bearbeiten mit dplyr (zu Vorlesung 2)
# Lösung

# Einmalig installieren, falls noch nicht vorhanden: dazu das # vor install.packages entfernen
# install.packages("readr")
library(readr)
# install.packages("dplyr")
library(dplyr)

# Aufgabe 1: Einlesen
# Semikolon als Trenner, Komma als Dezimalzeichen: read_delim mit diesen Angaben
Gebrauchtwagen <- read_delim("Data/Input/Gebrauchtwagen.csv",
                             delim = ";",
                             locale = locale(decimal_mark = ","),
                             trim_ws = TRUE)
head(Gebrauchtwagen)
dim(Gebrauchtwagen)                 # 863 Zeilen, 6 Spalten

# Aufgabe 2: Überblick
unique(Gebrauchtwagen$Typ)          # die genauen Namen der Typen
length(unique(Gebrauchtwagen$Typ))  # 9

# Aufgabe 3: Filtern
# 1. Wert über 10.000 Euro
teuer <- Gebrauchtwagen %>%
  filter(Wert > 10000)
nrow(teuer)                         # 297

# 2. Typ enthält BMW oder Audi. Die Namen lauten "5er BMW", "Audi A4" und "Audi A6";
#    filter(Typ == "BMW") fände 0 Zeilen.
bmw_audi <- Gebrauchtwagen %>%
  filter(Typ %in% c("5er BMW", "Audi A4", "Audi A6"))
nrow(bmw_audi)                      # 286
# gleichwertig: filter(grepl("BMW|Audi", Typ))

# 3. Älter als 50 Monate und teurer als 15.000 Euro
alt_teuer <- Gebrauchtwagen %>%
  filter(Alter > 50 & Wert > 15000)
nrow(alt_teuer)                     # 11

# Aufgabe 4: Neue Variable
Gebrauchtwagen <- Gebrauchtwagen %>%
  mutate(alter_jahr = round(Alter / 12, digits = 2))
mean(Gebrauchtwagen$alter_jahr)     # 5.74 Jahre

# Aufgabe 5: Gruppieren und Zusammenfassen
Gebrauchtwagen %>%
  group_by(Typ) %>%
  summarize(Mittelwert_Alter = mean(Alter),
            Mittelwert_Wert  = mean(Wert)) %>%
  arrange(Mittelwert_Alter)
# Jüngster Typ: Opel Vectra (48,8 Monate), ältester: Mazda 323 (92,1 Monate).
# Höchster mittlerer Wert: 5er BMW (19.091 Euro).
