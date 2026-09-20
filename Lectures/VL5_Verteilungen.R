# Verteilungsfunktion in R zeichnen.
# 1. Beispiel sind zufällig erzeugte Zahlen die Standard normalverteilt sind
set.seed(1234) # Setzt einen festen Startwert, damit die Zufallszahlen bei jedem Lauf gleich sind
norm <- rnorm(100) # Es werden 100 Zufallszahlen aus einer Standardnormalverteilung erzeugt

hist(norm,freq=TRUE, breaks = 100) # es wird die absolute Häufigkeit berechnet
# Hinweis: 100 Klassen bei 100 Werten sind zu viele, fast jede Klasse enthält 0 oder 1 Wert.
# Vergleich verschiedener Klassenanzahlen nebeneinander:
par(mfrow = c(1, 3))   # drei Grafiken nebeneinander
hist(norm, breaks = 5,  main = "5 Klassen")
hist(norm, breaks = 15, main = "15 Klassen")
hist(norm, breaks = 50, main = "50 Klassen")
par(mfrow = c(1, 1))   # zurück zu einer Grafik

hist(norm,freq=FALSE, breaks = 10) # es wird die relative Häufigkeit berechnet
# Genauer: Die FLÄCHE jedes Balkens ist die relative Häufigkeit der Klasse.
# Die HÖHE ist die Dichte, also die relative Häufigkeit geteilt durch die Klassenbreite.
# Alle Balkenflächen zusammen ergeben 1. Nur auf dieser Dichteskala passt die Kerndichte darüber.
lines(density(norm), col = 2)
# die wahl der Klassenbreite ist wichtig, da sie die Anzahl der Balken bestimmt
# die Anzahl der Balken sollte so gewählt werden, dass die Verteilung gut sichtbar ist

ecdf_norm <- ecdf(norm)
plot(ecdf_norm)

# noch einmal mit weniger Beobachtungen
norm2 <- rnorm(10) # Es werden 10 Zufallszahlen aus einer Standardnormalverteilung erzeugt (oben waren es 100)
plot(ecdf(norm2)) # empirische Verteilungsfunktion


#  Wiederholung mit mehr Beobachtungen
set.seed(1234)
norm3 <- rnorm(10000)
plot(ecdf(norm3))
curve(pnorm(x), add = T , col = "red" , lwd = 2 , lty = 2)
# pnorm(x) gibt die Wahrscheinlichkeit P(X <= x) wieder, also den Wert der Verteilungsfunktion
# (cdf, cumulative distribution function) der Normalverteilung an der Stelle x.
# Die Verteilungsfunktion ist die aufsummierte (integrierte) Dichte:
#   F(x) = P(X <= x) = Integral von -unendlich bis x über f(t) dt
#   mit der Dichte f(t) = 1 / (sigma * sqrt(2 * pi)) * exp(-(t - mu)^2 / (2 * sigma^2))
# Für die Standardnormalverteilung (mu = 0, sigma = 1) schreibt man auch Phi(x).
pnorm(1)                          # 0,84
integrate(dnorm, -Inf, 1)$value   # 0,84: dasselbe, als Fläche unter der Dichte berechnet

# Die Normalverteilung in R: vier Funktionen mit gleichem Namensteil
dnorm(0)                 # d = Dichte an der Stelle 0: 0,40
pnorm(1)                 # p = Verteilungsfunktion P(X <= 1): 0,84
pnorm(1) - pnorm(-1)     # P(-1 < X < 1): 0,68, die Ein-Sigma-Regel
pnorm(2) - pnorm(-2)     # P(-2 < X < 2): 0,95
qnorm(0.975)             # q = Quantil: 97,5 % der Werte liegen unter 1,96
rnorm(5)                 # r = fünf Zufallszahlen

# Je größer n, desto näher liegt die empirische an der theoretischen Verteilungsfunktion
par(mfrow = c(1, 3))
plot(ecdf(norm2), main = "n = 10");     curve(pnorm(x), add = TRUE, col = "red", lwd = 2)
plot(ecdf(norm),  main = "n = 100");    curve(pnorm(x), add = TRUE, col = "red", lwd = 2)
plot(ecdf(norm3), main = "n = 10.000"); curve(pnorm(x), add = TRUE, col = "red", lwd = 2)
par(mfrow = c(1, 1))
c(mean(norm2 <= 1), mean(norm <= 1), mean(norm3 <= 1))   # Anteile bis 1: 1,00  0,86  0,84
# Die Wahrscheinlichkeit pnorm(1) ist 0,84. Bei n = 10 liegen zufällig alle Werte unter 1:
# Bei wenigen Beobachtungen ist ein Anteil noch keine gute Schätzung der Wahrscheinlichkeit.
# Größter Abstand zwischen den Kurven: 0,34 bei n = 10, 0,16 bei n = 100, 0,01 bei n = 10.000.


