<div align="center">

```
███████╗  ██╗  ██╗██╗████████╗
██╔════╝  ██║ ██╔╝██║╚══██╔══╝
█████╗    █████╔╝ ██║   ██║   
██╔══╝    ██╔═██╗ ██║   ██║   
██║       ██║  ██╗██║   ██║   
╚═╝       ╚═╝  ╚═╝╚═╝   ╚═╝   
```

# FKIT CLI

### The modern, interactive project scaffolder for production-ready Flutter apps.

Scaffold fully-configured, production-grade Flutter architectures in seconds.<br/>
Includes state management, routing, networking, storage, native permissions, design systems, and CI-ready automation.

[![Pub Version](https://img.shields.io/pub/v/fkit_cli.svg?style=for-the-badge&logo=dart&color=0175C2)](https://pub.dev/packages/fkit_cli)
[![Dart Version](https://img.shields.io/badge/Dart-3.12+-00B4AB.svg?style=for-the-badge&logo=dart)](https://dart.dev)
[![Flutter](https://img.shields.io/badge/Flutter-3.x_Ready-02569B.svg?style=for-the-badge&logo=flutter)](https://flutter.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-22C55E.svg?style=for-the-badge)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-6366F1.svg?style=for-the-badge)](CONTRIBUTING.md)
[![GitHub Stars](https://img.shields.io/github/stars/hamzaali265/fkit-cli?style=for-the-badge&logo=github&color=F59E0B)](https://github.com/hamzaali265/fkit-cli)

<br/>

```text
 ✦ Welcome to FKIT CLI!
 ────────────────────────────────────────────────────────
   ▸ [1/6] Architecture  ● Feature-first (Domain / Data / Presentation)
     [2/6] State         ● BLoC (flutter_bloc)
     [3/6] Routing       ● go_router with typed routes & guards
     [4/6] Networking    ● Dio with interceptors & error handlers
     [5/6] Storage       ● Hive NoSQL database
     [6/6] Utilities     ● SVG, Caching, Gap, Permissions, DI
 ────────────────────────────────────────────────────────
 ✓ Scaffolding complete in 1.4s — Ready to build!
```

</div>

---

## ⚡ Highlights

- 🎯 **Interactive Terminal UI** — Rich arrow-key menus, step counters, and integrated interactive folder browser.
- 🏛️ **4 Battle-Tested Architectures** — Feature-First Clean Architecture, Layer-First, MVVM, or lightweight MVC.
- ⚡ **5 State Management Options** — Flutter BLoC, Riverpod, Provider, GetX, or Vanilla Flutter.
- 🛡️ **Zero-Config Native Permissions** — Automatically configures `AndroidManifest.xml`, iOS `Info.plist`, iOS `Podfile`, and macOS `Entitlements`.
- 🌐 **Production Networking & Storage** — Dio (with custom interceptors & error mapping) or HTTP; Hive or SharedPreferences.
- 🎨 **Built-in Design System & Utilities** — Themes (light/dark), typography, responsive ScreenUtil, Gap, SVG icons, cached images, UUID, URL launcher, and GetIt DI.
- 🌍 **Localization & Flavors Ready** — Built-in `l10n.yaml` with starter ARBs, plus environment flavors (dev/prod) with `--dart-define`.
- 🤖 **100% Scriptable for CI/CD** — Full non-interactive flag support (`--no-interactive`) for automated scaffolding in pipelines.

---

## 📑 Table of Contents

- [Why FKIT CLI?](#-why-fkit-cli)
- [Installation](#-installation)
- [Quick Start](#-quick-start)
- [Interactive Scaffolding Flow](#-interactive-scaffolding-flow)
- [Architectures Breakdown](#-architectures-breakdown)
- [Tech Stack & Features Matrix](#-tech-stack--features-matrix)
- [Automated Native Permissions](#-automated-native-permissions)
- [CLI Command & Flag Reference](#-cli-command--flag-reference)
- [Popular Recipe Examples](#-popular-recipe-examples)
- [CI/CD & Headless Usage](#-cicd--headless-usage)
- [Contributing](#-contributing)
- [License](#-license)

---

## 💡 Why FKIT CLI?

Setting up a production Flutter application usually requires hours of repetitive setup: configuring folder hierarchies, wiring router boilerplate, setting up HTTP interceptors, configuring local databases, editing Android manifests and iOS plists, and adding utility packages.

**FKIT CLI** eliminates all the boilerplate while giving you full architectural control:

| Standard Flutter Setup | With FKIT CLI |
| :--- | :--- |
| ⏳ 1–2 hours manual folder & package wiring | ⚡ **< 10 seconds** interactive or headless generation |
| ❌ Inconsistent architecture across projects & teams | ✅ **Standardized, industry-proven architectures** |
| ❌ Manual editing of AndroidManifest, Info.plist, Podfiles | ✅ **Automated native permission configuration** |
| ❌ Copy-pasting boilerplate networking & error handlers | ✅ **Pre-wired Dio / HTTP services & interceptors** |
| ❌ Setting up themes, typography, and l10n manually | ✅ **Production design system, ARB l10n, & environment flavors** |

---

## 📦 Installation

### From pub.dev (Recommended)

```bash
dart pub global activate fkit_cli
```

Make sure your pub global bin directory is in your system's `PATH`.

### From Git Source

```bash
dart pub global activate --source git https://github.com/hamzaali265/fkit-cli.git
```

### From Local Source (For Development)

```bash
git clone https://github.com/hamzaali265/fkit-cli.git
cd fkit-cli
dart pub get
dart pub global activate --source path .
```

> **Requirement**: [Dart SDK](https://dart.dev/get-dart) `^3.12.2` and [Flutter SDK](https://flutter.dev) on your `PATH`.

---

## 🚀 Quick Start

### 1. Interactive Home Menu
Run `fkit` with no arguments to enter the interactive console:

```bash
fkit
```

### 2. Scaffold a New Project with Wizard
Launch the guided step-by-step wizard directly:

```bash
fkit create my_awesome_app
```

### 3. Browse Supported Stacks & Packages
List all architectural patterns, state managers, and utility packages:

```bash
fkit list
```

### 4. Non-Interactive One-Liner (CI / Scripting)
Scaffold everything headlessly with explicit flags:

```bash
fkit create my_enterprise_app \
  --architecture feature-first \
  --state bloc \
  --routing go_router \
  --networking dio \
  --storage hive \
  --get-it \
  --image-picker \
  --file-picker \
  --permission-handler \
  --org com.mycompany \
  --no-interactive
```

---

## 🧙‍♂️ Interactive Scaffolding Flow

When running `fkit create <project_name>`, the interactive terminal guides you through a streamlined 6-step configurator:

```
  ┌────────────────────────────────────────────────────────┐
  │  Step 1: Target Directory Picker (Interactive Browser) │
  │  Step 2: Architecture Pattern Selection                │
  │  Step 3: State Management Choice                       │
  │  Step 4: Routing & Navigation Strategy                 │
  │  Step 5: Networking Client & Local Storage             │
  │  Step 6: Utilities, Permissions & Design System Extras │
  └────────────────────────────────────────────────────────┘
```

---

## 🏛️ Architectures Breakdown

FKIT CLI offers 4 distinct architectural patterns to fit any team size and application scale:

### 1. Feature-First Clean Architecture (`feature-first`)
> *Best for: Medium-to-large enterprise apps with modular, cross-functional domain boundaries.*

```text
lib/
├── app/                      # App widget, global routing, environment setup
├── core/                     # Common services, network clients, base models
│   ├── config/               # AppConfig, environment constants
│   ├── network/              # ApiClient, interceptors, error handling
│   └── di/                   # Service locator / injection
├── features/                 # Modular domain slices
│   ├── auth/
│   │   ├── data/             # Models, datasources, repositories implementation
│   │   ├── domain/           # Entities, repository interfaces, usecases
│   │   └── presentation/     # BLoCs / controllers, screens, widgets
│   └── home/
│       ├── data/
│       ├── domain/
│       └── presentation/
└── shared/                   # Design system, themes, shared widgets, extensions
```

### 2. Layer-First Clean Architecture (`layer-first`)
> *Best for: Apps following classical domain-driven or layer-separated clean design.*

```text
lib/
├── app/                      # Application entry, router configuration
├── core/                     # Constants, errors, utilities, network client
├── data/                     # Data sources, DTO models, repository implementations
├── domain/                   # Business models, repository contracts, usecases
├── presentation/             # Screens, view logic, state controllers, widgets
└── shared/                   # Global styles, themes, extensions
```

### 3. MVVM (`mvvm`)
> *Best for: Clean separation of UI from business logic and data without strict usecase overhead.*

```text
lib/
├── app/                      # Main app setup and routing
├── core/                     # Helpers, theme, network, constants
├── models/                   # Data structures and entities
├── services/                 # API, Storage, and Device services
├── viewmodels/               # Reactive view models & state handlers
├── views/                    # Screen widgets and user interfaces
└── widgets/                  # Reusable UI components
```

### 4. Simple MVC (`simple-mvc`)
> *Best for: Lightweight applications, MVPs, prototypes, and small utilities.*

```text
lib/
├── controllers/              # App controllers and state coordinators
├── models/                   # Simple data models
├── screens/                  # Application screens
├── services/                 # Direct service and network layers
└── widgets/                  # Shared components and styles
```

---

## 🧩 Tech Stack & Features Matrix

| Category | Options & Packages | Description |
| :--- | :--- | :--- |
| **Architecture** | `feature-first`, `layer-first`, `mvvm`, `simple-mvc` | Clean folder structures tailored for scale |
| **State Management** | `flutter_bloc`, `flutter_riverpod`, `provider`, `get`, `none` | Pre-wired with starter state, events, or providers |
| **Routing** | `go_router`, `auto_route`, `standard` | Declarative routing with typed route configs |
| **Networking** | `dio`, `http`, `none` | Configured with base options, JSON parsing, error handlers |
| **Local Storage** | `hive_flutter`, `shared_preferences`, `sqflite`, `none` | Fast NoSQL storage, key-value persistence, or SQLite relational database |
| **Dependency Injection** | `get_it` | Pre-wired `initDependencies()` service locator |
| **Hardware & Devices** | `image_picker`, `file_picker`, `permission_handler`, `geolocator` | Camera/gallery, file picking, runtime permissions, and GPS location tracking |
| **Secure Storage** | `flutter_secure_storage` | Keychain & Keystore encrypted storage |
| **UI & Layout** | `gap`, `flutter_screenutil`, `flutter_svg`, `cached_network_image`, `webview_flutter` | Modern spacing, responsive sizing, vector/cached media, and in-app web views |
| **Utilities & Cryptography** | `equatable`, `crypto`, `intl`, `url_launcher`, `uuid` | Value equality, SHA256/MD5 hashing, formatters, external links, and UUIDs |
| **Quality & Lints** | `very_good_analysis` | Pre-configured strict linting rules |
| **Internationalization** | `flutter_localizations`, `intl` | `l10n.yaml` with starter ARB dictionaries |
| **Environment Flavors** | Development / Staging / Production | `AppConfig` supporting `--dart-define=ENVIRONMENT` |

---

## 🛡️ Automated Native Permissions

When you enable hardware and device features, FKIT CLI automatically updates your native platform files without manual copy-pasting:

```text
Platform Configuration Breakdown:
├── 🤖 Android (android/app/src/main/AndroidManifest.xml)
│   ├── Internet & Network State permissions
│   ├── Camera & Gallery storage permissions (READ_MEDIA_IMAGES / VIDEO)
│   ├── Location permissions (ACCESS_FINE_LOCATION / ACCESS_COARSE_LOCATION)
│   └── Intent <queries> for url_launcher
│
├── 🍎 iOS (ios/Runner/Info.plist & ios/Podfile)
│   ├── NSCameraUsageDescription & NSPhotoLibraryUsageDescription
│   ├── NSMicrophoneUsageDescription
│   ├── NSLocationWhenInUseUsageDescription & NSLocationAlwaysAndWhenInUseUsageDescription
│   ├── LSApplicationQueriesSchemes (https, http, mailto, tel)
│   └── Podfile macro flags (PERMISSION_CAMERA=1, PERMISSION_PHOTOS=1, PERMISSION_LOCATION=1)
│
└── 💻 macOS (macos/Runner/*.entitlements)
    ├── Network client entitlements (com.apple.security.network.client)
    ├── File access entitlements (user-selected read-write)
    ├── Location entitlements (com.apple.security.personal-information.location)
    └── Camera device permissions
```

---

## 💻 CLI Command & Flag Reference

### `fkit`
Opens the interactive terminal home screen.

### `fkit list`
Displays a comprehensive catalog of all architectures, state solutions, routing, networking, storage, and utility packages.

### `fkit create <project_name> [options]`
Scaffolds a new Flutter application.

| Flag | Shorthand | Options / Type | Default | Description |
| :--- | :---: | :--- | :--- | :--- |
| `--org` | `-o` | `string` | `com.example` | The organization reverse domain (e.g. `com.mycompany`). |
| `--output` | `-d` | `path` | `./` | Output directory where the project folder is created. |
| `--description` | | `string` | `"A new Flutter project..."` | Project description in `pubspec.yaml`. |
| `--architecture` | `-a` | `feature-first` \| `layer-first` \| `mvvm` \| `simple-mvc` | Interactive | Folder layout pattern. |
| `--state` | `-s` | `bloc` \| `riverpod` \| `provider` \| `getx` \| `none` | Interactive | State management library. |
| `--routing` | `-r` | `go_router` \| `auto_route` \| `standard` | Interactive | Navigation & routing approach. |
| `--networking` | `-n` | `dio` \| `http` \| `none` | Interactive | HTTP networking client. |
| `--storage` | | `shared_preferences` \| `hive` \| `sqflite` \| `none` | Interactive | Local persistence engine. |
| `--[no-]interactive` | `-i` | `boolean` | `true` | Enable or disable the interactive wizard. |
| `--[no-]offline` | | `boolean` | `false` | Skip `flutter pub get` and online fetches. |
| `--[no-]strict-lints` | | `boolean` | `true` | Include `very_good_analysis` rules. |
| `--[no-]l10n` | | `boolean` | `true` | Include internationalization & ARB files. |
| `--[no-]flavors` | | `boolean` | `true` | Include AppConfig environment flavors. |
| `--[no-]assets` | | `boolean` | `true` | Create `assets/images/`, `icons/`, `svgs/`, `fonts/`. |
| `--[no-]svg` | | `boolean` | `true` | Include `flutter_svg` package. |
| `--[no-]cached-image` | | `boolean` | `true` | Include `cached_network_image` package. |
| `--[no-]gap` | | `boolean` | `true` | Include `gap` layout package. |
| `--[no-]screenutil` | | `boolean` | `false` | Include `flutter_screenutil` responsive library. |
| `--[no-]permission-handler` | | `boolean` | `false` | Include `permission_handler` and native configs. |
| `--[no-]get-it` | | `boolean` | `false` | Include `get_it` service locator. |
| `--[no-]image-picker` | | `boolean` | `false` | Include `image_picker` + `ImagePickerService`. |
| `--[no-]file-picker` | | `boolean` | `false` | Include `file_picker` + `FilePickerService`. |
| `--[no-]secure-storage` | | `boolean` | `false` | Include `flutter_secure_storage` encrypted vault. |
| `--[no-]url-launcher` | | `boolean` | `false` | Include `url_launcher` package. |
| `--[no-]uuid` | | `boolean` | `false` | Include `uuid` package for RFC-compliant UUID generation. |
| `--[no-]intl` | | `boolean` | `true` | Include `intl` package with Date, Time, & Currency `AppFormatters`. |
| `--[no-]equatable` | | `boolean` | `false` | Include `equatable` package for value equality without boilerplate. |
| `--[no-]crypto` | | `boolean` | `false` | Include `crypto` package with `AppCrypto` SHA256/MD5 hashing. |
| `--[no-]webview` | | `boolean` | `false` | Include `webview_flutter` package with `AppWebView` component. |
| `--[no-]geolocator` | | `boolean` | `false` | Include `geolocator` package with `LocationService`. |

---

## 🍳 Popular Recipe Examples

### Enterprise Scale (Clean Architecture + BLoC + Dio + Hive + DI)
```bash
fkit create enterprise_app \
  --architecture feature-first \
  --state bloc \
  --routing go_router \
  --networking dio \
  --storage hive \
  --get-it \
  --permission-handler \
  --image-picker \
  --file-picker \
  --no-interactive
```

### Modern Reactive (MVVM + Riverpod + Dio + Secure Storage)
```bash
fkit create reactive_app \
  --architecture mvvm \
  --state riverpod \
  --routing go_router \
  --networking dio \
  --storage shared_preferences \
  --secure-storage \
  --screenutil \
  --no-interactive
```

### Fast Prototype (Simple MVC + GetX + HTTP)
```bash
fkit create quick_prototype \
  --architecture simple-mvc \
  --state getx \
  --routing standard \
  --networking http \
  --storage shared_preferences \
  --no-interactive
```

---

## 🤖 CI/CD & Headless Usage

FKIT CLI works seamlessly in headless environments like GitHub Actions, GitLab CI, and Docker.

```yaml
# .github/workflows/scaffold_test.yml
name: Scaffold & Verify Project

on: [push, pull_request]

jobs:
  scaffold:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.x'
          channel: 'stable'

      - name: Install FKIT CLI
        run: dart pub global activate fkit_cli

      - name: Scaffold App
        run: |
          fkit create test_app \
            --architecture feature-first \
            --state bloc \
            --routing go_router \
            --networking dio \
            --storage hive \
            --no-interactive

      - name: Verify Generated App
        run: |
          cd test_app
          flutter analyze
          flutter test
```

---

## 🛠️ Contributing

Contributions, feature requests, and bug reports are warmly welcome!

1. Check out the [Contributing Guidelines](CONTRIBUTING.md).
2. Fork the repository and create your feature branch:
   ```bash
   git checkout -b feature/my-new-feature
   ```
3. Run tests and static analysis:
   ```bash
   dart analyze
   dart test
   ```
4. Commit your changes following [Conventional Commits](https://www.conventionalcommits.org/):
   ```bash
   git commit -m "feat: support supabase backend template"
   ```
5. Push to your branch and submit a Pull Request!

---

## 📄 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

<div align="center">

Crafted with ❤️ by [hamzaali265](https://github.com/hamzaali265)

**If FKIT CLI helps accelerate your Flutter development, please consider giving it a ⭐ on GitHub!**

</div>
