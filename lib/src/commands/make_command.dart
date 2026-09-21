import 'dart:convert';
import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:path/path.dart' as p;

import '../generator/feature_generator.dart';
import '../generator/flutter_project_validator.dart';
import '../models/project_config.dart';

/// Subcommand for `fkit make screen <name>`.
class MakeScreenSubcommand extends Command<int> {
  MakeScreenSubcommand({Logger? logger}) : _logger = logger ?? Logger() {
    argParser.addOption(
      'path',
      abbr: 'p',
      help: 'Path to the Flutter project root.',
      defaultsTo: '.',
    );
  }

  final Logger _logger;

  @override
  String get name => 'screen';

  @override
  String get description => 'Generates a new screen or view widget.';

  @override
  Future<int> run() async {
    final projectPath = argResults?['path'] as String? ?? '.';
    final projectDir = Directory(projectPath);

    if (!FlutterProjectValidator.requireFlutterProject(
      projectDir,
      _logger,
      commandName: 'make screen',
    )) {
      return ExitCode.usage.code;
    }

    final screenName = argResults?.rest.isNotEmpty == true
        ? argResults!.rest.first
        : _logger.prompt('Screen name (e.g. login, settings, details):');

    if (screenName.trim().isEmpty) {
      _logger.err('Screen name cannot be empty.');
      return ExitCode.usage.code;
    }

    final config = _loadConfig(projectDir);

    final snake = screenName.trim().toSnakeCase();
    final pascal = screenName.trim().toPascalCase();

    String relativePath;
    if (config.architecture == ArchitecturePattern.mvvm) {
      relativePath = 'lib/views/${snake}_view.dart';
    } else if (config.architecture == ArchitecturePattern.simpleMvc) {
      relativePath = 'lib/screens/${snake}_screen.dart';
    } else if (config.architecture == ArchitecturePattern.modular) {
      relativePath = 'lib/modules/$snake/screens/${snake}_screen.dart';
    } else if (config.architecture == ArchitecturePattern.layerFirst) {
      relativePath = 'lib/presentation/$snake/views/${snake}_view.dart';
    } else {
      relativePath =
          'lib/features/$snake/presentation/views/${snake}_view.dart';
    }

    final code =
        '''
import 'package:flutter/material.dart';

/// $pascal screen widget.
class ${pascal}Screen extends StatelessWidget {
  const ${pascal}Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('$pascal'),
      ),
      body: const Center(
        child: Text('$pascal Screen'),
      ),
    );
  }
}
''';

    final targetFile = File(p.join(projectDir.path, relativePath));
    targetFile.parent.createSync(recursive: true);
    targetFile.writeAsStringSync(code);

    _logger.success('✓ Created screen: $relativePath');
    return ExitCode.success.code;
  }
}

/// Subcommand for `fkit make controller <name>`.
class MakeControllerSubcommand extends Command<int> {
  MakeControllerSubcommand({Logger? logger}) : _logger = logger ?? Logger() {
    argParser.addOption(
      'path',
      abbr: 'p',
      help: 'Path to the Flutter project root.',
      defaultsTo: '.',
    );
  }

  final Logger _logger;

  @override
  String get name => 'controller';

  @override
  String get description =>
      'Generates a state controller (BLoC/Cubit, Riverpod Notifier, or ChangeNotifier).';

