import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:path/path.dart' as p;

import '../generator/project_generator.dart';
import '../models/project_config.dart';
import '../prompts/interactive_wizard.dart';

/// Command that creates and scaffolds a new Flutter project.
class CreateCommand extends Command<int> {
  CreateCommand({
    Logger? logger,
    ProjectGenerator? generator,
    InteractiveWizard? wizard,
  }) : _logger = logger ?? Logger(),
       _generator = generator ?? ProjectGenerator(logger: logger),
       _wizard = wizard ?? InteractiveWizard(logger: logger) {
    argParser
      ..addOption(
        'org',
        abbr: 'o',
        help:
            'The organization responsible for your new Flutter project, in reverse domain name notation.',
        defaultsTo: 'com.example',
      )
      ..addOption(
        'output',
        abbr: 'd',
        help: 'The directory in which to create the new project.',
      )
      ..addOption(
        'description',
        help: 'The description to use for your new Flutter project.',
        defaultsTo: 'A new Flutter project created with FKIT CLI.',
      )
      ..addOption(
        'architecture',
        abbr: 'a',
        help: 'Folder structure and architectural pattern.',
        allowed: [
          'feature-first',
          'layer-first',
          'mvvm',
          'simple-mvc',
          'modular',
        ],
      )
      ..addOption(
        'state',
        abbr: 's',
        help: 'State management library.',
        allowed: ['bloc', 'riverpod', 'provider', 'getx', 'none'],
      )
      ..addOption(
        'routing',
        abbr: 'r',
        help: 'Navigation and routing library.',
        allowed: ['go_router', 'auto_route', 'standard'],
      )
      ..addOption(
        'networking',
        abbr: 'n',
        help: 'HTTP networking client.',
        allowed: ['dio', 'http', 'none'],
      )
      ..addOption(
        'storage',
        help: 'Local persistence library.',
        allowed: ['shared_preferences', 'hive', 'sqflite', 'none'],
      )
      ..addFlag(
        'interactive',
        abbr: 'i',
        help: 'Run the interactive terminal wizard.',
        defaultsTo: true,
      )
      ..addFlag(
        'offline',
        help:
            'Skip running flutter pub get and online fetches during creation.',
        defaultsTo: false,
      )
      ..addFlag('l10n', help: 'Include localization setup.', defaultsTo: true)
      ..addFlag(
        'strict-lints',
        help: 'Pre-configure very_good_analysis in analysis_options.yaml.',
        defaultsTo: true,
      )
      ..addFlag(
        'flavors',
        help: 'Include environment flavor configuration.',
        defaultsTo: true,
      )
      ..addFlag(
        'assets',
        help: 'Include asset directory structure and pubspec declaration.',
        defaultsTo: true,
      )
      ..addFlag('svg', help: 'Include flutter_svg package.', defaultsTo: true)
      ..addFlag(
        'cached-image',
        help: 'Include cached_network_image package.',
        defaultsTo: true,
      )
      ..addFlag(
        'gap',
        help: 'Include gap package for layout spacing.',
        defaultsTo: true,
      )
      ..addFlag(
        'screenutil',
        help: 'Include flutter_screenutil package (ScreenUtilInit).',
        defaultsTo: false,
      )
      ..addFlag(
        'permission-handler',
        help: 'Include permission_handler package for runtime permissions.',
        defaultsTo: false,
      )
      ..addFlag(
        'get-it',
        help: 'Include get_it service locator for dependency injection.',
        defaultsTo: false,
      )
      ..addFlag(
        'image-picker',
        help:
            'Include image_picker package and ImagePickerService (Camera & Gallery).',
        defaultsTo: false,
      )
      ..addFlag(
        'file-picker',
        help:
            'Include file_picker package and FilePickerService (Files & Documents).',
        defaultsTo: false,
      )
      ..addFlag(
        'secure-storage',
        help: 'Include flutter_secure_storage package.',
        defaultsTo: false,
      )
      ..addFlag(
        'url-launcher',
        help: 'Include url_launcher package.',
        defaultsTo: false,
      )
      ..addFlag('uuid', help: 'Include uuid package.', defaultsTo: false)
      ..addFlag(
        'intl',
        help: 'Include intl package for date/number formatting and i18n.',
        defaultsTo: true,
      )
      ..addFlag(
        'equatable',
        help: 'Include equatable package for value equality comparisons.',
        defaultsTo: false,
      )
      ..addFlag(
        'crypto',
        help: 'Include crypto package for SHA256/MD5 hashing.',
        defaultsTo: false,
      )
      ..addFlag(
        'webview',
        help: 'Include webview_flutter package and AppWebView widget.',
        defaultsTo: false,
      )
      ..addFlag(
        'geolocator',
        help: 'Include geolocator package and LocationService.',
        defaultsTo: false,
      )
      ..addFlag(
        'hero',
        help: 'Show the FKIT CLI hero banner before the wizard.',
        defaultsTo: true,
        hide: true,
      );
  }

