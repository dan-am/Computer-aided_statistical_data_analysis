# Übungsblatt 3: Deskriptive Statistik (zu Vorlesung 3)
# Datensatz: Data/Input/Gebrauchtwagen.csv, Variable Fahr (Fahrleistung in Tausend km)
# Schreiben Sie Ihren Code unter die jeweilige Aufgabe.
# Die Kontrollwerte zeigen Ihnen, ob Ihr Ergebnis stimmt.

# Einmalig installieren, falls noch nicht vorhanden: dazu das # vor install.packages entfernen
# install.packages("readr")
library(readr)
Gebrauchtwagen <- read_delim("Data/Input/Gebrauchtwagen.csv",
                             delim = ";",
                             locale = locale(decimal_mark = ","),
                             trim_ws = TRUE)
fahr <- Gebrauchtwagen$Fahr

# Aufgabe 1: Lage
# Berechnen Sie Mittelwert und Median der Fahrleistung.
# Kontrollwerte: 83.19, 81


# Aufgabe 2: Streuung
# Berechnen Sie Standardabweichung, Varianz und Spannweite.
# Kontrollwerte: 47.35, 2241.72, 270.5


# Aufgabe 3: Quantile
# Berechnen Sie die Quartile, den Interquartilsabstand und das 90-%-Quantil.
# Kontrollwerte: 46.8, 81, 114.85; 68.05; 149.8


# Aufgabe 4: Grafiken
# Zeichnen Sie ein Histogramm mit senkrechten Linien für Median und Mittelwert und
# einer Legende. Zeichnen Sie einen Boxplot der Fahrleistung je Typ.
# Welcher Typ hat den höchsten, welcher den niedrigsten Median?
# Kontrollwerte: VW Passat (112,5), Opel Vectra (57)


# Aufgabe 5: Zusammenhang mit dem Wert
# Zeichnen Sie ein Streudiagramm von Fahrleistung und Wert. Berechnen Sie die
# Korrelation nach Pearson und nach Spearman und stufen Sie sie nach der Faustregel ein.
# Kontrollwerte: -0.56, -0.61


# Aufgabe 6: Deutung
# Beschreiben Sie in zwei Sätzen die Form der Verteilung und den Zusammenhang mit dem Wert.

