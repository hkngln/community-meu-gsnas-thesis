// Directive article 12 (footnotes: 10 pt, italic, single line spacing, a
// separator a quarter of a line long) and articles 8ç / 11/2 (quotations over
// 40 words: own paragraph, 10 pt, no quotation marks). verify.sh measures the
// PDF of the first chapter page; the marker words below are what it looks for.
#import "../lib.typ": *

#show: thesis.with(
  title: "Footnote and Quote Test",
  student: "Test ÖĞRENCİ",
  advisor: (name: "Prof. Dr. Test ADVISOR", orcid: none),
  jury: ("Prof. Dr. Test ADVISOR",),
  year: 2026,
  front-cover: false,
  back-cover: false,
  two-sided: false,
)

= GİRİŞ

body-word metni bir dipnot taşır#footnote[fn-first-line dipnotun birinci satırı \ fn-second-line dipnotun ikinci satırı]. Gövde metni 11 punto ve 1,5 satır aralığıyla devam eder.

#quote(block: true, attribution: [Yazar Adı])[quote-start Kırk sözcüğü aşan alıntılar metin içerisinde ayrı bir paragraf halinde, tırnak içerisine alınmadan ve on punto ile verilir. Bu örnek alıntı, ölçümün birden çok satırı kapsaması için yeterince uzun tutulmuştur ve blok alıntının sol kenardan paragraf girintisi kadar içeride başladığını gösterir.]

Kısa alıntılar #quote[inline-quote tırnak içinde] gövde puntosuyla kalır.

= SONUÇ

Sonuç.
