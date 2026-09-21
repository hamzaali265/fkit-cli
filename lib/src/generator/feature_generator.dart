import '../models/project_config.dart';

/// Helper to format casing.
extension StringCasingExtension on String {
  /// Converts string to camelCase (e.g. 'user_profile' -> 'userProfile').
  String toCamelCase() {
    final words = split(RegExp(r'[_\s-]'));
    if (words.isEmpty) return '';
    final first = words.first.toLowerCase();
    final rest = words
        .skip(1)
        .where((w) => w.isNotEmpty)
        .map((w) => '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}')
        .join();
    return '$first$rest';
  }

  /// Converts string to PascalCase (e.g. 'user_profile' -> 'UserProfile').
  String toPascalCase() {
    final words = split(RegExp(r'[_\s-]'));
    return words
        .where((w) => w.isNotEmpty)
        .map((w) => '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}')
        .join();
  }

  /// Converts string to snake_case (e.g. 'UserProfile' -> 'user_profile').
  String toSnakeCase() {
    return replaceAllMapped(
      RegExp(r'([A-Z])'),
      (match) => '_${match.group(1)!.toLowerCase()}',
    ).replaceAll(RegExp(r'[-\s]+'), '_').replaceAll(RegExp(r'^_+'), '');
  }
}

/// Generates a feature folder structure and boilerplate tailored to the project's config.
class FeatureGenerator {
  const FeatureGenerator();

  /// Generates map of relative file paths to their file contents.
  Map<String, String> generateFeature({
    required String featureName,
    required ProjectConfig config,
  }) {
    final snake = featureName.toSnakeCase();
    final pascal = featureName.toPascalCase();
    final camel = featureName.toCamelCase();

    final files = <String, String>{};

    switch (config.architecture) {
      case ArchitecturePattern.featureFirst:
        _generateFeatureFirst(files, snake, pascal, camel, config);
        break;
      case ArchitecturePattern.layerFirst:
        _generateLayerFirst(files, snake, pascal, camel, config);
        break;
      case ArchitecturePattern.mvvm:
        _generateMvvm(files, snake, pascal, camel, config);
        break;
      case ArchitecturePattern.simpleMvc:
        _generateSimpleMvc(files, snake, pascal, camel, config);
        break;
      case ArchitecturePattern.modular:
        _generateModular(files, snake, pascal, camel, config);
        break;
    }

    return files;
  }

