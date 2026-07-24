#!/usr/bin/env bash
# Schreibt die sprachspezifischen Partials (assets/partials/header.{de,en,fr}.html
# und footer.{de,en,fr}.html) in jede */index.html zwischen den Markern
# <!-- HEADER:START/END --> und <!-- FOOTER:START/END -->, sowie die
# hreflang-Alternates zwischen <!-- HREFLANG:START/END -->.
#
# - Sprache + Slug einer Seite werden aus dem Pfad hergeleitet:
#     ensemble/index.html      -> lang=de, slug=ensemble
#     en/ensemble/index.html   -> lang=en, slug=ensemble
#     fr/index.html            -> lang=fr, slug=""
# - Im Hauptmenü wird class="current" wie bisher per data-page=<slug> gesetzt.
# - Im Sprachumschalter (<span data-lang="xx">) wird pro Zielsprache xx
#   entschieden:
#     xx == eigene Sprache        -> <span class="active">xx</span>
#     Übersetzung existiert auf Platte (z. B. en/<slug>/index.html) -> echter Link
#     sonst                       -> <span class="lang-disabled">xx</span>
#   So verlinkt der Umschalter nie auf eine Seite, die es noch nicht gibt.
# - hreflang: pro Slug wird für jede Sprache, die auf Platte existiert, ein
#   <link rel="alternate" hreflang="xx"> mit absoluter URL erzeugt, plus
#   hreflang="x-default" auf die DE-Fassung (Standardsprache der Seite).
# - sitemap.xml wird bei jedem Lauf aus allen gefundenen Seiten neu geschrieben
#   (unabhängig von per CLI eingeschränkten Zielseiten). Seiten mit
#   <meta name="robots" content="noindex"> werden ausgelassen.
#
# Aufruf ohne Argumente: synct alle */index.html (de-root, en/*, fr/*).
# Aufruf mit Pfaden: synct NUR die angegebenen Seiten, prüft Existenz von
# Übersetzungen aber weiterhin über die ganze Seite (für den Sprachumschalter).
#   ./scripts/sync-partials.sh ensemble/index.html en/ensemble/index.html
set -euo pipefail
cd "$(dirname "$0")/.."

python3 - "$@" <<'PY'
import re
import sys
from pathlib import Path

root = Path(".")
LANGS = ["de", "en", "fr"]
BASE_URL = "https://tetrabrass.com"

header_tpl = {lang: (root / f"assets/partials/header.{lang}.html").read_text() for lang in LANGS}
footer_tpl = {lang: (root / f"assets/partials/footer.{lang}.html").read_text() for lang in LANGS}

def discover_pages():
    """Liste aller (Path, lang, slug) im Projekt."""
    pages = []
    root_index = root / "index.html"
    if root_index.exists():
        pages.append((root_index, "de", ""))
    for d in sorted(root.iterdir()):
        if not d.is_dir() or d.name in ("assets", "scripts", "en", "fr") or d.name.startswith("."):
            continue
        idx = d / "index.html"
        if idx.exists():
            pages.append((idx, "de", d.name))
    for lang in ("en", "fr"):
        lang_root = root / lang
        if not lang_root.is_dir():
            continue
        lang_index = lang_root / "index.html"
        if lang_index.exists():
            pages.append((lang_index, lang, ""))
        for d in sorted(lang_root.iterdir()):
            if not d.is_dir():
                continue
            idx = d / "index.html"
            if idx.exists():
                pages.append((idx, lang, d.name))
    return pages

all_pages = discover_pages()

def page_file_for(lang, slug):
    if lang == "de":
        return (root / slug / "index.html") if slug else (root / "index.html")
    return (root / lang / slug / "index.html") if slug else (root / lang / "index.html")

def target_href(lang, slug):
    prefix = "" if lang == "de" else f"{lang}/"
    return f"/{prefix}{slug}/" if slug else f"/{prefix}"

