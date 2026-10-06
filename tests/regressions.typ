// Regression cases from the adversarial review (v0.3.0). Each block below
// reproduced a wrong output; verify.sh checks that it stays fixed.
#import "../lib.typ": *

#show: thesis.with(
  // Content title with a Turkish "i": must become "İ", not "I".
  title: [Yapay zekâ ile _görüntü_ işleme],
  // English title: must be uppercased with plain I, not Turkish İ.
  title-en: "Image processing with artificial intelligence",
  student: "Test STUDENT",
  advisor: (name: "Prof. Dr. Test ADVISOR", orcid: none),
  jury: ("Prof. Dr. Test ADVISOR",),
  year: 2026,
  front-cover: false,
  back-cover: false,
  two-sided: false,
)

= GİRİŞ

// Two authors in Turkish: "ve", not "&" (v0.4.0).
Two authors @engin2016.

// Directive article 16/2: several citations in date order (v0.5.0).
Several @turan2018 @yilmaz2016 @couch2016 @aydeniz2015.

// Directive article 16/3: secondary source (v0.5.0).
Secondary #secondary-cite(<ozturk2012>, year: 2012)[Singh, 2007].

// Same author on both sides of another by date: every citation keeps its author.
Interleaved @smith2015 @jones2012 @smith2010.

Report @stuster2018, thesis @miranda2019, article @jerrentrup2018, chapter @chapter2019, standard @standard2018.

#figure(raw("chapter one", lang: "text"), caption: [Listing one])

// Long table: must break across pages without losing rows; later pages say
// "Tablo 1.1 (devamı)" (directive article 13/e).
#figure(
  table(
    columns: 2,
    table.header([*No*], [*Value*]),
    ..range(70).map(i => ([row-#i], [#(i * i)])).flatten(),
  ),
  caption: [Long table],
)

= SONUÇ

// Listing counter must restart per chapter: "Liste 2.1", not "Liste 2.2".
#figure(raw("chapter two", lang: "text"), caption: [Listing two])

#theorem[A theorem in chapter two.]

#references(bibliography("regressions.bib", full: true))

#appendices[
  // Appendix heading: must not be numbered under the last chapter.
  == EK-1 Appendix heading
  #theorem[A theorem in the appendix.]
]
