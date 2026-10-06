#!/usr/bin/env bash
# Compiles the template and the test documents, treats every warning as a
# failure and checks the PDF text. The thesis output itself is Turkish, so the
# expected strings below ("Tablo 2.1.", "GİRİŞ", …) are Turkish on purpose.
# Requires: typst, pdftotext/pdffonts (poppler), Times New Roman and the package
# installed as @local/community-meu-gsnas-thesis:<version> (README > Installation).
set -euo pipefail
cd "$(dirname "$0")/.."

OUT="${OUT:-tests/out}"
mkdir -p "$OUT"
VERSION=$(sed -n 's/^version = "\(.*\)"/\1/p' typst.toml)

fail() { echo "FAIL: $*" >&2; exit 1; }

# compile <root> <input> <output>
compile() {
  local log
  log=$(typst compile --root "$1" "$2" "$3" 2>&1) || { echo "$log"; fail "$2 did not compile"; }
  if grep -q "^warning" <<<"$log"; then echo "$log"; fail "$2 produced a warning"; fi
  echo "compiled: $2"
}

pdf_text() { pdftotext -layout "$@" - ; }
# Read the text into a variable first: under pipefail, `pdftotext | grep -q`
# fails even on a match because grep closes the pipe early (SIGPIPE).
contains() { local t; t=$(pdf_text "$1"); grep -qF -- "$2" <<<"$t" || fail "'$2' not found in $1"; }
not_contains() { local t; t=$(pdf_text "$1"); if grep -qF -- "$2" <<<"$t"; then fail "'$2' must not appear in $1"; fi; }
# Like contains, but ignores line breaks (for text that wraps across lines).
contains_flat() { local t; t=$(pdftotext "$1" - | tr '\n' ' ' | tr -s ' '); grep -qF -- "$2" <<<"$t" || fail "'$2' not found in $1"; }

# Physical page number of the first page with a line that is exactly <heading>.
heading_page() {
  local pages
  pages=$(pdfinfo "$1" | sed -n 's/^Pages: *//p')
  for ((p = 1; p <= pages; p++)); do
    local t
    t=$(pdf_text -f "$p" -l "$p" "$1")
    if grep -qx -- " *$2 *" <<<"$t"; then echo "$p"; return; fi
  done
  fail "heading '$2' not found in $1"
}

# Every package version in the template, READMEs, docs and lib.typ must match typst.toml.
# The separator is ":" (import), "/" (macOS/Linux path) or "\" (Windows path).
STALE=$(grep -rhoE 'community-meu-gsnas-thesis[:/\\][0-9]+\.[0-9]+\.[0-9]+|--branch v[0-9]+\.[0-9]+\.[0-9]+' \
  template README.md README.tr.md docs lib.typ | grep -vE "[:/\\\\v]$VERSION\$" || true)
[[ -z "$STALE" ]] || fail "references not matching the typst.toml version ($VERSION): $STALE"

# Template: two-sided, with outer covers.
TEMPLATE="$OUT/template.pdf"
compile template template/main.typ "$TEMPLATE"
contains "$TEMPLATE" "TEZİN BAŞLIĞI"
[[ $(pdf_text -f 3 -l 3 "$TEMPLATE") == *"ORCID ID"* ]] || fail "title page is not on page 3"
[[ $(pdf_text -f 4 -l 4 "$TEMPLATE") == *"ONAY"*" ii"* ]] || fail "approval page (ONAY) is not page ii"
FIRST_CHAPTER=$(heading_page "$TEMPLATE" "1. GİRİŞ")
((FIRST_CHAPTER % 2 == 1)) || fail "first chapter starts on an even physical page ($FIRST_CHAPTER)"
contains "$TEMPLATE" "Tablo 2.1."
contains "$TEMPLATE" "Eşitlik (2.1)"
contains "$TEMPLATE" "(Grady vd., 2019)"
# @misc standard with the number inside the title (template example) stays as it is.
contains_flat "$TEMPLATE" "International Organization for Standardization. (2018). Occupational health and safety management systems—Requirements with guidance for use (ISO Standard No. 45001:2018)."

