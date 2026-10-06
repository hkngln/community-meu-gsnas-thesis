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

# Wrong argument types must give a clear message, not an internal error.
# (Read from stdin, so no temporary file is needed inside the project root.)
bad_log=$(printf '%s\n' '#import "/lib.typ": *' '#show: thesis.with(keywords-tr: "a, b")' 'x' \
  | typst compile --root . - "$OUT/bad-input.pdf" 2>&1 || true)
grep -q "keywords-tr bir dizi olmalı" <<<"$bad_log" || { echo "$bad_log"; fail "no clear error for a wrong keywords-tr type"; }
echo "compiled: regressions"

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
