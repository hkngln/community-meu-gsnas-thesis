# meu-fbe-tez

[![CI](https://github.com/hkngln/meu-fbe-tez/actions/workflows/ci.yml/badge.svg?branch=dev)](https://github.com/hkngln/meu-fbe-tez/actions/workflows/ci.yml)
[![Sürüm](https://img.shields.io/github/v/release/hkngln/meu-fbe-tez)](https://github.com/hkngln/meu-fbe-tez/releases/latest)

Mersin Üniversitesi Fen Bilimleri Enstitüsü yüksek lisans ve doktora tezleri için [Typst](https://typst.app) şablonu.

Şablon enstitünün resmi belgelerinden üretildi:
- Tez yazım şablonu `Ornek_Tez_Yazim_Sablonu_20250911.docx`
- Dış ön kapak (EK-5) ve arka kapak (EK-6)
- LaTeX şablonu v1.4

![Önizleme: dış kapak, iç kapak ve bir bölüm sayfası](docs/onizleme.png)

> **Not:** Bu proje enstitünün resmi bir ürünü değildir. Logo ve görseller Mersin Üniversitesi'ne aittir ([Lisans](#lisans)). Tezinizi teslim etmeden önce güncel [tez yazım yönergesini](https://www.mersin.edu.tr) kontrol edin. Bir kuralın uymadığını fark ederseniz [issue açın](https://github.com/hkngln/meu-fbe-tez/issues).

## Özellikler

- Dış ön kapak, iç kapak, onay, etik beyan, özet, abstract, teşekkür, içindekiler, tablolar ve şekiller dizini, simgeler, kaynaklar, ekler, özgeçmiş ve arka kapak.
- Ölçüler Word şablonuyla aynı:
  - A4 kâğıt, 2,5 cm kenar boşluğu, Times New Roman 11 pt.
  - Satır aralığı Word'ün 1,5'iyle birebir aynı; ön kısım, tablolar ve şekiller tek satır aralıklı.
  - 1,25 cm paragraf girintisi.
- Ana bölümler, kaynaklar, ekler ve özgeçmiş yeni ve tek numaralı sayfadan başlar. Araya giren boş sayfalarda üst bilgi ve sayfa numarası basılmaz.
- Şekil, tablo ve eşitlikler bölüme göre numaralanır (**Tablo 2.1.**, **Şekil 2.1.**, (2.1)). Eklerde numaralar "E.1" olur.
- APA 7 atıflar Türkçe "vd." ile çıkar. Dipnotlar \*, †, ‡ işaretleriyle her sayfada yeniden başlar.
- Doldurulmamış her alan PDF'te **kırmızı** görünür.

## Kurulum

### 1. Typst'ü kurun

[Typst](https://typst.app), LaTeX'e benzer ama çok daha hızlı derlenen ve öğrenmesi kolay bir dizgi sistemidir. Bu şablon için **Typst 0.15 veya üstü** gerekir.

| Sistem | Komut |
|---|---|
| macOS ([Homebrew](https://formulae.brew.sh/formula/typst)) | `brew install typst` |
| Windows | `winget install --id Typst.Typst` |
| Linux / diğer | [GitHub sürümler sayfasından](https://github.com/typst/typst/releases/latest) indirin ya da `cargo install --locked typst-cli` |

Kurulumu doğrulayın:

```sh
typst --version   # typst 0.15.x
```

Typst'ü yeni tanıyorsanız [resmi eğitim](https://typst.app/docs/tutorial) ve [belgeler](https://typst.app/docs) iyi bir başlangıçtır.

> **Web uygulaması hakkında:** [typst.app](https://typst.app) web editörü bilgisayara kurulan yerel paketleri göremez. Bu şablon bu yüzden şimdilik bilgisayara kurulan Typst ile kullanılır.

### 2. Editör ve eklenti kurun (önerilir)

Typst dosyaları düz metindir; her editörde yazılabilir. Rahat çalışmak için bir editör ve [Tinymist](https://github.com/Myriad-Dreamin/tinymist) eklentisi önerilir. Tinymist yazdıkça güncellenen PDF önizleme, otomatik tamamlama ve satır üstünde hata gösterimi sağlar.

**Önerilen: [Visual Studio Code](https://code.visualstudio.com/download) + [Tinymist](https://marketplace.visualstudio.com/items?itemName=myriad-dreamin.tinymist)**
- Ücretsizdir; Windows, macOS ve Linux'ta çalışır.
- Typst'e yeni başlayanlar için en kolay kurulum budur.
- VS Code'u kurun. Eklentiler panelinde (`Ctrl/Cmd+Shift+X`) "Tinymist" aratıp kurun.

Diğer seçenekler:

| Editör | Typst desteği |
|---|---|
| [VSCodium](https://vscodium.com), Cursor ve diğer VS Code türevleri | Tinymist, [Open VSX](https://open-vsx.org/extension/myriad-dreamin/tinymist) üzerinden |
| [Zed](https://zed.dev) | [Typst eklentisi](https://zed.dev/extensions/typst) |
| Neovim, Helix, Emacs ve diğerleri | [Tinymist kurulum belgeleri](https://myriad-dreamin.github.io/tinymist/) |

### 3. Times New Roman fontu

Windows ve macOS'ta hazır gelir. Linux'ta `ttf-mscorefonts-installer` paketiyle kurulur. `typst fonts` komutunun çıktısında "Times New Roman" görünmelidir.

### 4. Şablonu kurun

Paketi Typst'ün yerel paket dizinine klonlayın. Dizin adı sürüm numarasıyla aynı olmalı.

```sh
# macOS
git clone --branch v0.1.1 https://github.com/hkngln/meu-fbe-tez \
  "$HOME/Library/Application Support/typst/packages/local/meu-fbe-tez/0.1.1"

# Linux
git clone --branch v0.1.1 https://github.com/hkngln/meu-fbe-tez \
  "$HOME/.local/share/typst/packages/local/meu-fbe-tez/0.1.1"
```

```powershell
# Windows (PowerShell)
git clone --branch v0.1.1 https://github.com/hkngln/meu-fbe-tez `
  "$env:APPDATA\typst\packages\local\meu-fbe-tez\0.1.1"
```

En güncel sürüm numarası [Releases](https://github.com/hkngln/meu-fbe-tez/releases) sayfasında.

## Yeni tez başlatma

```sh
typst init @local/meu-fbe-tez:0.1.1 tezim
cd tezim
typst watch main.typ
```

VS Code'da çalışmak için `tezim` klasörünü açın, `main.typ` dosyasını açın ve komut paletinden (`Ctrl/Cmd+Shift+P`) **Typst Preview: Preview Opened File** komutunu çalıştırın. Yazdıkça PDF önizlemesi güncellenir.

`main.typ` içindeki bilgileri doldurun. Bölümleri `bolumler/` altındaki dosyalara yazın.

| Dosya | İçerik |
|---|---|
| `main.typ` | Kapak ve onay bilgileri, bölümlerin eklenmesi, kaynaklar, özgeçmiş |
| `on/ozet.typ`, `on/abstract.typ`, `on/tesekkur.typ` | Ön kısım metinleri |
| `bolumler/*.typ` | Her bölüm ayrı dosyada; `= BAŞLIK` yeni ve tek numaralı sayfadan başlar |
| `kaynaklar.bib` | BibTeX kaynakları; metin içinde `@anahtar` → (Yazar vd., 2019) |
| `sekiller/` | Görseller |

## Yazım kısa yolları

| Gerekli | Yazım |
|---|---|
| Bölüm ve alt başlıklar | `=`, `==`, `===`, `====` → 1., 2.1., 2.1.1., 2.1.1.1. |
| Tablo (başlık üstte) | `#figure(table(..), caption: [..]) <tbl-x>` → **Tablo 2.1.** |
| Şekil | `#figure(image("../sekiller/a.png"), caption: [..]) <sekil-x>` → **Şekil 2.1.** |
| Numaralı eşitlik | `$ F = sigma dot A $ <esitlik-x>` → (2.1); `@esitlik-x` → Eşitlik (2.1) |
| Atıf | `@grady2019` → (Grady vd., 2019); `#cite(<grady2019>, form: "prose")` → Grady vd. (2019) |
| Dipnot | `#footnote[..]` → \*, †, ‡ |
| Matematik ortamları | `#tanim[..]`, `#teorem[..]`, `#lemma[..]`, `#ornek[..]`, `#onerme[..]`, `#uyari[..]`, `#nott[..]`, `#sonuc[..]`, `#kanit[..]` → Tanım 2.1.1 |

Bir bölüm dosyasında matematik ortamlarını kullanmak için dosyanın başına şunu ekleyin: `#import "@local/meu-fbe-tez:0.1.1": tanim, teorem, kanit`.

## Ayarlar

| Ayar | Açıklama |
|---|---|
| `tur` | `"yl"` (Yüksek Lisans) veya `"dr"` (Doktora). Kapak, onay ve üst bilgi buna göre değişir. |
| `juri` | ONAY sayfasındaki tam jüri, danışman dahil. İlk isim jüri başkanıdır; en fazla 5 kişi. Kapakta danışman jüri satırlarında tekrar edilmez. |
| `ikinci-danisman` | `(ad: .., orcid: ..)`. Kapağa "2. DANIŞMAN" olarak eklenir. |
| `dis-kapak`, `arka-kapak` | Logolu dış kapaklar (varsayılan `true`). Sayfa numarasına dahil değildir; iç kapak "i" olur. YÖK Tez Merkezi'ne yüklenen PDF'te arka kapak bulunmalıdır. |
| `tek-sayfa-basla` | `true` (varsayılan): çift taraflı baskı. Bölümler sağ sayfadan başlar, gerekirse araya boş sayfa eklenir; dış kapağın arkası da boş kalır. `false`: tek taraflı baskı, boş sayfa eklenmez. |
| `enstitu-muduru` | ONAY sayfasındaki imza. Varsayılan değeri `src/ayarlar.typ` dosyasında. |

Ek yoksa `#ekler[..]` satırını silin. Hiç tablo ya da şekil yoksa ilgili dizin sayfası basılmaz.

## Katkı

Dal yapısı, commit kuralları ve sürüm akışı [CONTRIBUTING.md](CONTRIBUTING.md) dosyasında.

## Lisans

Kod [MIT](LICENSE) lisanslıdır.

**Logo ve görseller Mersin Üniversitesi'ne aittir:**
- Mersin Üniversitesi logosu.
- `assets/` klasöründeki dış kapak görselleri.
- `template/sekiller/` klasöründeki örnek fotoğraflar.

Bu görseller enstitünün resmi tez şablonundan alınmıştır. Yalnızca resmi tasarımı uygulamak için kullanılırlar ve MIT lisansının kapsamında değildirler.
