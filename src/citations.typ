// Aktarma (ikincil kaynak) atfı, Tez Yazım Yönergesi Madde 16/3:
//   ...tanımlanmıştır (Singh, 2007: Öztürk vd. 2012'den).
// Kaynaklar bölümüne yalnızca eldeki eser (Öztürk vd.) girer; asıl eser
// (Singh) .bib'e eklenmez, metin olarak verilir.

// Türkçe ayrılma eki, yılın okunuşundaki son sözcüğe göre:
// 2007 "yedi" -> 'den, 2010 "on" -> 'dan, 2003 "üç" -> 'ten, 1940 "kırk" -> 'tan.
#let _UNITS = ("", "den", "den", "ten", "ten", "ten", "dan", "den", "den", "dan")
#let _TENS = ("", "dan", "den", "dan", "tan", "den", "tan", "ten", "den", "dan")
// Harfle biten yıl (2016a) ya da tarihsiz kaynak (t.y., n.d.): son harfin
// okunuşuna göre: "a", "ka" -> 'dan; "be", "ye", "de" -> 'den.
#let _BACK-VOWEL-LETTERS = ("a", "ı", "k", "o", "u")

#let _ablative(year) = {
  assert(
    type(year) in (int, str),
    message: "secondary-cite: year bir sayı ya da metin olmalı (ör. 2012, \"2016a\", \"t.y.\"), verilen: " + repr(year),
  )
  let year = lower(str(year)).trim(".")
  let last = year.clusters().last(default: "")
  if last.match(regex("\\d")) == none {
    assert(last != "", message: "secondary-cite: year boş olamaz")
    return if last in _BACK-VOWEL-LETTERS { "dan" } else { "den" }
  }
  let n = int(year.find(regex("\\d+$")))
  if calc.rem(n, 10) != 0 { return _UNITS.at(calc.rem(n, 10)) }
  if calc.rem(n, 100) != 0 { return _TENS.at(calc.quo(calc.rem(n, 100), 10)) }
  // ...00 "yüz", ...000 "bin": ikisi de 'den.
  "den"
}

// source: eldeki eserin etiketi (<ozturk2012>); year: o eserin yılı (2012 veya
// "2016a"); original: asıl eser ([Singh, 2007]).
// Türkçe tezde: (Singh, 2007: Öztürk vd. 2012'den)
// İngilizce tezde (APA): (Singh, 2007, as cited in Öztürk et al., 2012)
#let secondary-cite(source, year: none, original) = {
  assert(type(source) == label, message: "secondary-cite: ilk değer eldeki eserin etiketi olmalı, ör. <ozturk2012>")
  assert(year != none, message: "secondary-cite: year verilmeli, ör. year: 2012")
  // box: art arda iki cite tek atıf grubunda birleşmesin.
  let author = box(cite(source, form: "author"))
  context if text.lang == "en" {
    [(#original, as cited in #author, #year)]
  } else {
    [(#original: #author #year’#_ablative(year))]
  }
}
