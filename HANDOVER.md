# Tetra Brass Website — Übergabe-Dokument

Diese Datei beschreibt alles, was zur Pflege von tetrabrass.com nötig ist.
Für den neuen Maintainer (Aljoscha) und dessen Claude-Account — einfach
diese Datei lesen lassen ("lies HANDOVER.md"), dann ist der Kontext da.

## Überblick

- Statische, mehrsprachige Website (DE/EN/FR) für das Blechbläserquartett Tetra Brass
- Gehostet auf GitHub Pages, Custom Domain: tetrabrass.com
- Kein Build-System — reines HTML/CSS/Vanilla-JS
- Repo: `tetrabrass/tetrabrass.github.io` (DE-Seiten im Root, EN unter `/en/`, FR unter `/fr/`)
- GitHub-Account für das Repo: dedizierter Projekt-Account (nicht Jakobs privater),
  E-Mail/Git-Identität durchgehend: info@tetrabrass.com

## Ersteinrichtung auf einem neuen Mac

```bash
git config --global user.name "<Dein Name>"
git config --global user.email "info@tetrabrass.com"

ssh-keygen -t ed25519 -C "info@tetrabrass.com"
cat ~/.ssh/id_ed25519.pub | pbcopy
```
Dann den Key bei GitHub hinterlegen: Settings → SSH and GPG keys → New SSH key →
einfügen. Danach testen:
```bash
ssh -T git@github.com
```
Repo klonen:
```bash
cd ~
git clone git@github.com:tetrabrass/tetrabrass.github.io.git tetrabrass-website
cd tetrabrass-website
```

## Lokale Vorschau starten

```bash
cd ~/tetrabrass-website
python3 -m http.server 8934
```
Dann `http://localhost:8934/` im Browser öffnen. Server-Tab offen lassen,
während man arbeitet. Nach CSS-Änderungen Browser-Cache leeren
(Safari: Cmd+Option+E), sonst zeigt die Vorschau alte Styles.

## Header/Footer: zentrale Partials

Header und Footer liegen zentral in:
Mobile Overrides liegen jeweils in `@media (max-width: 720px)` bzw.
`@media (max-width: 760px)` Blöcken am Ende der jeweiligen Datei.

## Design-Regeln (bitte beibehalten)

- Keine abgerundeten Ecken irgendwo (`border-radius: 0`)
- Diskografie-Akkordeon: immer nur ein Eintrag gleichzeitig offen
- Farben: `#ffffff` (Hintergrund) / `#1a1814` (Text, `--ink`)
- Schriften: Archivo (Headlines) + DM Sans (Fließtext)
- Header ist überall eine statische Leiste über dem Inhalt (kein Overlay mehr
  auf Bildern, seit Oktober 2026 so umgebaut — Start- und Ensemble-Seite nutzen
  dafür einen `.hero-stage`-Flex-Wrapper, der das Bild/Karussell auf die
  restliche Viewport-Höhe streckt)
- Navigation einzeilig, Versalien, Grauton `--nav-muted` für unbetonte Links

## Git-Workflow

- Vor jedem Commit: Diff anschauen (`git diff`, `git status --short`)
- Änderungen erst lokal auf `localhost:8934` testen (Desktop UND Mobile-Ansicht,
  z.B. über die Browser-DevTools oder ein echtes Handy)
- Pro Commit nur eine klar abgegrenzte Änderung, keine Sammel-Commits über
  mehrere Themen hinweg
- Nach dem Push zur Kontrolle: `git log --oneline -3` und `git status --short`

## Bekannte Altlasten

- Ca. 19 alte Squarespace-Redirect-Stub-Seiten im Root (z.B. `christian-traute/`,
  `ursprung/`, `metall/`, `sound/` etc.) — reine Weiterleitungen (meta-refresh +
  noindex) von der alten Website, bewusst so belassen, kein Fehler.
- Content-Security-Policy ist als Meta-Tag auf allen echten Seiten gesetzt
  (`script-src 'self' 'unsafe-inline'`, wegen Inline-Scripts in den Akkordeons
  auf Diskografie/Programme/Repertoire).
- Stand Oktober 2026: vollständiger Audit durchgeführt (JS-Syntax, kaputte
  Links, doppelte CSS-Selektoren, Debug-Reste) — alles sauber, keine offenen
  Baustellen bekannt.

## Arbeiten mit Claude Code

Diese Datei genügt als Einstieg für eine neue Claude-Session — einfach
"lies HANDOVER.md" sagen. Tipp aus der bisherigen Zusammenarbeit: Falls Claude
über eine Geräte-Verbindung direkt auf dem Mac arbeitet und dabei
Git-Identitätsfehler auftreten (weil eine Sandbox-Umgebung kein eigenes
`~/.gitconfig` hat), hat es sich bewährt, Claude zu bitten, Terminal-Befehle
zum Einfügen zu liefern, statt selbst im Hintergrund auszuführen — dann läuft
alles über das eigene Terminal mit korrekt eingerichteter Git-Identität.
