# Modular Architecture Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement the new Modular architecture pattern (`ArchitecturePattern.modular`) in FKIT CLI, supporting `lib/modules/<module>/` with `logic/`, `providers/`, `repositories/`, `screens/`, `models/`, alongside `lib/core/` and `lib/shared/`.

**Architecture:** Add `ArchitecturePattern.modular` as a first-class architecture enum. Integrate into configuration serialization, wizard choice catalog, ASCII diagrams, CLI command flags, template engine generation, feature generator, and make subcommands.

**Tech Stack:** Dart 3.x, Flutter CLI tools, package:test.

**Spec:** [docs/superpowers/specs/2026-09-21-modular-architecture-design.md](file:///Users/hamza/Work/fkit/docs/superpowers/specs/2026-09-21-modular-architecture-design.md)

## Global Constraints
- Target architecture folder is `lib/modules/<module_name>/`.
- Cross-cutting concerns live in `lib/core/` and `lib/shared/`.
- Must support all existing state management options (Riverpod, BLoC, Provider, GetX, None).
- `dart analyze` must pass with 0 errors and 0 warnings.
- All existing and new tests in `test/` must pass.

---

### Task 1: Core Data Models & Config Support

**Files:**
- Modify: `lib/src/models/project_config.dart`
- Test: `test/models_test.dart`

**Interfaces:**
- Consumes: `enum ArchitecturePattern`
- Produces: `ArchitecturePattern.modular`, keys `'modular'`, `'module'`, `'modules'` supported in `fromKey`, JSON serialization `"modular"`.

- [ ] **Step 1: Write failing unit test in `test/models_test.dart`**
  Add test checking `ArchitecturePattern.fromKey('modular')`, `ArchitecturePattern.fromKey('module')`, and `ArchitecturePattern.fromKey('modules')` return `ArchitecturePattern.modular`, and JSON roundtrip serialization works with `ArchitecturePattern.modular`.

- [ ] **Step 2: Run test to verify it fails**
  Run: `dart test test/models_test.dart`
  Expected: FAIL with "modular is not defined" or similar.

- [ ] **Step 3: Implement `ArchitecturePattern.modular` in `lib/src/models/project_config.dart`**
  Add `modular` enum value:
  ```dart
  modular(
    'Modular',
    'Module-driven architecture grouped by domain modules (lib/modules/<name>/{logic, providers, repositories, screens, models})',
  ),
  ```
  And update `fromKey`:
  ```dart
  case 'modular':
  case 'module':
  case 'modules':
    return ArchitecturePattern.modular;
  ```

- [ ] **Step 4: Run test to verify it passes**
  Run: `dart test test/models_test.dart`
  Expected: PASS

- [ ] **Step 5: Commit**
  ```bash
  git add lib/src/models/project_config.dart test/models_test.dart
  git commit -m "feat(models): add ArchitecturePattern.modular"
  ```

---

### Task 2: CLI Options, Wizard Catalog & Architecture Diagrams

**Files:**
- Modify: `lib/src/prompts/choice_catalog.dart`
- Modify: `lib/src/prompts/architecture_diagrams.dart`
- Modify: `lib/src/commands/create_command.dart`
- Modify: `lib/src/commands/list_command.dart`
- Test: `test/choice_catalog_test.dart`

**Interfaces:**
- Consumes: `ArchitecturePattern.modular`
- Produces: `ChoiceCatalog.architecture()` includes `modular`, `ArchitectureDiagrams.forPattern` renders modular tree, `create` command accepts `'modular'`.

- [ ] **Step 1: Write failing test in `test/choice_catalog_test.dart`**
  Verify `ChoiceCatalog.architecture()` contains option with value `ArchitecturePattern.modular` and label `'Modular'`.

- [ ] **Step 2: Run test to verify it fails**
  Run: `dart test test/choice_catalog_test.dart`
  Expected: FAIL (missing option or wrong subtitle)

- [ ] **Step 3: Update catalog, diagrams, and CLI commands**
  - In `lib/src/prompts/choice_catalog.dart`: add `ArchitecturePattern.modular => 'modules · logic · screens'`.
  - In `lib/src/prompts/architecture_diagrams.dart`: add case `ArchitecturePattern.modular` returning the ASCII module tree diagram.
  - In `lib/src/commands/create_command.dart`: add `'modular'` to `--architecture` allowed options and documentation.
  - In `lib/src/commands/list_command.dart`: ensure list formats correctly.

- [ ] **Step 4: Run test to verify it passes**
  Run: `dart test test/choice_catalog_test.dart`
  Expected: PASS

- [ ] **Step 5: Commit**
  ```bash
  git add lib/src/prompts/ lib/src/commands/ test/choice_catalog_test.dart
  git commit -m "feat(cli): add modular architecture to wizard catalog and create command"
  ```

---

### Task 3: Starter Project Scaffolding in Template Engine

**Files:**
- Modify: `lib/src/generator/template_engine.dart`
- Test: `test/template_engine_test.dart`

**Interfaces:**
- Consumes: `ProjectConfig` with `architecture: ArchitecturePattern.modular`
- Produces: Generated project file map containing `lib/modules/counter/{models,repositories,logic,providers,screens}`, `lib/core/`, `lib/shared/`, and correct imports in `main.dart` and `app_router.dart`.

- [ ] **Step 1: Write failing test in `test/template_engine_test.dart`**
  Add tests for `ArchitecturePattern.modular` with Riverpod and BLoC:
  - Expect `lib/modules/counter/models/counter_model.dart`
  - Expect `lib/modules/counter/repositories/counter_repository.dart`
  - Expect `lib/modules/counter/logic/counter_controller.dart` (or cubit)
  - Expect `lib/modules/counter/providers/counter_provider.dart`
  - Expect `lib/modules/counter/screens/counter_screen.dart`
  - Expect `lib/core/routes/app_router.dart` importing `counter_screen.dart`
  - Expect `lib/core/theme/theme.dart`
  - Expect `lib/main.dart` importing core and counter screen.

- [ ] **Step 2: Run test to verify it fails**
  Run: `dart test test/template_engine_test.dart`
  Expected: FAIL

- [ ] **Step 3: Implement modular scaffolding in `lib/src/generator/template_engine.dart`**
  - Set `final isModular = config.architecture == ArchitecturePattern.modular;`
  - Include `isModular` in `usesCoreDir = isFeatureFirst || isLayerFirst || isModular;`
  - In architecture branch:
    ```dart
    final moduleRoot = 'lib/modules/counter';
    files['$moduleRoot/models/counter_model.dart'] = ...;
    files['$moduleRoot/repositories/counter_repository.dart'] = ...;
    files['$moduleRoot/logic/counter_controller.dart'] = ...;
    files['$moduleRoot/providers/counter_provider.dart'] = ...;
    files['$moduleRoot/screens/counter_screen.dart'] = ...;
    ```
  - Set `routerRelPath = 'lib/core/routes/app_router.dart'` and screen imports.

- [ ] **Step 4: Run test to verify it passes**
  Run: `dart test test/template_engine_test.dart`
  Expected: PASS

- [ ] **Step 5: Commit**
  ```bash
  git add lib/src/generator/template_engine.dart test/template_engine_test.dart
  git commit -m "feat(generator): support modular architecture in TemplateEngine"
  ```

---

### Task 4: Feature Generator Support (`fkit feature <name>`)

**Files:**
- Modify: `lib/src/generator/feature_generator.dart`
- Test: `test/feature_command_test.dart`

**Interfaces:**
- Consumes: `FeatureGenerator.generateFeature(featureName: ..., config: ...)` with `ArchitecturePattern.modular`
- Produces: Map of files under `lib/modules/<snake>/` (`models`, `repositories`, `logic`, `providers`, `screens`).

- [ ] **Step 1: Write failing test in `test/feature_command_test.dart`**
  Add test verifying feature generation under modular architecture outputs files in `lib/modules/<snake>/`.

- [ ] **Step 2: Run test to verify it fails**
  Run: `dart test test/feature_command_test.dart`
  Expected: FAIL

- [ ] **Step 3: Implement `_generateModular` in `lib/src/generator/feature_generator.dart`**
  Add case `ArchitecturePattern.modular` in `generateFeature` calling `_generateModular(...)`:
  - `lib/modules/$snake/models/${snake}_model.dart`
  - `lib/modules/$snake/repositories/${snake}_repository.dart`
  - `lib/modules/$snake/logic/${snake}_controller.dart` (or cubit/notifier)
  - `lib/modules/$snake/providers/${snake}_provider.dart`
  - `lib/modules/$snake/screens/${snake}_screen.dart`

- [ ] **Step 4: Run test to verify it passes**
  Run: `dart test test/feature_command_test.dart`
  Expected: PASS

- [ ] **Step 5: Commit**
  ```bash
  git add lib/src/generator/feature_generator.dart test/feature_command_test.dart
  git commit -m "feat(generator): implement modular feature scaffolding in FeatureGenerator"
  ```

---

### Task 5: Make Subcommands Resolution (`fkit make`)

**Files:**
- Modify: `lib/src/commands/make_command.dart`
- Test: `test/make_command_test.dart`

**Interfaces:**
- Consumes: `MakeCommand` subcommands (`screen`, `model`, `repository`, `controller`, `provider`)
- Produces: Correct relative path inside `lib/modules/<module>/...` when project architecture is `ArchitecturePattern.modular`.

- [ ] **Step 1: Write failing test in `test/make_command_test.dart`**
  Add test verifying that in a project with `architecture: modular`, `fkit make screen login auth` outputs to `lib/modules/auth/screens/login_screen.dart`, etc.

- [ ] **Step 2: Run test to verify it fails**
  Run: `dart test test/make_command_test.dart`
  Expected: FAIL

- [ ] **Step 3: Update `lib/src/commands/make_command.dart`**
  Update target path calculations in each `Make*Command` to check for `ArchitecturePattern.modular` and route to `lib/modules/<module>/<folder>/`.

- [ ] **Step 4: Run test to verify it passes**
  Run: `dart test test/make_command_test.dart`
  Expected: PASS

- [ ] **Step 5: Commit**
  ```bash
  git add lib/src/commands/make_command.dart test/make_command_test.dart
  git commit -m "feat(commands): support modular architecture in make subcommands"
  ```

---

### Task 6: Full Verification, Documentation & Static Analysis

**Files:**
- Modify: `README.md` (if architectures are documented)
- Verify: Entire repository

- [ ] **Step 1: Run static analysis**
  Run: `dart analyze`
  Expected: No issues found!

- [ ] **Step 2: Run all tests**
  Run: `dart test`
  Expected: All tests pass.

- [ ] **Step 3: Update documentation if needed**
  Update `README.md` to mention Modular architecture alongside Feature-First, Layer-First, MVVM, MVC.

- [ ] **Step 4: Commit**
  ```bash
  git add .
  git commit -m "docs: document modular architecture pattern and verify all tests pass"
  ```
