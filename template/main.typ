#import "@local/meu-fbe-tez:0.1.1": *

// Kırmızı görünen her şey doldurulmamış alandır.
#show: tez.with(
  baslik: "Tezin Başlığı",
  baslik-en: "Title of the Thesis",
  tur: "yl", // "yl" = Yüksek Lisans, "dr" = Doktora
  ogrenci: "Adı SOYADI",
  orcid: "0000-0000-0000-0000",
  anabilim-dali: "Elektrik-Elektronik Mühendisliği",
  department: "Electrical and Electronics Engineering",
  danisman: (ad: "Prof. Dr. Adı SOYADI", orcid: "0000-0000-0000-0000"),
  // ikinci-danisman: (ad: "Doç. Dr. Adı SOYADI", orcid: "0000-0000-0000-0000"),
  // ONAY sayfasındaki tam jüri (danışman dahil); ilk üye jüri başkanıdır.
  // Kapakta danışman ayrıca yazıldığı için jüri satırlarında tekrar edilmez.
  // Kullanılmayan üyeleri silin.
  juri: (
    "Prof. Dr. Adı SOYADI",
    "Prof. Dr. Birinci ÜYE",
    "Doç. Dr. İkinci ÜYE",
    "Dr. Öğr. Üyesi Üçüncü ÜYE",
    "Dr. Öğr. Üyesi Dördüncü ÜYE",
  ),
  tarih: "OCAK - 2026",
  // Logolu dış ön/arka kapak (EK-5, EK-6). Basımda dış kapak ayrı
  // basılacaksa false yapın; YÖK'e yüklenen PDF'te arka kapak bulunmalıdır.
  dis-kapak: true,
  arka-kapak: true,
  yil: 2026,
  savunma-tarihi: none, // "15/01/2026"
  karar: none, // "oybirliği" veya "oyçokluğu"
  ozet: include "on/ozet.typ",
  anahtar-kelimeler: ("Kelime1", "Kelime2", "Kelime3", "Kelime4", "Kelime5"),
  abstract: include "on/abstract.typ",
  keywords: ("Keyword1", "Keyword2", "Keyword3", "Keyword4", "Keyword5"),
  tesekkur: include "on/tesekkur.typ",
  kisaltmalar: (
    ("T.C.", "Türkiye Cumhuriyeti"),
    ("YÖK", "Yükseköğretim Kurulu"),
    ("MEÜ", "Mersin Üniversitesi"),
    ("FBE", "Fen Bilimleri Enstitüsü"),
  ),
  // Tek taraflı baskı için false yapın.
  tek-sayfa-basla: true,
)

#include "bolumler/01-giris.typ"
#include "bolumler/02-kaynak-arastirmalari.typ"
#include "bolumler/03-materyal-yontem.typ"
#include "bolumler/04-bulgular-tartisma.typ"
#include "bolumler/05-sonuclar-oneriler.typ"

#kaynaklar(bibliography("kaynaklar.bib", style: "apa", full: true, title: none))

// Ek yoksa aşağıdaki satırı silin.
#ekler[Ekler buraya yazılır.]

#ozgecmis(
  ad-soyad: "Adı SOYADI",
  dogum-tarihi: "",
  eposta: "",
  ogrenim: (
    ("Lisans", "", "", ""),
    ("Yüksek Lisans", "", "", ""),
    ("Doktora", "", "", ""),
  ),
  gorevler: (("", "", ""),),
  eserler: ([], [], []),
)
