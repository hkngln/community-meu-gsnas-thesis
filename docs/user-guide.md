# User Guide

🇬🇧 **English** | [🇹🇷 Türkçe](kullanim-kilavuzu.md)

This guide describes every setting and function of the template, with its Turkish equivalent.

The template's code uses **English** names, consistent with Typst's own names (`figure`, `table`, `heading`…) and readable for everyone. **Everything printed in the PDF is Turkish:** headings (ÖZET, ONAY, KAYNAKLAR…), labels (Tablo, Şekil, Tanım…) and cover texts stay in Turkish, as the institute's writing guidelines require.

For installation, see the [README](../README.md#installation).

## Contents

- [Quick start](#quick-start)
- [Thesis settings: `thesis`](#thesis-settings-thesis)
- [Values](#values)
- [Functions](#functions)
- [Math environments](#math-environments)
- [File and folder names](#file-and-folder-names)
- [Writing examples](#writing-examples)
- [Migrating from v0.1.x](#migrating-from-v01x)

## Quick start

```typ
#import "@local/community-meu-gsnas-thesis:0.3.0": *

#show: thesis.with(
  title: "Tezin Başlığı",
  degree: "master",                 // Yüksek Lisans (master's)
  student: "Adı SOYADI",
  advisor: (name: "Prof. Dr. Adı SOYADI", orcid: "0000-0000-0000-0000"),
  jury: ("Prof. Dr. Adı SOYADI", "Doç. Dr. Üye BİR", "Dr. Öğr. Üyesi Üye İKİ"),
  year: 2026,
)

= GİRİŞ

The thesis text goes here.
```

Every field you have not filled in shows up **in red** in the PDF.

## Thesis settings: `thesis`

Settings passed to `#show: thesis.with(...)`. All are optional; a missing value shows up as a red placeholder.

### Cover and people

| Setting | Turkish equivalent | Example | Appears on |
|---|---|---|---|
| `title` | Tezin başlığı (thesis title) | `"Kompozit Malzemelerin…"` | Covers, ONAY, ÖZET |
| `title-en` | Tezin İngilizce başlığı (English title) | `"Composite Materials…"` | ABSTRACT |
| `degree` | Tez türü (degree) | `"master"` / `"phd"` | Covers, ONAY, header |
| `student` | Öğrencinin adı soyadı (student name) | `"Ayşe YILMAZ"` | Covers, ONAY, ethics statement, header |
| `orcid` | Öğrencinin ORCID numarası | `"0000-0000-0000-0000"` | Title page |
| `department` | Anabilim dalı (department, in Turkish) | `"Elektrik-Elektronik Mühendisliği"` | Covers, ÖZET |
| `department-en` | Anabilim dalının İngilizcesi | `"Electrical and Electronics Engineering"` | ABSTRACT |
| `advisor` | Danışman: `(name: …, orcid: …)` | `(name: "Prof. Dr. Ali VELİ", orcid: "…")` | Title page, ONAY, ÖZET, ABSTRACT |
| `co-advisor` | İkinci danışman: `(name: …, orcid: …)` | `(name: "Doç. Dr. …", orcid: none)` | Title page ("2. DANIŞMAN") |
| `jury` | Jüri üyeleri: committee incl. the advisor; first name is the chair; at most 5 | `("Prof. Dr. …", "Doç. Dr. …")` | Title page, ONAY |
| `date` | Month and year on the covers | `"OCAK - 2026"` | Covers |
| `year` | Year in the page header | `2026` | Header |

### Approval and ethics statement

| Setting | Turkish equivalent | Example |
|---|---|---|
| `defense-date` | Tez savunma tarihi (defense date) | `"15/01/2026"` |
| `decision` | Jüri kararı (committee decision) | `"unanimous"` (oybirliği) / `"majority"` (oyçokluğu) |
| `institute-director` | Enstitü müdürü (institute director) | `"Prof. Dr. Birgül ÖZDEMİR"` (default) |

### Front matter contents

| Setting | Turkish equivalent | Example |
|---|---|---|
| `abstract-tr` | Özet (Turkish abstract) | `include "front/abstract-tr.typ"` |
| `keywords-tr` | Anahtar kelimeler | `("Kelime1", "Kelime2")` |
| `abstract-en` | Abstract (English) | `include "front/abstract-en.typ"` |
| `keywords-en` | Keywords | `("Keyword1", "Keyword2")` |
| `acknowledgements` | Teşekkür | `include "front/acknowledgements.typ"` |
| `abbreviations` | Simgeler ve kısaltmalar: `(abbreviation, meaning)` pairs | `(("MEÜ", "Mersin Üniversitesi"),)` |

### Printing

| Setting | Turkish equivalent | Default | Description |
|---|---|---|---|
| `two-sided` | Çift taraflı baskı | `true` | Chapters start on an odd (right-hand) page; unnumbered blank pages are inserted when needed. `false`: one-sided, no blank pages. |
| `front-cover` | Dış ön kapak (EK-5) | `true` | Outer cover with the logo; not counted in page numbering. |
| `back-cover` | Arka kapak (EK-6) | `true` | Must be included in the PDF uploaded to the YÖK Thesis Center. |
| `font` | Yazı tipi (font) | `("Times New Roman", "Libertinus Serif")` | The first installed font in the list is used. Libertinus Serif ships with Typst and is the fallback. Add `"TeX Gyre Termes"` if you installed it ([README](../README.md#3-font-times-new-roman)). Submit with Times New Roman. |

## Values

Some settings take fixed values. Their Turkish equivalents are printed in the PDF.

| Setting | Value | Printed in the PDF |
|---|---|---|
| `degree` | `"master"` | YÜKSEK LİSANS TEZİ / Yüksek Lisans |
| `degree` | `"phd"` | DOKTORA TEZİ / Doktora |
| `decision` | `"unanimous"` | oybirliği |
| `decision` | `"majority"` | oyçokluğu |

## Functions

Used in `main.typ`, after the chapters.

| Function | Turkish equivalent | Printed heading |
|---|---|---|
| `#references(bibliography("references.bib"))` | Kaynaklar (references) | KAYNAKLAR |
| `#appendices[...]` | Ekler (appendices) | EKLER. Write appendix sections as `== EK-1: Title` (unnumbered); figures, tables, equations and theorems inside are numbered E.1, E.2… |
| `#cv(...)` | Özgeçmiş (CV) | ÖZGEÇMİŞ |

`cv` settings:

| Setting | Turkish equivalent | Example |
|---|---|---|
| `name` | Adı ve soyadı | `"Ayşe YILMAZ"` |
| `birth-date` | Doğum tarihi | `"01.01.2000"` |
| `email` | E-posta | `"ayse@example.com"` |
| `education` | Öğrenim durumu: (degree, department/program, university, year) | `(("Lisans", "Fizik", "Mersin Üniversitesi", "2022"),)` |
| `positions` | Görevler: (position, institution, years) | `(("Arş. Gör.", "Mersin Üniversitesi", "2023-"),)` |
| `publications` | Eserler | `([Article citation], [Conference paper citation])` |

## Math environments

All share one counter and are numbered by section (Tanım 2.1.1, Teorem 2.1.2…). To use them in a chapter file, add at the top:

```typ
#import "@local/community-meu-gsnas-thesis:0.3.0": definition, theorem, proof
```

| Function | Printed in the PDF |
|---|---|
| `#definition[...]` | Tanım |
| `#theorem[...]` | Teorem |
| `#lemma[...]` | Lemma |
| `#proposition[...]` | Önerme |
| `#corollary[...]` | Sonuç |
| `#example[...]` | Örnek |
| `#remark[...]` | Uyarı |
| `#note[...]` | Not |
| `#proof[...]` | _Kanıt._ (ending with □) |

Environments can take a title and be referenced with a label:

```typ
#theorem(title: "Süreklilik")[Her türevlenebilir fonksiyon süreklidir.] <thm-continuity>

@thm-continuity ile verilen sonuç...   // → Teorem 2.1.1
```

To define a new environment: `#let hypothesis = theorem-env[Hipotez]`.

## File and folder names

The thesis folder created by `typst init`:

| File / folder | Turkish equivalent | Contents |
|---|---|---|
| `main.typ` | Ana dosya | Thesis settings, chapter includes, references, appendices, CV |
| `front/abstract-tr.typ` | Özet | Turkish abstract |
| `front/abstract-en.typ` | Abstract | English abstract |
| `front/acknowledgements.typ` | Teşekkür | Acknowledgements |
| `chapters/` | Bölümler | One file per chapter |
| `chapters/01-introduction.typ` | Giriş | 1. GİRİŞ |
| `chapters/02-literature-review.typ` | Kaynak araştırmaları | 2. KAYNAK ARAŞTIRMALARI |
| `chapters/03-materials-methods.typ` | Materyal ve yöntem | 3. MATERYAL VE YÖNTEM |
| `chapters/04-results-discussion.typ` | Bulgular ve tartışma | 4. BULGULAR VE TARTIŞMA |
| `chapters/05-conclusions.typ` | Sonuçlar ve öneriler | 5. SONUÇLAR VE ÖNERİLER |
| `figures/` | Şekiller | Images |
| `references.bib` | Kaynaklar | BibTeX entries |

You may rename these files; update the `#include` lines in `main.typ` accordingly. Chapter headings come from the `= HEADING` line inside each file, not from the file name.

## Writing examples

| What | How | Result |
|---|---|---|
| Chapters and sections | `=`, `==`, `===`, `====` | 1., 2.1., 2.1.1., 2.1.1.1. |
| Table (caption on top) | `#figure(table(..), caption: [..]) <tbl-example>` | **Tablo 2.1.** |
| Figure | `#figure(image("../figures/a.png"), caption: [..]) <fig-example>` | **Şekil 2.1.** |
| Numbered equation | `$ F = sigma dot A $ <eq-force>` | (2.1) |
| Equation reference | `@eq-force` | Eşitlik (2.1) |
| Citation | `@grady2019` | (Grady vd., 2019) |
| Narrative citation | `#cite(<grady2019>, form: "prose")` | Grady vd. (2019) |
| Footnote | `#footnote[..]` | \*, †, ‡ (restarts on every page) |

Label names (such as `<tbl-example>`) are free-form; the `tbl-`, `fig-` and `eq-` prefixes are only for readability.

## Migrating from v0.1.x

In v0.2.0 the package was renamed from `meu-fbe-tez` to `community-meu-gsnas-thesis` and all names became English. The renaming itself did not change the PDF output. To migrate an existing thesis, first install the package under its new name ([README > Installation](../README.md#installation)). Then change the import lines in `main.typ` and the chapter files to `@local/community-meu-gsnas-thesis:0.3.0` and rename the settings according to the table below. You can also keep using the old version: existing theses keep compiling as long as that version's folder stays installed.

| v0.1.x (Turkish) | v0.2.0 (English) |
|---|---|
| `#import "@local/meu-fbe-tez:0.1.1"` | `#import "@local/community-meu-gsnas-thesis:0.3.0"` |
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
| environment title `baslik:` | `title:` |
