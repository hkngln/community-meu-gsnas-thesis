// Sınır durumları: başlıksız şekil, ekte şekil/tablo/eşitlik, boş jüri,
// "==" öncesi teorem, ikinci danışman, doktora tezi, ön kısımda şekil.
#import "../lib.typ": *

#show: thesis.with(
  title: "Kenar Durum Testi",
  degree: "phd",
  student: "Test ÖĞRENCİ",
  advisor: (name: "Prof. Dr. Test DANIŞMAN", orcid: none),
  co-advisor: (name: "Doç. Dr. İkinci DANIŞMAN", orcid: none),
  jury: (),
  year: 2026,
  acknowledgements: [Teşekkür. #figure(rect(width: 2cm, height: 1cm), caption: [Ön kısım şekli])],
)

= GİRİŞ

#definition[Alt bölümden önce gelen tanım.] <tnm-giris>

Atıf: @tnm-giris.

#figure(rect(width: 3cm, height: 1cm), caption: none)

#figure(rect(width: 3cm, height: 1cm), caption: [Ana şekil]) <sekil-ana>

$ a = b $ <esitlik-ana>

@sekil-ana, @esitlik-ana

== Alt Bölüm

#theorem[Alt bölümdeki teorem.]

#appendices[
  #figure(rect(width: 3cm, height: 1cm), caption: [Ek şekil]) <sekil-ek>
  #figure(table(columns: 2, [a], [b]), caption: [Ek tablo])
  $ c = d $ <esitlik-ek>
  @sekil-ek, @esitlik-ek
]
