import 'package:fkit/fkit.dart';
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
      expect(
        options.every((o) => o.shortDescription.isNotEmpty),
        isTrue,
      );
    });
  });
}
