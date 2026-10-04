// Onay, etik beyan, özet, abstract, teşekkür, simgeler sayfaları.
#import "ayarlar.typ": BOS-SATIR, IMZA-NOKTALARI, TEZ-TURLERI
#import "yardimci.typ": alan, buyuk-harf, on-baslik, ortali-kalin, tek-aralik

#let _bos = "……"

#let onay(
  ogrenci: none,
  danisman-ad: none,
  baslik: none,
  savunma-tarihi: none,
  karar: none,
  tur: "yl",
  juri: (),
  enstitu-muduru: none,
) = {
  on-baslik[ONAY]
  // Docx: ONAY ve ETİK BEYAN paragraflarında ilk satır girintisi yok.
  set par(first-line-indent: 0pt)
  [#alan(ogrenci, _bos) tarafından #alan(danisman-ad, _bos) danışmanlığında hazırlanan “#alan(baslik, _bos)” başlıklı çalışma aşağıda imzaları bulunan jüri üyeleri tarafından #alan(savunma-tarihi, "…/…/……") tarihinde yapılan Tez Savunma Sınavı sonucunda #alan(karar, "oybirliği/oyçokluğu") ile #TEZ-TURLERI.at(tur).metin tezi olarak kabul edilmiştir.]

  let juri = if juri.len() > 0 { juri } else { (alan(none, "Unvanı Adı SOYADI"),) }
  let gorevler = range(juri.len()).map(i => if i == 0 [Başkan] else [Üye])
  v(BOS-SATIR / 2)
  tek-aralik(table(
    columns: (auto, 1fr, auto),
    stroke: none,
    inset: (x: 1em, y: 0.9em),
    table.hline(),
    table.header([*Görevi*], [*Unvanı, Adı ve Soyadı*], [*İmza*]),
    table.hline(),
    ..juri.zip(gorevler).map(((ad, gorev)) => (gorev, ad, IMZA-NOKTALARI)).flatten(),
    table.hline(),
  ))
  v(BOS-SATIR / 2)
  par(first-line-indent: 0pt)[Jüri kararı, Fen Bilimleri Enstitüsü Yönetim Kurulu’nun aşağıdaki tarih ve sayılı kararıyla onaylanmıştır.]
  v(BOS-SATIR)
  tek-aralik(grid(columns: 2, column-gutter: 1em, row-gutter: 1.2em, [Tarih], [:], [Sayı], [:]))
  v(4 * BOS-SATIR)
  align(center, tek-aralik[#enstitu-muduru \ Enstitü Müdürü])
  v(1fr)
  par(first-line-indent: 0pt, emph[Bu tezde kullanılan özgün bilgiler, şekil, tablo ve fotoğraflardan kaynak göstermeden alıntı yapmak 5846 sayılı Fikir ve Sanat Eserleri Kanunu hükümlerine tabidir.])
}

#let _ETIK-TR = (
  [Tez içindeki bütün bilgi ve belgeleri akademik kurallar çerçevesinde elde ettiğimi,],
  [Görsel, işitsel ve yazılı tüm bilgi ve sonuçları bilimsel ahlâk kurallarına uygun olarak sunduğumu,],
  [Başkalarının eserlerinden yararlanılması durumunda ilgili eserlere bilimsel normlara uygun olarak atıfta bulunduğumu,],
  [Atıfta bulunduğum eserlerin tümünü kaynak olarak kullandığımı,],
  [Kullanılan verilerde herhangi bir tahrifat yapmadığımı,],
  [Bu tezin herhangi bir bölümünü Mersin Üniversitesi veya başka bir üniversitede başka bir tez çalışması olarak sunmadığımı,],
  [Tezin tüm telif haklarını Mersin Üniversitesi’ne devrettiğimi],
)

#let _ETIK-EN = (
  [I have obtained all the information and the documents of the thesis in accordance with the academic rules.],
  [I presented all the visual, auditory and written information and results in accordance with scientific ethics.],
  [I refer in accordance with the norms of scientific works about the case of exploitation of others' works.],
  [I used all of the referred works as the references.],
  [I did not do any tampering in the used data.],
  [I did not present any part of this thesis as an another thesis at Mersin University or another university.],
  [I transfer all copyrights of this thesis to the Mersin University.],
)

#let etik-beyan(ogrenci: none, savunma-tarihi: none) = {
  on-baslik[ETİK BEYAN]
  set par(first-line-indent: 0pt)
  [Mersin Üniversitesi Lisansüstü Eğitim-Öğretim Yönetmeliğinde belirtilen kurallara uygun olarak hazırladığım bu tez çalışmasında,]
  list(.._ETIK-TR)
  par(first-line-indent: 0pt)[beyan ederim.]
  v(BOS-SATIR / 2)
  ortali-kalin[ETHICAL DECLARATION]
  text(lang: "en")[This thesis is prepared in accordance with the rules specified in Mersin University Graduate Education Regulation and I declare to comply with the following conditions:]
  text(lang: "en", list(.._ETIK-EN))
  v(1fr)
  align(center, tek-aralik[
    #alan(savunma-tarihi, "…/…/……") \ \
    İmza \ \ \ \
    #alan(ogrenci, "Öğrenci Adı ve Soyadı")
  ])
  v(1fr)
}

// Özet ve abstract aynı yerleşimi kullanır; yalnızca dil ve etiketler değişir.
#let _ozet-sayfasi(baslik, tez-basligi, govde, kelime-etiketi, kelimeler, danisman-etiketi, danisman-satiri) = {
  on-baslik(baslik)
  ortali-kalin(buyuk-harf(tez-basligi))
  v(BOS-SATIR / 2)
  govde
  v(BOS-SATIR / 2)
  let kelime-listesi = if kelimeler.len() > 0 { kelimeler.join(", ") } else { alan(none, "Kelime1, Kelime2, Kelime3") }
  par(first-line-indent: 0pt)[*#kelime-etiketi:* #kelime-listesi.]
  v(BOS-SATIR / 2)
  par(first-line-indent: 0pt)[*#danisman-etiketi:* #danisman-satiri]
}

#let ozet(baslik: none, govde: none, anahtar-kelimeler: (), danisman-ad: none, anabilim-dali: none) = _ozet-sayfasi(
  [ÖZET],
  alan(baslik, "TEZİN TÜRKÇE BAŞLIĞI"),
  alan(govde, "Bu kısımda tezin özeti verilmelidir."),
  "Anahtar Kelimeler",
  anahtar-kelimeler,
  "Danışman",
  [#alan(danisman-ad, "Unvanı Adı ve Soyadı"), Mersin Üniversitesi, #alan(anabilim-dali, _bos) Anabilim Dalı, Mersin.],
)

#let abstract(baslik: none, govde: none, keywords: (), danisman-ad: none, department: none) = {
  set text(lang: "en")
  _ozet-sayfasi(
    [ABSTRACT],
    alan(baslik, "TITLE OF THE THESIS"),
    alan(govde, "The summary of study should be given in this section."),
    "Keywords",
    keywords,
    "Advisor",
    [#alan(danisman-ad, "Title Name and Surname"), Department of #alan(department, _bos), Mersin University, Mersin.],
  )
}

#let tesekkur(govde) = {
  on-baslik[TEŞEKKÜR]
  alan(govde, "Tezin hazırlanmasında katkı yapanlar bu kısımda belirtilmelidir.")
}

// kisaltmalar: (("MEÜ", "Mersin Üniversitesi"), ...)
#let simgeler(kisaltmalar) = {
  on-baslik[SİMGELER VE KISALTMALAR]
  tek-aralik(table(
    columns: (auto, 1fr),
    align: (left, right),
    stroke: none,
    column-gutter: 3em,
    table.hline(),
    table.header([*Kısaltma/Simge*], [*Tanım*]),
    table.hline(),
    ..kisaltmalar.flatten(),
    table.hline(),
  ))
}
