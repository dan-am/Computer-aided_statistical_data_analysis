# Importieren des Datensatzes
# VORLESUNG 3

library(readr)
file_path <- "Data/Input/Mietwohnungen2016.csv"

Mietwohnungen2016 <- read_delim(file_path, 
                                delim = ";", 
                                escape_double = FALSE, 
                                locale = locale(decimal_mark = ","), 
                                trim_ws = TRUE)
View(Mietwohnungen2016)

### gefühl für die Daten bekommen
head(Mietwohnungen2016)
str(Mietwohnungen2016)
unique(Mietwohnungen2016$Stadtteil)

# zeichnen einiger Grafiken zum besseren verständnis

plot(Mietwohnungen2016$Fläche, Mietwohnungen2016$Miete)
# das bild zeigt einen Scatterplot und dieser weißt auf einen Zusammenhang hin
# Pearsonsche Kor.
cor(Mietwohnungen2016$Fläche, Mietwohnungen2016$Miete, method = "pearson")
cor(Mietwohnungen2016$Fläche, Mietwohnungen2016$Miete, method = "spearman")


# gibt es zwischen den Zimmern und der Miete einen Zusammenhang
plot(Mietwohnungen2016$Zimmer, Mietwohnungen2016$Miete)
# Spearman Kor.
# spearman immer wenn ich Klassen oder Ordinale Merkmale hab
cor(Mietwohnungen2016$Zimmer, Mietwohnungen2016$Miete, method = "spearman")#
boxplot(  Mietwohnungen2016$Miete ~  Mietwohnungen2016$Zimmer, range = 0 ) # hier wird im Boxplot die Spannweite genommen
boxplot(  Mietwohnungen2016$Miete ~  Mietwohnungen2016$Zimmer)

hist(  Mietwohnungen2016$Fläche) # Histogramm der Fläche
hist(  Mietwohnungen2016$Miete) # Histogramm der Miete

# Wiederholung: einfache deskriptive Statistik
stripchart(Mietwohnungen2016$Miete ~  Mietwohnungen2016$Zimmer)
plot(Mietwohnungen2016$Miete, Mietwohnungen2016$Zimmer)

mean( Mietwohnungen2016$Miete)
median( Mietwohnungen2016$Miete)

var( Mietwohnungen2016$Miete)
sqrt(var( Mietwohnungen2016$Miete)) # wurzel aus der varianz , sqrt - quadratwurzel

quantile( Mietwohnungen2016$Miete, probs = 0.25)
quantile( Mietwohnungen2016$Miete, probs = 0.75)

summary(Mietwohnungen2016)


# 1. Beispiel - Einfaktorielle Varianzanalyse 
# Anova oder Varianzanalyse 
P1 <- aov(Mietwohnungen2016$Miete ~  factor(Mietwohnungen2016$Zimmer)) # factor erzeugt eine Kategorie
P1
summary(P1) # p-value < 0.05
# p-value ist die Wahrscheinlichkeit, dass die Nullhypothese wahr ist
# wir sehen eine Signifikanz die wird durch *** dargestellt
# die F-Verteilung ist die Verteilung der Varianzen
# je nach Zimmeranzahl unterscheiden sich die Preise
# die Varianzanalyse ist ein Test auf die Mittelwerte

# 2. Beispiel - Stadtteil
# Anova oder Varianzanalyse
stripchart(Mietwohnungen2016$Miete ~  Mietwohnungen2016$Stadtteil)
boxplot(  Mietwohnungen2016$Miete ~  Mietwohnungen2016$Stadtteil)
P2 <- aov(Mietwohnungen2016$Miete ~  factor(Mietwohnungen2016$Stadtteil))
P2
summary(P2) # p-value < 0.05


#---------------
# zurück zu Grafiken und der Erstellung eines Boxplots mit Dichte

# Histgramm, ECDF

hist(Mietwohnungen2016$Fläche, freq = FALSE , breaks = 25)
lines(density(Mietwohnungen2016$Fläche), type = "l" , col = 3, lwd = 2) # das ist die Kerndichteschätzung
lines(x = seq(0,320, by = 0.5),
      dnorm(seq(0,320, by = 0.5), 
            mean=  mean(Mietwohnungen2016$Fläche),
            sd= sd(Mietwohnungen2016$Fläche)
      ), col= 4 , lwd = 2
) # dichte der Normalverteilung zum Vergleich

plot(ecdf(Mietwohnungen2016$Fläche))
lines(ecdf(rnorm(10000, mean = mean(Mietwohnungen2016$Fläche), sd = sd(Mietwohnungen2016$Fläche))),col=2)
# diese bilder zeigen einmal die empirische Verteilungsfunktion
# das 2. zeigt die Verteilungsfunktion einer Normalverteilung mit:
# Mittelwert = Mittelwert(Fläche)
# Standardabweichung = Sd(Fläche)
# rnorm erzeugt zufällige normalverteilte werte r´(r)norm heißt randomised



# wie sieht die Standard-Normalverteilung aus
set.seed(1234) # wir setzen einen fixpunkt, so dass unsere Zufallszahlen immer gleich sind
hist(rnorm(100000), freq = FALSE)
lines(density(rnorm(10000)), col= 2 , lwd = 2)
lines(seq(-5,5, by = 0.01),dnorm(seq(-5,5, by = 0.01)), col= 4 , lwd = 2)



# Chi-Quadrat

chisq.test(x = Mietwohnungen2016$Stadtteil, y = Mietwohnungen2016$Miete)
set.seed(123)
chisq.test(y = Mietwohnungen2016$Stadtteil, x = Mietwohnungen2016$Miete, simulate.p.value = TRUE, B = 100)
# der p-value ist der Probability Wert und sagt wie unwarscheinlich die Korrelation ist
length(unique(Mietwohnungen2016$Stadtteil)) # wieviele Stadtteile sind im Beispieldatensatz
