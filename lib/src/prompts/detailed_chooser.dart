import 'dart:io';
import 'dart:math' as math;

import 'package:mason_logger/mason_logger.dart';

import 'cli_theme.dart';

/// A selectable option with short and full descriptions.
class ChoiceOption<T> {
  /// Creates a choice option.
  const ChoiceOption({
    required this.value,
    required this.label,
    required this.shortDescription,
    required this.detail,
    this.diagram = const [],
  });

  /// Underlying value returned on confirm.
  final T value;

  /// Primary name shown in the list.
  final String label;

  /// One-line hint shown beside the label.
  final String shortDescription;

  /// Full description shown in the detail dialog.
  final String detail;

  /// Optional ASCII / markdown-style diagram lines for the dialog body.
  final List<String> diagram;
}

/// Arrow-key chooser with min labels and a full-screen detail dialog.
class DetailedChooser {
  /// Creates a [DetailedChooser].
  DetailedChooser({Logger? logger}) : _logger = logger ?? Logger();

  final Logger _logger;

  /// Choose one option. Press `i` to open a detail dialog for the cursor row.
  T chooseOne<T>({
    required List<ChoiceOption<T>> options,
    T? defaultValue,
  }) {
    if (options.isEmpty) {
      throw ArgumentError('options must not be empty');
    }

    if (!stdout.hasTerminal || !stdin.hasTerminal) {
      final fallback = defaultValue ?? options.first.value;
      _logger.info(
        '  ${CliTheme.muted('Selected')} ${CliTheme.label('$fallback')}',
      );
      return fallback;
    }

    var index = defaultValue == null
        ? 0
        : options.indexWhere((o) => o.value == defaultValue);
    if (index < 0) index = 0;

    void writeMenu() {
      stdout
        ..write('\x1b7')
        ..write('\x1b[?25l');

      for (var i = 0; i < options.length; i++) {
        final option = options[i];
        final isCurrent = i == index;
        final radio = isCurrent
            ? CliTheme.accent(CliTheme.radioOn)
            : CliTheme.muted(CliTheme.radioOff);
        final label = isCurrent
            ? CliTheme.label(option.label.padRight(14))
            : option.label.padRight(14);
        final short = CliTheme.muted(option.shortDescription);
        final prefix = isCurrent ? CliTheme.accent(CliTheme.arrow) : ' ';
        stdout.writeln('  $prefix $radio  $label $short');
      }

      stdout.writeln();
      stdout.writeln(
        '  ${CliTheme.muted('↑/↓')} ${CliTheme.muted(CliTheme.midDot)} '
        '${CliTheme.muted('enter')} ${CliTheme.muted(CliTheme.midDot)} '
        '${CliTheme.muted('i details')}',
      );
    }

    stdin
      ..echoMode = false
      ..lineMode = false;

    writeMenu();

    try {
      while (true) {
        final key = _readKey();
        if (key == _Key.up) {
          index = (index - 1) % options.length;
        } else if (key == _Key.down) {
          index = (index + 1) % options.length;
        } else if (key == _Key.info) {
          _showDetailDialog(options[index]);
        } else if (key == _Key.enter) {
          break;
        } else if (key == _Key.quit) {
          _restoreTerminal();
          exit(130);
        } else {
          continue;
        }

        stdout.write('\x1b8');
        writeMenu();
      }
    } finally {
      _restoreTerminal();
    }

    final selected = options[index];
    _logger.info(
      '  ${CliTheme.muted('Selected')} ${CliTheme.label(selected.label)}',
    );
    return selected.value;
  }