  @override
  Future<int> run() async {
    final projectPath = argResults?['path'] as String? ?? '.';
    final projectDir = Directory(projectPath);

    if (!FlutterProjectValidator.requireFlutterProject(
      projectDir,
      _logger,
      commandName: 'make controller',
    )) {
      return ExitCode.usage.code;
    }

    final name = argResults?.rest.isNotEmpty == true
        ? argResults!.rest.first
        : _logger.prompt('Controller name (e.g. auth, profile, cart):');

    if (name.trim().isEmpty) {
      _logger.err('Controller name cannot be empty.');
      return ExitCode.usage.code;
    }

    final config = _loadConfig(projectDir);

    final snake = name.trim().toSnakeCase();
    final pascal = name.trim().toPascalCase();
    final camel = name.trim().toCamelCase();

    String relativePath;
    String code;

    if (config.stateManagement == StateManagement.bloc) {
      relativePath = config.architecture == ArchitecturePattern.mvvm
          ? 'lib/viewmodels/${snake}_cubit.dart'
          : config.architecture == ArchitecturePattern.modular
          ? 'lib/modules/$snake/logic/${snake}_cubit.dart'
          : config.architecture == ArchitecturePattern.layerFirst
          ? 'lib/presentation/$snake/bloc/${snake}_cubit.dart'
          : 'lib/features/$snake/presentation/bloc/${snake}_cubit.dart';

      code =
          '''
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ${pascal}State extends Equatable {
  const ${pascal}State({this.isLoading = false});

  final bool isLoading;

  ${pascal}State copyWith({bool? isLoading}) {
    return ${pascal}State(
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [isLoading];
}

class ${pascal}Cubit extends Cubit<${pascal}State> {
  ${pascal}Cubit() : super(const ${pascal}State());

  void execute() {
    emit(state.copyWith(isLoading: true));
    emit(state.copyWith(isLoading: false));
  }
}
''';
    } else if (config.stateManagement == StateManagement.riverpod) {
      relativePath = config.architecture == ArchitecturePattern.mvvm
          ? 'lib/viewmodels/${snake}_notifier.dart'
          : config.architecture == ArchitecturePattern.modular
          ? 'lib/modules/$snake/logic/${snake}_controller.dart'
          : config.architecture == ArchitecturePattern.layerFirst
          ? 'lib/presentation/$snake/providers/${snake}_provider.dart'
          : 'lib/features/$snake/presentation/providers/${snake}_provider.dart';

      code =
          '''
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ${pascal}State {
  const ${pascal}State({this.isLoading = false});

  final bool isLoading;
}

class ${pascal}Notifier extends StateNotifier<${pascal}State> {
  ${pascal}Notifier() : super(const ${pascal}State());

  void execute() {
    state = const ${pascal}State(isLoading: false);
  }
}

final ${camel}Provider = StateNotifierProvider<${pascal}Notifier, ${pascal}State>((ref) {
  return ${pascal}Notifier();
});
''';
    } else {
      relativePath = config.architecture == ArchitecturePattern.mvvm
          ? 'lib/viewmodels/${snake}_viewmodel.dart'
          : config.architecture == ArchitecturePattern.modular
          ? 'lib/modules/$snake/logic/${snake}_controller.dart'
          : 'lib/features/$snake/presentation/controllers/${snake}_controller.dart';

      code =
          '''
import 'package:flutter/foundation.dart';

class ${pascal}ViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void execute() {
    _isLoading = true;
    notifyListeners();
    _isLoading = false;
    notifyListeners();
  }
}
''';
    }

    final targetFile = File(p.join(projectDir.path, relativePath));
    targetFile.parent.createSync(recursive: true);
    targetFile.writeAsStringSync(code);

    _logger.success('✓ Created controller: $relativePath');
    return ExitCode.success.code;
  }
}

/// Subcommand for `fkit make model <name>`.
class MakeModelSubcommand extends Command<int> {
  MakeModelSubcommand({Logger? logger}) : _logger = logger ?? Logger() {
    argParser.addOption(
      'path',
      abbr: 'p',
      help: 'Path to the Flutter project root.',
      defaultsTo: '.',
    );
  }

  final Logger _logger;

  @override
  String get name => 'model';

  @override
  String get description =>
      'Generates a data model with fromJson and toJson serialization.';

  @override
  Future<int> run() async {
    final projectPath = argResults?['path'] as String? ?? '.';
    final projectDir = Directory(projectPath);

    if (!FlutterProjectValidator.requireFlutterProject(
      projectDir,
      _logger,
      commandName: 'make model',
    )) {
      return ExitCode.usage.code;
    }

    final name = argResults?.rest.isNotEmpty == true
        ? argResults!.rest.first
        : _logger.prompt('Model name (e.g. user, product, transaction):');

    if (name.trim().isEmpty) {
      _logger.err('Model name cannot be empty.');
      return ExitCode.usage.code;
    }

    final config = _loadConfig(projectDir);

    final snake = name.trim().toSnakeCase();
    final pascal = name.trim().toPascalCase();

    String relativePath;
    if (config.architecture == ArchitecturePattern.featureFirst) {
      relativePath = 'lib/features/$snake/data/models/${snake}_model.dart';
    } else if (config.architecture == ArchitecturePattern.modular) {
      relativePath = 'lib/modules/$snake/models/${snake}_model.dart';
    } else if (config.architecture == ArchitecturePattern.layerFirst) {
      relativePath = 'lib/data/models/${snake}_model.dart';
    } else {
      relativePath = 'lib/models/${snake}_model.dart';
    }

    final code =
        '''
/// Model representing $pascal.
class ${pascal}Model {
  const ${pascal}Model({
    required this.id,
    required this.title,
  });

  final String id;
  final String title;

  factory ${pascal}Model.fromJson(Map<String, dynamic> json) {
    return ${pascal}Model(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
    };
  }
}
''';

    final targetFile = File(p.join(projectDir.path, relativePath));
    targetFile.parent.createSync(recursive: true);
    targetFile.writeAsStringSync(code);

    _logger.success('✓ Created model: $relativePath');
    return ExitCode.success.code;
  }
}

