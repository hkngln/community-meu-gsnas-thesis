// İç kapak (sayfa i, numarası basılmaz).
#import "settings.typ": DEGREES
#import "utils.typ": field, single-spaced, tr-upper

#let _orcid-line(orcid) = [(ORCID: #field(orcid, "0000-0000-0000-0000"))]

// Danışman/jüri tablosu: "UNVAN : AD" + gerekirse altında ORCID satırı.
#let _committee-rows(advisor, co-advisor, jury) = {
  let rows = (
    ([DANIŞMAN], tr-upper(field(advisor.name, "UNVANI ADI SOYADI"))),
    (none, _orcid-line(advisor.at("orcid", default: none))),
  )
  if co-advisor != none {
    rows += (
      ([2. DANIŞMAN], tr-upper(co-advisor.name)),
      (none, _orcid-line(co-advisor.at("orcid", default: none))),
    )
  }
  // `jury` ONAY sayfasının tam listesidir (danışman dahil). Kapakta danışman
  // zaten üstte yazdığı için jüri üyesi satırlarında tekrar edilmez.
  let co-name = if co-advisor == none { none } else { co-advisor.name }
  let advisors = (advisor.name, co-name).filter(name => name != none)
  let members = jury.filter(member => member not in advisors)
  rows + members.map(member => ([JÜRİ ÜYESİ], tr-upper(member)))
}

#let _committee-table(advisor, co-advisor, jury) = grid(
  columns: (auto, auto, 1fr),
  column-gutter: 0.4em,
  row-gutter: 0.55em,
  .._committee-rows(advisor, co-advisor, jury)
    .map(((label, value)) => if label == none { ([], [], value) } else { (label, [:], value) })
    .flatten(),
)

#let title-page(
  title: none,
  degree: "master",
  student: none,
  orcid: none,
  department: none,
  advisor: (name: none, orcid: none),
  co-advisor: none,
  jury: (),
  date: none,
) = page(numbering: none, footer: none, header: none, {
  set text(weight: "bold")
  single-spaced({
    align(center, {
      v(2.5em)
      text(16pt, tr-upper(field(title, "TEZİN BAŞLIĞI")))
      set text(14pt)
      v(1fr)
      DEGREES.at(degree).cover
      v(0.8fr)
      tr-upper(field(student, "ÖĞRENCİNİN ADI VE SOYADI"))
      linebreak()
      [ORCID ID: #field(orcid, "0000-0000-0000-0000")]
      v(0.8fr)
      [MERSİN ÜNİVERSİTESİ \ FEN BİLİMLERİ ENSTİTÜSÜ]
      v(0.5fr)
      tr-upper(field(department, "..."))
      [ \ ANABİLİM DALI]
      v(0.5fr)
      [DANIŞMAN VE JÜRİ ÜYELERİ]
    })
    v(1.2em)
    text(12pt, _committee-table(advisor, co-advisor, jury))
    v(0.5fr)
    align(center, text(14pt)[#underline[MERSİN] \ #tr-upper(field(date, "AY - YIL"))])
  })
})
