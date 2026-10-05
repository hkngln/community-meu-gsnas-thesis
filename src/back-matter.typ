// Kaynaklar, ekler ve özgeçmiş. Ana metinden sonra kullanılır; başlıklar
// numarasızdır, yeni (ve two-sided açıksa tek numaralı) sayfadan başlar.
#import "settings.typ": BLANK-LINE
#import "utils.typ": APPENDIX-STATE, single-spaced

// bib: bibliography("references.bib") — yol çağıran dosyaya göre çözülsün
// diye bibliography öğesi kullanıcı dosyasında oluşturulur.
#let references(bib) = {
  heading(level: 1, numbering: none)[KAYNAKLAR]
  set par(first-line-indent: 0pt)
  // Kullanıcı stil/başlık vermeyi unutursa: IEEE "[1]" ve ikinci bir
  // "Kaynakça" başlığı çıkmasın. Açıkça verilen değerler yine geçerlidir.
  set bibliography(style: "apa", title: none)
  // Kurala göre "her eser arasında birer satır boşluk".
  show bibliography: set par(spacing: BLANK-LINE)
  bib
}

#let appendices(body) = {
  heading(level: 1, numbering: none)[EKLER]
  // Ekteki şekil/tablo/eşitlikler "E.1" diye numaralanır.
  APPENDIX-STATE.update(true)
  body
}

#let _bordered-table(headers, rows) = single-spaced(table(
  columns: (auto,) + (1fr,) * (headers.len() - 1),
  stroke: 0.5pt,
  inset: (x: 0.8em, y: 0.5em),
  table.header(..headers.map(strong)),
  ..rows.flatten(),
))

// education: (("Lisans", "Bölüm", "Üniversite", "2020"), ...)
// positions: (("Arş. Gör.", "Mersin Üniversitesi", "2021-"), ...)
// publications: ([Makale künyesi], ...)
#let cv(
  name: none,
  birth-date: none,
  email: none,
  education: (("Lisans", "", "", ""), ("Yüksek Lisans", "", "", ""), ("Doktora", "", "", "")),
  positions: (("", "", ""),),
  publications: (),
) = {
  heading(level: 1, numbering: none)[ÖZGEÇMİŞ]
  set par(first-line-indent: 0pt)
  single-spaced(grid(
    columns: 3,
    column-gutter: 0.6em,
    row-gutter: 1.2em,
    [*Adı ve Soyadı*], [:], name,
    [*Doğum Tarihi*], [:], birth-date,
    [*E-mail*], [:], email,
    [*Öğrenim Durumu*], [:], [],
  ))
  v(BLANK-LINE / 2)
  _bordered-table(([Derece], [Bölüm/Program], [Üniversite], [Yıl]), education)
  v(BLANK-LINE / 2)
  [*Görevler:*]
  _bordered-table(([Görev Unvanı], [Görev Yeri], [Yıl]), positions)
  v(BLANK-LINE / 2)
  [*ESERLER*]
  enum(numbering: n => strong[#n.], ..publications)
}
