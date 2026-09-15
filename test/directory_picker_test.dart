import 'dart:io';

import 'package:fkit_cli/fkit.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  group('DirectoryPicker', () {
    test('resolveTargetDirectory joins parent and project name', () {
      final target = DirectoryPicker.resolveTargetDirectory(
        '/Users/hamza/Work',
        'my_app',
      );
      expect(target, equals(p.normalize(p.absolute('/Users/hamza/Work/my_app'))));
    });

    test('listChildDirectories returns sorted non-hidden dirs', () {
      final root = Directory.systemTemp.createTempSync('fkit_picker_');
      addTearDown(() {
        if (root.existsSync()) {
          root.deleteSync(recursive: true);
        }
      });

      Directory(p.join(root.path, 'zeta')).createSync();
      Directory(p.join(root.path, 'alpha')).createSync();
      Directory(p.join(root.path, '.hidden')).createSync();
      File(p.join(root.path, 'file.txt')).writeAsStringSync('x');

      expect(
        DirectoryPicker.listChildDirectories(root),
        equals(['alpha', 'zeta']),
      );
    });

    test('displayPath replaces home prefix with tilde', () {
      final home = Platform.environment['HOME'];
      if (home == null || home.isEmpty) {
        return;
      }
      expect(
        DirectoryPicker.displayPath(p.join(home, 'Work')),
        equals('~/Work'),
      );
      expect(DirectoryPicker.displayPath('/tmp/other'), equals('/tmp/other'));
    });
  });

  group('HomeAction', () {
    test('defaultActions include create, list, coming soon, and quit', () {
      final ids = HomeScreen.defaultActions.map((a) => a.id).toList();
      expect(ids, equals(['create', 'list', 'coming_soon', 'quit']));
      expect(
        HomeScreen.defaultActions
            .firstWhere((a) => a.id == 'coming_soon')
            .enabled,
        isFalse,
      );
    });
  });
}