# Übertragung auf echte Daten: Beschreibt eine Normalverteilung die Mieten?
# Einmalig installieren, falls noch nicht vorhanden: dazu das # vor install.packages entfernen
# install.packages("readr")
library(readr)
file_path <- "Data/Input/Mietwohnungen2016.csv"
Mietwohnungen2016 <- read_delim(file_path,
                                delim = ";",
                                escape_double = FALSE,
                                locale = locale(decimal_mark = ","),
                                trim_ws = TRUE)
mw <- mean(Mietwohnungen2016$Miete)   # 781,41 Euro
s  <- sd(Mietwohnungen2016$Miete)     # 444,47 Euro
1 - pnorm(1500, mean = mw, sd = s)    # Modell: 5,3 % der Wohnungen über 1.500 Euro
mean(Mietwohnungen2016$Miete > 1500)  # Daten:  8,4 %
pnorm(300, mean = mw, sd = s)         # Modell: 13,9 % unter 300 Euro
mean(Mietwohnungen2016$Miete < 300)   # Daten:   5,2 %
pnorm(0, mean = mw, sd = s)           # Modell:  3,9 % negative Mieten
plot(ecdf(Mietwohnungen2016$Miete), main = "Mieten: Daten und Normalverteilung",
     xlab = "Miete (Euro)", ylab = "Anteil (Daten) bzw. Wahrscheinlichkeit (Modell)")
curve(pnorm(x, mean = mw, sd = s), add = TRUE, col = "red", lwd = 2)
# Die Mieten sind rechtsschief. Die Normalverteilung unterschätzt teure Wohnungen,
# überschätzt billige und erlaubt sogar negative Mieten. Sie ist hier kein gutes Modell.


# EXKURS --- wie behandle ich fehlende Werte
# Fehlende Werte in R

set.seed(2024) # fester Startwert, damit die Zahlen unten reproduzierbar sind
xvec <- c(rnorm(100),NA,1000) # 100 normalverteilte Werte, ein fehlender Wert (NA) und ein Ausreißer
print(xvec)

mean(xvec)
min(xvec)
median(xvec)

# wie also mit felenden Werten umgehen???
# ich kann den NA Wert ausschließen

mean(xvec, na.rm = TRUE) # na.rm = TRUE bedeutet, dass NA Werte ignoriert werden
min(xvec, na.rm = TRUE)
median(xvec, na.rm = TRUE)

boxplot(xvec)
hist(xvec)
# der Mittelwert ist sehr viel größer als der Median (9,82 gegen -0,005)
# berechen Mittelwert ohne Ausreißer

mean(xvec, na.rm = T, trim = 0.01) # trim = 0.01 bedeutet, dass die 1% der Werte am Rand ignoriert werden
# Genauer: trim = 0.01 entfernt je 1 % der Werte an BEIDEN Enden, bevor gemittelt wird.
# Bei 101 vorhandenen Werten ist das je ein Wert: der Ausreißer 1000 und der kleinste Wert.
# Ergebnis etwa -0,05; ohne den Ausreißer läge der Mittelwert bei etwa -0,09, mit ihm bei 9,82.

yvec <- c(rnorm(100),NA,1000,"Haus")
# Ein einziger Text ("Haus") macht den ganzen Vektor zu Text: Auch die Zahlen stehen jetzt
# in Anführungszeichen.
class(yvec)   # "character"
yvec_num <- as.numeric(yvec) # as.numeric wandelt den Vektor in numerische Werte um
# R meldet dabei die Warnung "NAs durch Umwandlung erzeugt" (englisch: "NAs introduced by coercion").
# Das ist gewollt: "Haus" lässt sich nicht in eine Zahl umwandeln und wird zu NA.
print(yvec_num) # "Haus" wird zu NA
sum(is.na(yvec_num))   # 2 fehlende Werte: das ursprüngliche NA und "Haus"
