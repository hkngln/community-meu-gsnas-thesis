// İçindekiler, tablolar dizini, şekiller dizini. Hepsi şablondaki biçimde:
// üstte "Sayfa" sütunu, yatay çizgilerle ayrılmış gruplar, sağda sayfa no.
#import "yardimci.typ": bolum-no, on-baslik, tek-aralik

// Bir öğenin bulunduğu sayfanın numarasını o sayfanın numaralandırma
// biçimiyle (i, ii … / 1, 2 …) döndürür.
#let _sayfa-no(konum) = {
  let bicim = konum.page-numbering()
  if bicim == none { return "" }
  numbering(bicim, ..counter(page).at(konum))
}

#let _dizin-tablosu(ust-satir, gruplar) = tek-aralik(table(
  columns: (1fr, auto),
  stroke: none,
  inset: (x: 0.6em, y: 0.45em),
  table.hline(),
  table.header(..ust-satir),
  table.hline(),
  ..gruplar.filter(g => g.len() > 0).map(g => (..g.flatten(), table.hline())).flatten(),
))

#let _baslik-satiri(h) = {
  let no = if h.numbering == none { none } else {
    numbering(h.numbering, ..counter(heading).at(h.location()))
  }
  let metin = [#no #h.body]
  let sayfa = _sayfa-no(h.location())
  if h.level == 1 { (metin, sayfa) = (strong(metin), strong(sayfa)) }
  (link(h.location(), metin), link(h.location(), sayfa))
}

#let icindekiler() = {
  on-baslik[İÇİNDEKİLER]
  context {
    let basliklar = query(heading.where(outlined: true))
    let ilk-bolum = basliklar.position(h => h.numbering != none)
    let (on, ana, arka) = if ilk-bolum == none { (basliklar, (), ()) } else {
      let son-bolum = basliklar.len() - basliklar.rev().position(h => h.numbering != none)
      (basliklar.slice(0, ilk-bolum), basliklar.slice(ilk-bolum, son-bolum), basliklar.slice(son-bolum))
    }
    let kapak-satiri = (strong[İÇ KAPAK], strong[i])
    _dizin-tablosu(
      ([], [Sayfa]),
      ((kapak-satiri,) + on.map(_baslik-satiri), ana.map(_baslik-satiri), arka.map(_baslik-satiri)),
    )
  }
}

// tur: table | image. Etiket "Tablo 2.1." biçiminde kalın basılır.
// Numara figürün kendi konumunda hesaplanır (dizinin konumunda değil).
#let _dizin-satiri(f, tur) = {
  let konum = f.location()
  let no = counter(figure.where(kind: tur)).at(konum).first()
  let bolum = bolum-no(konum: konum)
  let numara = if bolum == "0" { str(no) } else { bolum + "." + str(no) }
  let etiket = strong[#f.supplement #numara.]
  let aciklama = if f.caption == none { none } else { f.caption.body }
  (link(konum)[#etiket #aciklama], link(konum, _sayfa-no(konum)))
}

// Hiç tablo/şekil yoksa dizin sayfası basılmaz (içindekilerde de görünmez).
#let _sekil-dizini(baslik, tur) = context {
  let sekiller = query(figure.where(kind: tur))
  if sekiller.len() == 0 { return }
  on-baslik(baslik)
  _dizin-tablosu(([], [Sayfa]), (sekiller.map(f => _dizin-satiri(f, tur)),))
}

#let tablolar-dizini() = _sekil-dizini([TABLOLAR DİZİNİ], table)
#let sekiller-dizini() = _sekil-dizini([ŞEKİLLER DİZİNİ], image)
