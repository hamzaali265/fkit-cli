# Changelog

All notable changes to **FKIT CLI** are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2026-09-16

### 🌟 Added
- **Expanded Utilities Catalog**:
  - `intl`: Automated date, time, relative time, and currency formatters along with `DateTime` and `num` extensions in `lib/shared/extensions/`.
  - `equatable`: Value equality support for entities and models.
  - `sqflite`: Local SQLite relational database support with typed table creation and persistence helpers.
  - `crypto`: Cryptographic hashing helpers (MD5, SHA-1, SHA-256, HMAC).
  - `webview_flutter`: In-app web view integration with pre-configured platform permissions.
  - `geolocator`: GPS location and permission handling with automated iOS `NSLocationWhenInUseUsageDescription` and Android location permissions.
- **Enterprise Network Architecture**: Production-grade HTTP architecture featuring abstraction contracts, interceptors, and typed exception handlers.

### 🐛 Fixed
- **Storage Service Futures**: Unified getter methods across all local persistence backends (`sqflite`, `hive`, `shared_preferences`) to consistently return `Future<T?>`.

---

## [1.0.4] - 2026-09-15

### 📖 Documentation & Polish
- **Comprehensive Documentation Overhaul**: Completely redesigned `README.md` with modern badges, ASCII terminal preview, clean architecture deep-dives with tree diagrams, features matrix, and GitHub Actions CI workflow.
- **Automated Native Permissions Guide**: Detailed breakdown of automated Android `AndroidManifest.xml`, iOS `Info.plist`/`Podfile`, and macOS `Entitlements` configuration.
- **Enhanced Contributing Guide**: Expanded `CONTRIBUTING.md` with full project architecture breakdown, template extension instructions, and conventional commit rules.

---

## [1.0.3] - 2026-09-15

### 🐛 Fixed
- **Terminal Redraw Stability**: Resolved double-render and cursor-up blinking artifacts in the interactive home menu and directory picker.
- **Folder Browser Rendering**: Fixed an issue where child directories could blank out during active folder traversal on macOS/Linux terminal sessions.

---

## [1.0.2] - 2026-09-15

### 🐛 Fixed
- **Cursor State in Choosers**: Wizard choosers now cleanly clear and overwrite stale rows on `↑`/`↓` redraws.
- **Terminal Viewport**: Stabilized full-screen terminal height calculations during directory tree navigation.

---

## [1.0.1] - 2026-09-15

### 🐛 Fixed
- **Menu Row Stacking**: Fixed an ANSI redraw issue where moving the selection cursor created duplicate stacked rows on certain terminal emulators.

---

## [1.0.0] - 2026-09-15

### 🚀 Initial Public Release

### 🌟 Added
- **Interactive Home Screen**: Modern terminal landing screen featuring ASCII wordmark, release version badge, and keyboard-driven action menu.
- **Interactive 6-Step Wizard**:
  - Interactive directory picker with parent traversal and path autocomplete.
  - Architecture selector (`feature-first`, `layer-first`, `mvvm`, `simple-mvc`).
  - State management selector (`bloc`, `riverpod`, `provider`, `getx`, `none`).
  - Routing strategy selector (`go_router`, `auto_route`, `standard`).
  - Networking client selector (`dio`, `http`, `none`).
  - Local database selector (`hive_flutter`, `shared_preferences`, `none`).
  - Optional utility package checkboxes.
- **Automated Native Platform Permissions**:
  - Automatic updates to Android `AndroidManifest.xml` (internet, media, camera permissions, URL schemes).
  - Automatic updates to iOS `Info.plist` (photo library, camera, microphone descriptions, query schemes) and `Podfile` macros.
  - Automatic updates to macOS `Entitlements` (network client, user-selected file read/write, camera).
- **Production-Ready Templates & Boilerplate**:
  - Modular clean architecture feature templates.
  - Pre-wired Dio HTTP client with interceptors and typed error handlers.
  - Pre-configured Hive NoSQL database and SharedPreferences services.
  - Theme system with dark/light themes, custom colors, typography, and context extensions.
  - `ImagePickerService` and `FilePickerService` helper wrappers.
  - Localization setup with `l10n.yaml` and starter ARB templates.
  - Environment flavor configuration (`AppConfig`) with `--dart-define` support.
  - Strict linting setup powered by `very_good_analysis`.
- **Headless & Scripting Support**:
  - Full CLI flag support for every option (`--architecture`, `--state`, `--routing`, `--networking`, `--storage`, `--org`, `--no-interactive`).
- **Catalog Command**:
  - `fkit list` to explore all supported architectural blueprints, state managers, and utility packages from the terminal.
- **Test Suite**:
  - Comprehensive unit test coverage and end-to-end project generation and static analysis verification tests.

### 📖 Documentation
- Published complete README documentation with architectural breakdowns, CLI options table, usage recipes, and GitHub Actions CI workflow.
- Created `CONTRIBUTING.md` and MIT `LICENSE`.
