# Modular Architecture Design Specification

## Overview
This specification details the addition of a new **Modular** architecture pattern (`ArchitecturePattern.modular`) to FKIT CLI.
The modular pattern groups code by business domain modules inside a `lib/modules/<module_name>/` folder hierarchy, with dedicated subfolders for:
- `logic/` (controllers / cubits / notifiers based on state management)
- `providers/` (state providers / dependency injection bindings)
- `repositories/` (data sources and repository abstractions/implementations)
- `screens/` (views / pages)
- `models/` (entities and data transfer models)

Cross-cutting infrastructure remains organized under `lib/core/` (theme, routing, networking, storage) and `lib/shared/` (widgets, extensions, utilities).

---

## Architecture & Layout

### 1. Directory Structure

```text
lib/
├── core/
│   ├── routes/
│   │   └── app_router.dart
│   ├── theme/
│   │   ├── app_colors.dart
│   │   ├── app_fonts.dart
│   │   ├── app_theme.dart
│   │   └── theme.dart
│   ├── network/                     # Present if networking != none
│   │   ├── api_client.dart
│   │   ├── api_endpoint.dart
│   │   └── network.dart
│   └── storage/                     # Present if storage != none
│       └── storage_service.dart
├── shared/
│   ├── constants/
│   ├── extensions/
│   ├── utils/
│   └── widgets/
│       └── app_button.dart
├── modules/
│   └── <module_name>/
│       ├── logic/                   # State controllers / Cubits
│       ├── providers/               # State / DI providers
│       ├── repositories/            # Data repositories
│       ├── screens/                 # UI screens
│       └── models/                  # Domain / data models
└── main.dart
```

### 2. State Management Mapping

For each module `<name>` (e.g., `counter` or `<feature>`):

| State Management | `logic/` contents | `providers/` contents |
| :--- | :--- | :--- |
| **Riverpod** | `<name>_controller.dart` (`StateNotifier` or `Notifier`) | `<name>_provider.dart` (`StateNotifierProvider` / `NotifierProvider`) |
| **BLoC** | `<name>_cubit.dart` (or `<name>_bloc.dart` + `<name>_state.dart`) | `<name>_provider.dart` (`BlocProvider` widget wrapper/helper) |
| **Provider** | `<name>_notifier.dart` (`ChangeNotifier`) | `<name>_provider.dart` (`ChangeNotifierProvider` helper) |
| **GetX** | `<name>_controller.dart` (`GetxController`) | `<name>_binding.dart` (`Bindings` class) |
| **None** | Empty or plain controller class | (Not generated / minimal) |

---

## Detailed Component Specifications

### 1. Project Config & Models (`lib/src/models/project_config.dart`)
- Update `ArchitecturePattern` enum:
  ```dart
  modular(
    'Modular',
    'Module-driven architecture grouped by domain modules (lib/modules/<name>/{logic, providers, repositories, screens, models})',
  )
  ```
- Update `ArchitecturePattern.fromKey(String key)`:
  - Match `'modular'`, `'module'`, `'modules'`.
- Ensure JSON serialization to `.fkit.json` uses `'modular'` and deserializes correctly.

### 2. Interactive Wizard & Catalog (`lib/src/prompts/`)
- `choice_catalog.dart`:
  - Add `ArchitecturePattern.modular` to `ChoiceCatalog.architecture()` with subtitle `'modules · logic · screens'`.
- `architecture_diagrams.dart`:
  - Add ASCII folder tree visualization for `ArchitecturePattern.modular`:
    ```text
    lib/
    ├── core/           (theme, network, routes)
    ├── shared/         (widgets, utils, extensions)
    └── modules/
        └── <module>/
            ├── logic/         (controllers / cubits)
            ├── providers/     (state providers)
            ├── repositories/  (data sources & repositories)
            ├── screens/       (views / pages)
            └── models/        (entities & data models)
    ```

