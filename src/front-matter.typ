// Onay, etik beyan, özet, abstract, teşekkür, simgeler sayfaları.
#import "settings.typ": BLANK-LINE, DECISIONS, DEGREES, SIGNATURE-DOTS
#import "utils.typ": centered-bold, field, front-heading, single-spaced, tr-upper

#let _blank = "……"

#let approval(
  student: none,
  advisor-name: none,
  title: none,
  defense-date: none,
  decision: none,
  degree: "master",
  jury: (),
  institute-director: none,
) = {
  front-heading[ONAY]
  // Docx: ONAY ve ETİK BEYAN paragraflarında ilk satır girintisi yok.
  set par(first-line-indent: 0pt)
  let decision-text = if decision == none { none } else { DECISIONS.at(decision) }
  [#field(student, _blank) tarafından #field(advisor-name, _blank) danışmanlığında hazırlanan “#field(title, _blank)” başlıklı çalışma aşağıda imzaları bulunan jüri üyeleri tarafından #field(defense-date, "…/…/……") tarihinde yapılan Tez Savunma Sınavı sonucunda #field(decision-text, "oybirliği/oyçokluğu") ile #DEGREES.at(degree).text tezi olarak kabul edilmiştir.]

  let jury = if jury.len() > 0 { jury } else { (field(none, "Unvanı Adı SOYADI"),) }
  let roles = range(jury.len()).map(i => if i == 0 [Başkan] else [Üye])
  v(BLANK-LINE / 2)
  single-spaced(table(
    columns: (auto, 1fr, auto),
    stroke: none,
    inset: (x: 1em, y: 0.9em),
    table.hline(),
    table.header([*Görevi*], [*Unvanı, Adı ve Soyadı*], [*İmza*]),
    table.hline(),
    ..jury.zip(roles).map(((name, role)) => (role, name, SIGNATURE-DOTS)).flatten(),
    table.hline(),
  ))
  v(BLANK-LINE / 2)
  par(first-line-indent: 0pt)[Jüri kararı, Fen Bilimleri Enstitüsü Yönetim Kurulu’nun aşağıdaki tarih ve sayılı kararıyla onaylanmıştır.]
  v(BLANK-LINE)
  single-spaced(grid(columns: 2, column-gutter: 1em, row-gutter: 1.2em, [Tarih], [:], [Sayı], [:]))
  v(4 * BLANK-LINE)
  align(center, single-spaced[#institute-director \ Enstitü Müdürü])
  v(1fr)
  par(first-line-indent: 0pt, emph[Bu tezde kullanılan özgün bilgiler, şekil, tablo ve fotoğraflardan kaynak göstermeden alıntı yapmak 5846 sayılı Fikir ve Sanat Eserleri Kanunu hükümlerine tabidir.])
}

#let _ETHICS-TR = (
  [Tez içindeki bütün bilgi ve belgeleri akademik kurallar çerçevesinde elde ettiğimi,],
  [Görsel, işitsel ve yazılı tüm bilgi ve sonuçları bilimsel ahlâk kurallarına uygun olarak sunduğumu,],
  [Başkalarının eserlerinden yararlanılması durumunda ilgili eserlere bilimsel normlara uygun olarak atıfta bulunduğumu,],
  [Atıfta bulunduğum eserlerin tümünü kaynak olarak kullandığımı,],
  [Kullanılan verilerde herhangi bir tahrifat yapmadığımı,],
  [Bu tezin herhangi bir bölümünü Mersin Üniversitesi veya başka bir üniversitede başka bir tez çalışması olarak sunmadığımı,],
  [Tezin tüm telif haklarını Mersin Üniversitesi’ne devrettiğimi],
)

#let _ETHICS-EN = (
  [I have obtained all the information and the documents of the thesis in accordance with the academic rules.],
  [I presented all the visual, auditory and written information and results in accordance with scientific ethics.],
  [I refer in accordance with the norms of scientific works about the case of exploitation of others' works.],
  [I used all of the referred works as the references.],
  [I did not do any tampering in the used data.],
  [I did not present any part of this thesis as an another thesis at Mersin University or another university.],
  [I transfer all copyrights of this thesis to the Mersin University.],
)

#let ethics(student: none, defense-date: none) = {
  front-heading[ETİK BEYAN]
  set par(first-line-indent: 0pt)
  [Mersin Üniversitesi Lisansüstü Eğitim-Öğretim Yönetmeliğinde belirtilen kurallara uygun olarak hazırladığım bu tez çalışmasında,]
  // Docx: etik beyan maddelerinin işareti "-".
  set list(marker: [-])
  list(.._ETHICS-TR)
  par(first-line-indent: 0pt)[beyan ederim.]
  v(BLANK-LINE / 2)
  centered-bold[ETHICAL DECLARATION]
  text(lang: "en")[This thesis is prepared in accordance with the rules specified in Mersin University Graduate Education Regulation and I declare to comply with the following conditions:]
  text(lang: "en", list(.._ETHICS-EN))
  v(1fr)
  align(center, single-spaced[
    #field(defense-date, "…/…/……") \ \
    İmza \ \ \ \
    #field(student, "Öğrenci Adı ve Soyadı")
  ])
  v(1fr)
}

// Özet ve abstract aynı yerleşimi kullanır; yalnızca dil ve etiketler değişir.
// to-upper: Türkçe sayfa için tr-upper (i -> İ), İngilizce için upper (i -> I).
#let _abstract-page(heading-text, thesis-title, to-upper, body, keywords-label, keywords, advisor-label, advisor-line) = {
  front-heading(heading-text)
  centered-bold(to-upper(thesis-title))
  v(BLANK-LINE / 2)
  body
  v(BLANK-LINE / 2)
  let keyword-list = if keywords.len() > 0 { keywords.join(", ") } else { field(none, "Kelime1, Kelime2, Kelime3") }
  par(first-line-indent: 0pt)[*#keywords-label:* #keyword-list.]
  v(BLANK-LINE / 2)
  par(first-line-indent: 0pt)[*#advisor-label:* #advisor-line]
}

#let abstract-tr(title: none, body: none, keywords: (), advisor-name: none, department: none) = _abstract-page(
  [ÖZET],
  field(title, "TEZİN TÜRKÇE BAŞLIĞI"),
  tr-upper,
  field(body, "Bu kısımda tezin özeti verilmelidir."),
  "Anahtar Kelimeler",
  keywords,
  "Danışman",
  [#field(advisor-name, "Unvanı Adı ve Soyadı"), Mersin Üniversitesi, #field(department, _blank) Anabilim Dalı, Mersin.],
)

#let abstract-en(title: none, body: none, keywords: (), advisor-name: none, department: none) = {
  set text(lang: "en")
  _abstract-page(
    [ABSTRACT],
    field(title, "TITLE OF THESIS"),
    upper,
    field(body, "The summary of study should be given in this section."),
    "Keywords",
    keywords,
    "Advisor",
    [#field(advisor-name, "Title Name and Surname"), Department of #field(department, _blank), Mersin University, Mersin.],
  )
}

#let acknowledgements(body) = {
  front-heading[TEŞEKKÜR]
  field(body, "Tezin hazırlanmasında katkı yapanlar bu kısımda belirtilmelidir.")
}

// items: (("MEÜ", "Mersin Üniversitesi"), ...)
#let abbreviations(items) = {
  front-heading[SİMGELER VE KISALTMALAR]
  single-spaced(table(
    columns: (auto, 1fr),
    align: (left, right),
    stroke: none,
    column-gutter: 3em,
    table.hline(),
    table.header([*Kısaltma/Simge*], [*Tanım*]),
    table.hline(),
    ..items.flatten(),
    table.hline(),
  ))
}
