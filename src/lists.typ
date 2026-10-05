// İçindekiler, tablolar dizini, şekiller dizini. Hepsi şablondaki biçimde:
// üstte "Sayfa" sütunu, yatay çizgilerle ayrılmış gruplar, sağda sayfa no.
#import "utils.typ": chapter-no, front-heading, single-spaced

// Bir öğenin bulunduğu sayfanın numarasını o sayfanın numaralandırma
// biçimiyle (i, ii … / 1, 2 …) döndürür.
#let _page-no(loc) = {
  let style = loc.page-numbering()
  if style == none { return "" }
  numbering(style, ..counter(page).at(loc))
}

#let _list-table(header-row, groups) = single-spaced(table(
  columns: (1fr, auto),
  stroke: none,
  inset: (x: 0.6em, y: 0.45em),
  table.hline(),
  table.header(..header-row),
  table.hline(),
  ..groups.filter(g => g.len() > 0).map(g => (..g.flatten(), table.hline())).flatten(),
))

#let _heading-row(h) = {
  let no = if h.numbering == none { none } else {
    numbering(h.numbering, ..counter(heading).at(h.location()))
  }
  let label = [#no #h.body]
  let page-no = _page-no(h.location())
  if h.level == 1 { (label, page-no) = (strong(label), strong(page-no)) }
  (link(h.location(), label), link(h.location(), page-no))
}

#let table-of-contents() = {
  front-heading[İÇİNDEKİLER]
  context {
    let headings = query(heading.where(outlined: true))
    let first-chapter = headings.position(h => h.numbering != none)
    let (front, main, back) = if first-chapter == none { (headings, (), ()) } else {
      let last-chapter = headings.len() - headings.rev().position(h => h.numbering != none)
      (headings.slice(0, first-chapter), headings.slice(first-chapter, last-chapter), headings.slice(last-chapter))
    }
    let title-page-row = (strong[İÇ KAPAK], strong[i])
    _list-table(
      ([], [Sayfa]),
      ((title-page-row,) + front.map(_heading-row), main.map(_heading-row), back.map(_heading-row)),
    )
  }
}

// kind: table | image. Etiket "Tablo 2.1." biçiminde kalın basılır.
// Numara figürün kendi konumunda hesaplanır (dizinin konumunda değil).
#let _figure-row(f, kind) = {
  let loc = f.location()
  let no = counter(figure.where(kind: kind)).at(loc).first()
  let chapter = chapter-no(loc: loc)
  let number = if chapter == "0" { str(no) } else { chapter + "." + str(no) }
  let label = strong[#f.supplement #number.]
  let caption = if f.caption == none { none } else { f.caption.body }
  (link(loc)[#label #caption], link(loc, _page-no(loc)))
}

// Hiç tablo/şekil yoksa dizin sayfası basılmaz (içindekilerde de görünmez).
#let _figure-list(heading-text, kind) = context {
  let figures = query(figure.where(kind: kind))
  if figures.len() == 0 { return }
  front-heading(heading-text)
  _list-table(([], [Sayfa]), (figures.map(f => _figure-row(f, kind)),))
}

#let list-of-tables() = _figure-list([TABLOLAR DİZİNİ], table)
#let list-of-figures() = _figure-list([ŞEKİLLER DİZİNİ], image)