  /// Choose any number of options. Press `i` for a detail dialog.
  List<T> chooseAny<T>({
    required List<ChoiceOption<T>> options,
    List<T>? defaultValues,
  }) {
    if (options.isEmpty) return <T>[];

    if (!stdout.hasTerminal || !stdin.hasTerminal) {
      return defaultValues ?? options.map((o) => o.value).toList();
    }

    final selected = <int>{};
    if (defaultValues != null) {
      for (final value in defaultValues) {
        final i = options.indexWhere((o) => o.value == value);
        if (i >= 0) selected.add(i);
      }
    }
    var index = 0;

    void writeMenu() {
      stdout
        ..write('\x1b7')
        ..write('\x1b[?25l');

      for (var i = 0; i < options.length; i++) {
        final option = options[i];
        final isCurrent = i == index;
        final isOn = selected.contains(i);
        final radio = isOn
            ? CliTheme.accent(CliTheme.radioOn)
            : CliTheme.muted(CliTheme.radioOff);
        final label = isCurrent
            ? CliTheme.label(option.label.padRight(22))
            : option.label.padRight(22);
        final short = CliTheme.muted(option.shortDescription);
        final prefix = isCurrent ? CliTheme.accent(CliTheme.arrow) : ' ';
        stdout.writeln('  $prefix $radio  $label $short');
      }

      stdout.writeln();
      stdout.writeln(
        '  ${CliTheme.muted('↑/↓')} ${CliTheme.muted(CliTheme.midDot)} '
        '${CliTheme.muted('space toggle')} ${CliTheme.muted(CliTheme.midDot)} '
        '${CliTheme.muted('enter')} ${CliTheme.muted(CliTheme.midDot)} '
        '${CliTheme.muted('i details')}',
      );
    }

    stdin
      ..echoMode = false
      ..lineMode = false;

    writeMenu();

    try {
      while (true) {
        final key = _readKey();
        if (key == _Key.up) {
          index = (index - 1) % options.length;
        } else if (key == _Key.down) {
          index = (index + 1) % options.length;
        } else if (key == _Key.space) {
          if (selected.contains(index)) {
            selected.remove(index);
          } else {
            selected.add(index);
          }
        } else if (key == _Key.info) {
          _showDetailDialog(options[index]);
        } else if (key == _Key.enter) {
          break;
        } else if (key == _Key.quit) {
          _restoreTerminal();
          exit(130);
        } else {
          continue;
        }

        stdout.write('\x1b8');
        writeMenu();
      }
    } finally {
      _restoreTerminal();
    }

    final values = selected.map((i) => options[i].value).toList();
    _logger.info(
      '  ${CliTheme.muted('Selected')} '
      '${values.isEmpty ? CliTheme.muted('none') : CliTheme.label('${values.length} items')}',
    );
    return values;
  }

  /// Full-screen dialog with double borders + shadow; closes on i / enter.
  void _showDetailDialog(ChoiceOption<Object?> option) {
    stdout
      ..write('\x1b[?25l')
      ..write('\x1b[2J') // clear screen
      ..write('\x1b[H'); // home

    final cols = _terminalColumns();
    final rows = _terminalRows();

    // Use nearly the full terminal for the dialog.
    final dialogWidth = math.min(cols - 4, math.max(56, cols - 6));
    final inner = dialogWidth - 4;
    final maxBodyRows = math.max(8, rows - 10);

    final body = <String>[
      ..._wrapLines(option.detail, inner),
      if (option.diagram.isNotEmpty) ...['', ...option.diagram],
    ];

    // Fit body into available height (keep footer).
    final visibleBody = body.length > maxBodyRows
        ? [...body.take(maxBodyRows - 1), '…']
        : body;

    // Pad body so the dialog fills vertical space.
    while (visibleBody.length < maxBodyRows) {
      visibleBody.add('');
    }

    final contentLines = <String>[
      _doubleTop(dialogWidth, title: option.label),
      _doubleRow(dialogWidth, ''),
      for (final line in visibleBody) _doubleRow(dialogWidth, line),
      _doubleRow(dialogWidth, ''),
      _doubleMid(dialogWidth),
      _doubleRow(
        dialogWidth,
        CliTheme.muted('i / enter  close'),
      ),
      _doubleBottom(dialogWidth),
    ];

    // Center horizontally a bit; draw shadow behind/right/bottom.
    final leftPad = math.max(1, (cols - dialogWidth - 2) ~/ 2);
    final pad = ' ' * leftPad;
    final shadow = CliTheme.muted('█');

    stdout.writeln();
    for (var i = 0; i < contentLines.length; i++) {
      final line = contentLines[i];
      // Right-edge shadow on every dialog row.
      stdout.writeln('$pad$line$shadow');
    }
    // Bottom shadow strip (offset).
    stdout.writeln(
      '$pad ${CliTheme.muted('█' * dialogWidth)}',
    );
    stdout.writeln();

    while (true) {
      final key = _readKey();
      if (key == _Key.info || key == _Key.enter || key == _Key.space) {
        break;
      }
      if (key == _Key.quit) {
        _restoreTerminal();
        exit(130);
      }
    }

    // Clear dialog before redrawing the menu.
    stdout
      ..write('\x1b[2J')
      ..write('\x1b[H');
  }

