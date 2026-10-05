#!/usr/bin/env bash
# Şablonu ve testleri derler, uyarıyı hata sayar, PDF metnini doğrular.
# Gereken: typst, pdftotext (poppler), Times New Roman fontu ve paketin
# @local/meu-fbe-tez:<sürüm> olarak kurulu olması (README > Kurulum).
set -euo pipefail
cd "$(dirname "$0")/.."

OUT="${OUT:-tests/out}"
mkdir -p "$OUT"
SURUM=$(sed -n 's/^version = "\(.*\)"/\1/p' typst.toml)

hata() { echo "HATA: $*" >&2; exit 1; }

# derle <kök> <girdi> <çıktı>
derle() {
  local log
  log=$(typst compile --root "$1" "$2" "$3" 2>&1) || { echo "$log"; hata "$2 derlenemedi"; }
  if grep -q "^warning" <<<"$log"; then echo "$log"; hata "$2 uyarı verdi"; fi
  echo "derlendi: $2"
}

metin() { pdftotext -layout "$@" - ; }
# Metin önce değişkene alınır: pipefail altında `pdftotext | grep -q` erken
# kapanan boru yüzünden (SIGPIPE) eşleşme olsa bile başarısız sayılır.
icerir() { local m; m=$(metin "$1"); grep -qF -- "$2" <<<"$m" || hata "$1 içinde '$2' bulunamadı"; }
icermez() { local m; m=$(metin "$1"); if grep -qF -- "$2" <<<"$m"; then hata "$1 içinde '$2' olmamalı"; fi; }

# Bir satırı tam olarak <başlık> olan ilk sayfanın fiziksel numarası.
baslik_sayfasi() {
  local sayfalar
  sayfalar=$(pdfinfo "$1" | sed -n 's/^Pages: *//p')
  for ((p = 1; p <= sayfalar; p++)); do
    local m
    m=$(metin -f "$p" -l "$p" "$1")
    if grep -qx -- " *$2 *" <<<"$m"; then echo "$p"; return; fi
  done
  hata "$1 içinde '$2' başlığı yok"
}

# Şablonda, README'de ve lib.typ'de geçen her paket sürümü typst.toml ile aynı olmalı.
# Ayırıcı ":" (import), "/" (macOS/Linux yolu) veya "\" (Windows yolu) olabilir.
ESKI=$(grep -rhoE 'meu-fbe-tez[:/\\][0-9]+\.[0-9]+\.[0-9]+|--branch v[0-9]+\.[0-9]+\.[0-9]+' \
  template README.md lib.typ | grep -vE "[:/\\\\v]$SURUM\$" || true)
[[ -z "$ESKI" ]] || hata "typst.toml sürümü ($SURUM) ile uyuşmayan referanslar: $ESKI"

# Şablon: çift taraflı, dış kapaklı.
SABLON="$OUT/sablon.pdf"
derle template template/main.typ "$SABLON"
icerir "$SABLON" "TEZİN BAŞLIĞI"
[[ $(metin -f 3 -l 3 "$SABLON") == *"ORCID ID"* ]] || hata "iç kapak 3. sayfada değil"
[[ $(metin -f 4 -l 4 "$SABLON") == *"ONAY"*" ii"* ]] || hata "ONAY sayfası ii değil"
GIRIS=$(baslik_sayfasi "$SABLON" "1. GİRİŞ")
((GIRIS % 2 == 1)) || hata "GİRİŞ fiziksel çift sayfada ($GIRIS)"
icerir "$SABLON" "Tablo 2.1."
icerir "$SABLON" "Eşitlik (2.1)"
icerir "$SABLON" "(Grady vd., 2019)"

# Kenar durumları.
KENAR="$OUT/kenar-durumlar.pdf"
derle . tests/kenar-durumlar.typ "$KENAR"
for beklenen in "DOKTORA TEZİ" "2. DANIŞMAN" "Şekil 1.1." "Şekil E.1." "Tablo E.1." "(E.1)" \
  "Tanım 1.1" "Teorem 1.1.1" "Şekil 1. Ön kısım şekli"; do
  icerir "$KENAR" "$beklenen"
done
icermez "$KENAR" "1.0.1"
icermez "$KENAR" "Şekil 0."

# Tek taraf + varsayılan kaynakça.
TEK="$OUT/tek-taraf.pdf"
derle . tests/tek-taraf.typ "$TEK"
icerir "$TEK" "(Grady vd., 2019)"
icermez "$TEK" "[1]"
icermez "$TEK" "Kaynakça"
[[ $(baslik_sayfasi "$TEK" "2. SONUÇ") -eq $(($(baslik_sayfasi "$TEK" "1. GİRİŞ") + 1)) ]] \
  || hata "tek taraflı modda bölümler arasında boş sayfa var"

echo "Tüm kontroller geçti (sürüm $SURUM)."
