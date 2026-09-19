# R-Grafiken für den Moodle-Kurs aus den Lehrdaten
# Erzeugt vier PNG-Dateien: Histogramm mit Kerndichte, Boxplot, ECDF, Streudiagramm.
# Benötigt nur ggplot2 und scales. Aufruf aus dem Projektordner des Repos:
#   source("Graphics/R_Grafiken_Lehrdaten.R")
# Die Grafiken stehen als Textfelder mit Deutungsfragen im Moodle-Kurs.

library(ggplot2)
library(scales)

if (!exists("daten"))   daten   <- "Data/Input"
if (!exists("ausgabe")) ausgabe <- "Graphics"
dir.create(ausgabe, showWarnings = FALSE, recursive = TRUE)

# Farben und Zahlenformat --------------------------------------------------
blau      <- "#2a78d6"   # Daten
blau_hell <- "#86b6ef"   # Flächen (Histogramm, Boxen)
orange    <- "#eb6834"   # Modell oder Vergleichskurve
tinte     <- "#0b0b0b"
tinte_2   <- "#52514e"
gedaempft <- "#898781"
gitter    <- "#e1e0d9"

zahl <- function(x, stellen = 0) {
  sub("^-", "−", formatC(x, format = "f", digits = stellen, big.mark = ".", decimal.mark = ","))
}
achse <- label_number(big.mark = ".", decimal.mark = ",")

thema <- theme_minimal(base_size = 13) +
  theme(
    plot.background    = element_rect(fill = "white", colour = NA),
    panel.grid.major   = element_line(colour = gitter, linewidth = 0.3),
    panel.grid.minor   = element_blank(),
    axis.title         = element_text(colour = tinte_2),
    axis.text          = element_text(colour = gedaempft),
    plot.title         = element_text(colour = tinte, face = "bold", size = 15),
    plot.subtitle      = element_text(colour = tinte_2, margin = margin(b = 10)),
    plot.caption       = element_text(colour = gedaempft, hjust = 0),
    plot.title.position   = "plot",
    plot.caption.position = "plot",
    plot.margin        = margin(14, 18, 10, 14)
  )

speichern <- function(plot, datei) {
  ggsave(file.path(ausgabe, datei), plot, width = 8, height = 5, dpi = 200, bg = "white")
}

# Daten einlesen -----------------------------------------------------------
# Semikolon als Trenner, Komma als Dezimalzeichen: read.csv2 erledigt beides.
autos <- read.csv2(file.path(daten, "Gebrauchtwagen.csv"), fileEncoding = "UTF-8-BOM")
miete <- read.csv2(file.path(daten, "Mietwohnungen2016.csv"), fileEncoding = "UTF-8-BOM")

# 1 Histogramm mit Kerndichte: Fahrzeugwert (Vorlesung 3) ------------------
autos$wert_tsd <- autos$Wert / 1000
mw  <- mean(autos$wert_tsd)
med <- median(autos$wert_tsd)
kd <- density(autos$wert_tsd)
dichte_max <- max(kd$y)
kd_bei_18 <- approx(kd$x, kd$y, xout = 18)$y

g1 <- ggplot(autos, aes(x = wert_tsd)) +
  geom_histogram(aes(y = after_stat(density)), binwidth = 2, boundary = 0,
                 fill = blau_hell, colour = "white", linewidth = 0.6) +
  geom_density(colour = orange, linewidth = 0.9) +
  geom_vline(xintercept = c(med, mw), colour = tinte_2, linewidth = 0.5) +
  annotate("text", x = med - 0.6, y = dichte_max * 1.12, hjust = 1, colour = tinte, size = 3.8,
           label = paste0("Median\n", zahl(med * 1000), " €")) +
  annotate("text", x = mw + 0.6, y = dichte_max * 1.12, hjust = 0, colour = tinte, size = 3.8,
           label = paste0("Mittelwert\n", zahl(mw * 1000), " €")) +
  annotate("text", x = 24.5, y = kd_bei_18 + 0.018, hjust = 0, colour = tinte_2, size = 3.6,
           label = "Kerndichteschätzung") +
  annotate("segment", x = 24, xend = 18.4, y = kd_bei_18 + 0.017, yend = kd_bei_18 + 0.002,
           colour = gedaempft, linewidth = 0.3) +
  scale_x_continuous(breaks = seq(0, 50, 10), labels = achse, expand = expansion(mult = c(0, 0.02))) +
  scale_y_continuous(breaks = seq(0, 0.1, 0.02), labels = label_number(decimal.mark = ",", accuracy = 0.01),
                     expand = expansion(mult = c(0, 0.22))) +
  labs(title = "Die Fahrzeugwerte sind rechtsschief verteilt",
       subtitle = "Histogramm mit Dichteskala und Kerndichte.\nWenige teure Fahrzeuge ziehen den Mittelwert über den Median.",
       x = "Fahrzeugwert in Tsd. €", y = "Dichte",
       caption = paste0("Daten: Gebrauchtwagen.csv, n = ", zahl(nrow(autos)), " Fahrzeuge")) +
  thema
