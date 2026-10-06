// Edge cases: figure without caption, figures/tables/equations in the
// appendix, empty jury, theorem before the first "==", co-advisor, PhD thesis,
// figure in the front matter. Chapter headings and the PDF output are Turkish.
#import "../lib.typ": *

#show: thesis.with(
  title: "Edge Case Test",
  degree: "phd",
  // Turkish letters on purpose: checks the Turkish-aware uppercase on covers.
  student: "Test ÖĞRENCİ",
  advisor: (name: "Prof. Dr. Test ADVISOR", orcid: none),
  co-advisor: (name: "Doç. Dr. İkinci ADVISOR", orcid: none),
  jury: (),
  year: 2026,
  acknowledgements: [Acknowledgements. #figure(rect(width: 2cm, height: 1cm), caption: [Front matter figure])],
)

= GİRİŞ

#definition[A definition before the first subsection.] <def-intro>

Reference: @def-intro.

#figure(rect(width: 3cm, height: 1cm), caption: none)

#figure(rect(width: 3cm, height: 1cm), caption: [Main figure]) <fig-main>

$ a = b $ <eq-main>

@fig-main, @eq-main

== Subsection

#theorem[A theorem inside a subsection.]

#appendices[
  #figure(rect(width: 3cm, height: 1cm), caption: [Appendix figure]) <fig-appendix>
  #figure(table(columns: 2, [a], [b]), caption: [Appendix table])
  $ c = d $ <eq-appendix>
  @fig-appendix, @eq-appendix
]
