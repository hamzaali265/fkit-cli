import 'dart:io';

import 'package:mason_logger/mason_logger.dart';
import 'package:path/path.dart' as p;

import 'cli_theme.dart';
import 'cli_ui.dart';

/// Menu row used while browsing parent directories.
class _DirChoice {
  const _DirChoice._(this.id, this.label, {this.path});

  factory _DirChoice.useThis() =>
      const _DirChoice._('use', 'Use this folder');

  factory _DirChoice.parent() => const _DirChoice._('parent', '..');

  factory _DirChoice.directory(String name, String absolutePath) =>
      _DirChoice._('dir', name, path: absolutePath);

  final String id;
  final String label;
  final String? path;
}

/// Interactive parent-folder browser with final path confirmation.
class DirectoryPicker {
  /// Creates a [DirectoryPicker].
  DirectoryPicker({Logger? logger})
    : _logger = logger ?? Logger(),
      _ui = CliUi(logger ?? Logger());

  final Logger _logger;
  final CliUi _ui;

  /// Browse for a parent folder, then confirm `parent/projectName`.
  ///
  /// Returns the absolute target directory for the new project.
  String pickTargetDirectory({
    required String projectName,
    Directory? startDirectory,
  }) {
    var current = (startDirectory ?? Directory.current).absolute;

    while (true) {
      final parent = _browseParent(current);
      final target = resolveTargetDirectory(parent.path, projectName);
      final display = displayPath(target);

      _ui.printPanel(
        title: 'Confirm',
        lines: [
          CliTheme.muted('Project will be created at'),
          CliTheme.boldText(display),
        ],
      );
      _ui.printKeyHints();

      final confirmed = _logger.chooseOne<String>(
        '  ',
        choices: const ['Continue', 'Choose different folder'],
        display: (c) => c == 'Continue'
            ? CliTheme.label(c)
            : CliTheme.muted(c),
      );

      if (confirmed == 'Continue') {
        return target;
      }
      current = Directory(parent.path);
    }
  }

  /// Joins [parentPath] and [projectName] into an absolute target path.
  static String resolveTargetDirectory(String parentPath, String projectName) {
    return p.normalize(p.absolute(p.join(parentPath, projectName)));
  }

  /// Lists non-hidden subdirectory names under [directory], sorted.
  static List<String> listChildDirectories(Directory directory) {
    if (!directory.existsSync()) {
      return const [];
    }

    final children = <String>[];
    for (final entity in directory.listSync(followLinks: false)) {
      if (entity is! Directory) continue;
      final name = p.basename(entity.path);
      if (name.startsWith('.')) continue;
      children.add(name);
    }
    children.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return children;
  }

  /// Formats [path] with a leading `~` when under the user home directory.
  static String displayPath(String path) {
    final home = Platform.environment['HOME'];
    if (home != null && home.isNotEmpty && path.startsWith(home)) {
      return '~${path.substring(home.length)}';
    }
    return path;
  }

  Directory _browseParent(Directory start) {
    var current = start;

    while (true) {
      final pathLabel = displayPath(current.path);
      _ui.printPanel(
        title: 'Folder',
        lines: [CliTheme.accent(pathLabel)],
      );
      _ui.printKeyHints(forBrowse: true);

      final choices = <_DirChoice>[
        _DirChoice.useThis(),
        _DirChoice.parent(),
        ...listChildDirectories(current).map(
          (name) => _DirChoice.directory(name, p.join(current.path, name)),
        ),
      ];

      final selected = _logger.chooseOne<_DirChoice>(
        '  ',
        choices: choices,
        display: (c) {
          switch (c.id) {
            case 'use':
              return '${CliTheme.accent(CliTheme.tick)} ${CliTheme.label(c.label)}';
            case 'parent':
              return '${CliTheme.muted(CliTheme.folder)} ${CliTheme.muted('${c.label}/')}';
            default:
              return '${CliTheme.muted(CliTheme.folder)} ${c.label}/';
          }
        },
      );

      switch (selected.id) {
        case 'use':
          return current;
        case 'parent':
          current = current.parent;
        case 'dir':
          current = Directory(selected.path!);
      }
    }
  }
}
