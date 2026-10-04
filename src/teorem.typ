// LaTeX şablonundaki \newtheorem ortamları: hepsi tek sayaç paylaşır ve
// alt bölüme göre numaralanır (Tanım 2.1.1, Teorem 2.1.2 …). Figure olarak
// kurulduğu için <etiket> + @etiket ile atıf yapılabilir.

#let TEOREM-TURU = "meu-teorem"

// Alt bölümde: 2.1.3; ilk "==" başlığından önce: 2.3 (".0." çıkmasın).
#let _teorem-numarasi(..n) = {
  let h = counter(heading).get()
  let ust = (h.at(0, default: 0), h.at(1, default: 0)).filter(x => x != 0)
  (ust + n.pos()).map(str).join(".")
}

#let teorem-ortami(ad) = (govde, baslik: none) => figure(
  kind: TEOREM-TURU,
  supplement: ad,
  numbering: _teorem-numarasi,
  outlined: false,
  {
    if baslik != none [(#baslik) ]
    govde
  },
)

#let teorem-stili(belge) = {
  show figure.where(kind: TEOREM-TURU): set block(breakable: true)
  show figure.where(kind: TEOREM-TURU): it => align(left, block(width: 100%, {
    strong[#it.supplement #it.counter.display(it.numbering).]
    [ ]
    it.body
  }))
  belge
}

#let tanim = teorem-ortami[Tanım]
#let teorem = teorem-ortami[Teorem]
#let ornek = teorem-ortami[Örnek]
#let onerme = teorem-ortami[Önerme]
#let uyari = teorem-ortami[Uyarı]
#let nott = teorem-ortami[Not]
#let sonuc = teorem-ortami[Sonuç]
#let lemma = teorem-ortami[Lemma]

#let kanit(govde) = block(width: 100%)[_Kanıt._ #govde #h(1fr) $square$]
