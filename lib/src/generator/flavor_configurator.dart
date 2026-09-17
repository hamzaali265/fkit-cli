import 'dart:io';
import 'package:path/path.dart' as p;

/// Configures Android Gradle product flavors, iOS schemes/xcconfigs,
/// Dart entrypoints, and VS Code launch configurations.
class FlavorConfigurator {
  const FlavorConfigurator();

  /// Applies flavors setup to the project in [targetDir].
  void setupFlavors({
    required String targetDir,
    List<String> flavors = const ['dev', 'staging', 'prod'],
    String? packageName,
  }) {
    _configureAndroid(targetDir, flavors);
    _configureIos(targetDir, flavors);
    _configureDartEntrypoints(targetDir, flavors);
    _configureVsCodeLaunch(targetDir, flavors, packageName);
  }

  void _configureAndroid(String targetDir, List<String> flavors) {
    // 1. Check build.gradle.kts or build.gradle
    final ktsFile = File(
      p.join(targetDir, 'android', 'app', 'build.gradle.kts'),
    );
    final groovyFile = File(
      p.join(targetDir, 'android', 'app', 'build.gradle'),
    );

    if (ktsFile.existsSync()) {
      var content = ktsFile.readAsStringSync();
      if (!content.contains('flavorDimensions')) {
        final flavorBlock =
            '''
    flavorDimensions += "default"
    productFlavors {
${flavors.map((f) => '''        create("$f") {
            dimension = "default"
            ${f != 'prod' ? 'applicationIdSuffix = ".$f"' : ''}
            resValue("string", "app_name", "${f == 'prod' ? 'App' : 'App ($f)'}")
        }''').join('\n')}
    }
''';
        // Insert inside android { ... }
        final androidIdx = content.indexOf('android {');
        if (androidIdx != -1) {
          final insertPos = content.indexOf('{', androidIdx) + 1;
          content =
              '${content.substring(0, insertPos)}\n$flavorBlock${content.substring(insertPos)}';
          ktsFile.writeAsStringSync(content);
        }
      }
    } else if (groovyFile.existsSync()) {
      var content = groovyFile.readAsStringSync();
      if (!content.contains('flavorDimensions')) {
        final flavorBlock =
            '''
    flavorDimensions "default"
    productFlavors {
${flavors.map((f) => '''        $f {
            dimension "default"
            ${f != 'prod' ? 'applicationIdSuffix ".$f"' : ''}
            resValue "string", "app_name", "${f == 'prod' ? 'App' : 'App ($f)'}"
        }''').join('\n')}
    }
''';
        final androidIdx = content.indexOf('android {');
        if (androidIdx != -1) {
          final insertPos = content.indexOf('{', androidIdx) + 1;
          content =
              '${content.substring(0, insertPos)}\n$flavorBlock${content.substring(insertPos)}';
          groovyFile.writeAsStringSync(content);
        }
      }
    }
  }

  void _configureIos(String targetDir, List<String> flavors) {
    final flutterDir = Directory(p.join(targetDir, 'ios', 'Flutter'));
    if (!flutterDir.existsSync()) return;

    for (final flavor in flavors) {
      final debugXconfig = File(
        p.join(flutterDir.path, 'Debug-$flavor.xcconfig'),
      );
      if (!debugXconfig.existsSync()) {
        debugXconfig.writeAsStringSync(
          '''#include? "Pods/Target Support Files/Pods-Runner/Pods-Runner.debug.xcconfig"
#include "Generated.xcconfig"
#include "Debug.xcconfig"

APP_DISPLAY_NAME=${flavor == 'prod' ? 'App' : 'App ($flavor)'}
''',
        );
      }

      final releaseXconfig = File(
        p.join(flutterDir.path, 'Release-$flavor.xcconfig'),
      );
      if (!releaseXconfig.existsSync()) {
        releaseXconfig.writeAsStringSync(
          '''#include? "Pods/Target Support Files/Pods-Runner/Pods-Runner.release.xcconfig"
#include "Generated.xcconfig"
#include "Release.xcconfig"

APP_DISPLAY_NAME=${flavor == 'prod' ? 'App' : 'App ($flavor)'}
''',
        );
      }
    }
  }

  void _configureDartEntrypoints(String targetDir, List<String> flavors) {
    final libDir = Directory(p.join(targetDir, 'lib'));
    if (!libDir.existsSync()) return;

    for (final flavor in flavors) {
      final mainFlavor = File(p.join(libDir.path, 'main_$flavor.dart'));
      if (!mainFlavor.existsSync()) {
        mainFlavor.writeAsStringSync('''import 'package:flutter/material.dart';
import 'main.dart' as runner;

/// Entrypoint for $flavor environment.
void main() {
  // Can configure environment-specific baseUrl, analytics, etc.
  runner.main();
}
''');
      }
    }
  }

  void _configureVsCodeLaunch(
    String targetDir,
    List<String> flavors,
    String? packageName,
  ) {
    final vscodeDir = Directory(p.join(targetDir, '.vscode'));
    vscodeDir.createSync(recursive: true);

    final launchJson = File(p.join(vscodeDir.path, 'launch.json'));
    if (!launchJson.existsSync()) {
      final configs = flavors
          .map(
            (f) =>
                '''    {
      "name": "Flutter (${f.toUpperCase()})",
      "request": "launch",
      "type": "dart",
      "program": "lib/main_$f.dart",
      "args": [
        "--flavor",
        "$f"
      ]
    }''',
          )
          .join(',\n');

      launchJson.writeAsStringSync('''{
  "version": "0.2.0",
  "configurations": [
$configs
  ]
}
''');
    }
  }
}
