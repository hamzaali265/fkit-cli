import 'dart:convert';

import '../models/project_config.dart';
import '../templates/analysis_options_template.dart';
import '../templates/core_templates.dart';
import '../templates/domain_data_templates.dart';
import '../templates/l10n_template.dart';
import '../templates/main_template.dart';
import '../templates/picker_templates.dart';
import '../templates/pubspec_template.dart';
import '../templates/routing_templates.dart';
import '../templates/screen_templates.dart';
import '../templates/state_templates.dart';
import '../templates/widget_templates.dart';

/// Engine responsible for compiling templates into file paths and contents.
class TemplateEngine {
  const TemplateEngine();

  /// Generates a map of relative file paths to their string contents.
  Map<String, String> generateFiles(ProjectConfig config) {
    final files = <String, String>{};

    // 1. Root configuration files
    files['pubspec.yaml'] = renderPubspecYaml(config);
    files['analysis_options.yaml'] = renderAnalysisOptions(config);
    files['README.md'] = _renderReadme(config);
    files['.fkit.json'] = _renderFkitJson(config);

    // 2. Localization
    if (config.hasLocalization) {
      files['l10n.yaml'] = renderL10nYaml();
      files['lib/l10n/app_en.arb'] = renderAppEnArb(config);
      files['lib/l10n/app_localizations.dart'] = renderAppLocalizationsDart(
        config,
      );
    }

    // 3. Core infrastructure files
    final isFeatureFirst =
        config.architecture == ArchitecturePattern.featureFirst;
    final isLayerFirst = config.architecture == ArchitecturePattern.layerFirst;
    final isMvvm = config.architecture == ArchitecturePattern.mvvm;
    final isModular = config.architecture == ArchitecturePattern.modular;

    final usesCoreDir = isFeatureFirst || isLayerFirst || isModular;
    final corePrefix = usesCoreDir ? 'lib/core/' : 'lib/';

    files['${corePrefix}theme/app_colors.dart'] = renderAppColors();
    files['${corePrefix}theme/app_fonts.dart'] = renderAppFonts();
    files['${corePrefix}theme/app_theme.dart'] = renderAppTheme();
    files['${corePrefix}theme/theme.dart'] = renderThemeBarrel();

    if (config.hasEnvFlavors) {
      files['${corePrefix}config/app_config.dart'] = renderAppConfig();
    }

    if (config.networking != Networking.none) {
      final netPrefix = usesCoreDir ? 'lib/core/network/' : 'lib/network/';
      files['${netPrefix}api_contract.dart'] = renderApiContract(config);
      files['${netPrefix}api_endpoint.dart'] = renderApiEndpoint(config);
      files['${netPrefix}api_response.dart'] = renderApiResponse();
      files['${netPrefix}app_exception.dart'] = renderAppException(config);
      files['${netPrefix}api_interceptor.dart'] = renderApiInterceptor(config);
      files['${netPrefix}api_service.dart'] = renderApiService(config);
      files['${netPrefix}api_client.dart'] = renderApiService(config);
      files['${netPrefix}network_event_provider.dart'] =
          renderNetworkEventProvider(config);
      files['${netPrefix}failures/failure.dart'] = renderFailure();
      files['${netPrefix}failures/exception.dart'] = renderException();
      files['${netPrefix}network.dart'] = renderNetworkBarrel();

      if (!usesCoreDir) {
        files['lib/services/api_client.dart'] = '''
import '../network/network.dart';

export '../network/network.dart';

typedef ApiClient = ApiService;
''';
      }
    }

    if (config.storage != Storage.none) {
      final storagePath = usesCoreDir
          ? 'lib/core/storage/storage_service.dart'
          : 'lib/services/storage_service.dart';
      files[storagePath] = renderStorageService(config);
    }

    if (config.hasGetIt) {
      final diPath = usesCoreDir
          ? 'lib/core/di/injection_container.dart'
          : 'lib/services/injection_container.dart';
      files[diPath] = renderInjectionContainer(
        config,
        usesCoreDir: usesCoreDir,
      );
    }

    // 4. Shared cross-cutting components (widgets, extensions, utilities)
    files['lib/shared/widgets/app_button.dart'] = renderAppButton();
    files['lib/shared/extensions/context_extensions.dart'] =
        renderContextExtensions();
    files['lib/shared/extensions/widget_extensions.dart'] =
        renderWidgetExtensions();
    files['lib/shared/extensions/string_extensions.dart'] =
        renderStringExtensions();
    files['lib/shared/extensions/number_extensions.dart'] =
        renderNumberExtensions(hasIntl: config.hasIntl);
    if (config.hasIntl) {
      files['lib/shared/extensions/datetime_extensions.dart'] =
          renderDateTimeExtensions();
    }
    files['lib/shared/extensions/extensions.dart'] = renderExtensionsBarrel(
      hasIntl: config.hasIntl,
    );
    files['lib/shared/utils/app_formatters.dart'] = renderAppFormatters(
      hasIntl: config.hasIntl,
    );

    if (config.hasCrypto) {
      files['lib/shared/utils/app_crypto.dart'] = renderAppCrypto();
    }

    files['lib/shared/utils/utils.dart'] = renderUtilsBarrel(
      hasCrypto: config.hasCrypto,
    );

    // Asset folder placeholders (directories created on disk in generator too)
    if (config.hasAssetsStructure) {
      files['assets/images/.gitkeep'] = '';
      files['assets/icons/.gitkeep'] = '';
      files['assets/svgs/.gitkeep'] = '';
      files['assets/fonts/.gitkeep'] = '';
      files['lib/shared/constants/app_assets.dart'] = renderAppAssets(
        hasFlutterSvg: config.hasFlutterSvg,
      );
      files['lib/shared/constants/constants.dart'] = renderConstantsBarrel();
    }

    // UI Utilities: Cached Network Image helper
    if (config.hasCachedNetworkImage) {
      files['lib/shared/widgets/app_network_image.dart'] =
          renderAppNetworkImage(config);
    }

    // UI Utilities: In-App Web View helper
    if (config.hasWebview) {
      files['lib/shared/widgets/app_webview.dart'] = renderAppWebView();
    }

    files['lib/shared/widgets/widgets.dart'] = renderWidgetsBarrel(
      hasCachedNetworkImage: config.hasCachedNetworkImage,
      hasWebview: config.hasWebview,
    );

    // UI Utilities: Starter SVG Icon
    if (config.hasFlutterSvg) {
      files['assets/icons/app_logo.svg'] = renderStarterSvg(config);
      if (config.hasAssetsStructure) {
        files['assets/svgs/app_logo.svg'] = renderStarterSvg(config);
      }
    }

    // Camera & Gallery Image Picker Service
    if (config.hasImagePicker) {
      final pickerPath = usesCoreDir
          ? 'lib/core/services/image_picker_service.dart'
          : 'lib/services/image_picker_service.dart';
      files[pickerPath] = renderImagePickerService();
    }

    // Cross-Platform File & Document Picker Service
    if (config.hasFilePicker) {
      final pickerPath = usesCoreDir
          ? 'lib/core/services/file_picker_service.dart'
          : 'lib/services/file_picker_service.dart';
      files[pickerPath] = renderFilePickerService();
    }

    // Cross-Platform Geolocation Service
    if (config.hasGeolocator) {
      final locationPath = usesCoreDir
          ? 'lib/core/services/location_service.dart'
          : 'lib/services/location_service.dart';
      files[locationPath] = renderLocationService();
    }

    // 5. Architectural Domain, Data, Presentation layers
    String controllerRelPath;
    String screenRelPath;
    String routerRelPath;
    String screenImportPrefix;
    String routerScreenImport;

    final hasStorage = config.storage != Storage.none;

    if (isFeatureFirst) {
      // Feature-First: Clean architecture within feature folder
      final featureRoot = 'lib/features/counter';
      final storageImportForRepo = hasStorage
          ? "import '../../../../core/storage/storage_service.dart';"
          : '';

      // Domain
      files['$featureRoot/domain/entities/counter_entity.dart'] =
          renderCounterEntity();
      files['$featureRoot/domain/repositories/counter_repository.dart'] =
          renderCounterRepositoryInterface(
            "import '../entities/counter_entity.dart';",
          );

      // Data
      files['$featureRoot/data/models/counter_model.dart'] = renderCounterModel(
        "import '../../domain/entities/counter_entity.dart';",
      );
      files['$featureRoot/data/repositories/counter_repository_impl.dart'] =
          renderCounterRepositoryImpl(
            entityImport: "import '../../domain/entities/counter_entity.dart';",
            repoInterfaceImport:
                "import '../../domain/repositories/counter_repository.dart';",
            storageServiceImport: storageImportForRepo,
            hasStorage: hasStorage,
          );

      // Presentation
      final stateDirName = config.stateManagement == StateManagement.bloc
          ? 'bloc'
          : (config.stateManagement == StateManagement.riverpod
                ? 'controllers'
                : (config.stateManagement == StateManagement.provider
                      ? 'notifiers'
                      : 'controllers'));

      controllerRelPath =
          '$featureRoot/presentation/$stateDirName/counter_controller.dart';
      screenRelPath = '$featureRoot/presentation/screens/counter_screen.dart';
      routerRelPath = 'lib/core/routes/app_router.dart';
      screenImportPrefix = "import '../$stateDirName/counter_controller.dart';";
      routerScreenImport =
          "import '../../features/counter/presentation/screens/counter_screen.dart';";
    } else if (isLayerFirst) {
      final storageImportForRepo = hasStorage
          ? "import '../../core/storage/storage_service.dart';"
          : '';

      // Layer-First: Global domain, data, presentation layers
      files['lib/domain/entities/counter_entity.dart'] = renderCounterEntity();
      files['lib/domain/repositories/counter_repository.dart'] =
          renderCounterRepositoryInterface(
            "import '../entities/counter_entity.dart';",
          );
      files['lib/domain/usecases/counter_usecases.dart'] =
          renderCounterUseCases(
            entityImport: "import '../entities/counter_entity.dart';",
            repoInterfaceImport:
                "import '../repositories/counter_repository.dart';",
          );

      files['lib/data/models/counter_model.dart'] = renderCounterModel(
        "import '../../domain/entities/counter_entity.dart';",
      );
      files['lib/data/repositories/counter_repository_impl.dart'] =
          renderCounterRepositoryImpl(
            entityImport: "import '../../domain/entities/counter_entity.dart';",
            repoInterfaceImport:
                "import '../../domain/repositories/counter_repository.dart';",
            storageServiceImport: storageImportForRepo,
            hasStorage: hasStorage,
          );

      final stateDirName = config.stateManagement == StateManagement.bloc
          ? 'bloc'
          : (config.stateManagement == StateManagement.riverpod
                ? 'providers'
                : (config.stateManagement == StateManagement.provider
                      ? 'notifiers'
                      : 'controllers'));

      controllerRelPath =
          'lib/presentation/$stateDirName/counter_controller.dart';
      screenRelPath = 'lib/presentation/pages/counter_page.dart';
      routerRelPath = 'lib/presentation/routes/app_router.dart';
      screenImportPrefix = "import '../$stateDirName/counter_controller.dart';";
      routerScreenImport = "import '../pages/counter_page.dart';";
    } else if (isMvvm) {
      // MVVM: models, services, viewmodels, views
      files['lib/models/counter_model.dart'] = renderCounterEntity();
      controllerRelPath = 'lib/viewmodels/counter_viewmodel.dart';
      screenRelPath = 'lib/views/counter/counter_view.dart';
      routerRelPath = 'lib/routes/app_router.dart';
      screenImportPrefix = "import '../../viewmodels/counter_viewmodel.dart';";
      routerScreenImport = "import '../views/counter/counter_view.dart';";
    } else if (isModular) {
      // Modular: modules/<name>/{models, repositories, logic, providers, screens}
      final moduleRoot = 'lib/modules/counter';
      final storageImportForRepo = hasStorage
          ? "import '../../../core/storage/storage_service.dart';"
          : '';

      files['$moduleRoot/models/counter_model.dart'] = '''
/// Data model for Counter.
class CounterModel {
  const CounterModel({required this.value});

  final int value;

  factory CounterModel.fromJson(Map<String, dynamic> json) {
    return CounterModel(
      value: (json['value'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
    };
  }
}
''';

      files['$moduleRoot/repositories/counter_repository.dart'] = '''
${storageImportForRepo.isNotEmpty ? '$storageImportForRepo\n' : ''}import '../models/counter_model.dart';

/// Repository interface for Counter module.
abstract class CounterRepository {
  Future<CounterModel> getCounter();
  Future<void> saveCounter(CounterModel model);
}

/// Repository implementation for Counter module.
class CounterRepositoryImpl implements CounterRepository {
  const CounterRepositoryImpl();
  static const String _storageKey = 'counter_value';

  @override
  Future<CounterModel> getCounter() async {
${hasStorage ? '    final value = await StorageService.getInt(_storageKey) ?? 0;\n    return CounterModel(value: value);' : '    return const CounterModel(value: 0);'}
  }

  @override
  Future<void> saveCounter(CounterModel model) async {
${hasStorage ? '    await StorageService.setInt(_storageKey, model.value);' : '    // In-memory or fallback persistence'}
  }
}
''';

      // Logic & Providers
      if (config.stateManagement == StateManagement.bloc) {
        files['$moduleRoot/logic/counter_cubit.dart'] =
            renderStateController(config);
        files['$moduleRoot/providers/counter_bloc_provider.dart'] = '''
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../logic/counter_cubit.dart';

Widget buildCounterProvider({required Widget child}) {
  return BlocProvider(
    create: (_) => CounterCubit(),
    child: child,
  );
}
''';
        screenImportPrefix =
            "import '../logic/counter_cubit.dart';\nimport '../providers/counter_bloc_provider.dart';";
      } else if (config.stateManagement == StateManagement.riverpod) {
        files['$moduleRoot/logic/counter_notifier.dart'] = '''
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Riverpod StateNotifier managing the counter value.
class CounterNotifier extends StateNotifier<int> {
  CounterNotifier() : super(0);

  void increment() => state++;
  void decrement() => state--;
  void reset() => state = 0;
}
''';
        files['$moduleRoot/providers/counter_notifier_provider.dart'] = '''
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../logic/counter_notifier.dart';

export '../logic/counter_notifier.dart';

/// Global provider for the counter state.
final counterNotifierProvider = StateNotifierProvider<CounterNotifier, int>((ref) {
  return CounterNotifier();
});

/// Alias provider for counter access.
final counterProvider = counterNotifierProvider;
''';
        screenImportPrefix =
            "import '../logic/counter_notifier.dart';\nimport '../providers/counter_notifier_provider.dart';";
      } else if (config.stateManagement == StateManagement.provider) {
        files['$moduleRoot/logic/counter_notifier.dart'] =
            renderStateController(config);
        files['$moduleRoot/providers/counter_provider.dart'] = '''
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../logic/counter_notifier.dart';

export '../logic/counter_notifier.dart';

SingleChildWidget createCounterProvider() {
  return ChangeNotifierProvider(create: (_) => CounterModel());
}
''';
        screenImportPrefix =
            "import '../logic/counter_notifier.dart';\nimport '../providers/counter_provider.dart';";
      } else if (config.stateManagement == StateManagement.getx) {
        files['$moduleRoot/logic/counter_controller.dart'] =
            renderStateController(config);
        files['$moduleRoot/providers/counter_binding.dart'] = '''
import 'package:get/get.dart';
import '../logic/counter_controller.dart';

export '../logic/counter_controller.dart';

class CounterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CounterController>(() => CounterController());
  }
}
''';
        screenImportPrefix =
            "import '../logic/counter_controller.dart';\nimport '../providers/counter_binding.dart';";
      } else {
        files['$moduleRoot/logic/counter_controller.dart'] =
            renderStateController(config);
        files['$moduleRoot/providers/counter_provider.dart'] = '''
import '../logic/counter_controller.dart';

export '../logic/counter_controller.dart';
''';
        screenImportPrefix = "import '../logic/counter_controller.dart';";
      }

      controllerRelPath = '';
      screenRelPath = '$moduleRoot/screens/counter_screen.dart';
      routerRelPath = 'lib/core/routes/app_router.dart';
      routerScreenImport =
          "import '../../modules/counter/screens/counter_screen.dart';";
    } else {
      // Simple MVC
      files['lib/models/counter_model.dart'] = renderCounterEntity();
      controllerRelPath = 'lib/controllers/counter_controller.dart';
      screenRelPath = 'lib/screens/counter_screen.dart';
      routerRelPath = 'lib/routes/app_router.dart';
      screenImportPrefix = "import '../controllers/counter_controller.dart';";
      routerScreenImport = "import '../screens/counter_screen.dart';";
    }

    // State Controller file
    if (controllerRelPath.isNotEmpty &&
        config.stateManagement != StateManagement.none) {
      files[controllerRelPath] = renderStateController(config);
    }

    files[screenRelPath] = renderCounterScreen(
      config,
      config.stateManagement != StateManagement.none ? screenImportPrefix : '',
    );

    files[routerRelPath] = renderRouter(config, routerScreenImport);

    // 5. Main entrypoint
    final themeImport = usesCoreDir
        ? "import 'core/theme/theme.dart';"
        : "import 'theme/theme.dart';";

    final storageImport = usesCoreDir
        ? "import 'core/storage/storage_service.dart';"
        : "import 'services/storage_service.dart';";

    final diImport = config.hasGetIt
        ? (usesCoreDir
              ? "import 'core/di/injection_container.dart';"
              : "import 'services/injection_container.dart';")
        : '';

    final routerImport = (isFeatureFirst || isModular)
        ? "import 'core/routes/app_router.dart';"
        : (isLayerFirst
              ? "import 'presentation/routes/app_router.dart';"
              : "import 'routes/app_router.dart';");

    final screenImport = isFeatureFirst
        ? "import 'features/counter/presentation/screens/counter_screen.dart';"
        : (isModular
              ? "import 'modules/counter/screens/counter_screen.dart';"
              : (isLayerFirst
                    ? "import 'presentation/pages/counter_page.dart';"
                    : (isMvvm
                          ? "import 'views/counter/counter_view.dart';"
                          : "import 'screens/counter_screen.dart';")));

    files['lib/main.dart'] = renderMainDart(
      config,
      themeImport: themeImport,
      routerImport: routerImport,
      screenImport: screenImport,
      storageImport: storageImport,
      diImport: diImport,
    );

    return files;
  }

