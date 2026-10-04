// Tek taraflı baskı, dış kapaklar kapalı, stil/başlık verilmeden kaynakça.
#import "../lib.typ": *

#show: tez.with(
  baslik: "Tek Taraf Testi",
  ogrenci: "Test ÖĞRENCİ",
  danisman: (ad: "Prof. Dr. Test DANIŞMAN", orcid: none),
  juri: ("Prof. Dr. Test DANIŞMAN", "Doç. Dr. Üye BİR", "Dr. Öğr. Üyesi Üye İKİ"),
  yil: 2026,
  dis-kapak: false,
  arka-kapak: false,
  tek-sayfa-basla: false,
)

= GİRİŞ

Atıf @grady2019.

= SONUÇ

Sonuç.

#kaynaklar(bibliography("../template/kaynaklar.bib"))
