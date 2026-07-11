# Tetra Brass Website — Build-Briefing (für Claude Code / Terminal)

## Projekt & Abgrenzung
- Website des Blechbläserquartetts **Tetra Brass** → tetrabrass.com
- **Statische Seite für GitHub Pages**, handgeschriebenes HTML/CSS/JS (kein Framework, kein Build-Tool nötig).
- **Eigenes, getrenntes Repo.** NICHT mit dem persönlichen Projekt *jakob-grimm.de* (Repo: hg9fj7ntkk-ai/jakob-grimm-website) vermischen. Immer prüfen, in welchem Ordner/Repo gearbeitet wird.
- Vorlage: die fünf Mockups (Startseite, ensemble, termine, diskografie, repertoire). Design & Interaktionen 1:1 übernehmen.

## Stack / Setup
- **Self-hosted Fonts (woff2), KEINE Google Fonts:** Archivo (Display/Headings/Wordmark), DM Sans (Body/Nav/Labels).
- Bilder lokal (z. B. `/assets/img/`). GitHub Pages ist **case-sensitive** → Groß-/Kleinschreibung der Ordner-/Dateinamen exakt einhalten.
- Logo als **SVG** einbinden (in den Mockups ist es base64-PNG).

## Design-Tokens (`:root`)
- `--bg: #f5f2ed;` (Off-White)
- `--ink: #1a1814;` (near-black)
- `--pad: clamp(24px, 3.5vw, 56px);` (Randabstand)
- `--maxw: 1500px;` (Inhaltsbreite)
- Schrift: Archivo = Display, DM Sans = Body

## Layout-System (WICHTIG, überall gleich)
- **Header + Footer:** volle Breite, nur `padding: var(--pad)`.
- **Inhalt dazwischen:** `max-width: var(--maxw); margin: 0 auto;` — auf JEDER Seite identisch.
- Ausnahme: **Ensemble-Bio** = zentrierte schmale Lesespalte (~92ch), bewusst so.
- **Keine runden Ecken — nirgends:** `border-radius: 0` bei allen Rahmen, Buttons, Karten, Toggles, Bildern. Grund: „Tetra" = vier-eckig (verschränktes Quadrat im Logo).

## Header
- Logo links, zweispaltige **lowercase**-Navigation rechts:
  - Spalte 1: `ensemble · programme · kollaboration`
  - Spalte 2: `termine · diskografie · repertoire`
- Sprachwahl unter „repertoire": `de / en / fr / it`
- Bild-Hero-Seiten (Startseite, Ensemble): Header liegt transparent über dem **randlosen** Hero; nur die Logo-/Nav-Ebene sitzt im `--maxw`-Raster.
- **Startseite: Zwei-Farben-Header (KEIN `mix-blend-mode`):**
  - Standard **hell** (Off-White Text, weißes Logo) → für die dunklen Bilder 2–4
  - `.overlay.is-dark` → **dunkel** (Ink Text, `filter: brightness(0)` Logo) → für das helle Bild 1
  - JS toggelt `.is-dark` bei `index === 0`; Farbübergang 0.45 s.

## Navigation: noch NICHT klickbar (kommt später)
- **programme** und **kollaboration** → im Menü sichtbar lassen, aber nicht verlinken (z. B. `<span>` statt `<a>`, bzw. `aria-disabled`, kein Hover-Cursor).
- (Bitte bestätigen, ob wirklich nur diese zwei.)

## Interaktionen
- **Diskografie- & Repertoire-Akkordion: SINGLE-OPEN** — beim Öffnen einer Klappe schließt sich jede andere (nie zwei gleichzeitig offen).
- Akkordion-Animation: `grid-template-rows: 0fr → 1fr` (animiert die echte Höhe, weich).

## Seiten
- **Fertig als Mockup:** Startseite (index), ensemble, termine, diskografie, repertoire.
- **Noch zu bauen:** programme, kollaboration, kontakt; Footer-Seiten: presse, newsletter, impressum, datenschutz.
- **Footer** (überall): `presse · kontakt · newsletter · datenschutz · impressum` + „© 2026 Tetra Brass".

## Inhalte
- **Vorerst KEINE echten Inhalte einbauen** — nur Struktur/Templates mit Platzhaltern.
- Bilder (vorgeschnitten) und Texte fügt Jakob danach **Schritt für Schritt einzeln** ein.
- Mehrsprachigkeit: zuerst **DE**; en/fr/it später (URL-Struktur noch offen).

## Referenz-Ästhetik
- ffwd-classical.de (Header, editoriale Ruhe) · NOVO Quartet (Termine-Kalenderstil).
