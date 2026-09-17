import 'dart:io';
import 'package:fkit_cli/fkit_cli.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  group('FlavorConfigurator & FlavorCommand', () {
    late Directory tempDir;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('fkit_flavor_test_');
    });

    tearDown(() {
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    });

    test('configures Android Gradle Kotlin, iOS xcconfigs, entrypoints, and vscode launch', () async {
      // Mock Android directory
      final androidAppDir = Directory(p.join(tempDir.path, 'android', 'app'))..createSync(recursive: true);
      final ktsFile = File(p.join(androidAppDir.path, 'build.gradle.kts'));
      ktsFile.writeAsStringSync('''
plugins {
    id("com.android.application")
}

android {
    namespace = "com.example.mockapp"
    compileSdk = 34
}
''');

      // Mock iOS Flutter directory
      Directory(p.join(tempDir.path, 'ios', 'Flutter'))..createSync(recursive: true);

      // Mock lib directory
      final libDir = Directory(p.join(tempDir.path, 'lib'))..createSync(recursive: true);
      File(p.join(libDir.path, 'main.dart')).writeAsStringSync('void main() {}');

      final runner = FkitCommandRunner();
      final exitCode = await runner.run(['flavor', '-p', tempDir.path, '-f', 'dev,staging,prod']);

      expect(exitCode, equals(0));

      // 1. Android build.gradle.kts updated with productFlavors
      final updatedKts = ktsFile.readAsStringSync();
      expect(updatedKts, contains('flavorDimensions += "default"'));
      expect(updatedKts, contains('create("dev")'));
      expect(updatedKts, contains('create("staging")'));
      expect(updatedKts, contains('create("prod")'));

      // 2. iOS xcconfig files generated
      expect(File(p.join(tempDir.path, 'ios', 'Flutter', 'Debug-dev.xcconfig')).existsSync(), isTrue);
      expect(File(p.join(tempDir.path, 'ios', 'Flutter', 'Release-prod.xcconfig')).existsSync(), isTrue);

      // 3. Dart entrypoints generated
      expect(File(p.join(tempDir.path, 'lib', 'main_dev.dart')).existsSync(), isTrue);
      expect(File(p.join(tempDir.path, 'lib', 'main_staging.dart')).existsSync(), isTrue);
      expect(File(p.join(tempDir.path, 'lib', 'main_prod.dart')).existsSync(), isTrue);

      // 4. .vscode/launch.json generated
      final launchJson = File(p.join(tempDir.path, '.vscode', 'launch.json'));
      expect(launchJson.existsSync(), isTrue);
      final launchContent = launchJson.readAsStringSync();
      expect(launchContent, contains('"name": "Flutter (DEV)"'));
      expect(launchContent, contains('"name": "Flutter (PROD)"'));
      expect(launchContent, contains('"--flavor"'));
    });
  });
}
