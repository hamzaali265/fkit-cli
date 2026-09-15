import 'dart:io';

import 'package:mason_logger/mason_logger.dart';

import 'cli_theme.dart';
import 'cli_ui.dart';
import 'terminal_redraw.dart';

/// Extensible home-menu action shown after the FKIT CLI hero.
class HomeAction {
  /// Creates a home menu action.
  const HomeAction({
    required this.id,
    required this.title,
    required this.description,
    this.enabled = true,
  });

  /// Stable identifier used for routing.
  final String id;

  /// Primary label shown in the menu.
  final String title;

  /// Muted one-line description under the title.
  final String description;

  /// Whether the action can be executed (coming-soon rows are disabled).
  final bool enabled;
}

/// Claude Code–style home screen for bare `fkit`.
class HomeScreen {
  /// Creates a [HomeScreen].
  ///
  /// [_runCommand] must dispatch into the same command runner (e.g. create/list).
  HomeScreen({
    required this._runCommand,
    Logger? logger,
    this.version = '1.0.0',
  }) : _logger = logger ?? Logger(),
       _ui = CliUi(logger ?? Logger());

  final Logger _logger;
  final CliUi _ui;
  final Future<int> Function(List<String> args) _runCommand;

  /// Package version shown under the hero.
  final String version;

  /// Default menu items for v1.
  static const List<HomeAction> defaultActions = [
    HomeAction(
      id: 'create',
      title: 'Create project',
      description: 'Scaffold a new Flutter app',
    ),
    HomeAction(
      id: 'list',
      title: 'List options',
      description: 'Browse stacks and packages',
    ),
    HomeAction(
      id: 'coming_soon',
      title: 'More features coming soon…',
      description: 'Not available yet',
      enabled: false,
    ),
    HomeAction(id: 'quit', title: 'Quit', description: 'Exit FKIT CLI'),
  ];

  /// Shows the hero and arrow menu until the user quits or runs a command.
  Future<int> run({List<HomeAction>? actions}) async {
    final menu = actions ?? defaultActions;

    while (true) {
      _ui.printHeroBanner(version: version);
      _ui.printHairline();
      _logger.info('  ${CliTheme.boldText('What do you want to do?')}');
      _logger.info('');

      final selected = _chooseHomeAction(menu);

      switch (selected.id) {
        case 'create':
          return _runCommand(['create', '--no-hero']);
        case 'list':
          return _runCommand(['list', '--no-hero']);
        case 'coming_soon':
          _logger.info('');
          _logger.info(
            '  ${CliTheme.muted('More features are on the way. Stay tuned.')}',
          );
          _logger.info('');
          continue;
        case 'quit':
          return ExitCode.success.code;
        default:
          if (!selected.enabled) {
            _logger.info('');
            _logger.info(
              '  ${CliTheme.muted('"${selected.title}" is not available yet.')}',
            );
            _logger.info('');
            continue;
          }
          return ExitCode.success.code;
      }
    }
  }

  HomeAction _chooseHomeAction(List<HomeAction> menu) {
    if (!TerminalRedraw.isInteractive) {
      return menu.firstWhere((a) => a.enabled, orElse: () => menu.first);
    }

    var index = 0;

    List<String> frame() {
      final lines = <String>[];
      for (var i = 0; i < menu.length; i++) {
        final action = menu[i];
        final isCurrent = i == index;
        final radio = isCurrent
            ? CliTheme.accent(CliTheme.radioOn)
            : CliTheme.muted(CliTheme.radioOff);
        final prefix = isCurrent ? CliTheme.accent(CliTheme.arrow) : ' ';
        final title = action.enabled
            ? (isCurrent
                  ? CliTheme.boldText(action.title.padRight(28))
                  : action.title.padRight(28))
            : CliTheme.muted(action.title.padRight(28));
        final desc = CliTheme.muted(action.description);
        lines.add('  $prefix $radio  $title $desc');
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
        final key = _readHomeKey();
        if (key == _HomeKey.up) {
          index = (index - 1) % menu.length;
        } else if (key == _HomeKey.down) {
          index = (index + 1) % menu.length;
        } else if (key == _HomeKey.enter) {
          break;
        } else if (key == _HomeKey.quit) {
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

    final selected = menu[index];
    _logger.info(
      '  ${CliTheme.muted('Selected')} ${CliTheme.label(selected.title)}',
    );
    return selected;
  }

  static _HomeKey _readHomeKey() {
    final first = stdin.readByteSync();
    if (first == 3) return _HomeKey.quit;
    if (first == 10 || first == 13) return _HomeKey.enter;
    if (first == 107 || first == 75) return _HomeKey.up;
    if (first == 106 || first == 74) return _HomeKey.down;
    if (first == 27) {
      if (stdin.readByteSync() == 91) {
        final code = stdin.readByteSync();
        if (code == 65) return _HomeKey.up;
        if (code == 66) return _HomeKey.down;
      }
      return _HomeKey.other;
    }
    return _HomeKey.other;
  }
}

enum _HomeKey { up, down, enter, quit, other }
