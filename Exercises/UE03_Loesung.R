# Übungsblatt 3: Deskriptive Statistik (zu Vorlesung 3)
# Lösung. Variable: Fahrleistung Fahr in Tausend Kilometern

# Einmalig installieren, falls noch nicht vorhanden: dazu das # vor install.packages entfernen
# install.packages("readr")
library(readr)
Gebrauchtwagen <- read_delim("Data/Input/Gebrauchtwagen.csv",
                             delim = ";",
                             locale = locale(decimal_mark = ","),
                             trim_ws = TRUE)
fahr <- Gebrauchtwagen$Fahr

# Aufgabe 1: Lage
mean(fahr)                  # 83.19
median(fahr)                # 81

# Aufgabe 2: Streuung
sd(fahr)                    # 47.35
var(fahr)                   # 2241.72
range(fahr)                 # 0.5 bis 271
diff(range(fahr))           # Spannweite 270.5

# Aufgabe 3: Quantile
quantile(fahr)              # Quartile 46.8, 81 und 114.85
IQR(fahr)                   # 68.05
quantile(fahr, probs = 0.9) # 149.8

# Aufgabe 4: Grafiken
hist(fahr, main = "Fahrleistung der Fahrzeuge", xlab = "Fahrleistung (Tsd. km)")
abline(v = median(fahr), col = "red", lwd = 2)
abline(v = mean(fahr), col = "blue", lty = 2, lwd = 2)
legend("topright", legend = c("Median", "Mittelwert"), col = c("red", "blue"),
       lty = c(1, 2), lwd = 2)

boxplot(Fahr ~ Typ, data = Gebrauchtwagen, las = 2, xlab = "",
        ylab = "Fahrleistung (Tsd. km)", main = "Fahrleistung nach Typ")
sort(tapply(fahr, Gebrauchtwagen$Typ, median))
# höchster Median: VW Passat (112,5), niedrigster: Opel Vectra (57)

# Aufgabe 5: Zusammenhang mit dem Wert
plot(fahr, Gebrauchtwagen$Wert, xlab = "Fahrleistung (Tsd. km)", ylab = "Wert (Euro)",
     main = "Fahrleistung und Wert")
cor(fahr, Gebrauchtwagen$Wert)                       # -0.56
cor(fahr, Gebrauchtwagen$Wert, method = "spearman")  # -0.61
# Nach der Faustregel aus VL3 eine mittlere Korrelation (0,5 bis unter 0,8).

# Aufgabe 6: Deutung
# Der Mittelwert (83,19) liegt etwas über dem Median (81): Die Verteilung ist leicht
# rechtsschief, einige Fahrzeuge haben sehr viele Kilometer. Je höher die Fahrleistung,
# desto geringer ist im Mittel der Wert; der Zusammenhang ist gegenläufig und mittelstark.
