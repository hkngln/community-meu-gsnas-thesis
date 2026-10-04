#import "ayarlar.typ": ARALIK-1

// Doldurulmamış alanı kırmızı yer tutucu olarak gösterir; PDF'e bakınca eksik
// bilgi hemen göze çarpar (LaTeX şablonundaki \color{red} alanların karşılığı).
#let alan(deger, yer-tutucu) = if deger == none {
  text(fill: red, yer-tutucu)
} else {
  deger
}

// Typst'ün upper() fonksiyonu dile duyarlı değil: "i" -> "I" yapar.
// Türkçede "i" -> "İ" olmalı; "ı" -> "I" zaten doğru.
#let buyuk-harf(metin) = if type(metin) == str {
  upper(metin.replace("i", "İ"))
} else {
  upper(metin)
}

// EKLER bölümüne girildi mi? Ekteki şekil/tablo/eşitlikler "E.1" diye
// numaralanır; aksi halde son bölümün numarasını tekrar kullanırlar.
#let EK-DURUMU = state("meu-ekler", false)

// Bir konumdaki (verilmezse bulunulan yerdeki) bölüm numarası: "2" veya "E".
#let bolum-no(konum: none) = {
  let ek-mi = if konum == none { EK-DURUMU.get() } else { EK-DURUMU.at(konum) }
  if ek-mi { return "E" }
  let basliklar = if konum == none { counter(heading).get() } else { counter(heading).at(konum) }
  str(basliklar.first())
}

// Şekil/tablo/eşitlik numarası: "2.1", ekte "E.1". Context içinde çağrılır.
// İlk bölümden önce (ön kısım) bölüm öneki olmadan: "1".
#let bolume-gore(..n) = {
  let bolum = bolum-no()
  let onek = if bolum == "0" { () } else { (bolum,) }
  (onek + n.pos().map(str)).join(".")
}

// Ön kısım başlığı: ortalı, numarasız, içindekilerde listelenir.
#let on-baslik(metin) = {
  pagebreak(weak: true)
  align(center, heading(level: 1, numbering: none, metin))
}

// Ortalı, kalın ama içindekilerde yer almayan ara başlık (ör. ETHICAL DECLARATION).
#let ortali-kalin(metin) = align(center, strong(metin))

// Tek satır aralıklı içerik (tablolar, dizinler, başlık sayfası tabloları).
#let tek-aralik(icerik) = {
  set par(leading: ARALIK-1, spacing: ARALIK-1, first-line-indent: 0pt, justify: false)
  icerik
}