### 3. CLI Options (`lib/src/commands/create_command.dart`, `list_command.dart`)
- `create_command.dart`:
  - Allow `'modular'` in `--architecture` argument definition and validation.
- `list_command.dart`:
  - Output Modular in the list of available architectures.

### 4. Template Engine (`lib/src/generator/template_engine.dart`)
- Extend `usesCoreDir`:
  ```dart
  final isModular = config.architecture == ArchitecturePattern.modular;
  final usesCoreDir = isFeatureFirst || isLayerFirst || isModular;
  ```
- Generate starter counter module under `lib/modules/counter/`:
  - `lib/modules/counter/models/counter_model.dart`
  - `lib/modules/counter/repositories/counter_repository.dart`
  - `lib/modules/counter/logic/counter_controller.dart` (or `counter_cubit.dart` / `counter_notifier.dart`)
  - `lib/modules/counter/providers/counter_provider.dart`
  - `lib/modules/counter/screens/counter_screen.dart`
- Route configuration:
  - `lib/core/routes/app_router.dart`: Imports and sets initial route to `lib/modules/counter/screens/counter_screen.dart`.
- `lib/main.dart`:
  - Correctly imports `core/theme/theme.dart`, `core/routes/app_router.dart`, and references `modules/counter/screens/counter_screen.dart`.

### 5. Feature Generator (`lib/src/generator/feature_generator.dart`)
- Implement `_generateModular(Map<String, String> files, String snake, String pascal, String camel, ProjectConfig config)`:
  - `lib/modules/$snake/models/${snake}_model.dart`
  - `lib/modules/$snake/repositories/${snake}_repository.dart`
  - `lib/modules/$snake/logic/${snake}_controller.dart` (or `_cubit.dart` / `_notifier.dart`)
  - `lib/modules/$snake/providers/${snake}_provider.dart`
  - `lib/modules/$snake/screens/${snake}_screen.dart`

### 6. Make Command (`lib/src/commands/make_command.dart`)
- Update path resolution for subcommands in modular projects:
  - `make screen <name> [module]` -> `lib/modules/<module>/screens/<name>_screen.dart`
  - `make model <name> [module]` -> `lib/modules/<module>/models/<name>_model.dart`
  - `make repository <name> [module]` -> `lib/modules/<module>/repositories/<name>_repository.dart`
  - `make controller <name> [module]` -> `lib/modules/<module>/logic/<name>_controller.dart`
  - `make provider <name> [module]` -> `lib/modules/<module>/providers/<name>_provider.dart`

---

## Verification & Testing Plan

### Automated Tests
1. **`test/models_test.dart`**:
   - Verify `ArchitecturePattern.fromKey('modular')` returns `ArchitecturePattern.modular`.
   - Verify JSON serialization and deserialization via `ProjectConfig`.
2. **`test/choice_catalog_test.dart`**:
   - Verify `ChoiceCatalog.architecture()` includes `ArchitecturePattern.modular`.
3. **`test/template_engine_test.dart`**:
   - Test generating a modular project with Riverpod:
     - Verify files in `lib/modules/counter/` (`models/`, `repositories/`, `logic/`, `providers/`, `screens/`).
     - Verify `lib/core/routes/app_router.dart` and `lib/core/theme/`.
     - Verify `lib/main.dart` imports.
   - Test generating a modular project with BLoC:
     - Verify `counter_cubit.dart` in `logic/`, `counter_provider.dart` in `providers/`.
4. **`test/feature_command_test.dart`**:
   - Test `fkit feature profile` on a modular project generates in `lib/modules/profile/`.
5. **`test/make_command_test.dart`**:
   - Test `fkit make screen login auth` in a modular project generates `lib/modules/auth/screens/login_screen.dart`.
6. **Code Quality**:
   - Run `dart analyze` — must have 0 warnings and 0 errors.
   - Run `dart test` — all test suites must pass.
