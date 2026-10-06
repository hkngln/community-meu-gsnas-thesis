#import "settings.typ": SPACING-1

// Doldurulmamış alanı kırmızı yer tutucu olarak gösterir; PDF'e bakınca eksik
// bilgi hemen göze çarpar (LaTeX şablonundaki \color{red} alanların karşılığı).
#let field(value, placeholder) = if value == none {
  text(fill: red, placeholder)
} else {
  value
}

// Typst'ün upper() fonksiyonu dile duyarlı değil: "i" -> "I" yapar.
// Türkçede "i" -> "İ" olmalı; "ı" -> "I" zaten doğru.
// İçerik (ör. italik tür adı içeren başlık) verilirse metin düğümlerindeki
// "i" harfleri bir show kuralıyla önce "İ" yapılır, sonra büyütülür.
#let tr-upper(body) = if type(body) == str {
  upper(body.replace("i", "İ"))
} else {
  show "i": "İ"
  upper(body)
}

// EKLER bölümüne girildi mi? Ekteki şekil/tablo/eşitlikler "E.1" diye
// numaralanır; aksi halde son bölümün numarasını tekrar kullanırlar.
#let APPENDIX-STATE = state("meu-appendix", false)

// YÖK Tez Merkezi kopyası mı (thesis(yok-copy: true))? thesis() ayarlar;
// ayrı çağrılan cv() özgeçmişi basıp basmayacağını buradan okur (Madde 18/4).
#let YOK-COPY-STATE = state("meu-yok-copy", false)

// Bir konumdaki (verilmezse bulunulan yerdeki) bölüm numarası: "2" veya "E".
#let chapter-no(loc: none) = {
  let in-appendix = if loc == none { APPENDIX-STATE.get() } else { APPENDIX-STATE.at(loc) }
  if in-appendix { return "E" }
  let headings = if loc == none { counter(heading).get() } else { counter(heading).at(loc) }
  str(headings.first())
}

// Şekil/tablo/eşitlik numarası: "2.1", ekte "E.1". Context içinde çağrılır.
// İlk bölümden önce (ön kısım) bölüm öneki olmadan: "1".
#let by-chapter(..n) = {
  let chapter = chapter-no()
  let prefix = if chapter == "0" { () } else { (chapter,) }
  (prefix + n.pos().map(str)).join(".")
}

// Ön kısım başlığı: ortalı, numarasız, içindekilerde listelenir.
#let front-heading(body) = {
  pagebreak(weak: true)
  align(center, heading(level: 1, numbering: none, body))
}

// Ortalı, kalın ama içindekilerde yer almayan ara başlık (ör. ETHICAL DECLARATION).
#let centered-bold(body) = align(center, strong(body))

// Tek satır aralıklı içerik (tablolar, dizinler, başlık sayfası tabloları).
#let single-spaced(body) = {
  set par(leading: SPACING-1, spacing: SPACING-1, first-line-indent: 0pt, justify: false)
  body
}
