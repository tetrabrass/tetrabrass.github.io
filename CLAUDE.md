# Tetra Brass Website

Ausführliche Übergabe-Doku (Setup, Vorschau, Partials, Design-Regeln, Git-Workflow, Altlasten): **`HANDOVER.md` lesen.** Hier nur das Wichtigste für Claude-Sitzungen.

- Statische Seite, reines HTML/CSS/Vanilla-JS, kein Build. Repo `tetrabrass/tetrabrass.github.io`, GitHub Pages aus `main`: **Push auf `main` = live.**
- Vorschau: `python3 -m http.server 8934` im Repo-Root → http://localhost:8934/
- DE im Root, EN unter `en/`, FR unter `fr/`. Inhalte (auch Termine) stehen direkt im HTML der jeweiligen Seite; Änderungen in allen Sprachfassungen nachziehen.
- Header, Footer, hreflang/Canonical und `sitemap.xml` nur über `scripts/sync-partials.sh` pflegen, nie direkt zwischen den `<!-- …:START/END -->`-Markern editieren.
- CSP-Meta auf jeder Seite: keine Inline-Styles/`style`-Attribute, keine externen Ressourcen.
- `tetrabrass-build-briefing.md` ist teilweise überholt; im Zweifel gelten Code und `HANDOVER.md`.
- Vor dem Commit zuerst `git pull` (andere pushen ebenfalls auf `main`). Commit-Messages auf Deutsch, ein Thema pro Commit.
