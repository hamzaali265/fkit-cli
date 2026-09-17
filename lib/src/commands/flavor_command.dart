import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';

import '../generator/flavor_configurator.dart';

/// Command that initializes and configures project flavors.
class FlavorCommand extends Command<int> {
  FlavorCommand({
    Logger? logger,
    FlavorConfigurator? configurator,
  }) : _logger = logger ?? Logger(),
       _configurator = configurator ?? const FlavorConfigurator() {
    argParser
      ..addOption(
        'path',
        abbr: 'p',
        help: 'Path to the Flutter project root.',
        defaultsTo: '.',
      )
      ..addMultiOption(
        'flavors',
        abbr: 'f',
        help: 'Comma-separated list of flavors to create.',
        defaultsTo: ['dev', 'staging', 'prod'],
      );
  }

  final Logger _logger;
  final FlavorConfigurator _configurator;

  @override
  String get name => 'flavor';

  @override
  String get description =>
      'Automates multi-flavor setup across Android, iOS, Dart entrypoints, and VS Code.';

  @override
  Future<int> run() async {
    final projectPath = argResults?['path'] as String? ?? '.';
    final projectDir = Directory(projectPath);

    if (!projectDir.existsSync()) {
      _logger.err('Target project directory "$projectPath" does not exist.');
      return ExitCode.usage.code;
    }

    final rawFlavors = (argResults?['flavors'] as List<String>?) ?? ['dev', 'staging', 'prod'];
    final flavors = rawFlavors.map((f) => f.trim().toLowerCase()).where((f) => f.isNotEmpty).toList();

    if (flavors.isEmpty) {
      _logger.err('At least one flavor name must be provided.');
      return ExitCode.usage.code;
    }

    final progress = _logger.progress('Configuring flavors (${flavors.join(', ')})...');

    try {
      _configurator.setupFlavors(
        targetDir: projectDir.path,
        flavors: flavors,
      );

      progress.complete('Flavors configured successfully!');
      _logger.info('');
      _logger.info('📱 Android product flavors added to build.gradle');
      _logger.info('🍏 iOS .xcconfig build schemes created in ios/Flutter');
      _logger.info('🎯 Dart entrypoints generated in lib/:');
      for (final f in flavors) {
        _logger.info('  • lib/main_$f.dart');
      }
      _logger.info('🚀 VS Code launch configurations saved to .vscode/launch.json');
      _logger.info('');
      _logger.info('To run a specific flavor:');
      _logger.info('  flutter run --flavor ${flavors.first} -t lib/main_${flavors.first}.dart');

      return ExitCode.success.code;
    } catch (e) {
      progress.fail('Failed to configure flavors: $e');
      return ExitCode.software.code;
    }
  }
}
