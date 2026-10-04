// Ana şablon fonksiyonu: #show: tez.with(...)
#import "ayarlar.typ": *
#import "yardimci.typ": alan, bolume-gore
#import "kapak.typ": kapak
#import "dis-kapak.typ" as dk
#import "on-kisim.typ" as on
#import "dizinler.typ": icindekiler, sekiller-dizini, tablolar-dizini
#import "teorem.typ": TEOREM-TURU, teorem-stili

// Bölüm sonu / bölüm başı işaretleri: tek sayfaya geçerken araya eklenen boş
// sayfaları bulmak için. Boş sayfada üst bilgi ve sayfa numarası basılmaz.
#let _BOLUM-SONU = <meu-bolum-sonu>
#let _BOLUM-BASI = <meu-bolum-basi>

#let _bos-sayfa-mi(sayfa) = {
  let sonlar = query(_BOLUM-SONU).map(m => m.location().page())
  let baslar = query(_BOLUM-BASI).map(m => m.location().page())
  sonlar.zip(baslar).any(((son, bas)) => son < sayfa and sayfa < bas)
}

// Yeni sayfaya geçer; araya eklenen boş sayfa işaretlerle tanınır.
#let _bos-sayfa-ile-gec(hedef) = {
  [#metadata(none)#_BOLUM-SONU]
  pagebreak(weak: true, to: hedef)
  [#metadata(none)#_BOLUM-BASI]
}

// Sayfa, yazı, paragraf, liste: her yerde geçerli temel ayarlar.
#let _temel-stil(belge) = {
  set page(paper: "a4", margin: KENAR-BOSLUGU, header-ascent: UST-BILGI-ASCENT)
  set text(
    font: YAZI-TIPI,
    size: YAZI-BOYUTU,
    lang: "tr",
    // "ascender" OS/2 typo değerini (0.693em) kullanır; Word ise hhea
    // ascender/descender (0.891em / 0.216em) ile satır kutusu kurar.
    top-edge: TNR-ASCENDER,
    bottom-edge: -TNR-DESCENDER,
  )
  set par(
    justify: true,
    leading: ARALIK-1-5,
    spacing: ARALIK-1-5,
    first-line-indent: (amount: PARAGRAF-GIRINTISI, all: true),
  )
  set list(marker: [–], spacing: ARALIK-1-5)
  set enum(spacing: ARALIK-1-5)
  set heading(numbering: "1.1.")
  show heading: set text(size: YAZI-BOYUTU, weight: "bold")
  show heading: set block(above: BOS-SATIR, below: BOS-SATIR)
  belge
}

// Şekil, tablo, denklem: bölüm numarasına göre (2.1), tek satır aralıklı.
#let _sekil-stili(belge) = {
  set figure(numbering: bolume-gore, gap: 0.8em)
  set figure.caption(separator: [. ])
  show figure.where(kind: table): set figure.caption(position: top)
  show figure: set block(above: BOS-SATIR, below: BOS-SATIR)
  show figure: set par(leading: ARALIK-1, first-line-indent: 0pt)
  show figure.caption: it => context [*#it.supplement #it.counter.display(it.numbering)#it.separator*#it.body]
  // Docx: yalnızca tablonun üstünde, başlık satırının altında ve en altta çizgi.
  set table(stroke: (_, y) => if y <= 1 { (top: 0.5pt) })
  show figure.where(kind: table): it => {
    show table: t => box(stroke: (bottom: 0.5pt), t)
    it
  }

  set math.equation(numbering: n => "(" + bolume-gore(n) + ")", supplement: [Eşitlik])
  show math.equation.where(block: true): set block(above: BOS-SATIR, below: BOS-SATIR)
  // @denklem -> "Eşitlik (2.1)" (Typst varsayılanı parantezleri düşürür).
  show ref: it => {
    let el = it.element
    if el == none or el.func() != math.equation { return it }
    let ek = if it.supplement == auto { el.supplement } else { it.supplement }
    link(el.location(), [#ek~#numbering(el.numbering, ..counter(math.equation).at(el.location()))])
  }

  set footnote(numbering: "*")
  show footnote.entry: set text(DIPNOT-BOYUTU)
  belge
}

#let _ust-bilgi(metin) = context {
  // Dipnot işaretleri her sayfada * ile yeniden başlar.
  counter(footnote).update(0)
  if _bos-sayfa-mi(here().page()) { return }
  block(width: 100%, stroke: (bottom: 0.5pt), inset: (bottom: 3pt), text(UST-BILGI-BOYUTU, metin))
}

#let _alt-bilgi = context {
  if _bos-sayfa-mi(here().page()) { return }
  align(right, counter(page).display())
}