# Edge cases.
EDGE="$OUT/edge-cases.pdf"
compile . tests/edge-cases.typ "$EDGE"
for expected in "DOKTORA TEZİ" "2. DANIŞMAN" "Şekil 1.1." "Şekil E.1." "Tablo E.1." "(E.1)" \
  "Tanım 1.1." "Teorem 1.1.1." "Şekil 1. Front matter figure"; do
  contains "$EDGE" "$expected"
done
not_contains "$EDGE" "1.0.1"
not_contains "$EDGE" "Şekil 0."

# One-sided printing + bibliography with default settings.
ONE_SIDED="$OUT/one-sided.pdf"
compile . tests/one-sided.typ "$ONE_SIDED"
contains "$ONE_SIDED" "(Grady vd., 2019)"
not_contains "$ONE_SIDED" "[1]"
not_contains "$ONE_SIDED" "Kaynakça"
[[ $(heading_page "$ONE_SIDED" "2. SONUÇ") -eq $(($(heading_page "$ONE_SIDED" "1. GİRİŞ") + 1)) ]] \
  || fail "one-sided mode inserted a blank page between chapters"

# Regressions from the adversarial review (v0.3.0).
REG="$OUT/regressions.pdf"
compile . tests/regressions.typ "$REG"
REG_TEXT=$(pdf_text "$REG")
rows=$(grep -cE "^ *row-[0-9]+ " <<<"$REG_TEXT" || true)
[[ "$rows" -eq 70 ]] || fail "long table lost rows across pages: $rows/70 rows in the PDF"
contains "$REG" "YAPAY ZEKÂ İLE GÖRÜNTÜ İŞLEME"
not_contains "$REG" "GÖRÜNTÜ IŞLEME"
contains "$REG" "IMAGE PROCESSING WITH ARTIFICIAL INTELLIGENCE"
not_contains "$REG" "PROCESSİNG"
contains "$REG" "Liste 2.1."
not_contains "$REG" "Liste 2.2."
contains "$REG" "Teorem 2.1."
contains "$REG" "Teorem E.1."
[[ $(heading_page "$REG" "EK-1 Appendix heading") -gt 0 ]] || fail "appendix heading missing"
not_contains "$REG" "2.1. EK-1"

# Turkish APA (v0.4.0): "ve" in citations, "&" kept in the reference list,
# Turkish thesis type label, 1.25 cm hanging indent.
contains "$REG" "(Engin ve Özçimen, 2016)"
contains "$REG" "Engin, A., & Özçimen, D. (2016)"
contains_flat "$REG" "[Yayımlanmamış doktora tezi]. University of Virginia."
# @incollection: book title printed once (APA 7 chapter format); @misc year-only
# date without a trailing comma.
contains_flat "$REG" "(Ed.), Lecture notes in computer science: C. 11353. Learning and intelligent optimization (ss. 225–240)"
not_contains "$REG" "optimization: Learning"
contains "$REG" "Standardization. (2018)."
not_contains "$REG" "(2018,)"
contains_flat "$REG" "İçinde R. Battiti"

# Institute citation style (v0.5.0): directive articles 13/e, 16/2, 16/3 and the
# Word template's reference examples.
contains_flat "$REG" "(Aydeniz vd., 2015; Couch ve Metz, 2016; Yılmaz, 2016; Turan, 2018)"
contains_flat "$REG" "(Singh, 2007: Öztürk vd. 2012’den)"
contains_flat "$REG" "(Rapor No. NASA/CR-2018-220043). National Aeronautics and Space Administration."
contains_flat "$REG" "(Yayın No. 27542827) [Doktora tezi, Pepperdine University]. PQDT Open."
contains_flat "$REG" "PLoS ONE, 13(3), Makale e0193972."
continued=$(grep -c "Tablo 1.1 (devamı)" <<<"$REG_TEXT" || true)
[[ "$continued" -ge 1 ]] || fail "long table has no \"Tablo 1.1 (devamı)\" on its later pages"
not_contains "$REG" "Tablo 1.1. (devamı)"
contains_flat "$REG" "(Smith, 2010; Jones, 2012; Smith, 2015)"
contains_flat "$REG" "On the Doctoral dissertation genre"

