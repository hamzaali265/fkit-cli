import 'package:fkit_cli/fkit_cli.dart';
import 'package:test/test.dart';

void main() {
  group('ChoiceCatalog', () {
    test('architecture options include short hints and details', () {
      final options = ChoiceCatalog.architecture();
      expect(options, hasLength(4));
      expect(options.first.label, equals('Feature-first'));
      expect(options.first.shortDescription, equals('by feature'));
      expect(options.first.detail, contains('features'));
      expect(options.first.diagram, isNotEmpty);
      expect(options.first.diagram.first, contains('lib/'));
    });

    test('state options stay compact', () {
      final options = ChoiceCatalog.state();
      expect(options.map((o) => o.label), containsAll(['BLoC', 'Riverpod']));
      expect(options.every((o) => o.shortDescription.isNotEmpty), isTrue);
    });

    test('utilities catalog includes all new packages', () {
      final options = ChoiceCatalog.utilities();
      expect(
        options.map((o) => o.label),
        containsAll([
          'intl',
          'uuid',
          'equatable',
          'sqflite',
          'crypto',
          'webview_flutter',
          'geolocator',
        ]),
      );
      final geoOption = options.firstWhere((o) => o.label == 'geolocator');
      expect(geoOption.shortDescription, equals('location'));
    });

    test('storage catalog includes sqflite', () {
      final options = ChoiceCatalog.storage();
      expect(
        options.map((o) => o.label),
        containsAll(['shared_preferences', 'hive_flutter', 'sqflite']),
      );
      final sqfliteOption = options.firstWhere((o) => o.label == 'sqflite');
      expect(sqfliteOption.shortDescription, equals('sqlite db'));
    });
  });
}
