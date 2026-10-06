// Kaynaklar, ekler ve özgeçmiş. Ana metinden sonra kullanılır; başlıklar
// numarasızdır, yeni (ve two-sided açıksa tek numaralı) sayfadan başlar.
#import "settings.typ": BLANK-LINE, PAR-INDENT
#import "utils.typ": APPENDIX-STATE, single-spaced

// bib: bibliography("references.bib") — yol çağıran dosyaya göre çözülsün
// diye bibliography öğesi kullanıcı dosyasında oluşturulur.
// Tezin diline göre APA stili (assets/csl/, CC BY-SA 3.0):
// tr: metin içi atıflarda iki yazar "ve" ile; en: "&" ile. İkisinde de kaynakça
// listesinde "&" kullanılır (docx örnekleriyle aynı).
#let _APA-STYLES = (tr: "../assets/csl/apa-tr.csl", en: "../assets/csl/apa-en.csl")

#let references(bib) = {
  heading(level: 1, numbering: none)[KAYNAKLAR]
  // Kurala göre "her eser arasında birer satır boşluk"; docx asılı girinti 1,25 cm.
  // Typst kaynakça kayıtlarını paragraf olarak üretmez (par ayarları uygulanmaz)
  // ve kendi asılı girintisini 1,5em'de sabitler. Bu yüzden CSL'de girinti
  // kapalıdır ve her kayıt bloğu burada asılı girintili bir paragrafa çevrilir.
  show bibliography: it => {
    show block: entry => par(
      hanging-indent: PAR-INDENT,
      first-line-indent: 0pt,
      justify: false,
      entry.body,
    )
    it
  }
  show bibliography: set par(spacing: BLANK-LINE)
  // CSL'nin büyük harf dönüşümü Türkçeyi bilmez: "in" terimi "Içinde" çıkar.
  show bibliography: it => { show "Içinde": "İçinde"; it }
  // Kullanıcı stil/başlık vermeyi unutursa: IEEE "[1]" ve ikinci bir
  // "Kaynakça" başlığı çıkmasın. Açıkça verilen değerler yine geçerlidir.
  context {
    let lang = if text.lang == "en" { "en" } else { "tr" }
    set bibliography(style: _APA-STYLES.at(lang), title: none)
    bib
  }
}

#let appendices(body) = {
  heading(level: 1, numbering: none)[EKLER]
  // Ekteki şekil/tablo/eşitlik/teoremler "E.1" diye numaralanır. Ekteki alt
  // başlıklar (ör. == EK-1: ...) numarasızdır; son bölümün numarasını almazlar.
  APPENDIX-STATE.update(true)
  set heading(numbering: none)
  body
}

#let _bordered-table(headers, rows) = single-spaced(table(
  columns: (auto,) + (1fr,) * (headers.len() - 1),
  stroke: 0.5pt,
  inset: (x: 0.8em, y: 0.5em),
  // Docx: özgeçmiş tablo başlıkları ortalı.
  table.header(..headers.map(h => table.cell(align: center, strong(h)))),
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
