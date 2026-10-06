// Mersin Üniversitesi Fen Bilimleri Enstitüsü tez yazım kurallarından gelen
// sabit ölçüler. Kaynak: Ornek_Tez_Yazim_Sablonu_20250911.docx + LaTeX v1.4.

// Kurala göre Times New Roman. Yoksa Typst'e gömülü gelen Libertinus Serif
// kullanılır (Typst "unknown font family: times new roman" uyarısı verir).
// TeX Gyre Termes (Times kopyası) varsayılan listede değildir: kurulu değilse
// her derlemede uyarı üretir. Kuranlar thesis(font: ...) ile ekleyebilir.
#let FONTS = ("Times New Roman", "Libertinus Serif")
#let FONT-SIZE = 11pt
#let HEADER-SIZE = 10pt
#let FOOTNOTE-SIZE = 10pt
// Docx w:header="851" (1,5 cm): üst bilgi çizgisi metin alanının ~0,5 cm üstünde.
#let HEADER-ASCENT = 0.5cm
#let MARGIN = 2.5cm
#let PAR-INDENT = 1.25cm

// Satır aralığı Word ile aynı olsun diye: satır kutusu Times New Roman'ın hhea
// ascender + descender'ı (1825/2048 + 443/2048 = 1.107em), Word'ün tek satırı
// buna lineGap eklenmiş hali (1.149em). Aradaki fark leading olur.
#let TNR-ASCENDER = 0.891em
#let TNR-DESCENDER = 0.216em
#let LINE-HEIGHT = TNR-ASCENDER + TNR-DESCENDER
#let WORD-SINGLE-LINE = 1.149em
#let line-spacing(factor) = factor * WORD-SINGLE-LINE - LINE-HEIGHT

#let SPACING-1-5 = line-spacing(1.5)
#let SPACING-1 = line-spacing(1)
// "1 adet satır boşluğu": bir satır adımı + normal satır arası.
#let BLANK-LINE = SPACING-1-5 + 1.5 * WORD-SINGLE-LINE

// degree parametresinin değerleri ve PDF'e basılan Türkçe karşılıkları.
#let DEGREES = (
  master: (cover: "YÜKSEK LİSANS TEZİ", text: "Yüksek Lisans"),
  phd: (cover: "DOKTORA TEZİ", text: "Doktora"),
)

// decision parametresinin değerleri ve ONAY sayfasındaki Türkçe karşılıkları.
#let DECISIONS = (
  unanimous: "oybirliği",
  majority: "oyçokluğu",
)

#let INSTITUTE-DIRECTOR = "Prof. Dr. Birgül ÖZDEMİR"
#let SIGNATURE-DOTS = "………………..."
