# Computergestützte Statistische Datenanalyse mit R

*R scripts, exercises and data for a German bachelor course in computer-aided statistics (HWR Berlin). Comments and materials are in German.*

Materialien zum Bachelorkurs „Computergestützte Statistische Datenanalyse“ (HWR Berlin, DL25, Wintersemester 2026). Das Repository enthält den R-Code, die Datensätze und die Grafiken des Kurses; die Dateien liegen im Moodle-Kurs unter denselben Namen. Vorlesungsfolien, Übungsblätter und die Kurstexte werden außerhalb des Repositorys gepflegt, im Ordner `Moodle_Ueberarbeitung/` neben diesem Projektordner.

**Vorwissen:** Statistik 1, also deskriptive Statistik, Wahrscheinlichkeitsrechnung und Regression ohne Tiefgang. Hypothesentests und p-Werte gehören nicht zum Kurs; Varianzanalyse und Chi-Quadrat werden über ihren deskriptiven Kern behandelt (Streuungszerlegung, korrigierter Kontingenzkoeffizient).

## Aufbau

| Ordner | Inhalt |
|---|---|
| `Lectures/` | R-Skripte der Vorlesungen, `Archiv/` enthält die Flinkster-Fallstudie von 2024 |
| `Exercises/` | Übungen mit Kontrollwerten: `UE0n_Aufgaben.R` (Vorlage) und `UE0n_Loesung.R` |
| `Data/Input/` | Datensätze der Vorlesungen und der Hausarbeit |
| `Graphics/` | Skript und PNG-Dateien der vier R-Grafiken, die im Moodle-Kurs mit Deutungsfragen stehen |

Die Übungsblätter in `Moodle_Ueberarbeitung/Uebungsblaetter/` drucken den Code aus `Exercises/` direkt ein, die Folien in `Moodle_Ueberarbeitung/Folien/` zeigen die Beispiele aus `Lectures/`. Beide Ordner erwarten das Repository unter diesem Namen daneben.

## Vorlesungen

| Skript | Thema | Datensatz | Übung |
|---|---|---|---|
| `VL1_Grundlagen.R` | Rechnen, Objekte, Vektoren, Funktionen, erste Grafiken | – | UE01 |
| `VL2_Daten_einlesen_dplyr.R` | Daten einlesen, filtern, gruppieren mit dplyr | Gebrauchtwagen | UE02 |
| `VL3_Deskriptive_Statistik.R` | Lage, Streuung, Quantile, Korrelation, Faustregel zur Stärke | Gebrauchtwagen | UE03 |
| `VL4_Zusammenhaenge.R` | Korrelation, Zufallsvergleich durch Mischen, Streuungszerlegung, Kreuztabelle | Mietwohnungen | folgt |
| `VL5_Grafiken_Regression.R` | Grafiken mit ggplot2, einfache und multiple Regression | Mietwohnungen | folgt |
| `VL6_Verteilungen.R` | Normalverteilung, Verteilungsfunktion, fehlende Werte | simuliert, Mietwohnungen | folgt |
| `VL7_Fallstudie_Passagierzahlen.R` | vollständige Fallstudie wie in der Hausarbeit | Passagierzahlen | – |

## Datensätze

| Datei | Beobachtungen | Variablen |
|---|---|---|
| `Gebrauchtwagen.csv` | 863 Fahrzeuge | `Typ`, `Alter` (Monate), `Fahr` (Tausend km), `Hub` (100 cm³, also 25 = 2,5 Liter), `Wert` (Euro) |
| `Mietwohnungen2016.csv` | 5.148 Wohnungen | `Stadtteil`, `Ortskode` (Code des Stadtteils), `WestOst` und `NordSüd` (Lage), `Lage` (Stufen 1 bis 3), `Zimmer`, `Fläche` (m²), `Miete` (Euro) |
| `Passagierzahlen.csv` | 610.670 Halte der S-Bahn Hamburg, 10.12.2016 bis 01.04.2017 | `Zugnr`, `Station`, `Einsteiger`, `Aussteiger`, Ist-Ankunft und Ist-Abfahrt, Linie |

Gebrauchtwagen und Mietwohnungen sind UTF-8-kodiert, die Passagierzahlen Latin-1. Alle Dateien nutzen das Semikolon als Trenner und das Komma als Dezimalzeichen; die Skripte zeigen, wie man sie einliest.

## Einrichtung

1. **Posit Cloud** (empfohlen, ohne Installation) oder **R und RStudio Desktop**.
2. Das Projekt über `Computer-aided_statistical_data_analysis.Rproj` öffnen. Alle Pfade sind relativ zum Projektordner (`Data/Input/...`).
3. Pakete einmalig installieren: `readr`, `dplyr`, `ggplot2`, `corrplot`. In den Skripten steht die Zeile `install.packages(...)` jeweils auskommentiert vor `library(...)`.

## Arbeiten mit KI-Werkzeugen

KI-Werkzeuge wie GitHub Copilot (für Studierende kostenlos) oder Posit Assistant sind erlaubt. Prüfen Sie jedes Ergebnis selbst: Läuft der Code in einer frischen Sitzung? Passt das Verfahren zum Skalenniveau? Stimmen die Zahlen mit den Kontrollwerten überein? KI-Werkzeuge schlagen oft Tests und p-Werte vor, die nicht zum Kurs gehören. Die Regeln für die Hausarbeit stehen im Moodle-Kurs.

## Lizenz

GPL-3.0, siehe `LICENSE`.
