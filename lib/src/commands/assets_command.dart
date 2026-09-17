import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:path/path.dart' as p;

import '../generator/asset_manager.dart';

/// Subcommand for `fkit assets gen`.
class AssetsGenSubcommand extends Command<int> {
  AssetsGenSubcommand({Logger? logger, AssetManager? manager})
    : _logger = logger ?? Logger(),
      _manager = manager ?? const AssetManager() {
    argParser.addOption(
      'path',
      abbr: 'p',
      help: 'Path to the Flutter project root.',
      defaultsTo: '.',
    );
  }

  final Logger _logger;
  final AssetManager _manager;

  @override
  String get name => 'gen';

  @override
  String get description =>
      'Scans assets directory and generates type-safe AppAssets constants.';

  @override
  Future<int> run() async {
    final projectPath = argResults?['path'] as String? ?? '.';
    final projectDir = Directory(projectPath);

    if (!projectDir.existsSync()) {
      _logger.err('Project directory "$projectPath" not found.');
      return ExitCode.usage.code;
    }

    final progress = _logger.progress('Scanning assets and generating AppAssets...');
    try {
      final generatedPath = _manager.generateAssetsFile(projectDir.path);
      progress.complete('Generated $generatedPath');
      _logger.success('✓ Type-safe assets class is ready to use!');
      return ExitCode.success.code;
    } catch (e) {
      progress.fail('Failed to generate assets: $e');
      return ExitCode.software.code;
    }
  }
}

/// Subcommand for `fkit assets clean`.
class AssetsCleanSubcommand extends Command<int> {
  AssetsCleanSubcommand({Logger? logger, AssetManager? manager})
    : _logger = logger ?? Logger(),
      _manager = manager ?? const AssetManager() {
    argParser
      ..addOption(
        'path',
        abbr: 'p',
        help: 'Path to the Flutter project root.',
        defaultsTo: '.',
      )
      ..addFlag(
        'delete',
        abbr: 'd',
        help: 'Automatically delete unused asset files instead of just listing them.',
        defaultsTo: false,
      );
  }

  final Logger _logger;
  final AssetManager _manager;

  @override
  String get name => 'clean';

  @override
  String get description =>
      'Scans codebase for unreferenced asset files to reduce bundle size.';

  @override
  Future<int> run() async {
    final projectPath = argResults?['path'] as String? ?? '.';
    final projectDir = Directory(projectPath);

    if (!projectDir.existsSync()) {
      _logger.err('Project directory "$projectPath" not found.');
      return ExitCode.usage.code;
    }

    final shouldDelete = argResults?['delete'] as bool? ?? false;
    final progress = _logger.progress('Scanning codebase for unused assets...');

    final unused = _manager.findUnusedAssets(projectDir.path);

    if (unused.isEmpty) {
      progress.complete('Clean! No unused assets found in the project.');
      return ExitCode.success.code;
    }

    progress.complete('Found ${unused.length} unreferenced asset(s):');
    _logger.info('');
    for (final item in unused) {
      _logger.warn('  ⚠️  $item');
    }

    if (shouldDelete) {
      final deleteProgress = _logger.progress('Removing unused assets...');
      for (final item in unused) {
        final f = File(p.join(projectDir.path, item));
        if (f.existsSync()) f.deleteSync();
      }
      deleteProgress.complete('Removed ${unused.length} asset(s).');
    } else {
      _logger.info('');
      _logger.info('💡 To delete these files automatically, run:');
      _logger.info('   fkit assets clean --delete');
    }

    return ExitCode.success.code;
  }
}

/// Parent `fkit assets` command.
class AssetsCommand extends Command<int> {
  AssetsCommand({Logger? logger}) : _logger = logger ?? Logger() {
    addSubcommand(AssetsGenSubcommand(logger: _logger));
    addSubcommand(AssetsCleanSubcommand(logger: _logger));
  }

  final Logger _logger;

  @override
  String get name => 'assets';

  @override
  String get description =>
      'Utilities for generating type-safe asset constants and cleaning unused assets.';
}
