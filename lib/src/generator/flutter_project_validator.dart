import 'dart:io';
import 'package:mason_logger/mason_logger.dart';
import 'package:path/path.dart' as p;

/// Validates whether a directory is a valid Flutter project.
class FlutterProjectValidator {
  const FlutterProjectValidator();

  /// Returns true if [directory] contains a valid `pubspec.yaml` with a Flutter dependency.
  static bool isFlutterProject(Directory directory) {
    if (!directory.existsSync()) return false;

    final pubspecFile = File(p.join(directory.path, 'pubspec.yaml'));
    if (!pubspecFile.existsSync()) return false;

    try {
      final content = pubspecFile.readAsStringSync();
      return content.contains('sdk: flutter') ||
          content.contains('flutter:') ||
          content.contains('flutter_test:');
    } catch (_) {
      return false;
    }
  }

  /// Verifies that [directory] is a valid Flutter project.
  ///
  /// If invalid, prints a helpful error message and returns `false`.
  static bool requireFlutterProject(Directory directory, Logger logger, {String? commandName}) {
    if (!isFlutterProject(directory)) {
      final cmd = commandName != null ? 'fkit $commandName' : 'this command';
      logger.err('Error: Cannot run "$cmd" outside of a Flutter project.');
      logger.info('');
      logger.info('  • No valid pubspec.yaml with Flutter dependencies found in:');
      logger.info('    ${p.canonicalize(directory.path)}');
      logger.info('');
      logger.info('  👉 Navigate to a Flutter project directory or specify `--path <path>`:');
      logger.info('     cd my_flutter_project');
      logger.info('     fkit ${commandName ?? '<command>'}');
      logger.info('');
      return false;
    }
    return true;
  }
}