  void _generateFeatureFirst(
    Map<String, String> files,
    String snake,
    String pascal,
    String camel,
    ProjectConfig config,
  ) {
    final basePath = 'lib/features/$snake';

    // Domain
    files['$basePath/domain/entities/${snake}_entity.dart'] =
        '''
/// Domain entity representing $pascal.
class ${pascal}Entity {
  const ${pascal}Entity({
    required this.id,
    required this.title,
  });

  final String id;
  final String title;
}
''';

    files['$basePath/domain/repositories/${snake}_repository.dart'] =
        '''
import '../entities/${snake}_entity.dart';

/// Repository interface for $pascal feature.
abstract class ${pascal}Repository {
  Future<${pascal}Entity> get$pascal(String id);
}
''';

    // Data
    files['$basePath/data/models/${snake}_model.dart'] =
        '''
import '../../domain/entities/${snake}_entity.dart';

/// Data model for $pascal.
class ${pascal}Model extends ${pascal}Entity {
  const ${pascal}Model({
    required super.id,
    required super.title,
  });

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

    files['$basePath/data/repositories/${snake}_repository_impl.dart'] =
        '''
import '../../domain/entities/${snake}_entity.dart';
import '../../domain/repositories/${snake}_repository.dart';
import '../models/${snake}_model.dart';

/// Repository implementation for $pascal.
class ${pascal}RepositoryImpl implements ${pascal}Repository {
  const ${pascal}RepositoryImpl();

  @override
  Future<${pascal}Entity> get$pascal(String id) async {
    return ${pascal}Model(id: id, title: 'Sample $pascal');
  }
}
''';

    // Presentation
    _addPresentationFiles(
      files,
      '$basePath/presentation',
      snake,
      pascal,
      camel,
      config,
    );
  }

  void _generateLayerFirst(
    Map<String, String> files,
    String snake,
    String pascal,
    String camel,
    ProjectConfig config,
  ) {
    // Domain
    files['lib/domain/entities/${snake}_entity.dart'] =
        '''
/// Domain entity representing $pascal.
class ${pascal}Entity {
  const ${pascal}Entity({
    required this.id,
    required this.title,
  });

  final String id;
  final String title;
}
''';

    files['lib/domain/repositories/${snake}_repository.dart'] =
        '''
import '../entities/${snake}_entity.dart';

/// Repository interface for $pascal.
abstract class ${pascal}Repository {
  Future<${pascal}Entity> get$pascal(String id);
}
''';

    // Data
    files['lib/data/models/${snake}_model.dart'] =
        '''
import '../../domain/entities/${snake}_entity.dart';

/// Data model for $pascal.
class ${pascal}Model extends ${pascal}Entity {
  const ${pascal}Model({
    required super.id,
    required super.title,
  });

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

    files['lib/data/repositories/${snake}_repository_impl.dart'] =
        '''
import '../../domain/entities/${snake}_entity.dart';
import '../../domain/repositories/${snake}_repository.dart';
import '../models/${snake}_model.dart';

/// Repository implementation for $pascal.
class ${pascal}RepositoryImpl implements ${pascal}Repository {
  const ${pascal}RepositoryImpl();

  @override
  Future<${pascal}Entity> get$pascal(String id) async {
    return ${pascal}Model(id: id, title: 'Sample $pascal');
  }
}
''';

    // Presentation
    _addPresentationFiles(
      files,
      'lib/presentation/$snake',
      snake,
      pascal,
      camel,
      config,
    );
  }

  void _generateMvvm(
    Map<String, String> files,
    String snake,
    String pascal,
    String camel,
    ProjectConfig config,
  ) {
    // Model
    files['lib/models/${snake}_model.dart'] =
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

    // ViewModel
    if (config.stateManagement == StateManagement.bloc) {
      files['lib/viewmodels/${snake}_cubit.dart'] =
          '''
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/${snake}_model.dart';

class ${pascal}State extends Equatable {
  const ${pascal}State({this.item, this.isLoading = false});

  final ${pascal}Model? item;
  final bool isLoading;

  ${pascal}State copyWith({${pascal}Model? item, bool? isLoading}) {
    return ${pascal}State(
      item: item ?? this.item,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [item, isLoading];
}

class ${pascal}Cubit extends Cubit<${pascal}State> {
  ${pascal}Cubit() : super(const ${pascal}State());

  void load(String id) {
    emit(state.copyWith(isLoading: true));
    emit(state.copyWith(
      item: ${pascal}Model(id: id, title: 'Loaded $pascal'),
      isLoading: false,
    ));
  }
}
''';
    } else if (config.stateManagement == StateManagement.riverpod) {
      files['lib/viewmodels/${snake}_viewmodel.dart'] =
          '''
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/${snake}_model.dart';

class ${pascal}State {
  const ${pascal}State({this.item, this.isLoading = false});

  final ${pascal}Model? item;
  final bool isLoading;
}

class ${pascal}ViewModel extends StateNotifier<${pascal}State> {
  ${pascal}ViewModel() : super(const ${pascal}State());

  void load(String id) {
    state = ${pascal}State(
      item: ${pascal}Model(id: id, title: 'Loaded $pascal'),
      isLoading: false,
    );
  }
}

final ${camel}Provider = StateNotifierProvider<${pascal}ViewModel, ${pascal}State>((ref) {
  return ${pascal}ViewModel();
});
''';
    } else {
      files['lib/viewmodels/${snake}_viewmodel.dart'] =
          '''
import 'package:flutter/foundation.dart';
import '../models/${snake}_model.dart';

class ${pascal}ViewModel extends ChangeNotifier {
  ${pascal}Model? _item;
  bool _isLoading = false;

  ${pascal}Model? get item => _item;
  bool get isLoading => _isLoading;

  void load(String id) {
    _isLoading = true;
    notifyListeners();
    _item = ${pascal}Model(id: id, title: 'Loaded $pascal');
    _isLoading = false;
    notifyListeners();
  }
}
''';
    }

    // View
    files['lib/views/${snake}_view.dart'] =
        '''
import 'package:flutter/material.dart';

class ${pascal}View extends StatelessWidget {
  const ${pascal}View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('$pascal'),
      ),
      body: const Center(
        child: Text('$pascal View'),
      ),
    );
  }
}
''';
  }

  void _generateSimpleMvc(
    Map<String, String> files,
    String snake,
    String pascal,
    String camel,
    ProjectConfig config,
  ) {
    // Model
    files['lib/models/${snake}_model.dart'] =
        '''
class ${pascal}Model {
  const ${pascal}Model({
    required this.id,
    required this.title,
  });

  final String id;
  final String title;
}
''';

    // Screen
    files['lib/screens/${snake}_screen.dart'] =
        '''
import 'package:flutter/material.dart';

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
  }

  void _addPresentationFiles(
    Map<String, String> files,
    String presentationPath,
    String snake,
    String pascal,
    String camel,
    ProjectConfig config,
  ) {
    if (config.stateManagement == StateManagement.bloc) {
      files['$presentationPath/bloc/${snake}_cubit.dart'] =
          '''
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ${pascal}State extends Equatable {
  const ${pascal}State({this.isLoading = false});

  final bool isLoading;

  @override
  List<Object?> get props => [isLoading];
}

class ${pascal}Cubit extends Cubit<${pascal}State> {
  ${pascal}Cubit() : super(const ${pascal}State());
}
''';
    } else if (config.stateManagement == StateManagement.riverpod) {
      files['$presentationPath/providers/${snake}_provider.dart'] =
          '''
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ${camel}Provider = Provider<String>((ref) {
  return '$pascal Provider';
});
''';
    }

    files['$presentationPath/views/${snake}_view.dart'] =
        '''
import 'package:flutter/material.dart';

class ${pascal}View extends StatelessWidget {
  const ${pascal}View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('$pascal'),
      ),
      body: const Center(
        child: Text('$pascal View'),
      ),
    );
  }
}
''';
  }

  void _generateModular(
    Map<String, String> files,
    String snake,
    String pascal,
    String camel,
    ProjectConfig config,
  ) {
    final basePath = 'lib/modules/$snake';

    // 1. Models
    files['$basePath/models/${snake}_model.dart'] = '''
