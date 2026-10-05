# Contributing

🇬🇧 **English** | [🇹🇷 Türkçe](CONTRIBUTING.tr.md)

Contributions are welcome: bug reports, a rule that does not match the guidelines, new features or documentation fixes. Before starting a large change, please open an [issue](https://github.com/hkngln/community-meu-gsnas-thesis/issues) to discuss it.

## Branching model

```
feat/… fix/… docs/…  ──PR (squash)──▶  dev  ──PR (merge commit)──▶  main  ──▶  vX.Y.Z release
```

- **`dev`** is the default and development branch. Every branch starts from `dev` and merges back into `dev`.
- **`main`** contains released versions only. Pull requests into `main` may only come from `dev`.
- Direct pushes to `main` and `dev` are blocked. Every change is merged through a PR with green CI.
- Every PR merged into `main` releases the version in `typst.toml` automatically: a `vX.Y.Z` tag and a GitHub Release with the example thesis PDF.

### Branch names

Branches for PRs into `dev` must be named `<type>/<short-name>`, using lowercase letters, digits, `.`, `_` and `-`. CI rejects other names.

| Type | Used for |
|---|---|
| `feat/` | New feature |
| `fix/` | Bug fix, compliance with the guidelines |
| `docs/` | Documentation |
| `refactor/` | Code changes that do not change behavior |
| `test/` | Tests |
| `ci/` | CI and workflows |
| `chore/` | Maintenance |
| `perf/` | Performance |

Example: `fix/appendix-numbering`, `feat/english-thesis`.

## Development workflow

1. Create a branch from `dev`:
   ```sh
   git switch dev && git pull
   git switch -c fix/short-description
   ```
2. Make your change and run the tests locally (see below).
3. Commit, push and open a PR **into `dev`**.
4. Once CI is green, the PR is merged with **squash merge**.

## Commit messages

We use [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>: <short description>

<optional details>
```

The types are the same as the branch types: `feat`, `fix`, `docs`, `refactor`, `test`, `ci`, `chore`, `perf`. Example: `fix: number appendix figures as E.1`.

## Tests

```sh
bash tests/verify.sh
```

Requirements:
- Typst 0.15.1, `pdftotext` (poppler) and the Times New Roman font.
- The package must be linked into the directory described in [README > Installation](README.md#installation). While developing, you can symlink your working copy instead of cloning:
  ```sh
  ln -sfn "$PWD" "$HOME/Library/Application Support/typst/packages/local/community-meu-gsnas-thesis/$(sed -n 's/^version = "\(.*\)"/\1/p' typst.toml)"
  ```

The script:
- Compiles `template/main.typ`, `tests/edge-cases.typ` and `tests/one-sided.typ`. **Every warning counts as a failure.**
- Checks the PDF text: page order, numbering, citations and version references.
- Writes its output to `tests/out/`.

The code uses English names. When you add a setting or function, also update the Turkish equivalents table in both user guides ([English](docs/user-guide.md), [Türkçe](docs/kullanim-kilavuzu.md)). When you add new behavior, add a case under `tests/` and a check to `verify.sh`. For changes that affect the layout, attach before/after screenshots to the PR.

Documentation is kept in English and Turkish: when you change `README.md`, `CONTRIBUTING.md` or a user guide, update its counterpart (`*.tr.md`, `kullanim-kilavuzu.md`) in the same PR.

## Releasing

Versions follow [SemVer](https://semver.org/):
- **Patch** (0.2.0 → 0.2.1): bug fixes.
- **Minor** (0.2.0 → 0.3.0): new features.
- **Major** (0.2.0 → 1.0.0): changes that require users to edit their `main.typ`.

Release steps:

1. Create a `chore/release-X.Y.Z` branch from `dev`.
2. Update the version number in all of these files; CI fails if one is missed:
   - `typst.toml` → `version`
   - `template/main.typ` and `template/chapters/*.typ` → `@local/community-meu-gsnas-thesis:X.Y.Z`
   - `README.md`, `README.tr.md`, `docs/` and `lib.typ` → installation and import examples
3. Merge this branch into `dev` with a PR.
4. Open a **`dev` → `main`** PR. CI checks that the version has not been released before.
5. Merge the PR with a **merge commit**, not squash; otherwise `dev` and `main` diverge.
6. The `Sürüm` (release) workflow creates the `vX.Y.Z` tag and the Release automatically.

## Changes to the rules

If a rule does not match the guidelines, cite your source in the issue or PR: the relevant article of the guidelines or a quote from the institute's current template. All measurements are collected in `src/settings.typ`; change them there if possible.
