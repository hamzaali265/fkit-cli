import 'dart:io';

import 'package:mason_logger/mason_logger.dart';

/// Centralized design tokens, glyphs, and typography for fkit terminal UI.
class CliTheme {
  CliTheme._();

  /// Minimum columns required to render the FKIT ASCII wordmark.
  static const int asciiMinColumns = 36;

  /// User-facing product name.
  static const String displayName = 'FKIT CLI';

  /// Default panel width for wizard cards.
  static const int panelWidth = 56;

  /// Flutter brand blue (#0175C2).
  static const int flutterBlueR = 1;
  static const int flutterBlueG = 117;
  static const int flutterBlueB = 194;

  /// Flutter logo light cyan (#45D1FD).
  static const int flutterCyanR = 69;
  static const int flutterCyanG = 209;
  static const int flutterCyanB = 253;

  /// Flutter logo deep blue (#0553AD).
  static const int flutterNavyR = 5;
  static const int flutterNavyG = 83;
  static const int flutterNavyB = 173;

  // Glyphs & Icons
  static const String spark = '✻';
  static const String dotFilled = '●';
  static const String dotEmpty = '○';
  static const String radioOn = '◉';
  static const String radioOff = '◯';
  static const String tick = '✔';
  static const String arrow = '❯';
  static const String bullet = '•';
  static const String midDot = '·';
  static const String folder = '▸';

  // Box Drawing Glyphs
  static const String topLeft = '╭';
  static const String topRight = '╮';
  static const String bottomLeft = '╰';
  static const String bottomRight = '╯';
  static const String horizontal = '─';
  static const String vertical = '│';
  static const String teeRight = '├';
  static const String teeLeft = '┤';

  /// Block-font F (paired with [kitWordmarkAscii] to form FKIT).
  static const List<String> fLetterAscii = [
    r'███████╗',
    r'██╔════╝',
    r'█████╗  ',
    r'██╔══╝  ',
    r'██║     ',
    r'╚═╝     ',
  ];

  /// Block-font KIT wordmark (paired beside [fLetterAscii]).
  static const List<String> kitWordmarkAscii = [
    r'██╗  ██╗██╗████████╗',
    r'██║ ██╔╝██║╚══██╔══╝',
    r'█████╔╝ ██║   ██║   ',
    r'██╔═██╗ ██║   ██║   ',
    r'██║  ██╗██║   ██║   ',
    r'╚═╝  ╚═╝╚═╝   ╚═╝   ',
  ];

  /// Full FKIT ASCII wordmark lines.
  static List<String> get fkitAsciiLogo {
    return [for (final row in fkitLogoRows) '${row.$1}  ${row.$2}'];
  }

  /// Rows of `(fLine, kitLine)` for colored hero rendering.
  static List<(String, String)> get fkitLogoRows {
    return [
      for (var i = 0; i < fLetterAscii.length; i++)
        (fLetterAscii[i], kitWordmarkAscii[i]),
    ];
  }

  static const String _reset = '\x1B[0m';
  static const String _flutterBlueFg =
      '\x1B[38;2;$flutterBlueR;$flutterBlueG;$flutterBlueB'
      'm';
  static const String _flutterCyanFg =
      '\x1B[38;2;$flutterCyanR;$flutterCyanG;$flutterCyanB'
      'm';
  static const String _flutterNavyFg =
      '\x1B[38;2;$flutterNavyR;$flutterNavyG;$flutterNavyB'
      'm';

  /// Flutter blue accent (truecolor when supported).
  static String accent(String text) => '$_flutterBlueFg$text$_reset';

  /// Light cyan used for the F letter in the FKIT wordmark.
  static String flutterCyan(String text) => '$_flutterCyanFg$text$_reset';

  /// Deep blue accent (kept for theme compatibility).
  static String flutterNavy(String text) => '$_flutterNavyFg$text$_reset';

  /// Colors one FKIT hero row: cyan F + brand-blue KIT.
  static String colorFkitLogoRow(String fLine, String kitLine) {
    return '${flutterCyan(fLine)}  ${accent(kitLine)}';
  }

  static String coral(String text) => lightRed.wrap(text) ?? text;
  static String border(String text) => darkGray.wrap(text) ?? text;
  static String muted(String text) => darkGray.wrap(text) ?? text;
  static String success(String text) => lightGreen.wrap(text) ?? text;
  static String boldText(String text) => styleBold.wrap(text) ?? text;
  static String label(String text) => accent(boldText(text));

  /// Soft horizontal hairline separator.
  static String hairline([int width = 48]) =>
      border(horizontal * width.clamp(8, 120));

  /// Formats text as a compact badge: `[ Text ]`.
  static String pill(String text, {bool active = false}) {
    final body = active ? boldText(text) : muted(text);
    return '${border('[')} $body ${border(']')}';
  }

  /// Choice row: accent label + muted description.
  static String choice(String title, String description, {int pad = 18}) {
    final padded = title.padRight(pad);
    return '${label(padded)} ${muted(bullet)} ${muted(description)}';
  }