def header_for_page(lang, slug):
    html = header_tpl[lang]

    # Hauptmenü: class="current" auf den Nav-Link mit passendem data-page
    if slug:
        pattern = re.compile(r'(<a href="[^"]*" data-page="%s")' % re.escape(slug))
        html, _ = pattern.subn(r'\1 class="current"', html)

    # Sprachumschalter: jede data-lang-Span pro Zielseite neu auflösen
    def resolve_lang_span(m):
        target_lang = m.group(1)
        if target_lang == lang:
            return f'<span class="active">{target_lang}</span>'
        if page_file_for(target_lang, slug).exists():
            return f'<a href="{target_href(target_lang, slug)}">{target_lang}</a>'
        return f'<span class="lang-disabled">{target_lang}</span>'

    html = re.sub(r'<span data-lang="(\w+)">\w+</span>', resolve_lang_span, html)
    return html

def hreflang_for_page(lang, slug):
    lines = []
    for target_lang in LANGS:
        if page_file_for(target_lang, slug).exists():
            lines.append(
                f'<link rel="alternate" hreflang="{target_lang}" '
                f'href="{BASE_URL}{target_href(target_lang, slug)}">'
            )
    # x-default: DE ist die Standardsprache der Seite
    if page_file_for("de", slug).exists():
        lines.append(
            f'<link rel="alternate" hreflang="x-default" '
            f'href="{BASE_URL}{target_href("de", slug)}">'
        )
    return "\n".join(lines)

def replace_block(text, marker, block):
    start, end = f"<!-- {marker}:START -->", f"<!-- {marker}:END -->"
    indent_match = re.search(r"[ \t]*(?=" + re.escape(start) + ")", text)
    indent = indent_match.group(0) if indent_match else ""
    lines = block.strip("\n").splitlines()
    indented_block = "\n".join(indent + line if line else line for line in lines)
    pattern = re.compile(re.escape(start) + r".*?" + re.escape(end), re.S)
    replacement = f"{start}\n{indented_block}\n{indent}{end}"
    new_text, n = pattern.subn(replacement, text)
    if n == 0:
        print(f"  WARNUNG: keine {marker}-Marker gefunden")
    return new_text

# Zielmenge bestimmen: entweder alle Seiten, oder nur die per CLI angegebenen
requested = sys.argv[1:]
if requested:
    requested_paths = {Path(p).resolve() for p in requested}
    pages = [p for p in all_pages if p[0].resolve() in requested_paths]
    missing = requested_paths - {p[0].resolve() for p in pages}
    for m in missing:
        print(f"  WARNUNG: {m} nicht gefunden oder keine gültige Seite")
else:
    pages = all_pages

changed = 0
for page, lang, slug in pages:
    text = page.read_text()
    updated = replace_block(text, "HEADER", header_for_page(lang, slug))
    updated = replace_block(updated, "FOOTER", footer_tpl[lang])
    updated = replace_block(updated, "HREFLANG", hreflang_for_page(lang, slug))
    if updated != text:
        page.write_text(updated)
        print(f"aktualisiert: {page}  (lang={lang}, slug={slug or '·'})")
        changed += 1

print(f"\n{changed} Datei(en) synchronisiert von {len(pages)} geprüft "
      f"(insgesamt {len(all_pages)} Seiten im Projekt gefunden).")

# sitemap.xml: immer aus ALLEN gefundenen Seiten neu geschrieben, auch wenn
# der Lauf per CLI auf einzelne Seiten eingeschränkt war. noindex-Seiten
# fliegen raus, damit die Sitemap kein widersprüchliches Signal sendet.
sitemap_urls = []
for page, lang, slug in sorted(all_pages, key=lambda p: (p[1] != "de", p[2])):
    content = page.read_text()
    if 'name="robots" content="noindex"' in content:
        continue
    sitemap_urls.append(f"{BASE_URL}{target_href(lang, slug)}")

sitemap_body = "\n".join(f"  <url><loc>{url}</loc></url>" for url in sitemap_urls)
sitemap_xml = (
    '<?xml version="1.0" encoding="UTF-8"?>\n'
    '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n'
    f"{sitemap_body}\n"
    "</urlset>\n"
)
sitemap_path = root / "sitemap.xml"
if not sitemap_path.exists() or sitemap_path.read_text() != sitemap_xml:
    sitemap_path.write_text(sitemap_xml)
    print(f"sitemap.xml geschrieben ({len(sitemap_urls)} URLs).")
PY
