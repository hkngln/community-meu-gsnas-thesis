#import "@local/community-meu-gsnas-thesis:0.3.0": *

// Kırmızı görünen her şey doldurulmamış alandır.
// Ayarların Türkçe karşılıkları: docs/kullanim-kilavuzu.md (English: docs/user-guide.md).
#show: thesis.with(
  title: "Tezin Başlığı",
  title-en: "Title of the Thesis",
  degree: "master", // "master" = Yüksek Lisans, "phd" = Doktora
  student: "Adı SOYADI",
  orcid: "0000-0000-0000-0000",
  department: "Elektrik-Elektronik Mühendisliği",
  department-en: "Electrical and Electronics Engineering",
  advisor: (name: "Prof. Dr. Adı SOYADI", orcid: "0000-0000-0000-0000"),
  // co-advisor: (name: "Doç. Dr. Adı SOYADI", orcid: "0000-0000-0000-0000"),
  // ONAY sayfasındaki tam jüri (danışman dahil); ilk üye jüri başkanıdır.
  // Kapakta danışman ayrıca yazıldığı için jüri satırlarında tekrar edilmez.
  // Kullanılmayan üyeleri silin.
  jury: (
    "Prof. Dr. Adı SOYADI",
    "Prof. Dr. Birinci ÜYE",
    "Doç. Dr. İkinci ÜYE",
    "Dr. Öğr. Üyesi Üçüncü ÜYE",
    "Dr. Öğr. Üyesi Dördüncü ÜYE",
  ),
  date: "OCAK - 2026",
  year: 2026,
  // Logolu dış ön/arka kapak (EK-5, EK-6). Basımda dış kapak ayrı
  // basılacaksa false yapın; YÖK'e yüklenen PDF'te arka kapak bulunmalıdır.
  front-cover: true,
  back-cover: true,
  defense-date: none, // "15/01/2026"
  decision: none, // "unanimous" = oybirliği, "majority" = oyçokluğu
  abstract-tr: include "front/abstract-tr.typ",
  keywords-tr: ("Kelime1", "Kelime2", "Kelime3", "Kelime4", "Kelime5"),
  abstract-en: include "front/abstract-en.typ",
  keywords-en: ("Keyword1", "Keyword2", "Keyword3", "Keyword4", "Keyword5"),
  acknowledgements: include "front/acknowledgements.typ",
  abbreviations: (
    ("T.C.", "Türkiye Cumhuriyeti"),
    ("YÖK", "Yükseköğretim Kurulu"),
    ("MEÜ", "Mersin Üniversitesi"),
    ("FBE", "Fen Bilimleri Enstitüsü"),
  ),
  // Tek taraflı baskı için false yapın.
  two-sided: true,
)

#include "chapters/01-introduction.typ"
#include "chapters/02-literature-review.typ"
#include "chapters/03-materials-methods.typ"
#include "chapters/04-results-discussion.typ"
#include "chapters/05-conclusions.typ"

#references(bibliography("references.bib", style: "apa", full: true, title: none))

// Ek yoksa aşağıdaki satırı silin.
#appendices[Ekler buraya yazılır.]

#cv(
  name: "Adı SOYADI",
  birth-date: "",
  email: "",
  education: (
    ("Lisans", "", "", ""),
    ("Yüksek Lisans", "", "", ""),
    ("Doktora", "", "", ""),
  ),
  positions: (("", "", ""),),
  publications: ([], [], []),
)
