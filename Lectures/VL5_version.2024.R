# Notwendige Bibliotheken laden
library(readr)
library(ggplot2)
library(dplyr)
install.packages("corrplot")
library(corrplot)

# 1. Datensatz einlesen
file_path <- "Data/Input/Mietwohnungen2016.csv" # Pfad zur Datei anpassen
Mietwohnungen2016 <- read_delim(file_path, 
                                delim = ";", 
                                escape_double = FALSE, 
                                locale = locale(decimal_mark = ","), 
                                trim_ws = TRUE)

# 2. Erste Dateninspektion
# Zeigt die ersten Zeilen des Datensatzes
head(Mietwohnungen2016)

# Gibt eine Übersicht über die Struktur des Datensatzes
str(Mietwohnungen2016)

# Zeigt eine Zusammenfassung der Daten (Min, Max, Median, Mean, etc.)
summary(Mietwohnungen2016)

# 3. Fehlende Werte überprüfen
# Anzahl der fehlenden Werte in jeder Spalte
colSums(is.na(Mietwohnungen2016))

# 4. Verteilung der numerischen Variablen visualisieren
# Histogramm für Mietpreise
ggplot(Mietwohnungen2016, aes(x = Miete)) +
  geom_histogram(binwidth = 50, fill = "blue", color = "black", alpha = 0.7) +
  ggtitle("Histogramm der Mietpreise") +
  xlab("Mietpreise (Euro)") +
  ylab("Häufigkeit")

# Boxplot für Mietpreise
ggplot(Mietwohnungen2016, aes(y = Miete)) +
  geom_boxplot(fill = "orange", color = "black") +
  ggtitle("Boxplot der Mietpreise") +
  ylab("Mietpreise (Euro)")

# 5. Empirische kumulative Verteilungsfunktion (ECDF)
ggplot(Mietwohnungen2016, aes(x = Miete)) +
  stat_ecdf(geom = "step") +
  ggtitle("Empirische kumulative Verteilungsfunktion der Mietpreise") +
  xlab("Mietpreise (Euro)") +
  ylab("Kumulative Wahrscheinlichkeit")

# 6. Zusammenhang zwischen Zimmeranzahl und Mietpreise
# Scatterplot
ggplot(Mietwohnungen2016, aes(x = Zimmer, y = Miete)) +
  geom_point(color = "darkgreen") +
  ggtitle("Zusammenhang zwischen Zimmeranzahl und Mietpreise") +
  xlab("Zimmeranzahl") +
  ylab("Mietpreise (Euro)")

# 7. Chi-Quadrat-Test
# Häufigkeitstabelle für Stadtteil und Zimmeranzahl
table_stadtteil_zimmer <- table(Mietwohnungen2016$Stadtteil, Mietwohnungen2016$Zimmer)

# Chi-Quadrat-Test durchführen
chi_sq <- chisq.test(table_stadtteil_zimmer)

# Ergebnisse des Chi-Quadrat-Tests anzeigen
chi_sq

# 8. Varianzanalyse (ANOVA)
# Zimmeranzahl (numerisch) über verschiedene Stadtteile (kategorisch) analysieren
Mietwohnungen2016$Stadtteil <- as.factor(Mietwohnungen2016$Stadtteil)
anova_model <- aov(Zimmer ~ Stadtteil, data = Mietwohnungen2016)

# Ergebnisse der ANOVA
summary(anova_model)

# 9. Einfache lineare Regression
# Ziel: Vorhersage der Mietpreise basierend auf der Zimmeranzahl
linear_model <- lm(Miete ~ Zimmer, data = Mietwohnungen2016)

# Zusammenfassung des Modells
summary(linear_model)

# Visualisierung der Regressionsgerade
ggplot(Mietwohnungen2016, aes(x = Zimmer, y = Miete)) +
  geom_point(color = "blue") +
  geom_smooth(method = "lm", color = "red") +
  ggtitle("Lineare Regression: Mietpreise vs. Zimmeranzahl") +
  xlab("Zimmeranzahl") +
  ylab("Mietpreise (Euro)")

# 10. Multiple Regression
# Ziel: Vorhersage der Mietpreise basierend auf Zimmeranzahl und Fläche
multiple_model <- lm(Miete ~ Zimmer + Fläche, data = Mietwohnungen2016)

# Zusammenfassung des Modells
summary(multiple_model)

# Diagnostikplots für das multiple Regressionsmodell
par(mfrow = c(2, 2))  # Plots in einer 2x2-Anordnung
plot(multiple_model)

# 11. Korrelationen analysieren
# Korrelation zwischen numerischen Variablen berechnen
correlation_matrix <- Mietwohnungen2016 %>%
  select_if(is.numeric) %>%
  cor(use = "complete.obs")

# Korrelationen anzeigen
print(correlation_matrix)

# 12. Heatmap der Korrelationen (falls mehrere numerische Variablen vorliegen)

corrplot(correlation_matrix, method = "circle")
