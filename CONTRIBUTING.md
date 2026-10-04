# Katkı Rehberi

Katkılarınız memnuniyetle karşılanır: hata bildirimi, yönergeye uymayan bir kural, yeni bir özellik ya da belge düzeltmesi. Büyük bir değişikliğe başlamadan önce bir [issue](https://github.com/hkngln/meu-fbe-tez/issues) açıp tartışmanız önerilir.

## Dal yapısı

```
feat/… fix/… docs/…  ──PR (squash)──▶  dev  ──PR (merge commit)──▶  main  ──▶  vX.Y.Z sürümü
```

- **`dev`** varsayılan ve geliştirme dalıdır. Bütün dallar `dev`'den açılır ve `dev`'e geri birleşir.
- **`main`** yalnızca yayınlanmış sürümleri içerir. `main`'e yalnızca `dev`'den PR açılabilir.
- `main` ve `dev`'e doğrudan push kapalıdır. Her değişiklik PR ile ve CI yeşilken birleşir.
- `main`'e birleşen her PR, `typst.toml` içindeki sürümü otomatik olarak yayınlar: `vX.Y.Z` etiketi ve örnek tez PDF'li bir GitHub Release oluşur.

### Dal adları

`dev`'e açılan PR'ların dal adı `<tür>/<kısa-ad>` biçiminde olmalıdır. Küçük harf, rakam, `.`, `_` ve `-` kullanılabilir. CI başka adları reddeder.

| Tür | Ne için |
|---|---|
| `feat/` | Yeni özellik |
| `fix/` | Hata düzeltme, yönergeye uyum |
| `docs/` | Belgeler |
| `refactor/` | Davranışı değiştirmeyen kod düzenlemesi |
| `test/` | Testler |
| `ci/` | CI ve workflow'lar |
| `chore/` | Bakım işleri |
| `perf/` | Performans |

Örnek: `fix/ek-numaralama`, `feat/ingilizce-tez`.

## Geliştirme akışı

1. `dev` dalından yeni bir dal açın:
   ```sh
   git switch dev && git pull
   git switch -c fix/kisa-aciklama
   ```
2. Değişikliği yapın ve testleri yerelde çalıştırın (aşağıya bakın).
3. Commit atın ve push edin. Ardından **`dev`'e** PR açın.
4. CI yeşil olunca PR **squash merge** ile birleştirilir.

## Commit mesajları

[Conventional Commits](https://www.conventionalcommits.org/) biçimi kullanılır:

```
<tür>: <kısa açıklama>

<isteğe bağlı ayrıntı>
```

Türler dal türleriyle aynıdır: `feat`, `fix`, `docs`, `refactor`, `test`, `ci`, `chore`, `perf`. Örnek: `fix: ekteki şekiller E.1 diye numaralansın`.

## Testler

```sh
bash tests/dogrula.sh
```

Gerekenler:
- Typst 0.15.1, `pdftotext` (poppler) ve Times New Roman fontu.
- Paket, [README > Kurulum](README.md#kurulum) bölümündeki dizine bağlı olmalı. Geliştirirken klonlamak yerine çalıştığınız klasöre symlink verebilirsiniz:
  ```sh
  ln -sfn "$PWD" "$HOME/Library/Application Support/typst/packages/local/meu-fbe-tez/0.1.0"
  ```

Betik şunları yapar:
- `template/main.typ`, `tests/kenar-durumlar.typ` ve `tests/tek-taraf.typ` dosyalarını derler. **Her uyarı hata sayılır.**
- PDF metnini denetler: sayfa sırası, numaralar, atıflar ve sürüm referansları.
- Çıktıları `tests/out/` klasörüne yazar.

Yeni bir davranış eklerken `tests/` altına bir durum ve `dogrula.sh` içine bir kontrol ekleyin. Görünümü etkileyen değişikliklerde PR'a önce/sonra ekran görüntüsü koyun.

## Sürüm yayınlama

Sürümler [SemVer](https://semver.org/lang/tr/)'e uyar:
- **Yama** (0.1.0 → 0.1.1): hata düzeltmeleri.
- **Küçük** (0.1.0 → 0.2.0): yeni özellikler.
- **Büyük** (0.1.0 → 1.0.0): `main.typ` dosyasında kullanıcının değişiklik yapmasını gerektiren değişiklikler.

Yayın adımları:

1. `dev` üzerinde bir `chore/surum-X.Y.Z` dalı açın.
2. Sürüm numarasını şu dosyaların hepsinde güncelleyin; CI biri unutulursa hata verir:
   - `typst.toml` → `version`
   - `template/main.typ` ve `template/bolumler/*.typ` → `@local/meu-fbe-tez:X.Y.Z`
   - `README.md` ve `lib.typ` → kurulum ve import örnekleri
3. Bu dalı PR ile `dev`'e birleştirin.
4. **`dev` → `main`** PR'ı açın. CI, sürümün daha önce yayınlanmadığını denetler.
5. PR'ı **merge commit** ile birleştirin; squash kullanmayın, yoksa `dev` ile `main` ayrışır.
6. `Sürüm` workflow'u `vX.Y.Z` etiketini ve Release'i otomatik oluşturur.

## Kurallarla ilgili değişiklikler

Bir kural yönergeye uymuyorsa issue'ya veya PR'a kaynağını ekleyin: yönergenin ilgili maddesi ya da enstitünün güncel şablonundan bir alıntı. Ölçüler `src/ayarlar.typ` dosyasında toplanmıştır; mümkünse yalnızca oradan değiştirin.