/// Subcommand for `fkit make service <name>`.
class MakeServiceSubcommand extends Command<int> {
  MakeServiceSubcommand({Logger? logger}) : _logger = logger ?? Logger() {
    argParser.addOption(
      'path',
      abbr: 'p',
      help: 'Path to the Flutter project root.',
      defaultsTo: '.',
    );
  }

  final Logger _logger;

  @override
  String get name => 'service';

  @override
  String get description => 'Generates a dedicated service class.';

  @override
  Future<int> run() async {
    final projectPath = argResults?['path'] as String? ?? '.';
    final projectDir = Directory(projectPath);

    if (!FlutterProjectValidator.requireFlutterProject(
      projectDir,
      _logger,
      commandName: 'make service',
    )) {
      return ExitCode.usage.code;
    }

    final name = argResults?.rest.isNotEmpty == true
        ? argResults!.rest.first
        : _logger.prompt('Service name (e.g. auth, payment, analytics):');

    if (name.trim().isEmpty) {
      _logger.err('Service name cannot be empty.');
      return ExitCode.usage.code;
    }

    final config = _loadConfig(projectDir);

    final snake = name.trim().toSnakeCase();
    final pascal = name.trim().toPascalCase();

    String relativePath;
    if (config.architecture == ArchitecturePattern.featureFirst) {
      relativePath =
          'lib/features/$snake/data/datasources/${snake}_remote_data_source.dart';
    } else if (config.architecture == ArchitecturePattern.modular) {
      relativePath = 'lib/modules/$snake/repositories/${snake}_repository.dart';
    } else if (config.architecture == ArchitecturePattern.layerFirst) {
      relativePath = 'lib/data/datasources/${snake}_remote_data_source.dart';
    } else {
      relativePath = 'lib/services/${snake}_service.dart';
    }

    final code =
        '''
/// Service managing operations for $pascal.
class ${pascal}Service {
  const ${pascal}Service();

  Future<void> initialize() async {}
}
''';

    final targetFile = File(p.join(projectDir.path, relativePath));
    targetFile.parent.createSync(recursive: true);
    targetFile.writeAsStringSync(code);

    _logger.success('✓ Created service: $relativePath');
    return ExitCode.success.code;
  }
}

/// Parent `fkit make` command with subcommands.
class MakeCommand extends Command<int> {
  MakeCommand({Logger? logger}) : _logger = logger ?? Logger() {
    addSubcommand(MakeScreenSubcommand(logger: _logger));
    addSubcommand(MakeControllerSubcommand(logger: _logger));
    addSubcommand(MakeModelSubcommand(logger: _logger));
    addSubcommand(MakeServiceSubcommand(logger: _logger));
  }

  final Logger _logger;

  @override
  String get name => 'make';

  @override
  String get description =>
      'Generates individual components (screen, controller, model, service).';
}

ProjectConfig _loadConfig(Directory projectDir) {
  final fkitConfigFile = File(p.join(projectDir.path, '.fkit.json'));
  if (fkitConfigFile.existsSync()) {
    try {
      final json =
          jsonDecode(fkitConfigFile.readAsStringSync()) as Map<String, dynamic>;
      return ProjectConfig.fromJson(json, targetDirectory: projectDir.path);
    } catch (_) {}
  }
  return ProjectConfig(
    projectName: 'app',
    orgName: 'com.example',
    targetDirectory: projectDir.path,
    architecture: ArchitecturePattern.featureFirst,
    stateManagement: StateManagement.bloc,
    routing: Routing.goRouter,
    networking: Networking.dio,
    storage: Storage.sharedPreferences,
    features: const {},
  );
}
