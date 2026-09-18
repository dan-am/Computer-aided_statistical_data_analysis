# -----------------------------------------
# Finale Vorlesung: Datenanalyse
# -----------------------------------------

# Pakete installieren und laden
install.packages("lubridate", dependencies = TRUE) # lubridate: für die Arbeit mit Datums- und Zeitobjekten
library(lubridate)
library(readr)       # für schnelles und einfaches CSV-Einlesen
library(dplyr)       # für Datenmanipulation
library(ggplot2)     # für Datenvisualisierung
library(corrplot)

# -----------------------------------------
# 1. Schritt: Daten einlesen
# -----------------------------------------

# Dateipfad definieren
filepath <- "Data/Output/OPENDATA_BOOKING_CARSHARING.csv"

# CSV-Datei einlesen
OPENDATA_BOOKING_CARSHARING <- read_csv(filepath)

str(OPENDATA_BOOKING_CARSHARING) # Struktur der Daten anzeigen
table(OPENDATA_BOOKING_CARSHARING$VEHICLE_HAL_ID) # Häufigkeit der Fahrzeug-IDs anzeigen
table(OPENDATA_BOOKING_CARSHARING$CITY_RENTAL_ZONE) # Häufigkeit der Städte anzeigen
table(OPENDATA_BOOKING_CARSHARING$CATEGORY_HAL_ID) # Häufigkeit der Kategorien anzeigen
table(OPENDATA_BOOKING_CARSHARING$BOOKING_HAL_ID) # Häufigkeit der Buchungs-IDs anzeigen
table(OPENDATA_BOOKING_CARSHARING$START_RENTAL_ZONE_HAL_ID) # Häufigkeit der Start-Zonen-IDs anzeigen
table(OPENDATA_BOOKING_CARSHARING$COMPUTE_EXTRA_BOOKING_FEE) # Häufigkeit der zusätzlichen Buchungsgebühren anzeigen
table(OPENDATA_BOOKING_CARSHARING$TRAVERSE_USE) # Häufigkeit der Nutzung des Fahrzeugs für Hin- und Rückfahrt 

# -----------------------------------------
# Daten vorbereiten und filtern
# -----------------------------------------

# Beispiel: Auswahl der Daten für die Stadt "Berlin" und Entfernung von fehlenden Werten in DISTANCE
Berlin <- OPENDATA_BOOKING_CARSHARING %>% 
  filter(CITY_RENTAL_ZONE == "Berlin" & !is.na(DISTANCE)) 
# Daten für Berlin auswählen und fehlende Werte in DISTANCE entfernen

# hier die Daten löschen
rm(OPENDATA_BOOKING_CARSHARING)
gc()

# Extrahieren zusätzlicher Zeit- und Datumsvariablen
Berlin <- Berlin %>% 
  mutate(
    stunde = hour(DATE_FROM), # Stunde aus Startdatum extrahieren
    wochentag = wday(DATE_FROM, label = TRUE), # Wochentag extrahieren
    woche = week(DATE_FROM), # Woche extrahieren
    month = month(DATE_FROM)      # Tag aus Startdatum extrahieren
  )

Berlin <- Berlin %>% 
  select(-RENTAL_ZONE_HAL_SRC, -CITY_RENTAL_ZONE) # Spalten entfernen die konstant sind

# Beispiel: Differenz zwischen Start- und Endzeitpunkt (nur zum Testen)
Berlin$DATE_UNTIL[1] - Berlin$DATE_FROM[1]

Berlin <- Berlin %>%
  mutate(DURATION = as.numeric(difftime(DATE_UNTIL, DATE_FROM, units = "mins"))) 
# Dauer der Buchung in Minuten berechnen

# Entfernung von Ausreißern in DISTANCE (oberes 99.9%-Quantil)
# weil sonst sind einige Werte zu groß
q_999 <- quantile(Berlin$DISTANCE, probs = 0.999)
Berlin <- Berlin %>% 
  filter(DISTANCE < q_999)

# -----------------------------------------
# 1. Aufgaben
# -----------------------------------------
# -----------------------------------------
# Flinkster Datenanalyse: Berlin
# -----------------------------------------

# darstellung der Grafiken ohne die großen Ausreißer
quant <- quantile(Berlin$DISTANCE, probs = c(0,0.99)) 
# Quantile der Distanz in Berlin mit dem Minimum und dem 99%-Quantil