/// Data model for $pascal.
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

    // 2. Repositories
    files['$basePath/repositories/${snake}_repository.dart'] = '''
import '../models/${snake}_model.dart';

/// Repository interface for $pascal module.
abstract class ${pascal}Repository {
  Future<${pascal}Model> get$pascal(String id);
}

/// Repository implementation for $pascal module.
class ${pascal}RepositoryImpl implements ${pascal}Repository {
  const ${pascal}RepositoryImpl();

  @override
  Future<${pascal}Model> get$pascal(String id) async {
    return ${pascal}Model(id: id, title: 'Sample $pascal');
  }
}
''';

    // 3. Logic & 4. Providers
    if (config.stateManagement == StateManagement.bloc) {
      files['$basePath/logic/${snake}_cubit.dart'] = '''
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/${snake}_model.dart';
import '../repositories/${snake}_repository.dart';

class ${pascal}State extends Equatable {
  const ${pascal}State({this.item, this.isLoading = false});

  final ${pascal}Model? item;
  final bool isLoading;

  ${pascal}State copyWith({${pascal}Model? item, bool? isLoading}) {
    return ${pascal}State(
      item: item ?? this.item,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [item, isLoading];
}

class ${pascal}Cubit extends Cubit<${pascal}State> {
  ${pascal}Cubit({this.repository = const ${pascal}RepositoryImpl()})
      : super(const ${pascal}State());

  final ${pascal}Repository repository;

  Future<void> load(String id) async {
    emit(state.copyWith(isLoading: true));
    final result = await repository.get$pascal(id);
    emit(state.copyWith(item: result, isLoading: false));
  }
}
''';
      files['$basePath/providers/${snake}_provider.dart'] = '''
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../logic/${snake}_cubit.dart';

/// BlocProvider helper for $pascal module.
Widget build${pascal}Provider({required Widget child}) {
  return BlocProvider(
    create: (_) => ${pascal}Cubit(),
    child: child,
  );
}
''';
    } else if (config.stateManagement == StateManagement.riverpod) {
      files['$basePath/logic/${snake}_controller.dart'] = '''
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/${snake}_model.dart';
import '../repositories/${snake}_repository.dart';

class ${pascal}State {
  const ${pascal}State({this.item, this.isLoading = false});

  final ${pascal}Model? item;
  final bool isLoading;
}

class ${pascal}Controller extends StateNotifier<${pascal}State> {
  ${pascal}Controller({this.repository = const ${pascal}RepositoryImpl()})
      : super(const ${pascal}State());

  final ${pascal}Repository repository;

  Future<void> load(String id) async {
    final item = await repository.get$pascal(id);
    state = ${pascal}State(item: item, isLoading: false);
  }
}
''';
      files['$basePath/providers/${snake}_provider.dart'] = '''
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../logic/${snake}_controller.dart';

final ${camel}ControllerProvider =
    StateNotifierProvider<${pascal}Controller, ${pascal}State>((ref) {
  return ${pascal}Controller();
});
''';
    } else if (config.stateManagement == StateManagement.provider) {
      files['$basePath/logic/${snake}_notifier.dart'] = '''
import 'package:flutter/foundation.dart';
import '../models/${snake}_model.dart';
import '../repositories/${snake}_repository.dart';

class ${pascal}Notifier extends ChangeNotifier {
  ${pascal}Notifier({this.repository = const ${pascal}RepositoryImpl()});

  final ${pascal}Repository repository;
  ${pascal}Model? _item;
  bool _isLoading = false;

  ${pascal}Model? get item => _item;
  bool get isLoading => _isLoading;

  Future<void> load(String id) async {
    _isLoading = true;
    notifyListeners();
    _item = await repository.get$pascal(id);
    _isLoading = false;
    notifyListeners();
  }
}
''';
      files['$basePath/providers/${snake}_provider.dart'] = '''
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../logic/${snake}_notifier.dart';

SingleChildWidget create${pascal}Provider() {
  return ChangeNotifierProvider(create: (_) => ${pascal}Notifier());
}
''';
    } else {
      // GetX / None
      files['$basePath/logic/${snake}_controller.dart'] = '''
import '../models/${snake}_model.dart';
import '../repositories/${snake}_repository.dart';

class ${pascal}Controller {
  ${pascal}Controller({this.repository = const ${pascal}RepositoryImpl()});

  final ${pascal}Repository repository;

  Future<${pascal}Model> load(String id) {
    return repository.get$pascal(id);
  }
}
''';
      files['$basePath/providers/${snake}_provider.dart'] = '''
import '../logic/${snake}_controller.dart';

${pascal}Controller create${pascal}Controller() => ${pascal}Controller();
''';
    }

    // 5. Screens
    files['$basePath/screens/${snake}_screen.dart'] = '''
import 'package:flutter/material.dart';

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
  }
}
