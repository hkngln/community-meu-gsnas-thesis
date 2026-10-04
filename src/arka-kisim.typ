// Kaynaklar, ekler ve özgeçmiş. Ana metinden sonra kullanılır; başlıklar
// numarasızdır, yeni (ve tek-sayfa-basla açıksa tek numaralı) sayfadan başlar.
#import "ayarlar.typ": BOS-SATIR
#import "yardimci.typ": EK-DURUMU, tek-aralik

// kaynakca: bibliography("kaynaklar.bib") — yol çağıran dosyaya göre çözülsün
// diye bibliography öğesi kullanıcı dosyasında oluşturulur.
#let kaynaklar(kaynakca) = {
  heading(level: 1, numbering: none)[KAYNAKLAR]
  set par(first-line-indent: 0pt)
  // Kullanıcı stil/başlık vermeyi unutursa: IEEE "[1]" ve ikinci bir
  // "Kaynakça" başlığı çıkmasın. Açıkça verilen değerler yine geçerlidir.
  set bibliography(style: "apa", title: none)
  // Kurala göre "her eser arasında birer satır boşluk".
  show bibliography: set par(spacing: BOS-SATIR)
  kaynakca
}

#let ekler(govde) = {
  heading(level: 1, numbering: none)[EKLER]
  // Ekteki şekil/tablo/eşitlikler "E.1" diye numaralanır.
  EK-DURUMU.update(true)
  govde
}

#let _cerceveli-tablo(basliklar, satirlar) = tek-aralik(table(
  columns: (auto,) + (1fr,) * (basliklar.len() - 1),
  stroke: 0.5pt,
  inset: (x: 0.8em, y: 0.5em),
  table.header(..basliklar.map(strong)),
  ..satirlar.flatten(),
))

// ogrenim: (("Lisans", "Bölüm", "Üniversite", "2020"), ...)
// gorevler: (("Arş. Gör.", "Mersin Üniversitesi", "2021-"), ...)
// eserler: ([Makale künyesi], ...)
#let ozgecmis(
  ad-soyad: none,
  dogum-tarihi: none,
  eposta: none,
  ogrenim: (("Lisans", "", "", ""), ("Yüksek Lisans", "", "", ""), ("Doktora", "", "", "")),
  gorevler: (("", "", ""),),
  eserler: (),
) = {
  heading(level: 1, numbering: none)[ÖZGEÇMİŞ]
  set par(first-line-indent: 0pt)
  tek-aralik(grid(
    columns: 3,
    column-gutter: 0.6em,
    row-gutter: 1.2em,
    [*Adı ve Soyadı*], [:], ad-soyad,
    [*Doğum Tarihi*], [:], dogum-tarihi,
    [*E-mail*], [:], eposta,
    [*Öğrenim Durumu*], [:], [],
  ))
  v(BOS-SATIR / 2)
  _cerceveli-tablo(([Derece], [Bölüm/Program], [Üniversite], [Yıl]), ogrenim)
  v(BOS-SATIR / 2)
  [*Görevler:*]
  _cerceveli-tablo(([Görev Unvanı], [Görev Yeri], [Yıl]), gorevler)
  v(BOS-SATIR / 2)
  [*ESERLER*]
  enum(numbering: n => strong[#n.], ..eserler)
}