# Reference list fixes after v0.5.0.
# Same author, same year: no CSL collapse. hayagriva 0.10 (Typst 0.15.1) mislabels the
# cite group of a moved item, so collapse="year" renders "(Smith, 2010; Smith, 2015; 2012)"
# for the interleaved case above and credits Jones' work to Smith. Each citation keeps its
# author until Typst's citation engine is fixed.
contains_flat "$REG" "(Şahin, 2016a; Şahin, 2016b)"
# Two different authors with the same surname and year: hayagriva's givenname
# disambiguation marks them as disambiguated but prints neither initials nor suffixes and
# drops the initials in the reference list ("Alpha. (2001)."). The style uses year
# suffixes instead. `full: true` (this document) hides the bug; the English document
# below, with a normal bibliography, is the case that failed.
contains_flat "$REG" "(Alpha, 2001a; Alpha, 2001b)"
contains_flat "$REG" "Alpha, A. (2001a). Same surname one."
contains_flat "$REG" "Alpha, B. (2001b). Same surname two."
# @book in a series with `number` (Typst: collection-title + issue): series and number with
# the title, as for chapters, instead of "(Sayı 7)" without the series.
contains_flat "$REG" "Kesharwani, P. (2020). Advances in pharmaceutical sciences: No. 7. Nanotechnology based approaches for tuberculosis treatment. Academic Press."
not_contains "$REG" "(Sayı 7)"
# biblatex @standard (Typst: `document`, organization -> authority, number -> issue).
contains_flat "$REG" "(International Organization for Standardization, 2015)"
contains_flat "$REG" "International Organization for Standardization. (2015). Quality management systems—Requirements (ISO Standard No. 9001:2015). https://www.iso.org/standard/62085.html"
not_contains "$REG" "[ISO Standard]"

# Tables (v0.5.0 review): user tables are left intact; no false "(devamı)".
TABLES="$OUT/tables.pdf"
compile . tests/tables.typ "$TABLES"
for expected in "SUBHEADER-X" "LA" "CELL-Y1"; do contains "$TABLES" "$expected"; done
row0_page=$(python3 - "$TABLES" <<'PY'
import subprocess, sys
pages = subprocess.run(["pdftotext", sys.argv[1], "-"], capture_output=True, text=True).stdout.split("\f")
print(next(i for i, page in enumerate(pages, 1) if "ROW-0" in page))
PY
)
pdftotext -f "$row0_page" -l "$row0_page" "$TABLES" - | grep -q "devamı" \
  && fail "the first piece of a table is labeled (devamı)"
pdftotext -f $((row0_page + 1)) -l $((row0_page + 1)) "$TABLES" - | grep -q "Tablo 1.4 (devamı)" \
  || fail "the second piece of a long table is not labeled \"Tablo 1.4 (devamı)\""
