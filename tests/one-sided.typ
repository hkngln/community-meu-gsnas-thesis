// Tek taraflı baskı, dış kapaklar kapalı, stil/başlık verilmeden kaynakça.
#import "../lib.typ": *

#show: thesis.with(
  title: "Tek Taraf Testi",
  student: "Test ÖĞRENCİ",
  advisor: (name: "Prof. Dr. Test DANIŞMAN", orcid: none),
  jury: ("Prof. Dr. Test DANIŞMAN", "Doç. Dr. Üye BİR", "Dr. Öğr. Üyesi Üye İKİ"),
  year: 2026,
  front-cover: false,
  back-cover: false,
  two-sided: false,
)

= GİRİŞ

Atıf @grady2019.

= SONUÇ

Sonuç.

#references(bibliography("../template/references.bib"))