#let _ana-metin(ust-bilgi, tek-sayfa-basla, govde) = {
  set page(numbering: "1", header: _ust-bilgi(ust-bilgi), footer: _alt-bilgi)
  counter(page).update(1)
  show heading.where(level: 1): it => {
    _bos-sayfa-ile-gec(if tek-sayfa-basla { "odd" } else { none })
    for tur in (table, image, TEOREM-TURU) { counter(figure.where(kind: tur)).update(0) }
    counter(math.equation).update(0)
    it
  }
  show heading.where(level: 2): it => {
    counter(figure.where(kind: TEOREM-TURU)).update(0)
    it
  }
  govde
}

#let tez(
  // Kapak ve üst bilgi
  baslik: none,
  baslik-en: none,
  tur: "yl", // "yl" | "dr"
  ogrenci: none, // "Adı SOYADI"
  orcid: none,
  anabilim-dali: none, // "Elektrik-Elektronik Mühendisliği"
  department: none, // "Electrical and Electronics Engineering"
  danisman: (ad: none, orcid: none),
  ikinci-danisman: none,
  juri: (),
  tarih: none, // "OCAK - 2025"
  // Enstitünün logolu dış kapakları (EK-5 ön kapak, EK-6 arka kapak).
  // YÖK Tez Merkezi'ne yüklenen elektronik kopyada arka kapak bulunmalıdır.
  dis-kapak: true,
  arka-kapak: true,
  yil: none, // üst bilgide
  // Onay / etik beyan
  savunma-tarihi: none,
  karar: none, // "oybirliği" | "oyçokluğu"
  enstitu-muduru: ENSTITU-MUDURU,
  // Ön kısım içerikleri
  ozet: none,
  anahtar-kelimeler: (),
  abstract: none,
  keywords: (),
  tesekkur: none,
  kisaltmalar: (),
  // Bölümler yeni ve tek numaralı sayfadan başlar (çift taraflı baskı).
  tek-sayfa-basla: true,
  govde,
) = {
  assert(tur in TEZ-TURLERI, message: "tur \"yl\" veya \"dr\" olmalı, verilen: " + repr(tur))
  assert(juri.len() <= 5, message: "jüri en fazla 5 üye (başkan dahil) olabilir")

  set document(title: alan(baslik, "Tez"), author: if ogrenci == none { () } else { ogrenci })
  show: _temel-stil
  show: _sekil-stili
  show: teorem-stili

  // Dış kapak sayfa sayısına girmez; çift taraflı baskıda iç yüzü boş kalır.
  if dis-kapak {
    dk.on-kapak(baslik: baslik, tur: tur, ogrenci: ogrenci, anabilim-dali: anabilim-dali, tarih: tarih)
    if tek-sayfa-basla { dk.bos-sayfa() }
  }

  // Ön kısım: Romen rakamı, iç kapak "i" sayılır ama basılmaz.
  {
    counter(page).update(1)
    // Docx: ön kısım sayfaları tek satır aralıklı (Normal stil, line=240).
    set par(leading: ARALIK-1, spacing: ARALIK-1)
    set list(spacing: ARALIK-1)
    set page(numbering: "i", header: none, footer: context {
      if _bos-sayfa-mi(here().page()) { return }
      align(right, counter(page).display("i"))
    })
    kapak(
      baslik: baslik,
      tur: tur,
      ogrenci: ogrenci,
      orcid: orcid,
      anabilim-dali: anabilim-dali,
      danisman: danisman,
      ikinci-danisman: ikinci-danisman,
      juri: juri,
      tarih: tarih,
    )
    on.onay(
      ogrenci: ogrenci,
      danisman-ad: danisman.ad,
      baslik: baslik,
      savunma-tarihi: savunma-tarihi,
      karar: karar,
      tur: tur,
      juri: juri,
      enstitu-muduru: enstitu-muduru,
    )
    on.etik-beyan(ogrenci: ogrenci, savunma-tarihi: savunma-tarihi)
    on.ozet(
      baslik: baslik,
      govde: ozet,
      anahtar-kelimeler: anahtar-kelimeler,
      danisman-ad: danisman.ad,
      anabilim-dali: anabilim-dali,
    )
    on.abstract(
      baslik: baslik-en,
      govde: abstract,
      keywords: keywords,
      danisman-ad: danisman.ad,
      department: department,
    )
    on.tesekkur(tesekkur)
    icindekiler()
    tablolar-dizini()
    sekiller-dizini()
    if kisaltmalar.len() > 0 { on.simgeler(kisaltmalar) }
    // pagebreak(to: "odd") fiziksel sayfa sırasına bakar. Ana metnin 1.
    // sayfası fiziksel tek sayfaya denk gelsin ki iki parite hep aynı kalsın.
    if tek-sayfa-basla { _bos-sayfa-ile-gec("odd") }
  }

  let ust-bilgi = [#alan(ogrenci, "Adı SOYADI"), #TEZ-TURLERI.at(tur).metin Tezi, Fen Bilimleri Enstitüsü, Mersin Üniversitesi, #alan(yil, "YIL")]
  _ana-metin(ust-bilgi, tek-sayfa-basla, govde)
  if arka-kapak { dk.arka-kapak() }
}
