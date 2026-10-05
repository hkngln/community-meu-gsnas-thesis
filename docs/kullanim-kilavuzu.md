# Kullanım Kılavuzu

Bu kılavuz şablonun bütün ayarlarını ve fonksiyonlarını Türkçe karşılıklarıyla anlatır.

Şablonun kodundaki adlar **İngilizcedir**; böylece Typst'ün kendi adlarıyla (`figure`, `table`, `heading`…) uyumlu ve herkes için okunaklı olur. **PDF'e basılan her şey Türkçedir:** başlıklar (ÖZET, ONAY, KAYNAKLAR…), etiketler (Tablo, Şekil, Tanım…) ve kapak metinleri enstitünün yazım kurallarına uygun şekilde Türkçe kalır.

Kurulum için [README](../README.md#kurulum) dosyasına bakın.

## İçindekiler

- [Hızlı başlangıç](#hızlı-başlangıç)
- [Tez ayarları: `thesis`](#tez-ayarları-thesis)
- [Değerler](#değerler)
- [Fonksiyonlar](#fonksiyonlar)
- [Matematik ortamları](#matematik-ortamları)
- [Dosya ve klasör adları](#dosya-ve-klasör-adları)
- [Yazım örnekleri](#yazım-örnekleri)
- [v0.1.x'ten geçiş](#v01xten-geçiş)

## Hızlı başlangıç

```typ
#import "@local/meu-fbe-tez:0.2.0": *

#show: thesis.with(
  title: "Tezin Başlığı",
  degree: "master",                 // Yüksek Lisans
  student: "Adı SOYADI",
  advisor: (name: "Prof. Dr. Adı SOYADI", orcid: "0000-0000-0000-0000"),
  jury: ("Prof. Dr. Adı SOYADI", "Doç. Dr. Üye BİR", "Dr. Öğr. Üyesi Üye İKİ"),
  year: 2026,
)

= GİRİŞ

Tez metni buraya yazılır.
```

Doldurulmamış her alan PDF'te **kırmızı** görünür.

## Tez ayarları: `thesis`

`#show: thesis.with(...)` içine yazılan ayarlar. Hepsi isteğe bağlıdır; verilmeyen alan kırmızı yer tutucu olarak görünür.

### Kapak ve kişiler

| Ayar (İngilizce) | Türkçe karşılığı | Örnek | Nerede görünür |
|---|---|---|---|
| `title` | Tezin başlığı | `"Kompozit Malzemelerin…"` | Kapaklar, ONAY, ÖZET |
| `title-en` | Tezin İngilizce başlığı | `"Composite Materials…"` | ABSTRACT |
| `degree` | Tez türü | `"master"` / `"phd"` | Kapaklar, ONAY, üst bilgi |
| `student` | Öğrencinin adı soyadı | `"Ayşe YILMAZ"` | Kapaklar, ONAY, etik beyan, üst bilgi |
| `orcid` | Öğrencinin ORCID numarası | `"0000-0000-0000-0000"` | İç kapak |
| `department` | Anabilim dalı | `"Elektrik-Elektronik Mühendisliği"` | Kapaklar, ÖZET |
| `department-en` | Anabilim dalının İngilizcesi | `"Electrical and Electronics Engineering"` | ABSTRACT |
| `advisor` | Danışman: `(name: …, orcid: …)` | `(name: "Prof. Dr. Ali VELİ", orcid: "…")` | İç kapak, ONAY, ÖZET, ABSTRACT |
| `co-advisor` | İkinci danışman: `(name: …, orcid: …)` | `(name: "Doç. Dr. …", orcid: none)` | İç kapak ("2. DANIŞMAN") |
| `jury` | Jüri üyeleri (danışman dahil, ilk isim başkan, en fazla 5) | `("Prof. Dr. …", "Doç. Dr. …")` | İç kapak, ONAY |
| `date` | Kapaktaki ay ve yıl | `"OCAK - 2026"` | Kapaklar |
| `year` | Üst bilgideki yıl | `2026` | Üst bilgi |

### Onay ve etik beyan

| Ayar (İngilizce) | Türkçe karşılığı | Örnek |
|---|---|---|
| `defense-date` | Tez savunma tarihi | `"15/01/2026"` |
| `decision` | Jüri kararı | `"unanimous"` (oybirliği) / `"majority"` (oyçokluğu) |
| `institute-director` | Enstitü müdürü | `"Prof. Dr. Birgül ÖZDEMİR"` (varsayılan) |

### Ön kısım içerikleri

| Ayar (İngilizce) | Türkçe karşılığı | Örnek |
|---|---|---|
| `abstract-tr` | Özet (Türkçe) | `include "front/abstract-tr.typ"` |
| `keywords-tr` | Anahtar kelimeler | `("Kelime1", "Kelime2")` |
| `abstract-en` | Abstract (İngilizce) | `include "front/abstract-en.typ"` |
| `keywords-en` | Keywords | `("Keyword1", "Keyword2")` |
| `acknowledgements` | Teşekkür | `include "front/acknowledgements.typ"` |
| `abbreviations` | Simgeler ve kısaltmalar: `(kısaltma, tanım)` çiftleri | `(("MEÜ", "Mersin Üniversitesi"),)` |

### Baskı

| Ayar (İngilizce) | Türkçe karşılığı | Varsayılan | Açıklama |
|---|---|---|---|
| `two-sided` | Çift taraflı baskı | `true` | Bölümler tek numaralı (sağ) sayfadan başlar; gerekirse araya numarasız boş sayfa eklenir. `false`: tek taraflı, boş sayfa yok. |
| `front-cover` | Dış ön kapak (EK-5) | `true` | Logolu dış kapak; sayfa numarasına dahil değildir. |
| `back-cover` | Arka kapak (EK-6) | `true` | YÖK Tez Merkezi'ne yüklenen PDF'te bulunmalıdır. |

## Değerler

Bazı ayarlar sabit değerler alır. PDF'e Türkçe karşılıkları basılır.

| Ayar | Değer | PDF'e basılan |
|---|---|---|
| `degree` | `"master"` | YÜKSEK LİSANS TEZİ / Yüksek Lisans |
| `degree` | `"phd"` | DOKTORA TEZİ / Doktora |
| `decision` | `"unanimous"` | oybirliği |
| `decision` | `"majority"` | oyçokluğu |

## Fonksiyonlar

`main.typ` içinde, bölümlerden sonra kullanılır.

| Fonksiyon (İngilizce) | Türkçe karşılığı | Basılan başlık |
|---|---|---|
| `#references(bibliography("references.bib"))` | Kaynaklar | KAYNAKLAR |
| `#appendices[...]` | Ekler | EKLER |
| `#cv(...)` | Özgeçmiş | ÖZGEÇMİŞ |

`cv` ayarları:

| Ayar (İngilizce) | Türkçe karşılığı | Örnek |
|---|---|---|
| `name` | Adı ve soyadı | `"Ayşe YILMAZ"` |
| `birth-date` | Doğum tarihi | `"01.01.2000"` |
| `email` | E-posta | `"ayse@ornek.com"` |
| `education` | Öğrenim durumu: (derece, bölüm/program, üniversite, yıl) | `(("Lisans", "Fizik", "Mersin Üniversitesi", "2022"),)` |
| `positions` | Görevler: (görev unvanı, görev yeri, yıl) | `(("Arş. Gör.", "Mersin Üniversitesi", "2023-"),)` |
| `publications` | Eserler | `([Makale künyesi], [Bildiri künyesi])` |

## Matematik ortamları

Hepsi tek sayaç paylaşır ve alt bölüme göre numaralanır (Tanım 2.1.1, Teorem 2.1.2…). Bir bölüm dosyasında kullanmak için dosyanın başına ekleyin:

```typ
#import "@local/meu-fbe-tez:0.2.0": definition, theorem, proof
```

| Fonksiyon (İngilizce) | PDF'e basılan |
|---|---|
| `#definition[...]` | Tanım |
| `#theorem[...]` | Teorem |
| `#lemma[...]` | Lemma |
| `#proposition[...]` | Önerme |
| `#corollary[...]` | Sonuç |
| `#example[...]` | Örnek |
| `#remark[...]` | Uyarı |
| `#note[...]` | Not |
| `#proof[...]` | _Kanıt._ (sonunda □) |

Ortamlara başlık verilebilir ve etiketle atıf yapılabilir:

```typ
#theorem(title: "Süreklilik")[Her türevlenebilir fonksiyon süreklidir.] <thm-sureklilik>

@thm-sureklilik ile verilen sonuç...   // → Teorem 2.1.1
```

Yeni bir ortam tanımlamak için: `#let hipotez = theorem-env[Hipotez]`.

## Dosya ve klasör adları

`typst init` ile oluşan tez klasörü:

| Dosya / klasör | Türkçe karşılığı | İçerik |
|---|---|---|
| `main.typ` | Ana dosya | Tez ayarları, bölümlerin eklenmesi, kaynaklar, ekler, özgeçmiş |
| `front/abstract-tr.typ` | Özet | Türkçe özet metni |
| `front/abstract-en.typ` | Abstract | İngilizce özet metni |
| `front/acknowledgements.typ` | Teşekkür | Teşekkür metni |
| `chapters/` | Bölümler | Her bölüm ayrı dosyada |
| `chapters/01-introduction.typ` | Giriş | 1. GİRİŞ |
| `chapters/02-literature-review.typ` | Kaynak araştırmaları | 2. KAYNAK ARAŞTIRMALARI |
| `chapters/03-materials-methods.typ` | Materyal ve yöntem | 3. MATERYAL VE YÖNTEM |
| `chapters/04-results-discussion.typ` | Bulgular ve tartışma | 4. BULGULAR VE TARTIŞMA |
| `chapters/05-conclusions.typ` | Sonuçlar ve öneriler | 5. SONUÇLAR VE ÖNERİLER |
| `figures/` | Şekiller | Görseller |
| `references.bib` | Kaynaklar | BibTeX kayıtları |

Dosya adlarını değiştirmek serbesttir; `main.typ` içindeki `#include` satırlarını da güncelleyin. Bölüm başlıkları dosya adından değil, dosyanın içindeki `= BAŞLIK` satırından gelir.

## Yazım örnekleri

| Gerekli | Yazım | Sonuç |
|---|---|---|
| Bölüm ve alt başlıklar | `=`, `==`, `===`, `====` | 1., 2.1., 2.1.1., 2.1.1.1. |
| Tablo (başlık üstte) | `#figure(table(..), caption: [..]) <tbl-ornek>` | **Tablo 2.1.** |
| Şekil | `#figure(image("../figures/a.png"), caption: [..]) <fig-ornek>` | **Şekil 2.1.** |
| Numaralı eşitlik | `$ F = sigma dot A $ <eq-kuvvet>` | (2.1) |
| Eşitliğe atıf | `@eq-kuvvet` | Eşitlik (2.1) |
| Kaynağa atıf | `@grady2019` | (Grady vd., 2019) |
| Metin içi atıf | `#cite(<grady2019>, form: "prose")` | Grady vd. (2019) |
| Dipnot | `#footnote[..]` | \*, †, ‡ (her sayfada yeniden başlar) |

Etiket adları (`<tbl-ornek>` gibi) serbesttir; `tbl-`, `fig-`, `eq-` önekleri yalnızca okunaklılık içindir.

## v0.1.x'ten geçiş

v0.2.0 ile bütün adlar İngilizceye çevrildi. PDF çıktısı değişmedi. Eski bir tezi taşımak için `main.typ` dosyasındaki adları aşağıdaki tabloya göre değiştirin ve import satırını `@local/meu-fbe-tez:0.2.0` yapın. Eski sürümü kullanmaya devam etmek de mümkündür; o sürümün klasörü kurulu kaldığı sürece eski tezler derlenmeye devam eder.

| v0.1.x (Türkçe) | v0.2.0 (İngilizce) |
|---|---|
| `tez` | `thesis` |
| `baslik` / `baslik-en` | `title` / `title-en` |
| `tur: "yl"` / `tur: "dr"` | `degree: "master"` / `degree: "phd"` |
| `ogrenci` | `student` |
| `anabilim-dali` / `department` | `department` / `department-en` |
| `danisman: (ad: …)` | `advisor: (name: …)` |
| `ikinci-danisman: (ad: …)` | `co-advisor: (name: …)` |
| `juri` | `jury` |
| `tarih` / `yil` | `date` / `year` |
| `dis-kapak` / `arka-kapak` | `front-cover` / `back-cover` |
| `savunma-tarihi` | `defense-date` |
| `karar: "oybirliği"` / `"oyçokluğu"` | `decision: "unanimous"` / `"majority"` |
| `enstitu-muduru` | `institute-director` |
| `ozet` / `anahtar-kelimeler` | `abstract-tr` / `keywords-tr` |
| `abstract` / `keywords` | `abstract-en` / `keywords-en` |
| `tesekkur` | `acknowledgements` |
| `kisaltmalar` | `abbreviations` |
| `tek-sayfa-basla` | `two-sided` |
| `#kaynaklar(...)` | `#references(...)` |
| `#ekler[...]` | `#appendices[...]` |
| `#ozgecmis(ad-soyad, dogum-tarihi, eposta, ogrenim, gorevler, eserler)` | `#cv(name, birth-date, email, education, positions, publications)` |
| `#tanim`, `#teorem`, `#ornek`, `#onerme` | `#definition`, `#theorem`, `#example`, `#proposition` |
| `#uyari`, `#nott`, `#sonuc`, `#kanit` | `#remark`, `#note`, `#corollary`, `#proof` |
| `teorem-ortami` | `theorem-env` |
| ortam başlığı `baslik:` | `title:` |
