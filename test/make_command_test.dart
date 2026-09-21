import 'dart:io';
import 'package:fkit_cli/fkit_cli.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  group('MakeCommand', () {
    late Directory tempDir;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('fkit_make_test_');
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

    test(
      'makes screen, controller, model, and service in Feature-first BLoC project',
      () async {
        final fkitJson = '''
{
  "name": "mock_app",
  "architecture": "featureFirst",
  "state_management": "bloc",
  "routing": "goRouter",
  "networking": "dio",
  "storage": "sharedPreferences",
  "features": []
}
''';
        File(p.join(tempDir.path, '.fkit.json')).writeAsStringSync(fkitJson);

        final runner = FkitCommandRunner();

        // 1. screen
        var exitCode = await runner.run([
          'make',
          'screen',
          'checkout',
          '-p',
          tempDir.path,
        ]);
        expect(exitCode, equals(0));
        expect(
          File(
            p.join(
              tempDir.path,
              'lib/features/checkout/presentation/views/checkout_view.dart',
            ),
          ).existsSync(),
          isTrue,
        );

        // 2. controller
        exitCode = await runner.run([
          'make',
          'controller',
          'checkout',
          '-p',
          tempDir.path,
        ]);
        expect(exitCode, equals(0));
        expect(
          File(
            p.join(
              tempDir.path,
              'lib/features/checkout/presentation/bloc/checkout_cubit.dart',
            ),
          ).existsSync(),
          isTrue,
        );

        // 3. model
        exitCode = await runner.run([
          'make',
          'model',
          'checkout_item',
          '-p',
          tempDir.path,
        ]);
        expect(exitCode, equals(0));
        expect(
          File(
            p.join(
              tempDir.path,
              'lib/features/checkout_item/data/models/checkout_item_model.dart',
            ),
          ).existsSync(),
          isTrue,
        );

        // 4. service
        exitCode = await runner.run([
          'make',
          'service',
          'payment',
          '-p',
          tempDir.path,
        ]);
        expect(exitCode, equals(0));
        expect(
          File(
            p.join(
              tempDir.path,
              'lib/features/payment/data/datasources/payment_remote_data_source.dart',
            ),
          ).existsSync(),
          isTrue,
        );
      },
    );

    test('makes screen and viewmodel in MVVM Riverpod project', () async {
      final fkitJson = '''
{
  "name": "mvvm_app",
  "architecture": "mvvm",
  "state_management": "riverpod",
  "routing": "goRouter",
  "networking": "dio",
  "storage": "sharedPreferences",
  "features": []
}
''';
      File(p.join(tempDir.path, '.fkit.json')).writeAsStringSync(fkitJson);

      final runner = FkitCommandRunner();

      // Screen
      var exitCode = await runner.run([
        'make',
        'screen',
        'settings',
        '-p',
        tempDir.path,
      ]);
      expect(exitCode, equals(0));
      expect(
        File(p.join(tempDir.path, 'lib/views/settings_view.dart')).existsSync(),
        isTrue,
      );

      // Controller / ViewModel
      exitCode = await runner.run([
        'make',
        'controller',
        'settings',
        '-p',
        tempDir.path,
      ]);
      expect(exitCode, equals(0));
      expect(
        File(
          p.join(tempDir.path, 'lib/viewmodels/settings_notifier.dart'),
        ).existsSync(),
        isTrue,
      );
    });

    test('makes screen, controller, model, and service in Modular Riverpod project', () async {
      final fkitJson = '''
{
  "name": "modular_app",
  "architecture": "modular",
  "state_management": "riverpod",
  "routing": "goRouter",
  "networking": "dio",
  "storage": "sharedPreferences",
  "features": []
}
''';
      File(p.join(tempDir.path, '.fkit.json')).writeAsStringSync(fkitJson);

      final runner = FkitCommandRunner();

      // Screen
      var exitCode = await runner.run([
        'make',
        'screen',
        'login',
        '-p',
        tempDir.path,
      ]);
      expect(exitCode, equals(0));
      expect(
        File(p.join(tempDir.path, 'lib/modules/login/screens/login_screen.dart')).existsSync(),
        isTrue,
      );

      // Controller
      exitCode = await runner.run([
        'make',
        'controller',
        'login',
        '-p',
        tempDir.path,
      ]);
      expect(exitCode, equals(0));
      expect(
        File(p.join(tempDir.path, 'lib/modules/login/logic/login_notifier.dart')).existsSync(),
        isTrue,
      );

      // Model
      exitCode = await runner.run([
        'make',
        'model',
        'login_request',
        '-p',
        tempDir.path,
      ]);
      expect(exitCode, equals(0));
      expect(
        File(p.join(tempDir.path, 'lib/modules/login_request/models/login_request_model.dart')).existsSync(),
        isTrue,
      );

      // Service / Repository
      exitCode = await runner.run([
        'make',
        'service',
        'auth',
        '-p',
        tempDir.path,
      ]);
      expect(exitCode, equals(0));
      expect(
        File(p.join(tempDir.path, 'lib/modules/auth/repositories/auth_repository.dart')).existsSync(),
        isTrue,
      );
    });
  });
}
