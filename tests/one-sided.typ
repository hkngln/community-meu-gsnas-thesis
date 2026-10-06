// One-sided printing, no outer covers, bibliography without explicit style or
// title. Also used by verify.sh for the fallback font test.
#import "../lib.typ": *

#show: thesis.with(
  title: "One-Sided Test",
  student: "Test ÖĞRENCİ",
  advisor: (name: "Prof. Dr. Test ADVISOR", orcid: none),
  jury: ("Prof. Dr. Test ADVISOR", "Doç. Dr. Member ONE", "Dr. Öğr. Üyesi Member TWO"),
  year: 2026,
  front-cover: false,
  back-cover: false,
  two-sided: false,
)

= GİRİŞ

Citation @grady2019.

= SONUÇ

Conclusion.

#references(bibliography("../template/references.bib"))
