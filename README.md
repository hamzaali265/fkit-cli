<div align="center">

```
███████╗██╗  ██╗██╗████████╗
██╔════╝██║ ██╔╝██║╚══██╔══╝  FKIT CLI
█████╗  █████╔╝ ██║   ██║     Production Flutter Scaffolder & Lifecycle Toolkit
██╔══╝  ██╔═██╗ ██║   ██║     https://pub.dev/packages/fkit_cli
██║     ██║  ██╗██║   ██║
╚═╝     ╚═╝  ╚═╝╚═╝   ╚═╝
```

# FKIT CLI

### The ultimate Flutter scaffolding & lifecycle companion CLI.

**Bootstrap production-grade Flutter architectures in seconds, generate modular components and clean feature slices, configure multi-environment flavors, manage type-safe assets, and diagnose setup health.**

[![Pub Version](https://img.shields.io/pub/v/fkit_cli.svg?style=flat-square&color=0175C2&label=pub.dev)](https://pub.dev/packages/fkit_cli)
[![Pub Points](https://img.shields.io/pub/points/fkit_cli?style=flat-square&color=22C55E&label=pub%20points)](https://pub.dev/packages/fkit_cli/score)
[![Dart SDK](https://img.shields.io/badge/Dart-3.12+-00B4AB.svg?style=flat-square&logo=dart)](https://dart.dev)
[![Flutter](https://img.shields.io/badge/Flutter-3.x_Ready-02569B.svg?style=flat-square&logo=flutter)](https://flutter.dev)
[![Platforms](https://img.shields.io/badge/Platforms-macOS%20%7C%20Linux%20%7C%20Windows-blueviolet.svg?style=flat-square)](https://pub.dev/packages/fkit_cli)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=flat-square)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](CONTRIBUTING.md)
[![GitHub Stars](https://img.shields.io/github/stars/hamzaali265/fkit-cli?style=flat-square&logo=github&color=F59E0B)](https://github.com/hamzaali265/fkit-cli)

<br/>

```text
  ✦ Welcome to FKIT CLI!
  ─────────────────────────────────────────────────────────────────────────────
    ? What would you like to do?
    ❯ 🚀 Create New Project       Scaffold a production-ready Flutter app
      ⚡ Make Component           Generate screen, controller, model, or service
      🧩 Add Feature Slice        Add clean architecture feature module
      🎨 Manage Assets            Generate type-safe asset code or clean unused
      🏷️  Configure Flavors       Automate Android, iOS & VS Code flavors
      🩺 Doctor                   Diagnose Flutter, CocoaPods, and project health
      📋 List Catalog             Browse supported architectures, state & packages
      🚪 Exit
  ─────────────────────────────────────────────────────────────────────────────
```

</div>

---

## ⚡ Highlights

- 🎯 **Interactive Terminal UX** — Arrow-key navigation, step counters, ASCII wordmarks, and built-in interactive directory picker.
- 🏛️ **4 Battle-Tested Architectures** — Feature-First Clean Architecture, Layer-First Clean Architecture, MVVM, or lightweight MVC.
- ⚡ **5 State Management Options** — Flutter BLoC, Riverpod, Provider, GetX, or Vanilla Flutter.
- 🛡️ **Zero-Config Native Permissions** — Automatically patches Android `AndroidManifest.xml`, iOS `Info.plist`, iOS `Podfile`, and macOS `Entitlements`.
- ⚡ **Rapid Component Generators (`fkit make`)** — Generate screens, controllers, models, and services that automatically conform to your project's architectural pattern.
- 🧩 **Clean Feature Slices (`fkit feature`)** — Scaffold complete domain slices (`data/`, `domain/`, `presentation/`) in one command.
- 🏷️ **Automated Flavor System (`fkit flavor`)** — Configure Android productFlavors, iOS Xcode build schemes, and VS Code `.vscode/launch.json` debug configurations.
- 🎨 **Type-Safe Asset Automation (`fkit assets`)** — Generate compile-safe `AppAssets` constants from your asset directories, and detect unreferenced/dead assets.
- 🩺 **Environment & Project Diagnostics (`fkit doctor`)** — Validate Flutter SDK, Dart SDK, CocoaPods, Android toolchain, and inspect project health.
- 🤖 **100% CI/CD & Headless Automation** — Full non-interactive flag support (`--no-interactive`) for automated pipeline generation.

---

## 📑 Table of Contents

- [Why FKIT CLI?](#-why-fkit-cli)
- [Installation](#-installation)
- [Commands Cheatsheet](#-commands-cheatsheet)
- [Quick Start](#-quick-start)
- [Command Reference](#-command-reference)
  - [`fkit` (Interactive Home)](#1-fkit-interactive-home)
  - [`fkit create` (Project Scaffolder)](#2-fkit-create-project-scaffolder)
  - [`fkit make` (Component Generators)](#3-fkit-make-component-generators)
  - [`fkit feature` (Clean Feature Slices)](#4-fkit-feature-clean-feature-slices)
  - [`fkit flavor` (Multi-Flavor Automation)](#5-fkit-flavor-multi-flavor-automation)
  - [`fkit assets` (Asset Code Gen & Cleanup)](#6-fkit-assets-asset-code-gen--cleanup)
  - [`fkit doctor` (Environment Diagnostics)](#7-fkit-doctor-environment-diagnostics)
  - [`fkit list` (Architecture & Package Catalog)](#8-fkit-list-catalog)
- [Architectures Breakdown](#-architectures-breakdown)
- [Tech Stack & Features Matrix](#-tech-stack--features-matrix)
- [Automated Native Permissions](#-automated-native-permissions)
- [Popular Recipe Examples](#-popular-recipe-examples)
- [CI/CD & Headless Usage](#-cicd--headless-usage)
- [Programmatic API](#-programmatic-api)
- [Contributing](#-contributing)
- [License](#-license)

---

## 💡 Why FKIT CLI?

Setting up a production Flutter application usually requires hours of repetitive work: assembling directory hierarchies, wiring router boilerplate, setting up HTTP interceptors, configuring local databases, editing Android manifests, iOS plists, and Podfiles, and generating boilerplate for every new screen or service.

**FKIT CLI** provides an end-to-end development toolkit from initial project scaffolding through active day-to-day feature development:

| Standard Flutter Workflow | With FKIT CLI |
| :--- | :--- |
| ⏳ 1–2 hours manual folder & package setup | ⚡ **< 10 seconds** interactive or headless generation |
| ❌ Inconsistent architecture across teams | ✅ **Standardized, battle-tested architectural blueprints** |
| ❌ Manual editing of AndroidManifest, Info.plist, Podfiles | ✅ **Automated native permission configuration** |
| ❌ Repetitive boilerplate for new screens & services | ✅ **`fkit make` & `fkit feature` one-command generators** |
| ❌ Fragile manual flavor setups across Android & iOS | ✅ **`fkit flavor` multi-environment automation** |
| ❌ String-based asset typos (`"assets/images/logo.png"`) | ✅ **`fkit assets gen` type-safe `AppAssets` constants** |
| ❌ Unused asset bloat inflating app bundle size | ✅ **`fkit assets clean` dead asset detector** |
| ❌ Hard to diagnose missing dependencies & SDK tools | ✅ **`fkit doctor` instant environment health checks** |

---

## 📦 Installation

### From pub.dev (Recommended)

```bash
dart pub global activate fkit_cli
```

Make sure your pub global bin directory is in your system's `PATH`:
- **macOS / Linux**: `~/.pub-cache/bin`
- **Windows**: `%LOCALAPPDATA%\Pub\Cache\bin`

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

> **Requirements**: [Dart SDK](https://dart.dev/get-dart) `^3.12.2` and [Flutter SDK](https://flutter.dev) `3.x` on your `PATH`.

---

## ⚡ Commands Cheatsheet

| Command | Description |
| :--- | :--- |
| `fkit` | Launch the interactive console with quick-action dashboard. |
| `fkit create <name>` | Scaffold a production-ready Flutter app with guided wizard or flags. |
| `fkit make screen <name>` | Generate a new screen/view conforming to the project architecture. |
| `fkit make controller <name>` | Generate a BLoC, Cubit, GetxController, or ChangeNotifier. |
| `fkit make model <name>` | Generate a data model with `fromJson`, `toJson`, and `copyWith`. |
| `fkit make service <name>` | Generate an API/data service with error handling & singleton. |
| `fkit feature add <name>` | Scaffold a complete Clean Architecture feature slice (`data/`, `domain/`, `presentation/`). |
| `fkit flavor add <name>` | Configure multi-flavor support across Android, iOS, and VS Code. |
| `fkit flavor list` | Display all configured project flavors. |
| `fkit assets gen` | Scan `assets/` and generate type-safe `AppAssets` constants. |
| `fkit assets clean` | Scan codebase for unreferenced assets and report or remove them. |
| `fkit doctor` | Validate Flutter SDK, Dart SDK, CocoaPods, and project health. |
| `fkit list` | Display catalog of supported architectures, state, and packages. |

---

## 🚀 Quick Start

### 1. Launch Interactive Dashboard
Run `fkit` with no arguments to enter the interactive console:

```bash
fkit
```

### 2. Scaffold a New Project
Run the guided step-by-step creation wizard:

```bash
fkit create my_awesome_app
```

### 3. Generate Components on the Fly
Navigate into your Flutter project and generate components:

```bash
cd my_awesome_app

# Generate a screen
fkit make screen profile

# Generate a data model
fkit make model user

# Add a complete feature slice
fkit feature add authentication
```

### 4. Headless One-Liner (CI / Automated Scripting)
Scaffold everything non-interactively with explicit flags:

```bash
fkit create my_enterprise_app \
  --architecture feature-first \
  --state bloc \
  --routing go_router \
  --networking dio \
  --storage hive \
  --get-it \
  --image-picker \
  --permission-handler \
  --org com.mycompany \
  --no-interactive
```

---

## 💻 Command Reference

### 1. `fkit` (Interactive Home)
Launches the interactive terminal menu where you can navigate between project creation, component generation, flavor configuration, asset management, and diagnostics using arrow keys:

```bash
fkit
```

---

### 2. `fkit create` (Project Scaffolder)
Scaffolds a new Flutter application. When run without options, it guides you through an interactive 6-step configurator.

```bash
fkit create <project_name> [options]
```

#### CLI Flags & Options

| Flag | Shorthand | Type / Options | Default | Description |
| :--- | :---: | :--- | :--- | :--- |
| `--architecture` | `-a` | `feature-first` \| `layer-first` \| `mvvm` \| `simple-mvc` | Interactive | Folder architecture pattern. |
| `--state` | `-s` | `bloc` \| `riverpod` \| `provider` \| `getx` \| `none` | Interactive | State management solution. |
| `--routing` | `-r` | `go_router` \| `auto_route` \| `standard` | Interactive | Declarative routing strategy. |
| `--networking` | `-n` | `dio` \| `http` \| `none` | Interactive | HTTP networking client. |
| `--storage` | | `hive` \| `shared_preferences` \| `sqflite` \| `none` | Interactive | Local persistence backend. |
| `--org` | `-o` | `string` | `com.example` | Organization reverse domain. |
| `--output` | `-d` | `path` | `./` | Output destination directory. |
| `--description` | | `string` | `"A new Flutter project..."` | Description in `pubspec.yaml`. |
| `--[no-]interactive` | `-i` | `boolean` | `true` | Enable or disable the interactive wizard. |
| `--[no-]offline` | | `boolean` | `false` | Skip `flutter pub get` and online fetches. |
| `--[no-]strict-lints` | | `boolean` | `true` | Include `very_good_analysis` rules. |
| `--[no-]l10n` | | `boolean` | `true` | Include internationalization & starter ARB. |
| `--[no-]flavors` | | `boolean` | `true` | Include AppConfig environment flavors. |
| `--[no-]assets` | | `boolean` | `true` | Create structured `assets/` folders. |
| `--[no-]svg` | | `boolean` | `true` | Include `flutter_svg` package. |
| `--[no-]cached-image` | | `boolean` | `true` | Include `cached_network_image` package. |
| `--[no-]gap` | | `boolean` | `true` | Include `gap` layout package. |
| `--[no-]screenutil` | | `boolean` | `false` | Include `flutter_screenutil` responsive library. |
| `--[no-]get-it` | | `boolean` | `false` | Include `get_it` service locator. |
| `--[no-]permission-handler` | | `boolean` | `false` | Include `permission_handler` + native config. |
| `--[no-]image-picker` | | `boolean` | `false` | Include `image_picker` + native permissions. |
| `--[no-]file-picker` | | `boolean` | `false` | Include `file_picker` + native entitlements. |
| `--[no-]secure-storage` | | `boolean` | `false` | Include `flutter_secure_storage` vault. |
| `--[no-]geolocator` | | `boolean` | `false` | Include `geolocator` + native location permissions. |
| `--[no-]url-launcher` | | `boolean` | `false` | Include `url_launcher` + platform queries. |
| `--[no-]webview` | | `boolean` | `false` | Include `webview_flutter` component. |
| `--[no-]uuid` | | `boolean` | `false` | Include `uuid` package. |
| `--[no-]intl` | | `boolean` | `true` | Include `intl` + `AppFormatters` helpers. |
| `--[no-]equatable` | | `boolean` | `false` | Include `equatable` value equality helper. |
| `--[no-]crypto` | | `boolean` | `false` | Include `crypto` SHA256/MD5 hashing helper. |

---

### 3. `fkit make` (Component Generators)
Quickly scaffold individual components inside an existing Flutter project. The generated files automatically match your project's architecture (`feature-first`, `layer-first`, `mvvm`, or `simple-mvc`).

#### Make Screen / View
```bash
fkit make screen <screen_name>
```
*Generates screen widget with app bar, responsive body, and routing hook.*

#### Make Controller / BLoC
```bash
fkit make controller <name> [type]
```
*Generates state controller based on project stack (BLoC + Event + State, Cubit, GetxController, or ChangeNotifier).*

#### Make Model
```bash
fkit make model <model_name>
```
*Generates typed Dart data model with `fromJson`, `toJson`, `copyWith`, and `toString` methods.*

#### Make Service
```bash
fkit make service <service_name>
```
*Generates service layer class with pre-wired error handling, logging, and singleton access.*

---

### 4. `fkit feature` (Clean Feature Slices)
Scaffolds a complete modular feature slice adhering to Clean Architecture principles:

```bash
fkit feature add <feature_name>
```

For example, `fkit feature add auth` generates:
```text
lib/features/auth/
├── data/
│   ├── datasources/auth_remote_datasource.dart
│   ├── models/auth_model.dart
│   └── repositories/auth_repository_impl.dart
├── domain/
│   ├── entities/auth_entity.dart
│   ├── repositories/auth_repository.dart
│   └── usecases/login_usecase.dart
└── presentation/
    ├── controllers/auth_controller.dart
    ├── views/auth_view.dart
    └── widgets/auth_form_widget.dart
```

---

### 5. `fkit flavor` (Multi-Flavor Automation)
Automates multi-flavor configuration without tedious manual editing:

```bash
# Add a new environment flavor
fkit flavor add <flavor_name> [options]

# List configured project flavors
fkit flavor list
```

**What it automates:**
- 🤖 **Android**: Adds `productFlavors` and `flavorDimensions` to `android/app/build.gradle`.
- 🍎 **iOS**: Creates Xcode scheme configurations and build configurations in `ios/Runner.xcodeproj`.
- 🎯 **Dart Entrypoints**: Generates `lib/main_<flavor>.dart` with environment-specific `AppConfig`.
- 💻 **VS Code**: Generates `.vscode/launch.json` debug profiles with `--flavor` and target entrypoints.

---

### 6. `fkit assets` (Asset Code Gen & Cleanup)
Manages static assets with type safety and size optimization:

#### Generate Type-Safe Constants (`assets gen`)
```bash
fkit assets gen
```
Scans `assets/images/`, `assets/icons/`, `assets/svgs/`, and `assets/fonts/` and writes `lib/core/constants/app_assets.dart`:

```dart
// Generated by FKIT CLI — Type-Safe Asset Access
class AppAssets {
  AppAssets._();

  static const String imagesLogo = 'assets/images/logo.png';
  static const String iconsUser = 'assets/icons/user.svg';
  static const String svgsBackground = 'assets/svgs/background.svg';
}
```

#### Find Unreferenced Assets (`assets clean`)
```bash
fkit assets clean [--delete]
```
Scans all `.dart` files in your project, checks for referenced asset strings, and flags unreferenced files. Pass `--delete` to safely prune unused assets from disk.

---

### 7. `fkit doctor` (Environment Diagnostics)
Checks your machine's development environment and validates the health of your local Flutter project:

```bash
fkit doctor
```

```text
🩺 Running FKIT Doctor...

[✓] Flutter SDK installed: Flutter 3.24.0 • channel stable
[✓] Dart SDK installed: Dart SDK version: 3.12.2
[✓] CocoaPods installed: pod 1.15.2
[✓] Project root: Valid Flutter project structure detected
[✓] Dependencies: pubspec.lock is synchronized
[✓] FKIT Configuration: .fkit.json configuration is valid

✓ Doctor found 0 issues. Environment and project are ready!
```

---

### 8. `fkit list` (Catalog)
Displays a terminal catalog of all supported architectures, state managers, routing engines, network clients, storage backends, and utility packages:

```bash
fkit list
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
│   └── di/                   # Service locator / dependency injection
├── features/                 # Modular domain slices
│   ├── auth/
│   │   ├── data/             # Models, datasources, repository implementations
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

When hardware and device features are selected, FKIT CLI automatically patches your platform configuration files without manual copy-pasting:

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

FKIT CLI is designed to run headlessly in CI/CD pipelines (GitHub Actions, GitLab CI, Docker):

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

## 💻 Programmatic API

You can also use `package:fkit_cli` as a Dart library in your custom automation scripts:

```dart
import 'dart:io';
import 'package:fkit_cli/fkit_cli.dart';

void main() async {
  final runner = FkitCommandRunner();

  // Run doctor diagnostics programmatically
  await runner.run(['doctor']);

  // Or inspect supported architecture patterns
  for (final pattern in ArchitecturePattern.values) {
    print('${pattern.label}: ${pattern.description}');
  }
}
```

See the [example/](example/) directory for complete runnable demonstrations.

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
   git commit -m "feat: add support for supabase template"
   ```
5. Push to your branch and submit a Pull Request!

---

## 📄 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

<div align="center">

Crafted with ❤️ by [hamzaali265](https://github.com/hamzaali265)

**If FKIT CLI helps accelerate your Flutter development, please give it a ⭐ on [GitHub](https://github.com/hamzaali265/fkit-cli) and 👍 on [pub.dev](https://pub.dev/packages/fkit_cli)!**

</div>