speichern(g1, "R01_Histogramm_Kerndichte_Fahrzeugwert.png")

# 2 Boxplot mit Streuungszerlegung: Miete nach Zimmerzahl (Vorlesung 4) ----
# Streuungszerlegung als deskriptiver Kern der Varianzanalyse; kein F-Test, kein p-Wert.
miete$zimmer_f <- factor(miete$Zimmer)
anzahl <- table(miete$zimmer_f)
etiketten <- paste0(names(anzahl), " Zi.\nn = ", zahl(as.numeric(anzahl)))
gesamt_mw   <- mean(miete$Miete)
gruppen_mw  <- tapply(miete$Miete, miete$zimmer_f, mean)
sq_gesamt   <- sum((miete$Miete - gesamt_mw)^2)
sq_zwischen <- sum(anzahl * (gruppen_mw - gesamt_mw)^2)
eta2 <- sq_zwischen / sq_gesamt

g2 <- ggplot(miete, aes(x = zimmer_f, y = Miete)) +
  geom_boxplot(fill = blau_hell, colour = blau, width = 0.55, linewidth = 0.5,
               outlier.colour = gedaempft, outlier.size = 0.9, outlier.alpha = 0.6) +
  scale_x_discrete(labels = etiketten) +
  scale_y_continuous(labels = achse, breaks = seq(0, 3000, 500)) +
  labs(title = "Mit der Zimmerzahl steigt die Miete, und die Streuung wächst",
       subtitle = paste0("Streuungszerlegung: Die Zimmerzahl erklärt ", zahl(eta2 * 100),
                         " % der Streuung der Mieten (eta² = ", zahl(eta2, 2), ").\n",
                         "Der Rest ist Streuung innerhalb der Zimmerklassen."),
       x = NULL, y = "Miete in €",
       caption = paste0("Daten: Mietwohnungen2016.csv, n = ", zahl(nrow(miete)), " Wohnungen")) +
  thema + theme(panel.grid.major.x = element_blank())
speichern(g2, "R02_Streuungszerlegung_Miete_nach_Zimmern.png")

# 3 ECDF: Wohnfläche im Vergleich zur Normalverteilung (Vorlesung 4 und 6) -
fl_mw <- mean(miete$Fläche)
fl_sd <- sd(miete$Fläche)
raster <- seq(0, 320, by = 1)
vergleich <- data.frame(
  x = raster,
  empirisch = ecdf(miete$Fläche)(raster),
  normal    = pnorm(raster, mean = fl_mw, sd = fl_sd)
)
i <- which.max(abs(vergleich$empirisch - vergleich$normal))
x_max <- vergleich$x[i]

