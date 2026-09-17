import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:path/path.dart' as p;

/// Command that checks development environment readiness and current project health.
class DoctorCommand extends Command<int> {
  DoctorCommand({Logger? logger}) : _logger = logger ?? Logger() {
    argParser.addOption(
      'path',
      abbr: 'p',
      help: 'Path to the Flutter project root (optional).',
      defaultsTo: '.',
    );
  }

  final Logger _logger;

  @override
  String get name => 'doctor';

  @override
  String get description =>
      'Checks Flutter development environment and local project health.';

  @override
  Future<int> run() async {
    _logger.info('🩺 Running FKIT Doctor...');
    _logger.info('');

    var issuesCount = 0;

    // 1. Check Flutter SDK
    final flutterProgress = _logger.progress('Checking Flutter SDK...');
    try {
      final res = await Process.run('flutter', ['--version'], runInShell: true);
      if (res.exitCode == 0) {
        final firstLine = res.stdout.toString().split('\n').first.trim();
        flutterProgress.complete('Flutter SDK installed: $firstLine');
      } else {
        flutterProgress.fail('Flutter command returned an error');
        issuesCount++;
      }
    } catch (_) {
      flutterProgress.fail('Flutter is not installed or not in PATH');
      issuesCount++;
    }

    // 2. Check Dart SDK
    final dartProgress = _logger.progress('Checking Dart SDK...');
    try {
      final res = await Process.run('dart', ['--version'], runInShell: true);
      if (res.exitCode == 0) {
        final out = (res.stdout.toString().isNotEmpty ? res.stdout : res.stderr)
            .toString()
            .split('\n')
            .first
            .trim();
        dartProgress.complete('Dart SDK installed: $out');
      } else {
        dartProgress.fail('Dart command returned an error');
        issuesCount++;
      }
    } catch (_) {
      dartProgress.fail('Dart is not installed or not in PATH');
      issuesCount++;
    }

    // 3. Check CocoaPods (macOS)
    if (Platform.isMacOS) {
      final podProgress = _logger.progress('Checking CocoaPods...');
      try {
        final res = await Process.run('pod', ['--version'], runInShell: true);
        if (res.exitCode == 0) {
          podProgress.complete(
            'CocoaPods installed: ${res.stdout.toString().trim()}',
          );
        } else {
          podProgress.fail('CocoaPods returned an error');
          issuesCount++;
        }
      } catch (_) {
        podProgress.fail(
          'CocoaPods is not installed (required for iOS/macOS builds: gem install cocoapods)',
        );
        issuesCount++;
      }
    }

    // 4. Check Local Project (if inside Flutter project)
    final projectPath = argResults?['path'] as String? ?? '.';
    final projectDir = Directory(projectPath);
    final pubspec = File(p.join(projectDir.path, 'pubspec.yaml'));
    final fkitConfig = File(p.join(projectDir.path, '.fkit.json'));

    if (pubspec.existsSync()) {
      _logger.info('');
      _logger.info('📁 Project Health:');
      _logger.info('  ✓ pubspec.yaml found');
      if (fkitConfig.existsSync()) {
        _logger.info('  ✓ .fkit.json configuration detected');
      } else {
        _logger.warn(
          '  ℹ .fkit.json not found (using default fallback configurations)',
        );
      }
    }

    _logger.info('');
    if (issuesCount == 0) {
      _logger.success(
        '🎉 Doctor summary: Everything looks ready for Flutter development!',
      );
      return ExitCode.success.code;
    } else {
      _logger.warn(
        '⚠️ Doctor summary: Found $issuesCount issue(s). Please review the logs above.',
      );
      return ExitCode.success.code;
    }
  }
}
