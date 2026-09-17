import 'dart:io';
import 'package:fkit_cli/fkit_cli.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  group('DoctorCommand', () {
    late Directory tempDir;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('fkit_doctor_test_');
    });

    tearDown(() {
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    });

    test('runs doctor successfully in a project with pubspec.yaml and .fkit.json', () async {
      File(p.join(tempDir.path, 'pubspec.yaml')).writeAsStringSync('name: test_app\n');
      File(p.join(tempDir.path, '.fkit.json')).writeAsStringSync('{"name": "test_app"}');

      final runner = FkitCommandRunner();
      final exitCode = await runner.run(['doctor', '-p', tempDir.path]);

      expect(exitCode, equals(0));
    });
  });
}
