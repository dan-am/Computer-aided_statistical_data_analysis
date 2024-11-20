# Verteilungsfunktion in R zeichnen.
# 1. Beispiel sind zufällig erzeugte Zahlen die Standard normalverteilt sind
set.seed(1234) # Setzt einen zufälligen Startwert
norm <- rnorm(100) # Es werden 100 Zufallszahlen aus einer Standardnormalverteilung erzeugt

hist(norm,freq=TRUE, breaks = 100) # es wird die absolute Häufigkeit berechnet

hist(norm,freq=FALSE, breaks = 10) # es wird die relative Häufigkeit berechnet
lines(density(norm), col = 2)
# die wahl der Klassenbreite ist wichtig, da sie die Anzahl der Balken bestimmt
# die Anzahl der Balken sollte so gewählt werden, dass die Verteilung gut sichtbar ist

ecdf_norm <- ecdf(norm)
plot(ecdf_norm)

# noch einmal mit weniger Beobachtungen
norm2 <- rnorm(10) # Es werden 100 Zufallszahlen aus einer Standardnormalverteilung erzeugt
plot(ecdf(norm2)) # empirische Verteilungsfunktion


#  Wiederholung mit mehr Beobachtungen
set.seed(1234)
norm3 <- rnorm(10000)
plot(ecdf(norm3))
curve(pnorm(x), add = T , col = "red" , lwd = 2 , lty = 2) #  pnorm ist - Wahrscheinlichkeit 


# EXKURS --- wie behandle ich fehlende Werte
# Fehlende Werte in R

xvec <- c(rt(100,df = 20),NA,1000)
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
# der Mittelwert ist sehr viel größer als der Median
# berechen Mittelwert ohne Ausreißer

mean(xvec, na.rm = T, trim = 0.01) # trim = 0.01 bedeutet, dass die 1% der Werte am Rand ignoriert werden

yvec <- c(rt(100,df = 20),NA,1000,"Haus")
yvec_num <- as.numeric(yvec) # as.numeric wandelt den Vektor in numerische Werte um
print(yvec_num) # "Haus" wird zu NA

