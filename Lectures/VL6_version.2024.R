# Verteilungsfunktion in R zeichnen.
# 1. Beispiel sind zufällig erzeugte Zahlen die Standard normalverteilt sind
set.seed(1234)
norm <- rnorm(100)

ecdf_norm <- ecdf(norm)

hist(norm,freq=FALSE, breaks = 100)
lines(density(norm), col = 2)
plot(ecdf_norm)

#  Wiederholung mit mehr Beobachtungen
set.seed(1234)
norm <- rnorm(10000)
head(norm)
ecdf_norm <- ecdf(norm)

plot(ecdf_norm)
curve(pnorm(x), add = T , col = "red" , lwd = 2 , lty = 2) #  pnorm ist - Wahrscheinlichkeit 

# nun erzeugen wir das Histogram und die Dichte

hist(norm, freq = FALSE, breaks = 20)
lines(density(norm) , col = "blue" , lwd = 2)
curve(dnorm(x), add = T , col = "red" , lwd = 2 , lty = 2) # dnorm für Dichte
  
# EXKURS --- wie behandle ich fehlende Werte
# Fehlende Werte in R

xvec <- c(rt(100,df = 20),NA,1000)
print(xvec)

mean(xvec)
min(xvec)
median(xvec)

# wie also mit felenden Werten umgehen???
# ich kann den NA Wert ausschließen

mean(xvec, na.rm = TRUE)
min(xvec, na.rm = TRUE)
median(xvec, na.rm = TRUE)

boxplot(xvec)
hist(xvec)
# der Mittelwert ist sehr viel größer als der Median
# berechen Mittelwert ohne Ausreißer

mean(xvec, na.rm = T, trim = 0.01)

yvec <- c(rt(100,df = 20),NA,1000,"Haus")
yvec_num <- as.numeric(yvec)
print(yvec_num)

