// Sınır durumları: başlıksız şekil, ekte şekil/tablo/eşitlik, boş jüri,
// "==" öncesi teorem, ikinci danışman, doktora tezi, ön kısımda şekil.
#import "../lib.typ": *

#show: tez.with(
  baslik: "Kenar Durum Testi",
  tur: "dr",
  ogrenci: "Test ÖĞRENCİ",
  danisman: (ad: "Prof. Dr. Test DANIŞMAN", orcid: none),
  ikinci-danisman: (ad: "Doç. Dr. İkinci DANIŞMAN", orcid: none),
  juri: (),
  yil: 2026,
  tesekkur: [Teşekkür. #figure(rect(width: 2cm, height: 1cm), caption: [Ön kısım şekli])],
)

= GİRİŞ

#tanim[Alt bölümden önce gelen tanım.] <tnm-giris>

Atıf: @tnm-giris.

#figure(rect(width: 3cm, height: 1cm), caption: none)

#figure(rect(width: 3cm, height: 1cm), caption: [Ana şekil]) <sekil-ana>

$ a = b $ <esitlik-ana>

@sekil-ana, @esitlik-ana

== Alt Bölüm

#teorem[Alt bölümdeki teorem.]

#ekler[
  #figure(rect(width: 3cm, height: 1cm), caption: [Ek şekil]) <sekil-ek>
  #figure(table(columns: 2, [a], [b]), caption: [Ek tablo])
  $ c = d $ <esitlik-ek>
  @sekil-ek, @esitlik-ek
]
