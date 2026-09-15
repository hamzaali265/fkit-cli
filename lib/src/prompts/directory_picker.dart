import 'dart:io';
import 'dart:math' as math;

import 'package:mason_logger/mason_logger.dart';
import 'package:path/path.dart' as p;

import 'cli_theme.dart';
import 'terminal_redraw.dart';

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
  DirectoryPicker({Logger? logger}) : _logger = logger ?? Logger();

  final Logger _logger;

  static const int _panelWidth = CliTheme.panelWidth;
  static const int _maxVisibleRows = 12;

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

      final confirmed = _confirmTarget(target);
      if (confirmed) {
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
    if (!TerminalRedraw.isInteractive) {
      _logger.info(
        '  ${CliTheme.muted('Using')} ${CliTheme.label(displayPath(start.path))}',
      );
      return start;
    }

    var current = start;
    var index = 0;

    List<_DirChoice> buildChoices() => [
      _DirChoice.useThis(),
      _DirChoice.parent(),
      ...listChildDirectories(current).map(
        (name) => _DirChoice.directory(name, p.join(current.path, name)),
      ),
    ];

    List<String> frame(List<_DirChoice> choices) {
      final pathLabel = displayPath(current.path);
      final inner = _panelWidth - 6;
      final window = _visibleWindow(choices.length, index, _maxVisibleRows);
      final lines = <String>[
        '',
        '  ${CliTheme.topBorder(_panelWidth, title: 'Folder')}',
        '  ${CliTheme.boxLine(CliTheme.accent(pathLabel), inner)}',
        '  ${CliTheme.bottomBorder(_panelWidth)}',
        '',
      ];

      for (var i = window.start; i < window.end; i++) {
        lines.add('  ${_formatChoice(choices[i], isCurrent: i == index)}');
      }

      if (choices.length > _maxVisibleRows) {
        lines.add(
          '  ${CliTheme.muted('  … ${index + 1}/${choices.length}')}',
        );
      }

      lines
        ..add('')
        ..add(
          '  ${CliTheme.muted('↑/↓ move')} ${CliTheme.muted(CliTheme.midDot)} '
          '${CliTheme.muted('enter open / select')} ${CliTheme.muted(CliTheme.midDot)} '
          '${CliTheme.muted('ctrl+c quit')}',
        );
      return lines;
    }

    var choices = buildChoices();
    TerminalRedraw.begin();
    TerminalRedraw.paint(frame(choices));

    try {
      while (true) {
        final key = _readKey();
        if (key == _Key.up) {
          index = (index - 1) % choices.length;
        } else if (key == _Key.down) {
          index = (index + 1) % choices.length;
        } else if (key == _Key.enter) {
          final selected = choices[index];
          switch (selected.id) {
            case 'use':
              TerminalRedraw.end();
              _logger.info(
                '  ${CliTheme.muted('Folder')} '
                '${CliTheme.label(displayPath(current.path))}',
              );
              return current;
            case 'parent':
              current = current.parent;
              index = 0;
              choices = buildChoices();
            case 'dir':
              current = Directory(selected.path!);
              index = 0;
              choices = buildChoices();
          }
        } else if (key == _Key.quit) {
          TerminalRedraw.end();
          exit(130);
        } else {
          continue;
        }

        TerminalRedraw.paint(frame(choices));
      }
    } finally {
      TerminalRedraw.end(clearFrame: false);
    }
  }

  bool _confirmTarget(String target) {
    if (!TerminalRedraw.isInteractive) {
      return true;
    }

    const choices = ['Continue', 'Choose different folder'];
    var index = 0;
    final display = displayPath(target);
    final inner = _panelWidth - 6;

    List<String> frame() {
      final lines = <String>[
        '',
        '  ${CliTheme.topBorder(_panelWidth, title: 'Confirm')}',
        '  ${CliTheme.boxLine(CliTheme.muted('Project will be created at'), inner)}',
        '  ${CliTheme.boxLine(CliTheme.boldText(display), inner)}',
        '  ${CliTheme.bottomBorder(_panelWidth)}',
        '',
      ];

      for (var i = 0; i < choices.length; i++) {
        final isCurrent = i == index;
        final radio = isCurrent
            ? CliTheme.accent(CliTheme.radioOn)
            : CliTheme.muted(CliTheme.radioOff);
        final prefix = isCurrent ? CliTheme.accent(CliTheme.arrow) : ' ';
        final label = isCurrent
            ? CliTheme.label(choices[i])
            : CliTheme.muted(choices[i]);
        lines.add('  $prefix $radio  $label');
      }

      lines
        ..add('')
        ..add(
          '  ${CliTheme.muted('↑/↓')} ${CliTheme.muted(CliTheme.midDot)} '
          '${CliTheme.muted('enter')} ${CliTheme.muted(CliTheme.midDot)} '
          '${CliTheme.muted('ctrl+c')}',
        );
      return lines;
    }

    TerminalRedraw.begin();
    TerminalRedraw.paint(frame());

    try {
      while (true) {
        final key = _readKey();
        if (key == _Key.up) {
          index = (index - 1) % choices.length;
        } else if (key == _Key.down) {
          index = (index + 1) % choices.length;
        } else if (key == _Key.enter) {
          break;
        } else if (key == _Key.quit) {
          TerminalRedraw.end();
          exit(130);
        } else {
          continue;
        }

        TerminalRedraw.paint(frame());
      }
    } finally {
      TerminalRedraw.end();
    }

    final selected = choices[index];
    _logger.info(
      '  ${CliTheme.muted('Selected')} ${CliTheme.label(selected)}',
    );
    return selected == 'Continue';
  }

  static String _formatChoice(_DirChoice choice, {required bool isCurrent}) {
    final radio = isCurrent
        ? CliTheme.accent(CliTheme.radioOn)
        : CliTheme.muted(CliTheme.radioOff);
    final prefix = isCurrent ? CliTheme.accent(CliTheme.arrow) : ' ';

    switch (choice.id) {
      case 'use':
        final label = isCurrent
            ? CliTheme.label(choice.label)
            : choice.label;
        return '$prefix $radio  ${CliTheme.accent(CliTheme.tick)} $label';
      case 'parent':
        return '$prefix $radio  ${CliTheme.muted(CliTheme.folder)} '
            '${CliTheme.muted('${choice.label}/')}';
      default:
        final name = isCurrent
            ? CliTheme.boldText('${choice.label}/')
            : '${choice.label}/';
        return '$prefix $radio  ${CliTheme.muted(CliTheme.folder)} $name';
    }
  }

  static ({int start, int end}) _visibleWindow(
    int length,
    int index,
    int maxVisible,
  ) {
    if (length <= maxVisible) {
      return (start: 0, end: length);
    }
    final half = maxVisible ~/ 2;
    var start = math.max(0, index - half);
    var end = start + maxVisible;
    if (end > length) {
      end = length;
      start = length - maxVisible;
    }
    return (start: start, end: end);
  }

  static _Key _readKey() {
    final first = stdin.readByteSync();
    if (first == 3) return _Key.quit;
    if (first == 10 || first == 13) return _Key.enter;
    if (first == 107 || first == 75) return _Key.up;
    if (first == 106 || first == 74) return _Key.down;
    if (first == 27) {
      if (stdin.readByteSync() == 91) {
        final code = stdin.readByteSync();
        if (code == 65) return _Key.up;
        if (code == 66) return _Key.down;
      }
      return _Key.other;
    }
    return _Key.other;
  }
}

enum _Key { up, down, enter, quit, other }
