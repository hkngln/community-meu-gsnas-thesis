// İç kapak (sayfa i, numarası basılmaz).
#import "ayarlar.typ": TEZ-TURLERI
#import "yardimci.typ": alan, buyuk-harf, tek-aralik

#let _orcid-satiri(orcid) = [(ORCID: #alan(orcid, "0000-0000-0000-0000"))]

// Danışman/jüri tablosu: "UNVAN : AD" + gerekirse altında ORCID satırı.
#let _kurul-satirlari(danisman, ikinci-danisman, juri) = {
  let satirlar = (
    ([DANIŞMAN], buyuk-harf(alan(danisman.ad, "UNVANI ADI SOYADI"))),
    (none, _orcid-satiri(danisman.at("orcid", default: none))),
  )
  if ikinci-danisman != none {
    satirlar += (
      ([2. DANIŞMAN], buyuk-harf(ikinci-danisman.ad)),
      (none, _orcid-satiri(ikinci-danisman.at("orcid", default: none))),
    )
  }
  // `juri` ONAY sayfasının tam listesidir (danışman dahil). Kapakta danışman
  // zaten üstte yazdığı için jüri üyesi satırlarında tekrar edilmez.
  let ikinci-ad = if ikinci-danisman == none { none } else { ikinci-danisman.ad }
  let danismanlar = (danisman.ad, ikinci-ad).filter(ad => ad != none)
  let uyeler = juri.filter(uye => uye not in danismanlar)
  satirlar + uyeler.map(uye => ([JÜRİ ÜYESİ], buyuk-harf(uye)))
}

#let _kurul-tablosu(danisman, ikinci-danisman, juri) = grid(
  columns: (auto, auto, 1fr),
  column-gutter: 0.4em,
  row-gutter: 0.55em,
  .._kurul-satirlari(danisman, ikinci-danisman, juri)
    .map(((etiket, deger)) => if etiket == none { ([], [], deger) } else { (etiket, [:], deger) })
    .flatten(),
)

#let kapak(
  baslik: none,
  tur: "yl",
  ogrenci: none,
  orcid: none,
  anabilim-dali: none,
  danisman: (ad: none, orcid: none),
  ikinci-danisman: none,
  juri: (),
  tarih: none,
) = page(numbering: none, footer: none, header: none, {
  set text(weight: "bold")
  tek-aralik({
    align(center, {
      v(2.5em)
      text(16pt, buyuk-harf(alan(baslik, "TEZİN BAŞLIĞI")))
      set text(14pt)
      v(1fr)
      TEZ-TURLERI.at(tur).kapak
      v(0.8fr)
      buyuk-harf(alan(ogrenci, "ÖĞRENCİNİN ADI VE SOYADI"))
      linebreak()
      [ORCID ID: #alan(orcid, "0000-0000-0000-0000")]
      v(0.8fr)
      [MERSİN ÜNİVERSİTESİ \ FEN BİLİMLERİ ENSTİTÜSÜ]
      v(0.5fr)
      buyuk-harf(alan(anabilim-dali, "..."))
      [ \ ANABİLİM DALI]
      v(0.5fr)
      [DANIŞMAN VE JÜRİ ÜYELERİ]
    })
    v(1.2em)
    text(12pt, _kurul-tablosu(danisman, ikinci-danisman, juri))
    v(0.5fr)
    align(center, text(14pt)[#underline[MERSİN] \ #buyuk-harf(alan(tarih, "AY - YIL"))])
  })
})
