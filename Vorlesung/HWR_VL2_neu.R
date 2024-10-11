## Vorlesung 2 / Fortsetzung von Vorlesung 1
# start einlesen von Daten


# 1. Datei in Moodle downloaden
# 2. im rechten unteren fenster zu der Datei navigieren (ggf. auf das Haus klicken)
# 3. wir installieren das notwendige Paket in R

install.packages("readr", dependencies = TRUE) # bitte prüft, ob das Paket bereits installiert ist
library(readr)

# diese 3 Zeilen importieren die Daten

"/Users/danielambach/Google Drive/2-Lehre/HWR/CDA_20_21/Gebrauchtwagen.csv" # hier muss euer dateipfad stehen

Gebrauchtwagen <- read_delim("Downloads/Gebrauchtwagen.csv", 
                             delim = ";", escape_double = FALSE, 
                             locale = locale(decimal_mark = ","), 
                             trim_ws = TRUE)
View(Gebrauchtwagen)

# structur und Klasse des Datensatzes 
# ergebnis: Metadaten des Datensatzes
class(Gebrauchtwagen)
str(Gebrauchtwagen)

# Aus dem Datensatz Daten auswählen:
Gebrauchtwagen[1, ] # zeigt die erste Zeile
Gebrauchtwagen[, 6] # 6. Spalte anzeigen
# der erste wert ist die Zeile und der 2. Wert ist Spalte

Gebrauchtwagen$Typ # direkter zugriff auf eine Spalte
Gebrauchtwagen$Typ[1] # ich wähle die 1. Beobachtung aus der Spalte "Typ"

head(Gebrauchtwagen)  # die ersten 6 Zeilen aller Spalten werden angezeigt
tail(Gebrauchtwagen)  # zeigt die letzten 6 Zeilen)

###### Manipulation von Daten in R -------
     
# Installieren eines Paketes um die Daten besser auswerten zu Koennen

install.packages("dplyr" , dependencies = TRUE)
library(dplyr)

base::mean(c(3,8,9)) # base:: gibt das Paket an aus dem die funktion mean() verwendet werden soll
# mean ist der Mittelwert

names(Gebrauchtwagen) # zeigt euch alle Spaltennamen

df <- Gebrauchtwagen %>%
  filter(Alter > 50 & Wert > 15000) # alles das beide Bedingungen erfüllt wird in df, einem neuen Objekt gespeichert

df  

df1 <- Gebrauchtwagen %>%
  filter(Typ == "5er BMW") # es werden aus dem Ausgangsdatensatz alle 5er BMW im Datensatz gespeichert

View(df1)  


# komplexe Anwendung der Gruppierungsfunktion und der Berechnung eines Mittelwerts

Gebrauchtwagen %>%
  group_by(Typ) %>%
  summarize( Mittelwert =  mean(Wert)) %>%  # Mittelwert ist nur die Bezeichnung der neuen Spalte
  arrange(Mittelwert)

mean(Gebrauchtwagen$Wert)

# bis hier Daten einlesen, Meta Daten analysieren
# danach daten filtern oder Aggregieren

mean(Gebrauchtwagen$Alter) # berechnet den Mittelwert
median(Gebrauchtwagen$Alter) # berechnet den mittleren Wert 

plot(Gebrauchtwagen$Alter, Gebrauchtwagen$Wert) # zeichnet eine Punktwolke oder Scatterplot
hist(Gebrauchtwagen$Alter)  # Histgramm
boxplot(Gebrauchtwagen$Alter)

# Scatterplot in R
cor(Gebrauchtwagen$Alter, Gebrauchtwagen$Wert) # correlation 


# zurück zu analyse und Manipulation von Daten
unique(Gebrauchtwagen$Typ) 
length(unique(Gebrauchtwagen$Typ))
# das ist eine Übersicht aller Daten und der wichtigsten Merkmale 
summary(Gebrauchtwagen)

# wir erzeugen eine neue Spalte
Gebrauchtwagen$alter_jahr <- Gebrauchtwagen$Alter / 12
View(Gebrauchtwagen)

table(Gebrauchtwagen$Typ, Gebrauchtwagen$Alter) # Häufigkeitstabelle

#-----

# Visualisierung von Daten
anzahl <- table(Gebrauchtwagen$Typ)
anzahl
barplot(height = anzahl, main = "Verteilung der Autotypen", xlab = "Autotypen") 
# main ist der Titel der Grafik und , xlab ist die X-Achsen bezeichnung

# kurzer Exkurs zum zeichnen und der Hilfe
# umgang mit der hilfe und Beispiele

require(stats) # for lowess, rpois, rnorm
require(graphics) # for plot methods
plot(cars)  # cars ist ein Datensatz aus R und wird mit den Paketen zuvor geladen
lines(lowess(cars))

# was macht die funktion lowess
? lowess() # zeichnet eine line vom Ursprung zur rechten Seite

? plot
plot(sin, -pi, 2*pi) # see ?plot.function

## andere Art des Barplots
plot( table(Gebrauchtwagen$Typ), type = "h", col = "red", lwd = 10,
     main = "Autotypen")
