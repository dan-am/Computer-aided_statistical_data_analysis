# Grundrechenarten in R

5 + 1  # Addition: Ergebnis 6
6 - 2.6  # Subtraktion: Ergebnis 3.4
4 * 0.01  # Multiplikation: Ergebnis 0.04
9 / 8  # Division: Ergebnis 1.125
(3 / 4) * (5 / 8)  # Kombinierte Operation: Ergebnis 0.46875

1 + 5  # Addition: Ergebnis 6

# Arbeiten mit Variablen und Zuweisungen
# R ist eine Objektsprache, was bedeutet, dass Werte Objekten (Variablen) zugewiesen werden.

# Hier wird ein Fehler auftreten, weil die Variable 'a' noch nicht definiert ist:
# a / 10  # Führt zu einem Fehler, weil 'a' nicht definiert ist

# Zuweisung eines Werts zu 'a'
a <- 1 + 5  # 'a' wird der Wert 6 zugewiesen
a  # Ausgabe: 6

# Alternativer Zuweisungsoperator (rechts nach links)
1 -> a  # 'a' wird der Wert 1 zugewiesen
a  # Ausgabe: 1

# Hinweis: In R können Variablen überschrieben werden, wie hier gezeigt.
# Zuerst war 'a' 6, dann wurde es 1.

# Logische Operatoren
3 > 1  # Wahr (TRUE), weil 3 größer als 1 ist
7 < 1  # Falsch (FALSE), weil 7 nicht kleiner als 1 ist
2 == 1  # Falsch (FALSE), weil 2 nicht gleich 1 ist
3 != 1  # Wahr (TRUE), weil 3 nicht gleich 1 ist
1 <= 1  # Wahr (TRUE), weil 1 kleiner oder gleich 1 ist
2 >= 2  # Wahr (TRUE), weil 2 größer oder gleich 2 ist

# Hinweis: Das Ergebnis von logischen Vergleichen ist ein logischer Wert (TRUE oder FALSE).

# Arithmetik mit logischen Werten
(3 > 1) + 1  # TRUE wird als 1 interpretiert, also 1 + 1 = 2

# Arbeiten mit Funktionen
# Eine Funktion ist ein vordefinierter Satz von Anweisungen, die aufgerufen werden können.

# Überprüfen, ob ein Wert NA (Not Available) ist
is.na(100)  # Ergebnis: FALSE, weil 100 nicht NA ist
is.na(NA)  # Ergebnis: TRUE, weil NA gleich NA ist

# Eigene Funktionen definieren
daniel <- function() {
  return("hello world!")
}

# Aufruf der Funktion
daniel()  # Ausgabe: "hello world!"
daniel  # Zeigt die Definition der Funktion

# Weitere eingebaute Funktionen
sum(2 < 3)  # Summe von TRUE, was als 1 interpretiert wird: Ergebnis 1
sum(10 + 2)  # Summe des Ausdrucks 10 + 2: Ergebnis 12

# Mehrere Werte an die Summe-Funktion übergeben, einschließlich NA
sum(1, 2, 3, 4, 10, NA, na.rm = TRUE)  # NA wird ignoriert, Ergebnis: 20
sum(1, 2, 3, 4, 10, NA)  # Ohne na.rm, Ergebnis ist NA, weil ein NA enthalten ist

# Hilfefunktion in R
?sum  # Zeigt die Dokumentation der Funktion sum() an
help(sum)  # Alternative Methode, um die Hilfe anzuzeigen

# Objektorientierung in R
# Erstellen eines Vektors (Sammlung von Werten desselben Typs)
a <- 1,3,6,8,10  # Fehler: Komma wird als Dezimaltrennzeichen interpretiert
hwr <- c(1, 4, 8, 10)  # Ein numerischer Vektor, c heißt concatenate
hwr  # Ausgabe: 1 4 8 10

# Erstellen eines gemischten Vektors
hwr_neu <- c(1, 4, 8, 10.4, "eins")  # Dieser Vektor enthält eine Zahl als Zeichenfolge
hwr_neu  # Ausgabe: "1" "4" "8" "10.4" "eins"

# Ersetzen von "eins" durch das Objekt 'eins', das den numerischen Wert 1 enthält
eins <- 1  # Zuweisung des Werts 1 an das Objekt 'eins'
hwr_neu2 <- c(1, 4, 8, 10, eins)  # Erstellen eines neuen Vektors
hwr_neu2  # Ausgabe: 1 4 8 10 1

# Vektoroperationen
hwr_neu2 / 5  # Jedes Element des Vektors wird durch 5 dividiert

# Summen von Vektoren
sum(hwr)  # Ergebnis: 23 (Summe der Elemente im Vektor hwr)

# Zugriff auf Elemente eines Vektors
hwr[3]  # Ausgabe des dritten Elements: 8

# Logische Operationen auf Vektoren
hwr > 6  # Prüft, ob jedes Element größer als 6 ist
hwr[hwr > 6]  # Gibt nur die Elemente zurück, die größer als 6 sind: 8 und 10

# Struktur von Objekten untersuchen
str(hwr)  # Zeigt die Struktur des Vektors hwr an
str(TRUE)  # Zeigt die Struktur des logischen Werts TRUE


# kurzer Exkurs zum zeichnen und der Hilfe
# umgang mit der hilfe und Beispiele

require(stats) # require prüft das vorhandensein eines paketes und lädt es hier stats
require(graphics) # require prüft das vorhandensein eines paketes und lädt es hier graphics
# wenn ein Fehler ausgegeben wird, dann ist das Paket nicht installiert
# install.packages("graphics", dependencies = TRUE) # installiert das Paket graphics
plot(cars)  # cars ist ein Datensatz aus R und wird mit den Paketen zuvor geladen
# plot ist eine Funktion, die ein Streudiagramm erstellt
lines(lowess(cars)) # lines ist eine Funktion, die eine Linie in ein Diagramm zeichnet und 
# lowess ist eine Funktion, die eine geglättete Linie berechnet
# was macht die funktion lowess
? lowess() # zeichnet eine line vom Ursprung zur rechten Seite
? plot
plot(cos, -pi, 2*pi) # see ?plot.function
lines(seq(-pi, 2*pi, by = 0.1), sin(seq(-pi, 2*pi, by = 0.1)), col = "blue") 


# Beispiel für die Erstellung eines einfachen DataFrames
df <- data.frame(
  Name = c("Anna", "Bernd", "Clara"),
  Alter = c(23, 35, 28)
)
df  # Ausgabe des DataFrames
df[1, ]  # Ausgabe der ersten Zeile des DataFrames
df[, 2]  # Ausgabe der zweiten Spalte des DataFrames
# Zugriff auf Spalten eines DataFrames
df$Alter  # Gibt die Alterswerte zurück: 23, 35, 28
mean(df$Alter)  # Durchschnittsalter berechnen: 28.67

# Zusammenfassung der Inhalte eines DataFrames
summary(df)  # Statistische Zusammenfassung des DataFrames

# Visualisierung von Daten
# Erstellen eines einfachen Streudiagramms
barplot( height = df$Alter, # Höhe der Balken
         names.arg = df$Name, # Namen der Personen
         main = "Alter der Personen", # Titel des Diagramms
         xlab = "Alter", ylab = "Name") # Beschriftung der Achsen