g3 <- ggplot() +
  geom_line(data = vergleich, aes(x = x, y = normal, colour = "Normalverteilung"), linewidth = 0.9) +
  stat_ecdf(data = miete, aes(x = Fläche, colour = "Empirische Verteilungsfunktion"),
            geom = "step", linewidth = 0.9) +
  annotate("segment", x = x_max, xend = x_max,
           y = vergleich$empirisch[i], yend = vergleich$normal[i], colour = tinte_2, linewidth = 0.4) +
  annotate("text", x = x_max + 6, y = mean(c(vergleich$empirisch[i], vergleich$normal[i])),
           hjust = 0, colour = tinte, size = 3.6,
           label = paste0("größter Abstand bei ", x_max, " m²:\n",
                          zahl(abs(vergleich$empirisch[i] - vergleich$normal[i]) * 100), " Prozentpunkte")) +
  scale_colour_manual(values = c("Empirische Verteilungsfunktion" = blau, "Normalverteilung" = orange),
                      breaks = c("Empirische Verteilungsfunktion", "Normalverteilung"), name = NULL) +
  scale_x_continuous(breaks = seq(0, 300, 50), labels = achse) +
  scale_y_continuous(labels = label_percent(decimal.mark = ",", suffix = " %"), breaks = seq(0, 1, 0.25)) +
  labs(title = "Die Wohnflächen weichen von der Normalverteilung ab",
       subtitle = paste0("Empirische Verteilungsfunktion der Fläche gegen eine Normalverteilung mit gleichem\nMittelwert (",
                         zahl(fl_mw, 1), " m²) und gleicher Standardabweichung (", zahl(fl_sd, 1), " m²)"),
       x = "Wohnfläche in m²", y = "Anteil der Wohnungen bis zu dieser Fläche",
       caption = paste0("Daten: Mietwohnungen2016.csv, n = ", zahl(nrow(miete)), " Wohnungen")) +
  thema + theme(legend.position = "top", legend.justification = "left",
                legend.text = element_text(colour = tinte_2),
                legend.key.width = unit(1.4, "cm"))
speichern(g3, "R03_ECDF_Flaeche_Normalverteilung.png")

# 4 Streudiagramm mit Regressionsgerade: Miete und Fläche (Vorlesung 5) ----
modell <- lm(Miete ~ Fläche, data = miete)
a  <- coef(modell)[1]
b  <- coef(modell)[2]
r2 <- summary(modell)$r.squared
x_ende <- 300

g4 <- ggplot(miete, aes(x = Fläche, y = Miete)) +
  geom_point(colour = blau, alpha = 0.18, size = 1.1, stroke = 0) +
  annotate("segment", x = 20, xend = x_ende, y = a + b * 20, yend = a + b * x_ende,
           colour = orange, linewidth = 0.9) +
  annotate("text", x = x_ende, y = a + b * x_ende + 110, hjust = 1, colour = tinte, size = 3.8,
           label = "Regressionsgerade") +
  annotate("text", x = 5, y = 2950, hjust = 0, vjust = 1, colour = tinte, size = 3.8,
           label = paste0("Miete = ", zahl(a, 1), " € + ", zahl(b, 2), " €/m² · Fläche\n",
                          "R² = ", zahl(r2, 2), ", r = ", zahl(cor(miete$Fläche, miete$Miete), 2))) +
  scale_x_continuous(breaks = seq(0, 300, 50), labels = achse, limits = c(0, 320)) +
  scale_y_continuous(breaks = seq(0, 3000, 500), labels = achse, limits = c(0, 3050)) +
  labs(title = "Größere Wohnungen kosten mehr, mit wachsender Streuung",
       subtitle = paste0("Jeder Punkt ist eine Wohnung.\nJeder zusätzliche Quadratmeter erhöht die Miete im Mittel um ",
                         zahl(b, 2), " €."),
       x = "Wohnfläche in m²", y = "Miete in €",
       caption = paste0("Daten: Mietwohnungen2016.csv, n = ", zahl(nrow(miete)), " Wohnungen")) +
  thema
speichern(g4, "R04_Streudiagramm_Regression_Miete_Flaeche.png")

# Kennzahlen für die Begleittexte ------------------------------------------
cat("Fahrzeugwert: Mittelwert", zahl(mw * 1000), "€, Median", zahl(med * 1000), "€\n")
cat("Streuungszerlegung Miete nach Zimmer: eta² =", zahl(eta2, 3), "\n")
cat("Fläche: Mittelwert", zahl(fl_mw, 1), ", sd", zahl(fl_sd, 1), ", größter ECDF-Abstand bei", x_max, "m²:",
    zahl(abs(vergleich$empirisch[i] - vergleich$normal[i]) * 100, 1), "Prozentpunkte\n")
cat("Regression: a =", zahl(a, 1), ", b =", zahl(b, 3), ", R² =", zahl(r2, 3), "\n")
