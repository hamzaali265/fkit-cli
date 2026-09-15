import 'dart:io';

/// Reliable in-place terminal redraw without DECSC/DECRC (which many
/// terminals — including Cursor's — handle inconsistently).
///
/// Pattern: paint lines, remember count, on update move up N lines and
/// rewrite each line with clear-line so nothing stacks or blanks.
class TerminalRedraw {
  TerminalRedraw._();

  static int _lastLineCount = 0;
  static bool _rawMode = false;

  /// Enter raw input mode and hide the cursor.
  static void begin() {
    if (!stdout.hasTerminal || !stdin.hasTerminal) return;
    stdin
      ..echoMode = false
      ..lineMode = false;
    stdout.write('\x1b[?25l');
    _rawMode = true;
    _lastLineCount = 0;
  }

  /// Restore cooked input and show the cursor. Clears the last painted frame.
  static void end({bool clearFrame = true}) {
    if (clearFrame && _lastLineCount > 0) {
      erase(_lastLineCount);
      _lastLineCount = 0;
    }
    if (_rawMode) {
      try {
        stdin
          ..lineMode = true
          ..echoMode = true;
      } on Object {
        // Ignore when stdin is not a terminal.
      }
      stdout.write('\x1b[?25h');
      _rawMode = false;
    }
  }

  /// Erase [count] lines above the cursor ( inclusive of moving up ).
  static void erase(int count) {
    if (count <= 0) return;
    for (var i = 0; i < count; i++) {
      stdout.write('\x1b[1A\r\x1b[2K');
    }
  }

  /// Paint [lines] in place. Replaces the previous frame when one exists.
  static void paint(List<String> lines) {
    if (_lastLineCount > 0) {
      erase(_lastLineCount);
    }
    for (final line in lines) {
      stdout.writeln(line);
    }
    _lastLineCount = lines.length;
  }

  /// Whether stdin/stdout support interactive redraw.
  static bool get isInteractive =>
      stdout.hasTerminal && stdin.hasTerminal;
}
