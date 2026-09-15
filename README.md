# FKIT CLI

**Scaffold production-ready Flutter apps from your terminal — architecture, state, routing, and packages in one interactive flow.**

[![Dart](https://img.shields.io/badge/Dart-3.12+-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![pub package](https://img.shields.io/pub/v/fkit.svg)](https://pub.dev/packages/fkit)
[![Flutter](https://img.shields.io/badge/Flutter-ready-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![GitHub stars](https://img.shields.io/github/stars/hamzaali265/fkit-cli?style=social)](https://github.com/hamzaali265/fkit-cli)

<p align="center">
  <code>fkit</code> · interactive home · wizard scaffolding · CI-friendly flags
</p>

```
███████╗  ██╗  ██╗██╗████████╗
██╔════╝  ██║ ██╔╝██║╚══██╔══╝
█████╗    █████╔╝ ██║   ██║
██╔══╝    ██╔═██╗ ██║   ██║
██║       ██║  ██╗██║   ██║
╚═╝       ╚═╝  ╚═╝╚═╝   ╚═╝
```

---

## Why FKIT CLI?

Setting up a Flutter app the “right” way still means the same busywork every time: folder structure, state management, routing, networking, storage, lints, l10n, permissions, and a pile of utility packages.

**FKIT CLI** turns that into a guided terminal experience — or a single non-interactive command for scripts and CI.

| You want | FKIT CLI gives you |
| --- | --- |
| Clean architecture choices | Feature-first, layer-first, MVVM, or lightweight MVC |
| State that fits the team | Bloc, Riverpod, Provider, GetX, or vanilla |
| Production defaults | Dio/HTTP, Hive/SharedPreferences, go_router, l10n, flavors, `very_good_analysis` |
| Less copy-paste | Services for image/file picking, assets, themes, extensions, DI (`get_it`) |

---

## Features

- **Interactive home** — run `fkit` with no args for a Claude-style hero + arrow menu
- **Step-by-step wizard** — architecture → state → routing → networking → storage → utilities
- **Directory picker** — browse and confirm where the project lands
- **Rich templates** — screens, themes, assets, permissions, and package wiring generated for you
- **Scriptable** — every choice has a CLI flag for automation (`--no-interactive`)
- **List catalog** — `fkit list` shows stacks and packages available to scaffold

---

## Install

### From pub.dev (recommended)

```bash
dart pub global activate fkit
fkit
```

Make sure Pub’s bin directory is on your `PATH` (Dart prints it after activate if needed).

### From GitHub

```bash
dart pub global activate --source git https://github.com/hamzaali265/fkit-cli.git
fkit
```

### From source

```bash
git clone https://github.com/hamzaali265/fkit-cli.git
cd fkit-cli
dart pub get
dart pub global activate --source path .
fkit
```

> Requires [Dart SDK](https://dart.dev/get-dart) `^3.12` and a working [Flutter](https://flutter.dev) install on your PATH for project generation.

---

## Quick start

```bash
# Interactive home
fkit

# Create a project (wizard)
fkit create my_awesome_app

# Fully scripted (CI / templates)
fkit create my_app \
  --architecture feature-first \
  --state bloc \
  --routing go_router \
  --networking dio \
  --storage shared_preferences \
  --image-picker \
  --file-picker \
  --get-it \
  --org com.mycompany \
  --no-interactive
```

```bash
# Browse available options
fkit list
```

---

## What you can choose

<details>
<summary><strong>Architecture</strong></summary>

- **Feature-first** — clean architecture per feature  
- **Layer-first** — classical domain / data / presentation  
- **MVVM** — views, viewmodels, models, services  
- **Simple MVC** — lightweight screens + controllers  

</details>

<details>
<summary><strong>State management</strong></summary>

`flutter_bloc` · `flutter_riverpod` · `provider` · `get` · vanilla Flutter  

</details>

<details>
<summary><strong>Routing · Networking · Storage</strong></summary>

- Routing: `go_router`, `auto_route`, or Navigator  
- Networking: `dio`, `http`, or none  
- Storage: `shared_preferences`, `hive`, or none  

</details>

<details>
<summary><strong>Utilities & extras</strong></summary>

`flutter_svg` · `cached_network_image` · `gap` · `flutter_screenutil` · `image_picker` · `file_picker` · `permission_handler` · `get_it` · `flutter_secure_storage` · `url_launcher` · `uuid`  

Plus optional l10n, flavors, asset folders, and strict linting.

</details>

---

## Project layout (after generate)

Generated apps include opinionated shared layers (exact paths depend on architecture):

```text
lib/
  shared/          # theme, extensions, constants, widgets
  …                # feature or layer folders from your architecture choice
assets/
  images/ icons/ svgs/ fonts/
```

---

## Development

```bash
dart pub get
dart run bin/fkit.dart
dart test
dart analyze
```

---

## Roadmap

- [x] Pub.dev publish (`fkit`)
- [ ] Homebrew / scoop install snippets
- [ ] More architecture presets and template packs
- [ ] Plugin hooks for custom generators

---

## Contributing

Ideas, bugs, and PRs are welcome. See [CONTRIBUTING.md](CONTRIBUTING.md) for the short workflow.

1. Fork the repo  
2. Create a branch (`git checkout -b feature/amazing`)  
3. Commit (`git commit -m 'feat: add amazing thing'`)  
4. Push and open a Pull Request  

---

## License

MIT © [hamzaali265](https://github.com/hamzaali265) — see [LICENSE](LICENSE).

---

<p align="center">
  If FKIT CLI saves you setup time, consider giving the repo a ⭐
</p>