# Histogramm und Kerndichte
hist(Berlin$DISTANCE, 
     main = "Histogram der Distanz in Berlin", 
     xlab = "Distanz (km)", 
     breaks = 30, 
     col = "lightblue",
     freq = FALSE,# Histogramm mit Kerndichte (FREQUENZ = FAL)
     xlim = quant) 
lines(density(Berlin$DISTANCE), col = "red", lwd = 2)

# Boxplot: Distanz
boxplot(Berlin$DISTANCE, 
        main = "Boxplot der Distanz in Berlin", 
        ylab = "Distanz (km)",
        ylim = quant)

# ECDF (Empirische kumulative Verteilungsfunktion)
plot(ecdf(Berlin$DISTANCE), 
     main = "ECDF der Distanz in Berlin", 
     xlab = "Distanz (km)", 
     ylab = "Kumulative Wahrscheinlichkeit", 
     col = "blue")

# -----------------------------------------
# Aufgabe 2: Varianzanalyse
# -----------------------------------------

# Varianzanalyse mit mehreren Faktoren
varanalyse <- aov(DISTANCE ~ COMPUTE_EXTRA_BOOKING_FEE + TRAVERSE_USE + END_RENTAL_ZONE_HAL_ID +
                    CATEGORY_HAL_ID , # Faktoren für die Varianzanalyse
                  data = Berlin)
summary(varanalyse) # Ergebnisse der ANOVA anzeigen
# es kann gezeigt werden, dass die Vrianz in der Distanz durch die Faktoren beeinflusst wird
# dabei sind alle Faktoren signifikant, dass wird durch den *** angezeigt

# Visualisierung: Boxplot der Distanz nach TRAVERSE_USE
boxplot(Berlin$DISTANCE ~ Berlin$TRAVERSE_USE, 
        main = "Boxplot der Distanz nach TRAVERSE_USE in Berlin", 
        xlab = "TRAVERSE_USE", 
        ylab = "Distanz (km)",
        ylim = quant)

# -----------------------------------------
# Aufgabe 3: Multiple Regression
# -----------------------------------------

# Regressionsmodell: Einfluss von Stunde,  Woche, Duration und weiteren Variablen auf die Distanz
reg_model <- lm(DISTANCE ~ stunde +  woche + DURATION + month + COMPUTE_EXTRA_BOOKING_FEE + 
                  TRAVERSE_USE + CATEGORY_HAL_ID  , # Prädiktoren für die Regression 
                data = Berlin)
summary(reg_model) # Ergebnisse der Regression anzeigen
# wir sehen, dass alle Regressoren, außer der CATEGORY_HAL_ID signifikant sind
# die Duration und die Distance stehen aber in einem engen Zusammenhang, denn je länger die Fahrt dauert, desto weiter ist sie


# Visualisierung der Modellanpassung
plot(reg_model$fitted.values, Berlin$DISTANCE, 
     main = "Modellanpassung: Vorhergesagte vs. tatsächliche Distanz in Berlin", 
     xlab = "Vorhergesagte Distanz (km)", 
     ylab = "Tatsächliche Distanz (km)")
abline(0, 1, col = "red", lwd = 2)

# Interpretation der Regressions-Ergebnisse
# - Schauen Sie auf die R-squared-Werte und die p-Werte der Prädiktoren.
# - Beispielkommentar: "Die Stunde, die Woche, Duration, Monat, COMPUTE_EXTRA_BOOKING_FEE und TRAVERSE_USE haben einen signifikanten Einfluss auf die Distanz."
# - das R squared ist nicht so groß, das bedeutet, dass das Modell noch verbessert werden kann
# - die Duration ist aber ein sehr guter Prädiktor für die Distanz, 
# - jedoch ist sie auch sehr eng mit der Distanz verbunden

# -----------------------------------------
# Aufgabe 4: Korrelationsplot
# -----------------------------------------

# Auswahl numerischer Variablen
numeric_vars <- Berlin %>% 
  select(DISTANCE,  stunde, woche, DURATION) %>% 
  na.omit()

# Korrelationsmatrix berechnen
cor_matrix <- cor(numeric_vars)

# Korrelationsplot erstellen
corrplot(cor_matrix, method = "circle", type = "upper", 
         tl.col = "black", tl.srt = 45, 
         main = "Korrelationsplot der numerischen Variablen in Berlin")

# Interpretation des Korrelationsplots
# - Beispiel: "Die Distanz zeigt eine moderate Korrelation mit COMPUTE_EXTRA_BOOKING_FEE, aber schwache Korrelation mit Stunde und Woche."