  String _doubleTop(int width, {required String title}) {
    final titlePlain = ' ✻ $title ';
    final titleStr =
        ' ${CliTheme.accent(CliTheme.spark)} ${CliTheme.boldText(title)} ';
    final titleLen = titlePlain.length;
    final fill = (width - 2 - titleLen).clamp(0, width);
    final left = 1;
    final right = (fill - left).clamp(0, width);
    return '${CliTheme.accent('╔${'═' * left}')}$titleStr${CliTheme.accent('${'═' * right}╗')}';
  }

  String _doubleBottom(int width) =>
      CliTheme.accent('╚${'═' * (width - 2)}╝');

  String _doubleMid(int width) => CliTheme.accent('╟${'─' * (width - 2)}╢');

  String _doubleRow(int width, String content) {
    final inner = width - 4;
    var text = content;
    if (CliTheme.visibleLength(text) > inner) {
      text = '${_visiblePrefix(text, inner - 1)}…';
    }
    final pad = (inner - CliTheme.visibleLength(text)).clamp(0, 1000);
    final filled = '$text${' ' * pad}';
    final body = _looksLikeDiagram(content)
        ? CliTheme.accent(filled)
        : filled;
    return '${CliTheme.accent('║')} $body ${CliTheme.accent('║')}';
  }

  static bool _looksLikeDiagram(String content) {
    const marks = ['─', '│', '└', '├', '┌', '┐', '┘', '▼', '►', '▲', '◄', '═'];
    return marks.any(content.contains);
  }

  static String _visiblePrefix(String text, int maxVisible) {
    if (text.length <= maxVisible) return text;
    return text.substring(0, maxVisible);
  }

  void _restoreTerminal() {
    try {
      stdin
        ..lineMode = true
        ..echoMode = true;
    } on Object {
      // Ignore when stdin is not a terminal.
    }
    stdout
      ..write('\x1b8')
      ..write('\x1b[J')
      ..write('\x1b[?25h');
  }

  static int _terminalColumns() {
    try {
      return stdout.terminalColumns;
    } on Object {
      return 80;
    }
  }

  static int _terminalRows() {
    try {
      return stdout.terminalLines;
    } on Object {
      return 24;
    }
  }

  static List<String> _wrapLines(String text, int maxWidth) {
    if (text.isEmpty) return [''];
    final words = text.split(RegExp(r'\s+'));
    final lines = <String>[];
    var current = StringBuffer();

    for (final word in words) {
      if (current.isEmpty) {
        if (word.length <= maxWidth) {
          current.write(word);
        } else {
          var rest = word;
          while (rest.length > maxWidth) {
            lines.add(rest.substring(0, maxWidth));
            rest = rest.substring(maxWidth);
          }
          current.write(rest);
        }
        continue;
      }

      if (current.length + 1 + word.length <= maxWidth) {
        current
          ..write(' ')
          ..write(word);
      } else {
        lines.add(current.toString());
        current = StringBuffer(word);
      }
    }
    if (current.isNotEmpty) {
      lines.add(current.toString());
    }
    return lines.isEmpty ? [''] : lines;
  }

  static _Key _readKey() {
    final first = stdin.readByteSync();
    if (first == 3) return _Key.quit;
    if (first == 10 || first == 13) return _Key.enter;
    if (first == 32) return _Key.space;
    if (first == 105 || first == 73 || first == 63) return _Key.info;
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

enum _Key { up, down, enter, space, info, quit, other }
