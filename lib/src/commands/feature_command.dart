import 'dart:convert';
import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:path/path.dart' as p;

import '../generator/feature_generator.dart';
import '../generator/flutter_project_validator.dart';
import '../models/project_config.dart';

/// Command that adds a new feature module to an existing project.
class FeatureCommand extends Command<int> {
  FeatureCommand({Logger? logger, FeatureGenerator? generator})
    : _logger = logger ?? Logger(),
      _generator = generator ?? const FeatureGenerator() {
    argParser.addOption(
      'path',
      abbr: 'p',
      help: 'Path to the Flutter project root (defaults to current directory).',
      defaultsTo: '.',
    );
  }

  final Logger _logger;
  final FeatureGenerator _generator;

  @override
  String get name => 'feature';

  @override
  String get description =>
      'Scaffolds a new feature module matching your project architecture.';

  @override
  Future<int> run() async {
    final projectPath = argResults?['path'] as String? ?? '.';
    final projectDir = Directory(projectPath);

    if (!FlutterProjectValidator.requireFlutterProject(
      projectDir,
      _logger,
      commandName: 'feature',
    )) {
      return ExitCode.usage.code;
    }

    final featureName = argResults?.rest.isNotEmpty == true
        ? argResults!.rest.first
        : _logger.prompt('Feature name (e.g. auth, profile, cart):');

    if (featureName.trim().isEmpty) {
      _logger.err('Feature name cannot be empty.');
      return ExitCode.usage.code;
    }

    // Look for .fkit.json
    final fkitConfigFile = File(p.join(projectDir.path, '.fkit.json'));
    ProjectConfig config;

    if (fkitConfigFile.existsSync()) {
      try {
        final content = fkitConfigFile.readAsStringSync();
        final json = jsonDecode(content) as Map<String, dynamic>;
        config = ProjectConfig.fromJson(json, targetDirectory: projectDir.path);
        _logger.info(
          '📦 Found existing FKIT config (${config.architecture.label}, ${config.stateManagement.label})',
        );
      } catch (e) {
        _logger.warn(
          'Failed to parse .fkit.json: $e. Falling back to default Feature-First + BLoC.',
        );
        config = _defaultConfig(projectDir.path);
      }
    } else {
      _logger.info(
        '💡 No .fkit.json found. Scaffolding with standard Feature-First Clean architecture.',
      );
      config = _defaultConfig(projectDir.path);
    }

    final files = _generator.generateFeature(
      featureName: featureName.trim(),
      config: config,
    );

    final progress = _logger.progress('Scaffolding feature "$featureName"...');

    for (final entry in files.entries) {
      final filePath = p.join(projectDir.path, entry.key);
      final file = File(filePath);
      file.parent.createSync(recursive: true);
      if (!file.existsSync()) {
        file.writeAsStringSync(entry.value);
      }
    }

    progress.complete(
      'Generated feature "$featureName" (${files.length} files)',
    );

    _logger.info('');
    _logger.info('📁 Created files:');
    for (final key in files.keys) {
      _logger.info('  ✓ $key');
    }

    return ExitCode.success.code;
  }

  ProjectConfig _defaultConfig(String targetDirectory) {
    return ProjectConfig(
      projectName: 'app',
      orgName: 'com.example',
      targetDirectory: targetDirectory,
      architecture: ArchitecturePattern.featureFirst,
      stateManagement: StateManagement.bloc,
      routing: Routing.goRouter,
      networking: Networking.dio,
      storage: Storage.sharedPreferences,
      features: const {},
    );
  }
}