  final Logger _logger;
  final ProjectGenerator _generator;
  final InteractiveWizard _wizard;

  @override
  String get name => 'create';

  @override
  String get description =>
      'Create a new Flutter project with customizable packages and architecture.';

  @override
  String get invocation => 'fkit create <project-name> [flags]';

  @override
  Future<int> run() async {
    final args = argResults;
    if (args == null) return ExitCode.usage.code;

    final positional = args.rest;
    final explicitName = positional.isNotEmpty ? positional.first : null;
    final isInteractive = args['interactive'] as bool;
    final offline = args['offline'] as bool;
    final org = args['org'] as String;
    final desc = args['description'] as String;
    final outputArg = args['output'] as String?;

    final hasDirectConfig =
        args.wasParsed('architecture') &&
        args.wasParsed('state') &&
        args.wasParsed('routing') &&
        args.wasParsed('networking') &&
        args.wasParsed('storage');

    ProjectConfig config;

    if (!isInteractive ||
        (hasDirectConfig &&
            explicitName != null &&
            !args.wasParsed('interactive'))) {
      if (explicitName == null) {
        _logger.err('Missing project name. Usage: fkit create <project-name>');
        return ExitCode.usage.code;
      }

      final targetDir =
          outputArg ?? p.join(Directory.current.path, explicitName);

      final features = <ProjectFeature>{};
      if (args['flavors'] as bool) {
        features.add(ProjectFeature.envFlavors);
      }
      if (args['strict-lints'] as bool) {
        features.add(ProjectFeature.strictLinting);
      }
      if (args['l10n'] as bool) {
        features.add(ProjectFeature.localization);
      }
      if (args['assets'] as bool) {
        features.add(ProjectFeature.assetsStructure);
      }

      final utilities = <UtilityPackage>{};
      if (args['svg'] as bool) {
        utilities.add(UtilityPackage.flutterSvg);
      }
      if (args['cached-image'] as bool) {
        utilities.add(UtilityPackage.cachedNetworkImage);
      }
      if (args['gap'] as bool) {
        utilities.add(UtilityPackage.gap);
      }
      if (args['screenutil'] as bool) {
        utilities.add(UtilityPackage.flutterScreenutil);
      }
      if (args['permission-handler'] as bool) {
        utilities.add(UtilityPackage.permissionHandler);
      }
      if (args['get-it'] as bool) {
        utilities.add(UtilityPackage.getIt);
      }
      if (args['image-picker'] as bool) {
        utilities.add(UtilityPackage.imagePicker);
      }
      if (args['file-picker'] as bool) {
        utilities.add(UtilityPackage.filePicker);
      }
      if (args['secure-storage'] as bool) {
        utilities.add(UtilityPackage.flutterSecureStorage);
      }
      if (args['url-launcher'] as bool) {
        utilities.add(UtilityPackage.urlLauncher);
      }
      if (args['uuid'] as bool) {
        utilities.add(UtilityPackage.uuid);
      }
      if (args['intl'] as bool) {
        utilities.add(UtilityPackage.intl);
      }
      if (args['equatable'] as bool) {
        utilities.add(UtilityPackage.equatable);
      }
      if (args['crypto'] as bool) {
        utilities.add(UtilityPackage.crypto);
      }
      if (args['webview'] as bool) {
        utilities.add(UtilityPackage.webviewFlutter);
      }
      if (args['geolocator'] as bool) {
        utilities.add(UtilityPackage.geolocator);
      }

      config = ProjectConfig(
        projectName: explicitName,
        orgName: org,
        targetDirectory: targetDir,
        description: desc,
        architecture: ArchitecturePattern.fromKey(
          args['architecture'] as String? ?? 'feature-first',
        ),
        stateManagement: StateManagement.fromKey(
          args['state'] as String? ?? 'bloc',
        ),
        routing: Routing.fromKey(args['routing'] as String? ?? 'go_router'),
        networking: Networking.fromKey(args['networking'] as String? ?? 'dio'),
        storage: Storage.fromKey(
          args['storage'] as String? ?? 'shared_preferences',
        ),
        features: features,
        utilities: utilities,
        offline: offline,
      );
    } else {
      config = _wizard.run(
        initialProjectName: explicitName,
        initialOrg: args.wasParsed('org') ? org : null,
        outputDir: outputArg,
        offline: offline,
        showHero: args['hero'] as bool,
      );
    }

    final success = await _generator.generate(config);
    return success ? ExitCode.success.code : ExitCode.software.code;
  }
}
