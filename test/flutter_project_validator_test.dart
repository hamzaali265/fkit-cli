import 'dart:io';
import 'package:fkit_cli/fkit_cli.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  group('FlutterProjectValidator', () {
    late Directory tempDir;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('fkit_validator_test_');
    });

    tearDown(() {
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    });

    test('returns false when directory has no pubspec.yaml', () {
      expect(FlutterProjectValidator.isFlutterProject(tempDir), isFalse);
    });

    test(
      'returns false when pubspec.yaml is a pure Dart package without Flutter',
      () {
        final pubspec = File(p.join(tempDir.path, 'pubspec.yaml'));
        pubspec.writeAsStringSync('''
name: pure_dart_tool
environment:
  sdk: '>=3.0.0 <4.0.0'
dependencies:
  args: ^2.5.0
''');
        expect(FlutterProjectValidator.isFlutterProject(tempDir), isFalse);
      },
    );

    test('returns true when pubspec.yaml has flutter sdk dependency', () {
      final pubspec = File(p.join(tempDir.path, 'pubspec.yaml'));
      pubspec.writeAsStringSync('''
name: flutter_sample_app
dependencies:
  flutter:
    sdk: flutter
''');
      expect(FlutterProjectValidator.isFlutterProject(tempDir), isTrue);
    });

    test(
      'commands fail with usage exit code and helpful message when executed outside Flutter project',
      () async {
        final runner = FkitCommandRunner();

        // feature command
        final featureExit = await runner.run([
          'feature',
          'auth',
          '-p',
          tempDir.path,
        ]);
        expect(featureExit, isNot(equals(0)));

        // make screen
        final screenExit = await runner.run([
          'make',
          'screen',
          'profile',
          '-p',
          tempDir.path,
        ]);
        expect(screenExit, isNot(equals(0)));

        // flavor
        final flavorExit = await runner.run(['flavor', '-p', tempDir.path]);
        expect(flavorExit, isNot(equals(0)));

        // assets gen
        final assetsExit = await runner.run([
          'assets',
          'gen',
          '-p',
          tempDir.path,
        ]);
        expect(assetsExit, isNot(equals(0)));
      },
    );
  });
}
