// Ana şablon fonksiyonu: #show: thesis.with(...)
#import "settings.typ": *
#import "utils.typ": by-chapter, field
#import "title-page.typ": title-page
#import "covers.typ" as covers
#import "front-matter.typ" as fm
#import "lists.typ": list-of-figures, list-of-tables, table-of-contents
#import "theorems.typ": THEOREM-KIND, theorem-style

// Bölüm sonu / bölüm başı işaretleri: tek sayfaya geçerken araya eklenen boş
// sayfaları bulmak için. Boş sayfada üst bilgi ve sayfa numarası basılmaz.
#let _SECTION-END = <meu-section-end>
#let _SECTION-START = <meu-section-start>

#let _is-blank-page(page-no) = {
  let ends = query(_SECTION-END).map(m => m.location().page())
  let starts = query(_SECTION-START).map(m => m.location().page())
  ends.zip(starts).any(((end, start)) => end < page-no and page-no < start)
}

// Yeni sayfaya geçer; araya eklenen boş sayfa işaretlerle tanınır.
#let _break-to(target) = {
  [#metadata(none)#_SECTION-END]
  pagebreak(weak: true, to: target)
  [#metadata(none)#_SECTION-START]
}

// Sayfa, yazı, paragraf, liste: her yerde geçerli temel ayarlar.
#let _base-style(font, doc) = {
  set page(paper: "a4", margin: MARGIN, header-ascent: HEADER-ASCENT)
  set text(
    font: font,
    size: FONT-SIZE,
    lang: "tr",
    // "ascender" OS/2 typo değerini (0.693em) kullanır; Word ise hhea
    // ascender/descender (0.891em / 0.216em) ile satır kutusu kurar.
    top-edge: TNR-ASCENDER,
    bottom-edge: -TNR-DESCENDER,
  )
  set par(
    justify: true,
    leading: SPACING-1-5,
    spacing: SPACING-1-5,
    first-line-indent: (amount: PAR-INDENT, all: true),
  )
  set list(marker: [–], spacing: SPACING-1-5)
  set enum(spacing: SPACING-1-5)
  set heading(numbering: "1.1.")
  show heading: set text(size: FONT-SIZE, weight: "bold")
  show heading: set block(above: BLANK-LINE, below: BLANK-LINE)
  doc
}

// table.header'ın kapladığı satır sayısı (yoksa ilk satır başlık sayılır).
#let _header-rows(t) = {
  let cols = if type(t.columns) == int { t.columns } else { t.columns.len() }
  let header = t.children.filter(c => c.func() == table.header)
  if header.len() == 0 { return 1 }
  let cells = header.first().children.filter(c => c.func() != table.hline)
  let slots = cells.map(c => if c.func() == table.cell { c.at("colspan", default: 1) } else { 1 }).sum(default: 0)
  calc.max(1, calc.ceil(slots / cols))
}

