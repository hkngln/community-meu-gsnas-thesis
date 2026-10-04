// Mersin Üniversitesi Fen Bilimleri Enstitüsü tez yazım kurallarından gelen
// sabit ölçüler. Kaynak: Ornek_Tez_Yazim_Sablonu_20250911.docx + LaTeX v1.4.

#let YAZI-TIPI = "Times New Roman"
#let YAZI-BOYUTU = 11pt
#let UST-BILGI-BOYUTU = 10pt
#let DIPNOT-BOYUTU = 10pt
// Docx w:header="851" (1,5 cm): üst bilgi çizgisi metin alanının ~0,5 cm üstünde.
#let UST-BILGI-ASCENT = 0.5cm
#let KENAR-BOSLUGU = 2.5cm
#let PARAGRAF-GIRINTISI = 1.25cm

// Satır aralığı Word ile aynı olsun diye: satır kutusu Times New Roman'ın hhea
// ascender + descender'ı (1825/2048 + 443/2048 = 1.107em), Word'ün tek satırı
// buna lineGap eklenmiş hali (1.149em). Aradaki fark leading olur.
#let TNR-ASCENDER = 0.891em
#let TNR-DESCENDER = 0.216em
#let SATIR-YUKSEKLIGI = TNR-ASCENDER + TNR-DESCENDER
#let WORD-TEK-SATIR = 1.149em
#let satir-araligi(carpan) = carpan * WORD-TEK-SATIR - SATIR-YUKSEKLIGI

#let ARALIK-1-5 = satir-araligi(1.5)
#let ARALIK-1 = satir-araligi(1)
// "1 adet satır boşluğu": bir satır adımı + normal satır arası.
#let BOS-SATIR = ARALIK-1-5 + 1.5 * WORD-TEK-SATIR

#let TEZ-TURLERI = (
  yl: (kapak: "YÜKSEK LİSANS TEZİ", metin: "Yüksek Lisans"),
  dr: (kapak: "DOKTORA TEZİ", metin: "Doktora"),
)

#let ENSTITU-MUDURU = "Prof. Dr. Birgül ÖZDEMİR"
#let IMZA-NOKTALARI = "………………..."
