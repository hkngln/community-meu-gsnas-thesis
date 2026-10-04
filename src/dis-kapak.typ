// Dış kapaklar: EK_5-On_Kapak.docx ve EK_6-Arka_Kapak.docx.
// Sayfa sayısına dahil değildir (iç kapak "i" olarak kalır).
#import "ayarlar.typ": TEZ-TURLERI
#import "yardimci.typ": alan, buyuk-harf, tek-aralik

#let _ON-KAPAK-GORSELI = image("../assets/on-kapak.jpg", width: 100%, height: 100%)
#let _ARKA-KAPAK-GORSELI = image("../assets/arka-kapak.jpg", width: 100%, height: 100%)

// Docx'teki kenarlıksız tablonun satır yükseklikleri (twip). Oranlar korunur,
// toplam yükseklik metin alanına sığdırılır.
#let _SATIR-YUKSEKLIKLERI = (992, 2389, 2097, 1702, 1981, 1826, 1397, 1408)

#let _kapak-sayfasi(gorsel, icerik) = page(
  numbering: none,
  header: none,
  footer: none,
  background: gorsel,
  icerik,
)

#let on-kapak(baslik: none, tur: "yl", ogrenci: none, anabilim-dali: none, tarih: none) = _kapak-sayfasi(
  _ON-KAPAK-GORSELI,
  {
    set text(14pt, weight: "bold")
    tek-aralik(grid(
      columns: 1fr,
      rows: _SATIR-YUKSEKLIKLERI.map(h => h * 1fr),
      align: center + horizon,
      [],
      text(16pt, buyuk-harf(alan(baslik, "TEZİN BAŞLIĞI"))),
      TEZ-TURLERI.at(tur).kapak,
      buyuk-harf(alan(ogrenci, "ÖĞRENCİ ADI VE SOYADI")),
      [MERSİN ÜNİVERSİTESİ \ FEN BİLİMLERİ ENSTİTÜSÜ],
      [#buyuk-harf(alan(anabilim-dali, "...")) \ ANABİLİM DALI],
      [],
      [#underline[MERSİN] \ #buyuk-harf(alan(tarih, "AY - YIL"))],
    ))
  },
)

#let arka-kapak() = _kapak-sayfasi(_ARKA-KAPAK-GORSELI, [])

// Çift taraflı baskıda kapağın iç yüzü boş kalır; böylece iç kapak yine
// fiziksel tek sayfaya düşer ve bölümlerin tek sayfa hizası bozulmaz.
#let bos-sayfa() = page(numbering: none, header: none, footer: none, background: none, [])
