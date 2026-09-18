# Übungsblatt 1: Grundlagen in R (zu Vorlesung 1)
# Lösung

# Aufgabe 1: Rechnen
5 + 12            # 17
8 * 4             # 32
15 / 4            # 3.75
(7 * 3) + (9 / 2) # 25.5

# Aufgabe 2: Objekte
a <- 10
b <- a * 2        # b ist 20
a + b             # 30

# Aufgabe 3: Vergleiche
10 > 5            # TRUE
4 <= 8            # TRUE
3 != 2            # TRUE
7 == 7            # TRUE

# Aufgabe 4: Vektoren
v <- c(3, 8, 1, 12, 7)
sum(v)            # 31
mean(v)           # 6.2
v[4]              # 12
v[v > 5]          # 8 12 7

# Aufgabe 5: Fehlende Werte
w <- c(2, NA, 6, 10)
mean(w)                 # NA: Ein fehlender Wert macht das Ergebnis unbekannt
mean(w, na.rm = TRUE)   # 6
sum(is.na(w))           # 1

# Aufgabe 6: Datentypen
x <- c(1, 2, "drei")
class(x)          # "character": Wegen "drei" werden alle Elemente zu Text
as.numeric(x)     # 1 2 NA, mit Warnung: "drei" lässt sich nicht in eine Zahl umwandeln
