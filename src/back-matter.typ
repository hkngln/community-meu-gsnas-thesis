// Kaynaklar, ekler ve özgeçmiş. Ana metinden sonra kullanılır; başlıklar
// numarasızdır, yeni (ve two-sided açıksa tek numaralı) sayfadan başlar.
#import "settings.typ": BLANK-LINE, PAR-INDENT
#import "utils.typ": APPENDIX-STATE, single-spaced

// bib: bibliography("references.bib") — yol çağıran dosyaya göre çözülsün
// diye bibliography öğesi kullanıcı dosyasında oluşturulur.
// MEÜ FBE kaynak gösterme stili (assets/csl/, CC BY-SA 3.0): APA 7 tabanlı,
// Tez Yazım Yönergesi (Madde 11, 16) ile uyumlu; tezin diline göre seçilir.
// tr: metin içi atıflarda "ve" / "vd."; en: "&" / "et al.". İkisinde de kaynakça
// listesinde "&" kullanılır (docx örnekleriyle aynı).
#let _STYLES = (tr: "../assets/csl/meu-fbe-tr.csl", en: "../assets/csl/meu-fbe-en.csl")

// Typst .bib türlerine sabit İngilizce tür adı verir (@phdthesis ->
// "Doctoral dissertation"); CSL bunları çeviremez. .bib'de `type` alanı
// verilirse o yazılır, bu tablo yalnızca varsayılan adları değiştirir. Yalnızca
// köşeli parantez ya da parantez içindeki tür açıklaması değişir; aynı sözcükler
// bir eserin başlığında geçerse olduğu gibi kalır.
#let _GENRES = (
  tr: (
    "[Doctoral dissertation": "[Doktora tezi",
    "[Master's thesis": "[Yüksek lisans tezi",
    "[Master’s thesis": "[Yüksek lisans tezi",
    "(technical report ": "(Rapor ",
    "(Technical report ": "(Rapor ",
    "(Technical Report ": "(Rapor ",
    "[Technical report": "[Rapor",
    // biblatex `type = {mathesis}` / `{phdthesis}` anahtar sözcükleri.
    "[Mathesis": "[Yüksek lisans tezi",
    "[Phdthesis": "[Doktora tezi",
  ),
  en: (
    "(Technical Report ": "(Report ",
    "(Technical report ": "(Report ",
    "[Technical report": "[Report",
    "[Mathesis": "[Master’s thesis",
    "[Phdthesis": "[Doctoral dissertation",
  ),
)
// Makale numarası (eLocator) sayfa alanında verilir: "13(3), e0193972." ->
// "13(3), Article e0193972." Yalnızca cilt/sayıdan hemen sonra gelen e+rakam.
#let _ARTICLE-LABEL = (tr: "Makale", en: "Article")

#let _localize-entries(lang, it) = {
  // Rapor/yayın numarası bir sayı aralığı değildir: "NASA/CR-2018-220043"
  // numarasındaki kısa çizgi uzun çizgiye (–) çevrilmesin. Numara ")" ya da
  // "; " ile biter.
  show regex("No\. [^);]*–[^);]*"): m => m.text.replace("–", "-")
  show regex("[\d)], e\d{4,}\."): m => {
    let (before, number) = m.text.split(", ")
    [#before, #_ARTICLE-LABEL.at(lang) #number]
  }
  // CSL'nin büyük harf dönüşümü Türkçeyi bilmez: "in" terimi "Içinde" çıkar.
  show "Içinde": "İçinde"
  _GENRES.at(lang).pairs().fold(it, (body, (from, to)) => {
    show from: to
    body
  })
}

#let references(bib) = {
  // Eski şablonlardaki bibliography(..., style: "apa") enstitü stilini ezer:
  // atıflarda "ve" yerine "&", tarih sırası yerine alfabetik sıra çıkar.
  assert(
    not bib.has("style"),
    message: "references(): bibliography(...) çağrısına style vermeyin; şablon enstitünün kaynak gösterme stilini kendisi kullanır. "
      + "Do not pass style to bibliography(...); the template uses the institute's citation style.",
  )
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
  // Başlığı şablon basar; bibliography ikinci bir "Kaynakça" başlığı basmasın.
  context {
    let lang = if text.lang == "en" { "en" } else { "tr" }
    show bibliography: _localize-entries.with(lang)
    set bibliography(style: _STYLES.at(lang), title: none)
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
