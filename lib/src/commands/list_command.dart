import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';

import '../models/project_config.dart';
import '../prompts/cli_ui.dart';

/// Command that lists all available options, packages, and architecture patterns.
class ListCommand extends Command<int> {
  /// Creates a new [ListCommand].
  ListCommand({Logger? logger})
    : _logger = logger ?? Logger(),
      _ui = CliUi(logger ?? Logger()) {
    argParser.addFlag(
      'hero',
      help: 'Show the FKIT CLI hero banner before listing options.',
      defaultsTo: true,
      hide: true,
    );
  }

  final Logger _logger;
  final CliUi _ui;

  @override
  String get name => 'list';

  @override
  String get description =>
      'List all available technologies, packages, and architectures.';

  @override
  Future<int> run() async {
    final showHero = argResults?['hero'] as bool? ?? true;
    if (showHero) {
      _ui.printHeroBanner();
    }

    _ui.printListCategory(
      'Architecture Patterns',
      ArchitecturePattern.values
          .map((a) => MapEntry(a.name, a.description))
          .toList(),
    );

    _ui.printListCategory(
      'State Management',
      StateManagement.values
          .map((s) => MapEntry(s.name, s.description))
          .toList(),
    );

    _ui.printListCategory(
      'Routing Solutions',
      Routing.values.map((r) => MapEntry(r.name, r.description)).toList(),
    );

    _ui.printListCategory(
      'Networking Clients',
      Networking.values.map((n) => MapEntry(n.name, n.description)).toList(),
    );

    _ui.printListCategory(
      'Local Storage Engines',
      Storage.values.map((s) => MapEntry(s.name, s.description)).toList(),
    );

    _ui.printListCategory(
      'UI & Device Utilities',
      UtilityPackage.values
          .map((u) => MapEntry(u.packageName, u.description))
          .toList(),
    );

    _logger.info('');
    return ExitCode.success.code;
  }
}
