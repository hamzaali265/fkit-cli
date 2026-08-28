import 'package:mason_logger/mason_logger.dart';

import 'cli_theme.dart';
import 'cli_ui.dart';

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
      _ui.printKeyHints(forHome: true);
      _logger.info('');

      final selected = _logger.chooseOne<HomeAction>(
        '  ',
        choices: menu,
        display: _formatAction,
      );

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

  String _formatAction(HomeAction action) {
    final title = action.enabled
        ? CliTheme.boldText(action.title.padRight(28))
        : CliTheme.muted(action.title.padRight(28));
    final desc = CliTheme.muted(action.description);
    return '$title $desc';
  }
}
