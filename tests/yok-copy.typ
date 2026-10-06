// Electronic copy for the YÖK Thesis Center (directive article 18/4): the
// ONAY, ETİK BEYAN and ÖZGEÇMİŞ pages are left out, the back cover (EK-6) is
// kept even though back-cover is false. Two-sided with the front cover so the
// odd-page logic of the front matter is exercised without those pages.
#import "../lib.typ": *

#show: thesis.with(
  title: "YÖK Copy Test",
  student: "Test ÖĞRENCİ",
  advisor: (name: "Prof. Dr. Test ADVISOR", orcid: none),
  jury: ("Prof. Dr. Test ADVISOR",),
  year: 2026,
  back-cover: false,
  yok-copy: true,
)

= GİRİŞ

Introduction.

= SONUÇ

Conclusion.

#cv(
  name: "Test ÖĞRENCİ",
  birth-date: "01.01.2000",
  email: "test@example.com",
  publications: ([cv-publication],),
)