  String _renderReadme(ProjectConfig config) {
    return '''
# ${config.projectName}

${config.description}

Bootstrapped with **[FKIT CLI](https://github.com/)** 🚀

## Architecture & Stack

- **Architecture:** ${config.architecture.label}
- **State Management:** ${config.stateManagement.label}
- **Routing:** ${config.routing.label}
- **Networking:** ${config.networking.label}
- **Local Storage:** ${config.storage.label}
- **Utilities:** ${config.utilities.isEmpty ? 'None' : config.utilities.map((u) => u.packageName).join(', ')}
- **Strict Lints:** ${config.hasStrictLinting ? 'Enabled (very_good_analysis)' : 'Standard'}
- **Localization:** ${config.hasLocalization ? 'Enabled (flutter_localizations + ARB)' : 'Disabled'}
- **Environment Flavors:** ${config.hasEnvFlavors ? 'Enabled (AppConfig)' : 'Disabled'}

## Getting Started

### 1. Install Dependencies
```bash
flutter pub get
```

${config.hasLocalization ? '''### 2. Generate Localization Files
```bash
flutter gen-l10n
```
''' : ''}
### 3. Run the App
```bash
flutter run
```

${config.hasEnvFlavors ? '''### Run with Environment Flavor
```bash
flutter run --dart-define=ENV=dev
flutter run --dart-define=ENV=prod
```
''' : ''}
''';
  }

  String _renderFkitJson(ProjectConfig config) {
    const encoder = JsonEncoder.withIndent('  ');
    return '${encoder.convert(config.toJson())}\n';
  }
}
