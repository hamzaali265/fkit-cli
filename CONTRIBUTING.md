# Contributing to FKIT CLI

First off, thank you for considering contributing to **FKIT CLI**! 🎉

Whether you are fixing a bug, adding support for a new state manager or architecture, improving native platform configurations, or enhancing documentation — your help is greatly appreciated.

---

## 📑 Table of Contents

- [Code of Conduct](#-code-of-conduct)
- [Development Setup](#-development-setup)
- [Project Architecture](#-project-architecture)
- [Adding New Templates & Options](#-adding-new-templates--options)
- [Coding Guidelines & Style](#-coding-guidelines--style)
- [Testing & Quality Verification](#-testing--quality-verification)
- [Commit Conventions](#-commit-conventions)
- [Submitting a Pull Request](#-submitting-a-pull-request)

---

## 🤝 Code of Conduct

We are committed to providing a friendly, welcoming, and harassment-free environment for everyone. Please be respectful and constructive in all issues, pull requests, and discussions.

---

## 🛠️ Development Setup

### Prerequisites
- [Dart SDK](https://dart.dev/get-dart) `^3.12.2`
- [Flutter SDK](https://flutter.dev) (latest stable recommended)
- Git

### Setup Steps

1. **Fork and clone the repository:**
   ```bash
   git clone https://github.com/<your-username>/fkit-cli.git
   cd fkit-cli
   ```

2. **Install dependencies:**
   ```bash
   dart pub get
   ```

3. **Activate your local build globally:**
   ```bash
   dart pub global activate --source path .
   ```
   Now running `fkit` in any terminal will use your local modifications!

4. **Run the CLI directly during development:**
   ```bash
   dart run bin/fkit.dart
   ```

---

## 📂 Project Architecture

```text
lib/
├── fkit_cli.dart                     # Public package exports & version metadata
└── src/
    ├── command_runner.dart           # Top-level CLI command dispatcher & error handling
    ├── commands/                     # Subcommand implementations (create, list)
    ├── models/                       # Data models (ProjectConfig, enums, catalog items)
    ├── prompts/                      # Interactive terminal UI, themes, & directory picker
    ├── generator/                    # Project builder, file orchestrator, & native permission patchers
    └── templates/                    # Code generation templates (screens, routers, DI, themes, pubspec)
```

---

## 🧩 Adding New Templates & Options

When adding a new architecture, state management library, or utility package:

1. **Define the Option in Models**:
   - Add the enum or entry to `lib/src/models/project_config.dart`.
   - Update `ChoiceCatalog` in `lib/src/prompts/choice_catalog.dart`.

2. **Add CLI Flags**:
   - Register corresponding flags in `lib/src/commands/create_command.dart`.

3. **Create/Update Generator Templates**:
   - Place templates in `lib/src/templates/` (e.g. `state_templates.dart`, `routing_templates.dart`, or `screen_templates.dart`).
   - Hook the generation into `TemplateEngine` in `lib/src/generator/template_engine.dart`.

4. **Configure Platform Permissions (If Native Hardware/Services)**:
   - If the package requires iOS `Info.plist`, Android permissions, or macOS entitlements, add the rules to `lib/src/generator/platform_permission_configurator.dart`.

5. **Write Unit and Generation Tests**:
   - Add test cases in `test/models_test.dart` or `test/e2e_generation_test.dart`.

---

## 🎨 Coding Guidelines & Style

- **Follow Effective Dart**: Follow standard Dart conventions and clean architectural principles.
- **Strict Analysis**: All code must conform to the linting rules defined in `analysis_options.yaml`.
- **Formatting**: Always format your code before committing:
  ```bash
  dart format .
  ```

---

## 🧪 Testing & Quality Verification

Before opening a pull request, ensure all tests and lints pass cleanly:

```bash
# 1. Format check
dart format --output=none --set-exit-if-changed .

# 2. Static analysis
dart analyze

# 3. Unit & End-to-End Tests
dart test
```

---

## 💬 Commit Conventions

We follow [Conventional Commits](https://www.conventionalcommits.org/) to keep the commit history clean and facilitate automated releases:

- `feat:` A new feature or template option
- `fix:` A bug fix or UI correction
- `docs:` Documentation updates (README, CHANGELOG, etc.)
- `style:` Formatting or whitespace changes (no production code change)
- `refactor:` Code restructuring without modifying behavior
- `test:` Adding or updating unit/e2e tests
- `chore:` Maintenance, dependency bumps, or tooling updates

*Example:* `feat(generator): add support for supabase template`

---

## 🚀 Submitting a Pull Request

1. Create a descriptive branch:
   ```bash
   git checkout -b feat/my-cool-feature
   ```
2. Make your changes and commit them cleanly.
3. Push your branch:
   ```bash
   git push origin feat/my-cool-feature
   ```
4. Open a Pull Request against the `main` branch.
5. Provide a clear summary of what your PR introduces and include any relevant test commands or screenshots.

Thank you for helping make **FKIT CLI** the go-to tool for Flutter developers worldwide! 💙