  /// Builds a sequence of progress dots: `● ● ○ ○ ○ ○ ○`.
  static String progressDots(int current, int total) {
    final buffer = StringBuffer();
    for (var i = 1; i <= total; i++) {
      if (i < current) {
        buffer.write('${success(dotFilled)} ');
      } else if (i == current) {
        buffer.write('${accent(dotFilled)} ');
      } else {
        buffer.write('${muted(dotEmpty)} ');
      }
    }
    return buffer.toString().trimRight();
  }

  /// Wraps a single line inside rounded borders of a specified width.
  ///
  /// Content longer than [innerWidth] is truncated with an ellipsis so the
  /// right border stays aligned.
  static String boxLine(String content, int innerWidth) {
    final fitted = fit(content, innerWidth);
    final plainLength = visibleLength(fitted);
    final padding = (innerWidth - plainLength).clamp(0, 1000);
    return '${border(vertical)}  $fitted${' ' * padding}  ${border(vertical)}';
  }

  /// Truncates [content] to [maxWidth] visible columns, appending `…` if needed.
  static String fit(String content, int maxWidth) {
    if (maxWidth <= 0) return '';
    if (visibleLength(content) <= maxWidth) return content;
    if (maxWidth == 1) return '…';
    return '${takeVisible(content, maxWidth - 1)}…';
  }

  /// Returns the first [maxWidth] visible characters of [content] (ANSI-safe).
  static String takeVisible(String content, int maxWidth) {
    if (maxWidth <= 0) return '';
    if (visibleLength(content) <= maxWidth) return content;

    final buf = StringBuffer();
    var visible = 0;
    for (final match in _tokenPattern.allMatches(content)) {
      final token = match.group(0)!;
      if (token.startsWith('\x1B')) {
        buf.write(token);
        continue;
      }
      if (visible >= maxWidth) break;
      buf.write(token);
      visible++;
    }
    return buf.toString();
  }

  /// Drops the first [count] visible characters of [content] (ANSI-safe).
  static String dropVisible(String content, int count) {
    if (count <= 0) return content;
    final buf = StringBuffer();
    var visible = 0;
    for (final match in _tokenPattern.allMatches(content)) {
      final token = match.group(0)!;
      if (token.startsWith('\x1B')) {
        buf.write(token);
        continue;
      }
      if (visible < count) {
        visible++;
        continue;
      }
      buf.write(token);
    }
    return buf.toString();
  }

  static final RegExp _tokenPattern = RegExp(
    r'\x1B\[[0-9;]*[a-zA-Z]|\x1B\[[0-?]*[ -/]*[@-~]|.',
  );

  /// Word-wraps [content] into lines of at most [maxWidth] visible columns.
  static List<String> wrap(String content, int maxWidth) {
    if (maxWidth <= 0) return [''];
    if (visibleLength(content) <= maxWidth) return [content];

    final words = content.split(RegExp(r'\s+'));
    final lines = <String>[];
    var current = '';

    void flush() {
      if (current.isNotEmpty) {
        lines.add(current);
        current = '';
      }
    }

    for (final word in words) {
      if (word.isEmpty) continue;
      if (visibleLength(word) > maxWidth) {
        flush();
        var rest = word;
        while (visibleLength(rest) > maxWidth) {
          lines.add(takeVisible(rest, maxWidth));
          rest = dropVisible(rest, maxWidth);
        }
        current = rest;
        continue;
      }

      final next = current.isEmpty ? word : '$current $word';
      if (visibleLength(next) <= maxWidth) {
        current = next;
      } else {
        flush();
        current = word;
      }
    }
    flush();
    return lines.isEmpty ? [''] : lines;
  }

  /// Empty padded line inside a panel.
  static String boxEmpty(int innerWidth) => boxLine('', innerWidth);

  /// Renders a horizontal border line: `╭───...───╮`.
  static String topBorder(int width, {String? title}) {
    if (title != null && title.isNotEmpty) {
      final titleStr = ' $title ';
      final titleLen = visibleLength(titleStr);
      final remaining = (width - titleLen - 2).clamp(0, 1000);
      final left = 1;
      final right = (remaining - left).clamp(0, 1000);
      return border(
        '$topLeft${horizontal * left}$titleStr${horizontal * right}$topRight',
      );
    }
    return border('$topLeft${horizontal * (width - 2)}$topRight');
  }

  /// Renders a divider border line: `├───...───┤`.
  static String midBorder(int width) {
    return border('$teeRight${horizontal * (width - 2)}$teeLeft');
  }

  /// Renders a bottom border line: `╰───...───╯`.
  static String bottomBorder(int width) {
    return border('$bottomLeft${horizontal * (width - 2)}$bottomRight');
  }

  /// Whether the terminal is wide enough for the full ASCII logo.
  static bool canShowAsciiLogo({int? columns}) {
    final width = columns ?? _terminalColumns();
    return width >= asciiMinColumns;
  }

  static int _terminalColumns() {
    try {
      return stdout.terminalColumns;
    } on Object {
      return 80;
    }
  }

  /// Visible character length after stripping ANSI escape sequences.
  static int visibleLength(String str) {
    return str
        .replaceAll(RegExp(r'\x1B\[[0-9;]*[a-zA-Z]'), '')
        .replaceAll(RegExp(r'\x1B\[[0-?]*[ -/]*[@-~]'), '')
        .length;
  }
}
