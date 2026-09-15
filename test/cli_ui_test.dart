import 'package:fkit_cli/fkit_cli.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:test/test.dart';

void main() {
  group('CliUi', () {
    late _MockLogger logger;
    late CliUi ui;

    setUp(() {
      logger = _MockLogger();
      ui = CliUi(logger);
    });

    test('printHeroBanner prints Welcome to FKIT CLI and version', () {
      ui.printHeroBanner(version: '1.2.3', columns: 80);
      final output = logger.logs.join('\n');

      expect(output, contains('Welcome to FKIT CLI!'));
      expect(output, contains('v1.2.3'));
      expect(output, contains('Modern Flutter scaffolding for production apps.'));
      expect(output, contains('██'));
    });

    test('printHeroBanner falls back on narrow terminals', () {
      ui.printHeroBanner(version: '1.0.0', columns: 20);
      final output = logger.logs.join('\n');

      expect(output, contains('Welcome to FKIT CLI!'));
      expect(output, contains('FKIT CLI'));
      expect(output, isNot(contains('██')));
    });

    test('printStepHeader prints formatted step badge and description', () {
      ui.printStepHeader(
        step: 2,
        total: 8,
        title: 'Architecture Pattern',
        description: 'Choose code layers',
      );
      final output = logger.logs.join('\n');

      expect(output, contains('2/8'));
      expect(output, contains('Architecture Pattern'));
      expect(output, contains('Choose code layers'));
    });

    test('printSummaryCard wraps long values inside aligned borders', () {
      final config = ProjectConfig(
        projectName: 'demo_app',
        orgName: 'com.demo',
        targetDirectory:
            '/Users/hamza/Work/very/long/path/to/project/demo_app',
        architecture: ArchitecturePattern.featureFirst,
        stateManagement: StateManagement.bloc,
        routing: Routing.goRouter,
        networking: Networking.dio,
        storage: Storage.hive,
        features: {
          ProjectFeature.strictLinting,
          ProjectFeature.localization,
          ProjectFeature.assetsStructure,
          ProjectFeature.envFlavors,
        },
        utilities: {
          UtilityPackage.flutterSvg,
          UtilityPackage.cachedNetworkImage,
          UtilityPackage.imagePicker,
          UtilityPackage.filePicker,
          UtilityPackage.permissionHandler,
          UtilityPackage.urlLauncher,
          UtilityPackage.uuid,
        },
      );

      ui.printSummaryCard(config);
      final lines = logger.logs.where((l) => l.contains('│')).toList();

      expect(lines, isNotEmpty);
      final widths = lines.map(CliTheme.visibleLength).toSet();
      expect(widths.length, equals(1), reason: 'all box rows same width');
      expect(logger.logs.join('\n'), contains('Summary'));
      expect(logger.logs.join('\n'), contains('demo_app'));
    });

    test('printSuccessCard renders clean instructions and commands', () {
      final config = ProjectConfig(
        projectName: 'demo_app',
        orgName: 'com.demo',
        targetDirectory: '/tmp/demo_app',
        architecture: ArchitecturePattern.featureFirst,
        stateManagement: StateManagement.bloc,
        routing: Routing.goRouter,
        networking: Networking.dio,
        storage: Storage.hive,
        features: {},
      );

      ui.printSuccessCard(config, relativePath: 'demo_app');
      final output = logger.logs.join('\n');

      expect(output, contains('Success'));
      expect(output, contains('cd demo_app'));
      expect(output, contains('flutter run'));
    });

    test('printListCategory renders styled table category', () {
      ui.printListCategory('Category A', [
        const MapEntry('Item1', 'Description of item 1'),
      ]);
      final output = logger.logs.join('\n');

      expect(output, contains('Category A'));
      expect(output, contains('Item1'));
      expect(output, contains('Description of item 1'));
    });
  });

  group('CliTheme', () {
    test('canShowAsciiLogo respects column threshold', () {
      expect(CliTheme.canShowAsciiLogo(columns: 80), isTrue);
      expect(CliTheme.canShowAsciiLogo(columns: 20), isFalse);
    });
  });
}

class _MockLogger extends Logger {
  final List<String> logs = [];

  @override
  void info(String? message, {LogStyle? style}) {
    if (message != null) logs.add(message);
  }
}
