import 'package:mason_logger/mason_logger.dart';
import 'package:path/path.dart' as p;

import '../models/project_config.dart';
import 'choice_catalog.dart';
import 'cli_ui.dart';
import 'detailed_chooser.dart';
import 'directory_picker.dart';

/// Terminal interactive wizard guiding the developer through project options.
class InteractiveWizard {
  /// Creates a new [InteractiveWizard].
  InteractiveWizard({
    Logger? logger,
    DirectoryPicker? directoryPicker,
    DetailedChooser? chooser,
  }) : _logger = logger ?? Logger(),
       _ui = CliUi(logger ?? Logger()),
       _directoryPicker =
           directoryPicker ?? DirectoryPicker(logger: logger ?? Logger()),
       _chooser = chooser ?? DetailedChooser(logger: logger ?? Logger());

  final Logger _logger;
  final CliUi _ui;
  final DirectoryPicker _directoryPicker;
  final DetailedChooser _chooser;

  /// Runs the questionnaire and returns the assembled [ProjectConfig].
  ProjectConfig run({
    String? initialProjectName,
    String? initialOrg,
    String? outputDir,
    bool offline = false,
    bool showHero = true,
  }) {
    if (showHero) {
      _ui.printHeroBanner();
    }

    const totalSteps = 8;

    // 1. Project & Org Setup
    _ui.printStepHeader(
      step: 1,
      total: totalSteps,
      title: 'Project & Organization',
      description: 'Name and reverse-domain package id for your app.',
    );

    var projectName = initialProjectName ?? '';
    while (projectName.isEmpty || !_isValidProjectName(projectName)) {
      projectName = _logger
          .prompt(
            '  Project name',
            defaultValue: initialProjectName ?? 'my_flutter_app',
          )
          .trim();

      if (!_isValidProjectName(projectName)) {
        _logger.err('  Invalid name. Use lowercase snake_case (e.g. my_app).');
        projectName = '';
      }
    }

    final orgName =
        initialOrg ??
        _logger.prompt('  Organization', defaultValue: 'com.example').trim();

    // 2. Location
    late final String targetDirectory;
    if (outputDir != null) {
      targetDirectory = p.normalize(p.absolute(outputDir));
    } else {
      _ui.printStepHeader(
        step: 2,
        total: totalSteps,
        title: 'Location',
        description: 'Pick the parent folder for $projectName.',
      );
      targetDirectory = _directoryPicker.pickTargetDirectory(
        projectName: projectName,
      );
    }

    // 3. Architecture
    _ui.printStepHeader(
      step: 3,
      total: totalSteps,
      title: 'Architecture',
      description: 'How your lib/ folder should be organized.',
    );
    final architecture = _chooser.chooseOne<ArchitecturePattern>(
      options: ChoiceCatalog.architecture(),
    );

    // 4. State Management
    _ui.printStepHeader(
      step: 4,
      total: totalSteps,
      title: 'State management',
      description: 'Reactive state approach for your UI.',
    );
    final stateManagement = _chooser.chooseOne<StateManagement>(
      options: ChoiceCatalog.state(),
    );

    // 5. Routing
    _ui.printStepHeader(
      step: 5,
      total: totalSteps,
      title: 'Routing',
      description: 'Navigation engine for screens and deep links.',
    );
    final routing = _chooser.chooseOne<Routing>(
      options: ChoiceCatalog.routing(),
    );

    // 6. Networking & Storage
    _ui.printStepHeader(
      step: 6,
      total: totalSteps,
      title: 'Networking & storage',
      description: 'HTTP client and local persistence.',
    );
    final networking = _chooser.chooseOne<Networking>(
      options: ChoiceCatalog.networking(),
    );
    final storage = _chooser.chooseOne<Storage>(
      options: ChoiceCatalog.storage(),
    );

    // 7. Essential UI & Device Utilities
    _ui.printStepHeader(
      step: 7,
      total: totalSteps,
      title: 'Utilities',
      description: 'Optional packages to include out of the box.',
    );
    final utilitiesList = _chooser.chooseAny<UtilityPackage>(
      options: ChoiceCatalog.utilities(),
      defaultValues: [
        UtilityPackage.flutterSvg,
        UtilityPackage.cachedNetworkImage,
        UtilityPackage.gap,
      ],
    );

    // 8. Additional Features
    _ui.printStepHeader(
      step: 8,
      total: totalSteps,
      title: 'Features',
      description: 'Linting, l10n, assets, and flavors.',
    );
    final featuresList = _chooser.chooseAny<ProjectFeature>(
      options: ChoiceCatalog.features(),
      defaultValues: [
        ProjectFeature.strictLinting,
        ProjectFeature.localization,
        ProjectFeature.assetsStructure,
      ],
    );

    final config = ProjectConfig(
      projectName: projectName,
      orgName: orgName,
      targetDirectory: targetDirectory,
      architecture: architecture,
      stateManagement: stateManagement,
      routing: routing,
      networking: networking,
      storage: storage,
      features: featuresList.toSet(),
      utilities: utilitiesList.toSet(),
      offline: offline,
    );

    _ui.printSummaryCard(config);
    return config;
  }

  static final _identifierRegex = RegExp(r'^[a-z][a-z0-9_]*$');

  bool _isValidProjectName(String name) {
    if (name.isEmpty || !_identifierRegex.hasMatch(name)) {
      return false;
    }
    const reserved = {
      'assert',
      'break',
      'case',
      'catch',
      'class',
      'const',
      'continue',
      'default',
      'do',
      'else',
      'enum',
      'extends',
      'false',
      'final',
      'finally',
      'for',
      'if',
      'in',
      'is',
      'new',
      'null',
      'rethrow',
      'return',
      'super',
      'switch',
      'this',
      'throw',
      'true',
      'try',
      'var',
      'void',
      'while',
      'with',
    };
    return !reserved.contains(name);
  }
}
