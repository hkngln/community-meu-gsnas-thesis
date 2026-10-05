// Dış kapaklar: EK_5-On_Kapak.docx ve EK_6-Arka_Kapak.docx.
// Sayfa sayısına dahil değildir (iç kapak "i" olarak kalır).
#import "settings.typ": DEGREES
#import "utils.typ": field, single-spaced, tr-upper

#let _FRONT-IMAGE = image("../assets/front-cover.jpg", width: 100%, height: 100%)
#let _BACK-IMAGE = image("../assets/back-cover.jpg", width: 100%, height: 100%)

// Docx'teki kenarlıksız tablonun satır yükseklikleri (twip). Oranlar korunur,
// toplam yükseklik metin alanına sığdırılır.
#let _ROW-HEIGHTS = (992, 2389, 2097, 1702, 1981, 1826, 1397, 1408)

#let _cover-page(background, body) = page(
  numbering: none,
  header: none,
  footer: none,
  background: background,
  body,
)

#let front-cover(title: none, degree: "master", student: none, department: none, date: none) = _cover-page(
  _FRONT-IMAGE,
  {
    set text(14pt, weight: "bold")
    single-spaced(grid(
      columns: 1fr,
      rows: _ROW-HEIGHTS.map(h => h * 1fr),
      align: center + horizon,
      [],
      text(16pt, tr-upper(field(title, "TEZİN BAŞLIĞI"))),
      DEGREES.at(degree).cover,
      tr-upper(field(student, "ÖĞRENCİ ADI VE SOYADI")),
      [MERSİN ÜNİVERSİTESİ \ FEN BİLİMLERİ ENSTİTÜSÜ],
      [#tr-upper(field(department, "...")) \ ANABİLİM DALI],
      [],
      [#underline[MERSİN] \ #tr-upper(field(date, "AY - YIL"))],
    ))
  },
)

#let back-cover() = _cover-page(_BACK-IMAGE, [])

// Çift taraflı baskıda kapağın iç yüzü boş kalır; böylece iç kapak yine
// fiziksel tek sayfaya düşer ve bölümlerin tek sayfa hizası bozulmaz.
#let blank-page() = page(numbering: none, header: none, footer: none, background: none, [])