// Şekil, tablo, denklem: bölüm numarasına göre (2.1), tek satır aralıklı.
#let _figure-style(font, doc) = {
  set figure(numbering: by-chapter, gap: 0.8em)
  set figure.caption(separator: [. ])
  show figure.where(kind: table): set figure.caption(position: top)
  // Etiketler tez dili İngilizce olsa da Türkçe kalır (enstitü kuralı).
  show figure.where(kind: table): set figure(supplement: [Tablo])
  show figure.where(kind: image): set figure(supplement: [Şekil])
  show figure.where(kind: raw): set figure(supplement: [Liste])
  show figure: set block(above: BLANK-LINE, below: BLANK-LINE)
  show figure: set par(leading: SPACING-1, first-line-indent: 0pt)
  show figure.caption: it => context [*#it.supplement #it.counter.display(it.numbering)#it.separator*#it.body]
  // Docx: tablonun üstünde, başlık satır(lar)ının altında ve en altta çizgi.
  // Yalnızca figür içindeki tablolara uygulanır. Uzun tablolar sayfadan sayfaya
  // bölünebilir; başlık satırı tekrarlanır, her parçanın altında çizgi olur.
  show figure.where(kind: table): set block(breakable: true)
  show figure.where(kind: table): it => {
    let header-rows = if it.body.func() == table { _header-rows(it.body) } else { 1 }
    set table(stroke: (_, y) => if y == 0 or y == header-rows { (top: 0.5pt) })
    show table: t => context {
      block(width: measure(t).width, breakable: true, stroke: (bottom: 0.5pt), t)
    }
    it
  }

  // Numara matematik fontuyla değil, metin fontuyla basılsın: "(2.1)".
  set math.equation(numbering: n => text(font: font)[(#by-chapter(n))], supplement: [Eşitlik])
  show math.equation.where(block: true): set block(above: BLANK-LINE, below: BLANK-LINE)
  // @denklem -> "Eşitlik (2.1)" (Typst varsayılanı parantezleri düşürür).
  show ref: it => {
    let el = it.element
    if el == none or el.func() != math.equation { return it }
    let supplement = if it.supplement == auto { el.supplement } else { it.supplement }
    link(el.location(), [#supplement~#numbering(el.numbering, ..counter(math.equation).at(el.location()))])
  }

  set footnote(numbering: "*")
  show footnote.entry: set text(FOOTNOTE-SIZE)
  doc
}

#let _header(body) = context {
  // Dipnot işaretleri her sayfada * ile yeniden başlar.
  counter(footnote).update(0)
  if _is-blank-page(here().page()) { return }
  block(width: 100%, stroke: (bottom: 0.5pt), inset: (bottom: 3pt), text(HEADER-SIZE, body))
}

#let _footer = context {
  if _is-blank-page(here().page()) { return }
  align(right, counter(page).display())
}

#let _main-matter(header-text, two-sided, language, body) = {
  set page(numbering: "1", header: _header(header-text), footer: _footer)
  set text(lang: language)
  counter(page).update(1)
  show heading.where(level: 1): it => {
    _break-to(if two-sided { "odd" } else { none })
    // Belgede kullanılan her figür türü (tablo, şekil, kod listesi, teorem,
    // kullanıcı türleri) her bölümde yeniden 1'den başlar.
    context {
      let kinds = (table, image, raw, THEOREM-KIND) + query(figure).map(f => f.kind)
      for kind in kinds.dedup() { counter(figure.where(kind: kind)).update(0) }
    }
    counter(math.equation).update(0)
    it
  }
  show heading.where(level: 2): it => {
    counter(figure.where(kind: THEOREM-KIND)).update(0)
    it
  }
  body
}

#let thesis(
  // Kapak ve üst bilgi
  title: none,
  title-en: none,
  degree: "master", // "master" | "phd"
  student: none, // "Adı SOYADI"
  orcid: none,
  department: none, // "Elektrik-Elektronik Mühendisliği"
  department-en: none, // "Electrical and Electronics Engineering"
  advisor: (name: none, orcid: none),
  co-advisor: none,
  jury: (),
  date: none, // "OCAK - 2026"
  year: none, // üst bilgide
  // Enstitünün logolu dış kapakları (EK-5 ön kapak, EK-6 arka kapak).
  // YÖK Tez Merkezi'ne yüklenen elektronik kopyada arka kapak bulunmalıdır.
  front-cover: true,
  back-cover: true,
  // Onay / etik beyan
  defense-date: none,
  decision: none, // "unanimous" | "majority"
  institute-director: INSTITUTE-DIRECTOR,
  // Ön kısım içerikleri
  abstract-tr: none,
  keywords-tr: (),
  abstract-en: none,
  keywords-en: (),
  acknowledgements: none,
  abbreviations: (),
  // Bölümler yeni ve tek numaralı sayfadan başlar (çift taraflı baskı).
  two-sided: true,
  // Tezin yazıldığı dil: "tr" | "en". Ana metnin heceleme dilini ve atıflarda
  // iki yazar arasındaki bağlacı belirler (tr: "ve", en: "&"). Basılı başlıklar
  // ve etiketler (ÖZET, KAYNAKLAR, Tablo, Şekil…) enstitü kuralı gereği Türkçedir.
  language: "tr",
  // Yazı tipi; listede bulunan ilk font kullanılır. Resmi teslim: Times New Roman.
  // Ör. ("Times New Roman", "TeX Gyre Termes", "Libertinus Serif")
  font: FONTS,
  body,
) = {
  assert(
    type(font) in (str, array),
    message: "font bir yazı tipi adı ya da ad listesi olmalı, verilen: " + repr(font),
  )
  // Yanlış türde değer verildiğinde Typst'ün iç hatası yerine anlaşılır mesaj.
  let _person = (name, value) => assert(
    type(value) == dictionary and "name" in value,
    message: name + " (name: \"...\", orcid: \"...\") biçiminde olmalı, verilen: " + repr(value),
  )
  _person("advisor", advisor)
  if co-advisor != none { _person("co-advisor", co-advisor) }
  for (name, value) in (
    ("jury", jury),
    ("keywords-tr", keywords-tr),
    ("keywords-en", keywords-en),
    ("abbreviations", abbreviations),
  ) {
    assert(
      type(value) == array,
      message: name + " bir dizi olmalı, ör. (\"a\", \"b\"); verilen: " + repr(value),
    )
  }
  assert(degree in DEGREES, message: "degree \"master\" veya \"phd\" olmalı, verilen: " + repr(degree))
  assert(
    decision == none or decision in DECISIONS,
    message: "decision \"unanimous\" veya \"majority\" olmalı, verilen: " + repr(decision),
  )
  assert(jury.len() <= 5, message: "jüri en fazla 5 üye (başkan dahil) olabilir")
  assert(language in ("tr", "en"), message: "language \"tr\" veya \"en\" olmalı, verilen: " + repr(language))

  set document(title: field(title, "Tez"), author: if student == none { () } else { student })
  show: _base-style.with(font)
  show: _figure-style.with(font)
  show: theorem-style

  // Dış kapak sayfa sayısına girmez; çift taraflı baskıda iç yüzü boş kalır.
  if front-cover {
    covers.front-cover(title: title, degree: degree, student: student, department: department, date: date)
    if two-sided { covers.blank-page() }
  }

  // Ön kısım: Romen rakamı, iç kapak "i" sayılır ama basılmaz.
  {
    counter(page).update(1)
    // Docx: ön kısım sayfaları tek satır aralıklı (Normal stil, line=240).
    set par(leading: SPACING-1, spacing: SPACING-1)
    set list(spacing: SPACING-1)
    set page(numbering: "i", header: none, footer: context {
      if _is-blank-page(here().page()) { return }
      align(right, counter(page).display("i"))
    })
    title-page(
      title: title,
      degree: degree,
      student: student,
      orcid: orcid,
      department: department,
      advisor: advisor,
      co-advisor: co-advisor,
      jury: jury,
      date: date,
    )
    fm.approval(
      student: student,
      advisor-name: advisor.name,
      title: title,
      defense-date: defense-date,
      decision: decision,
      degree: degree,
      jury: jury,
      institute-director: institute-director,
    )
    fm.ethics(student: student, defense-date: defense-date)
    fm.abstract-tr(
      title: title,
      body: abstract-tr,
      keywords: keywords-tr,
      advisor-name: advisor.name,
      department: department,
    )
    fm.abstract-en(
      title: title-en,
      body: abstract-en,
      keywords: keywords-en,
      advisor-name: advisor.name,
      department: department-en,
    )
    fm.acknowledgements(acknowledgements)
    table-of-contents()
    list-of-tables()
    list-of-figures()
    if abbreviations.len() > 0 { fm.abbreviations(abbreviations) }
    // pagebreak(to: "odd") fiziksel sayfa sırasına bakar. Ana metnin 1.
    // sayfası fiziksel tek sayfaya denk gelsin ki iki parite hep aynı kalsın.
    if two-sided { _break-to("odd") }
  }

  let header-text = [#field(student, "Adı SOYADI"), #DEGREES.at(degree).text Tezi, Fen Bilimleri Enstitüsü, Mersin Üniversitesi, #field(year, "YIL")]
  _main-matter(header-text, two-sided, language, body)
  if back-cover { covers.back-cover() }
}
