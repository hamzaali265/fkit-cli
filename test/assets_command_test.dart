import 'dart:io';
import 'package:fkit_cli/fkit_cli.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  group('AssetManager & AssetsCommand', () {
    late Directory tempDir;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('fkit_assets_test_');
      File(p.join(tempDir.path, 'pubspec.yaml')).writeAsStringSync('''
name: mock_app
dependencies:
  flutter:
    sdk: flutter
''');
    });

    tearDown(() {
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    });

    test('generates AppAssets class with type-safe constant paths', () async {
      final assetsImages = Directory(p.join(tempDir.path, 'assets', 'images'))..createSync(recursive: true);
      final assetsIcons = Directory(p.join(tempDir.path, 'assets', 'icons'))..createSync(recursive: true);

      File(p.join(assetsImages.path, 'logo.png')).writeAsStringSync('');
      File(p.join(assetsIcons.path, 'home_icon.svg')).writeAsStringSync('');

      final runner = FkitCommandRunner();
      final exitCode = await runner.run(['assets', 'gen', '-p', tempDir.path]);

      expect(exitCode, equals(0));

      final generatedFile = File(p.join(tempDir.path, 'lib', 'constants', 'app_assets.dart'));
      expect(generatedFile.existsSync(), isTrue);

      final content = generatedFile.readAsStringSync();
      expect(content, contains('abstract class AppAssets {'));
      expect(content, contains("static const String logoPng = 'assets/images/logo.png';"));
      expect(content, contains("static const String homeIconSvg = 'assets/icons/home_icon.svg';"));
    });

    test('detects unused assets and deletes them when requested', () async {
      final assetsImages = Directory(p.join(tempDir.path, 'assets', 'images'))..createSync(recursive: true);
      final libDir = Directory(p.join(tempDir.path, 'lib'))..createSync(recursive: true);

      final usedFile = File(p.join(assetsImages.path, 'used.png'))..writeAsStringSync('');
      final unusedFile = File(p.join(assetsImages.path, 'orphan.png'))..writeAsStringSync('');

      // Reference only used.png in code
      File(p.join(libDir.path, 'main.dart')).writeAsStringSync("final img = 'assets/images/used.png';");

      final runner = FkitCommandRunner();

      // 1. Dry run clean (does not delete)
      var exitCode = await runner.run(['assets', 'clean', '-p', tempDir.path]);
      expect(exitCode, equals(0));
      expect(unusedFile.existsSync(), isTrue);

      // 2. Clean with --delete flag
      exitCode = await runner.run(['assets', 'clean', '-p', tempDir.path, '--delete']);
      expect(exitCode, equals(0));
      expect(unusedFile.existsSync(), isFalse);
      expect(usedFile.existsSync(), isTrue);
    });
  });
}