REF_PAGE=$(heading_page "$REG" "KAYNAKLAR")
indent_cm=$(pdftotext -f "$REF_PAGE" -l "$REF_PAGE" -bbox "$REG" - | python3 -c '
import re, sys
lines = {}
for m in re.finditer(r"<word xMin=\"([\d.]+)\" yMin=\"([\d.]+)\"", sys.stdin.read()):
    x, y = float(m.group(1)), round(float(m.group(2)))
    lines[y] = min(lines.get(y, 9e9), x)
xs = sorted({round(v, 1) for v in lines.values()})
print(f"{(xs[1] - xs[0]) / 72 * 2.54:.2f}" if len(xs) > 1 else "0")')
[[ "$indent_cm" == "1.25" ]] || fail "bibliography hanging indent is $indent_cm cm, expected 1.25 cm"

# English thesis: "&" in citations, "et al." (v0.4.0).
en_log=$(printf '%s\n' '#import "/lib.typ": *' '#show: thesis.with(language: "en", front-cover: false, back-cover: false, two-sided: false)' \
  '= INTRODUCTION' '@engin2016' 'Report @stuster2018.' '#secondary-cite(<ozturk2012>, year: 2012)[Singh, 2007]' \
  'Series book @series2020, standard @iso9001, same surname @alphaA2001 @alphaB2001.' \
  '#references(bibliography("/tests/regressions.bib"))' \
  | typst compile --root . - "$OUT/english.pdf" 2>&1) || { echo "$en_log"; fail "English thesis did not compile"; }
contains "$OUT/english.pdf" "(Engin & Özçimen, 2016)"
contains_flat "$OUT/english.pdf" "(Singh, 2007, as cited in Öztürk et al., 2012)"
contains_flat "$OUT/english.pdf" "(Report No. NASA/CR-2018-220043)"
contains_flat "$OUT/english.pdf" "Advances in pharmaceutical sciences: No. 7. Nanotechnology"
not_contains "$OUT/english.pdf" "(Issue 7)"
contains_flat "$OUT/english.pdf" "Quality management systems—Requirements (ISO Standard No. 9001:2015)."
contains_flat "$OUT/english.pdf" "(Alpha, 2001a; Alpha, 2001b)"
contains_flat "$OUT/english.pdf" "Alpha, A. (2001a). Same surname one."
contains_flat "$OUT/english.pdf" "Alpha, B. (2001b). Same surname two."

# An old main.typ with style: "apa" must stop with a clear message (v0.5.0).
style_log=$(printf '%s\n' '#import "/lib.typ": *' '#show: thesis.with(front-cover: false, back-cover: false)' \
  '#references(bibliography("/tests/regressions.bib", style: "apa"))' \
  | typst compile --root . - "$OUT/old-style.pdf" 2>&1 || true)
grep -q "style vermeyin" <<<"$style_log" || { echo "$style_log"; fail "no clear error for style: \"apa\""; }

# Wrong argument types must give a clear message, not an internal error.
# (Read from stdin, so no temporary file is needed inside the project root.)
bad_log=$(printf '%s\n' '#import "/lib.typ": *' '#show: thesis.with(keywords-tr: "a, b")' 'x' \
  | typst compile --root . - "$OUT/bad-input.pdf" 2>&1 || true)
grep -q "keywords-tr bir dizi olmalı" <<<"$bad_log" || { echo "$bad_log"; fail "no clear error for a wrong keywords-tr type"; }
# Directive article 15/2: at most 5 keywords.
kw_log=$(printf '%s\n' '#import "/lib.typ": *' '#show: thesis.with(keywords-en: ("a", "b", "c", "d", "e", "f"))' 'x' \
  | typst compile --root . - "$OUT/too-many-keywords.pdf" 2>&1 || true)
grep -q "keywords-en en fazla 5" <<<"$kw_log" || { echo "$kw_log"; fail "no clear error for more than 5 keywords"; }
echo "compiled: regressions"

# Directive article 12: footnotes 10 pt, italic, single line spacing, separator a
# quarter of a line long. Articles 8ç and 11/2: block quotations 10 pt, no
# quotation marks, own paragraph indented like a paragraph's first line.
FQ="$OUT/footnotes-quotes.pdf"
compile . tests/footnotes-quotes.typ "$FQ"
FQ_PAGE=$(heading_page "$FQ" "1. GİRİŞ")
# Expected values come from src/settings.typ: Word's single line for Times New
# Roman at the footnote size, the paragraph indent and the text width.
settings() { typst eval --root . "import \"/src/settings.typ\": *; $1"; }
fn_leading=$(settings 'WORD-SINGLE-LINE.em * FOOTNOTE-SIZE.pt()')
rule_length=$(settings '((21cm - 2 * MARGIN) * FOOTNOTE-RULE-LENGTH).pt()')
quote_ratio=$(settings 'QUOTE-SIZE / FONT-SIZE')
quote_indent=$(settings 'PAR-INDENT.pt()')
margin=$(settings 'MARGIN.pt()')
pdftoppm -gray -r 300 -f "$FQ_PAGE" -l "$FQ_PAGE" -singlefile "$FQ" "$OUT/footnotes-quotes-page"
pdftotext -f "$FQ_PAGE" -l "$FQ_PAGE" -bbox "$FQ" "$OUT/footnotes-quotes-page.bbox"
measured=$(python3 - "$OUT/footnotes-quotes-page.bbox" "$OUT/footnotes-quotes-page.pgm" <<'PY'
import re, sys
words = {m.group(5): tuple(float(m.group(i)) for i in range(1, 5)) for m in re.finditer(
    r'<word xMin="([\d.]+)" yMin="([\d.]+)" xMax="([\d.]+)" yMax="([\d.]+)">([^<]*)</word>', open(sys.argv[1]).read())}
fn1, fn2, body, quote = (words[w] for w in ("fn-first-line", "fn-second-line", "body-word", "quote-start"))
# Separator: longest dark horizontal run in the 30 pt above the first footnote line.
data = open(sys.argv[2], "rb").read()
header = re.match(rb"P5\s+(\d+)\s+(\d+)\s+255\s", data)
width, height = int(header.group(1)), int(header.group(2))
pixels, dpi = data[header.end():], 300
longest = 0
for y in range(int((fn1[1] - 30) * dpi / 72), int(fn1[1] * dpi / 72)):
    row, run = pixels[y * width:(y + 1) * width], 0
    for value in row:
        run = run + 1 if value < 160 else 0
        longest = max(longest, run)
print(f"{fn2[1] - fn1[1]:.2f} {longest * 72 / dpi:.1f} {(quote[3] - quote[1]) / (body[3] - body[1]):.3f} {quote[0]:.2f}")
PY
)
read -r fn_measured rule_measured ratio_measured quote_x <<<"$measured"
near() { python3 -c "import sys; sys.exit(0 if abs(float(sys.argv[1]) - float(sys.argv[2])) <= float(sys.argv[3]) else 1)" "$@"; }
near "$fn_measured" "$fn_leading" 0.3 || fail "footnote baseline distance is $fn_measured pt, expected $fn_leading pt (single spacing)"
near "$rule_measured" "$rule_length" 3 || fail "footnote separator is $rule_measured pt long, expected $rule_length pt (1/4 line)"
near "$ratio_measured" "$quote_ratio" 0.02 || fail "block quote / body font size ratio is $ratio_measured, expected $quote_ratio"
near "$(python3 -c "print($quote_x - $margin)")" "$quote_indent" 0.5 || fail "block quote starts at $quote_x pt, expected margin + $quote_indent pt"
# Italic: the footnote is the only italic text on that page.
pdffonts -f "$FQ_PAGE" -l "$FQ_PAGE" "$FQ" | grep -q "Italic" || fail "footnote is not italic (no italic font on page $FQ_PAGE)"
not_contains "$FQ" "“quote-start"
contains "$FQ" "“inline-quote"
contains "$FQ" "— Yazar Adı"
echo "measured: footnote leading $fn_measured pt, separator $rule_measured pt, quote size ratio $ratio_measured"

# Directive article 18/4: the copy uploaded to the YÖK Thesis Center has no ONAY,
# ETİK BEYAN or ÖZGEÇMİŞ pages; the back cover (EK-6) stays. Page numbering and
# the odd-page logic of the front matter must still hold.
YOK="$OUT/yok-copy.pdf"
compile . tests/yok-copy.typ "$YOK"
for unexpected in "ONAY" "ETİK BEYAN" "ÖZGEÇMİŞ" "Adı ve Soyadı" "cv-publication"; do not_contains "$YOK" "$unexpected"; done
[[ $(pdf_text -f 4 -l 4 "$YOK") == *"ÖZET"*" ii"* ]] || fail "yok-copy: ÖZET is not page ii after the title page"
YOK_FIRST=$(heading_page "$YOK" "1. GİRİŞ")
((YOK_FIRST % 2 == 1)) || fail "yok-copy: first chapter starts on an even physical page ($YOK_FIRST)"
YOK_LAST=$(heading_page "$YOK" "2. SONUÇ")
[[ $(pdfinfo "$YOK" | sed -n 's/^Pages: *//p') -eq $((YOK_LAST + 1)) ]] || fail "yok-copy: back cover missing or extra pages after the last chapter"

# Fallback font: without Times New Roman, the bundled Libertinus Serif is used.
# The only expected warning is that Times New Roman was not found.
FALLBACK="$OUT/fallback-font.pdf"
log=$(typst compile --ignore-system-fonts --root . tests/one-sided.typ "$FALLBACK" 2>&1) \
  || { echo "$log"; fail "did not compile with the fallback font"; }
unexpected=$(grep "^warning" <<<"$log" | grep -v "unknown font family: times new roman" || true)
[[ -z "$unexpected" ]] || { echo "$log"; fail "unexpected warning with the fallback font"; }
fonts=$(pdffonts "$FALLBACK")
grep -q "LibertinusSerif" <<<"$fonts" || fail "fallback font (Libertinus Serif) was not used"
echo "compiled: fallback font (Libertinus Serif)"

echo "All checks passed (version $VERSION)."
