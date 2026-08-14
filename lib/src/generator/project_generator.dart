import 'dart:io';
import 'package:mason_logger/mason_logger.dart';
import 'package:path/path.dart' as p;

import '../models/project_config.dart';
import '../prompts/cli_ui.dart';
import 'platform_permission_configurator.dart';
import 'template_engine.dart';

/// Scaffolds and writes the Flutter project according to [ProjectConfig].
class ProjectGenerator {
  /// Creates a new [ProjectGenerator].
  ProjectGenerator({
    Logger? logger,
    TemplateEngine? templateEngine,
    PlatformPermissionConfigurator? platformPermissionConfigurator,
  }) : _logger = logger ?? Logger(),
       _ui = CliUi(logger ?? Logger()),
       _templateEngine = templateEngine ?? const TemplateEngine(),
       _platformPermissionConfigurator =
           platformPermissionConfigurator ??
           const PlatformPermissionConfigurator();

  final Logger _logger;
  final CliUi _ui;
  final TemplateEngine _templateEngine;
  final PlatformPermissionConfigurator _platformPermissionConfigurator;

  /// Executes the full generation pipeline.
  Future<bool> generate(ProjectConfig config) async {
    final targetDir = Directory(config.targetDirectory);

    // 1. Validation
    if (targetDir.existsSync() && targetDir.listSync().isNotEmpty) {
      _logger.warn(
        'Target directory "${config.targetDirectory}" is not empty.',
      );
      final proceed = _logger.confirm(
        'Do you want to continue and overwrite files in this directory?',
        defaultValue: false,
      );
      if (!proceed) {
        _logger.err('Aborted project generation.');
        return false;
      }
    } else {
      targetDir.createSync(recursive: true);
    }

    // 2. Run flutter create for native platform runners
    final createProgress = _logger.progress(
      '[1/5] Creating Flutter base project (${config.projectName})...',
    );

    try {
      final flutterCreateArgs = [
        'create',
        config.projectName,
        '--org',
        config.orgName,
        '--project-name',
        config.projectName,
        '--description',
        config.description,
        '--no-pub',
      ];

      final parentDir = targetDir.parent.path;
      final createResult = await Process.run(
        'flutter',
        flutterCreateArgs,
        workingDirectory: parentDir,
        runInShell: true,
      );

      if (createResult.exitCode != 0) {
        createProgress.fail('Failed to create Flutter base project.');
        _logger.err(createResult.stderr.toString());
        return false;
      }
      createProgress.complete('Created Flutter base project');
    } catch (e) {
      createProgress.fail('Error executing flutter create: $e');
      return false;
    }

    // 3. Generate and write template files
    final templateProgress = _logger.progress(
      '[2/5] Scaffolding architecture & boilerplate...',
    );
    final files = _templateEngine.generateFiles(config);

    for (final entry in files.entries) {
      final filePath = p.join(targetDir.path, entry.key);
      final file = File(filePath);
      file.parent.createSync(recursive: true);
      file.writeAsStringSync(entry.value);
    }

    // 4. Create assets directories if enabled
    if (config.hasAssetsStructure) {
      for (final folder in ['images', 'icons', 'svgs', 'fonts']) {
        final dir = Directory(p.join(targetDir.path, 'assets', folder));
        dir.createSync(recursive: true);
        File(p.join(dir.path, '.gitkeep')).writeAsStringSync('');
      }
    }

    templateProgress.complete(
      'Scaffolded architecture and boilerplate (${files.length} files)',
    );

    // 5. Configure platform permissions (Android, iOS, macOS)
    final permsProgress = _logger.progress(
      '[3/5] Configuring platform permissions (Android, iOS, macOS)...',
    );
    _platformPermissionConfigurator.applyPermissions(targetDir.path, config);
    permsProgress.complete('Platform permissions configured');

    // 6. Run flutter pub get
    if (!config.offline) {
      final pubProgress = _logger.progress(
        '[4/5] Resolving package dependencies (flutter pub get)...',
      );
      try {
        final pubResult = await Process.run(
          'flutter',
          ['pub', 'get'],
          workingDirectory: targetDir.path,
          runInShell: true,
        );

        if (pubResult.exitCode != 0) {
          pubProgress.fail('Failed to resolve dependencies');
          _logger.warn(pubResult.stderr.toString());
        } else {
          pubProgress.complete('Dependencies resolved successfully');
        }
      } catch (e) {
        pubProgress.fail('Error running flutter pub get: $e');
      }

      // 7. Run flutter gen-l10n if localization is enabled
      if (config.hasLocalization) {
        final l10nProgress = _logger.progress(
          '[5/5] Generating localization classes (flutter gen-l10n)...',
        );
        try {
          final l10nResult = await Process.run(
            'flutter',
            ['gen-l10n'],
            workingDirectory: targetDir.path,
            runInShell: true,
          );
          if (l10nResult.exitCode == 0) {
            l10nProgress.complete('Localization generated');
          } else {
            l10nProgress.fail('Localization generation skipped or failed');
          }
        } catch (_) {
          l10nProgress.fail('Skipped flutter gen-l10n');
        }
      }
    }

    // 8. Success card
    _ui.printSuccessCard(config, relativePath: p.relative(targetDir.path));

    return true;
  }
}
