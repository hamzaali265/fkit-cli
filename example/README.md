# FKIT CLI Examples

This directory contains examples demonstrating how to use `fkit_cli` both as a command-line tool and programmatically in Dart.

## 1. CLI Usage Examples

### Scaffold a New Project

Scaffold a complete Flutter application with the interactive wizard:
```bash
fkit create my_app
```

Or non-interactively with specific presets:
```bash
fkit create my_app \
  --architecture feature-first \
  --state bloc \
  --routing go_router \
  --networking dio \
  --storage hive \
  --get-it \
  --no-interactive
```

### Scaffold Features & Components

Add a Clean Architecture feature slice:
```bash
fkit feature add authentication
```

Generate screens, widgets, services, models, and state controllers:
```bash
fkit make screen user_profile
fkit make widget custom_card
fkit make service auth_service
fkit make bloc login
```

### Configure Flavors & Assets

Add environment flavors for Android, iOS, and VS Code:
```bash
fkit flavor add staging --app-name "App Staging" --app-id "com.example.staging"
```

Generate type-safe asset references or clean up unused assets:
```bash
fkit assets gen
fkit assets clean
```

### Check System & Project Health

Verify Flutter SDK, CocoaPods, Android toolchain, and project readiness:
```bash
fkit doctor
```

---

## 2. Programmatic Usage Example

You can also import `package:fkit_cli` in your Dart scripts:

```dart
import 'dart:io';
import 'package:fkit_cli/fkit_cli.dart';

void main() async {
  // Access command runner directly
  final runner = FkitCommandRunner();
  await runner.run(['list']);

  // Or inspect architectures and models
  for (final pattern in ArchitecturePattern.values) {
    print('${pattern.label}: ${pattern.description}');
  }
}
```

Run the example:
```bash
dart run example/main.dart
```
