import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';

import 'commands/create_command.dart';
import 'commands/feature_command.dart';
import 'commands/list_command.dart';
import 'commands/make_command.dart';
import 'prompts/home_screen.dart';

const String packageName = 'fkit';
const String packageVersion = '1.1.0';
const String packageDescription =
    'FKIT CLI — interactive tool for bootstrapping production-ready Flutter applications.';

/// Command runner for fkit.
class FkitCommandRunner extends CommandRunner<int> {
  FkitCommandRunner({Logger? logger, this._homeScreen})
    : _logger = logger ?? Logger(),
      super(packageName, packageDescription) {
    argParser.addFlag(
      'version',
      abbr: 'v',
      negatable: false,
      help: 'Print the current version.',
    );

    addCommand(CreateCommand(logger: _logger));
    addCommand(FeatureCommand(logger: _logger));
    addCommand(MakeCommand(logger: _logger));
    addCommand(ListCommand(logger: _logger));
  }

  final Logger _logger;
  final HomeScreen? _homeScreen;

  @override
  Future<int> run(Iterable<String> args) async {
    try {
      final argResults = parse(args);
      return await runCommand(argResults) ?? ExitCode.success.code;
    } on FormatException catch (e) {
      _logger.err(e.message);
      _logger.info('');
      _logger.info(usage);
      return ExitCode.usage.code;
    } on UsageException catch (e) {
      _logger.err(e.message);
      _logger.info('');
      _logger.info(e.usage);
      return ExitCode.usage.code;
    }
  }

  @override
  Future<int?> runCommand(ArgResults topLevelResults) async {
    if (topLevelResults['version'] == true) {
      _logger.info('$packageName version: $packageVersion');
      return ExitCode.success.code;
    }

    final wantsHelp =
        topLevelResults.wasParsed('help') && topLevelResults['help'] == true;

    // Bare `fkit` with no args → interactive home. Unknown tokens fall through
    // to CommandRunner so they still produce a usage error.
    if (topLevelResults.command == null &&
        !wantsHelp &&
        topLevelResults.arguments.isEmpty) {
      final home =
          _homeScreen ??
          HomeScreen(
            logger: _logger,
            version: packageVersion,
            runCommand: (commandArgs) => run(commandArgs),
          );
      return home.run();
    }

    return super.runCommand(topLevelResults);
  }
}
