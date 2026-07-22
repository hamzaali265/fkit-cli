/// Architecture patterns supported by fkit.
enum ArchitecturePattern {
  featureFirst(
    'Feature-first',
    'Modular structure grouped by business features (lib/features/<name>/{presentation, domain, data})',
  ),
  layerFirst(
    'Layer-first',
    'Classical clean architecture grouped by technical layers (lib/data, lib/domain, lib/presentation)',
  ),
  mvvm(
    'MVVM',
    'Clean separation of UI, business logic, and data (lib/views, lib/viewmodels, lib/models, lib/services)',
  ),
  simpleMvc(
    'MVC',
    'Flat and lightweight structure (lib/screens, lib/models, lib/services, lib/widgets)',
  );

  const ArchitecturePattern(this.label, this.description);
  final String label;
  final String description;

  static ArchitecturePattern fromKey(String key) {
    switch (key.toLowerCase().replaceAll('-', '_')) {
      case 'feature_first':
      case 'feature':
        return ArchitecturePattern.featureFirst;
      case 'layer_first':
      case 'clean':
      case 'layer':
        return ArchitecturePattern.layerFirst;
      case 'mvvm':
      case 'viewmodel':
        return ArchitecturePattern.mvvm;
      case 'simple_mvc':
      case 'simple':
      case 'mvc':
        return ArchitecturePattern.simpleMvc;
      default:
        throw ArgumentError('Unknown architecture: $key');
    }
  }
}

/// State management options supported by fkit.
enum StateManagement {
  bloc(
    'BLoC',
    'State management library following the BLoC design pattern',
  ),
  riverpod(
    'Riverpod',
    'Compile-safe and flexible state management provider system',
  ),
  provider(
    'Provider',
    'Recommended Flutter community standard for scoped dependency injection and state',
  ),
  getx(
    'GetX',
    'Fast and lightweight reactive state management and micro-framework',
  ),
  none('None', 'Built-in StatefulWidget and ValueNotifier');

  const StateManagement(this.label, this.description);
  final String label;
  final String description;

  static StateManagement fromKey(String key) {
    switch (key.toLowerCase().replaceAll('-', '_')) {
      case 'bloc':
      case 'flutter_bloc':
        return StateManagement.bloc;
      case 'riverpod':
      case 'flutter_riverpod':
        return StateManagement.riverpod;
      case 'provider':
        return StateManagement.provider;
      case 'getx':
      case 'get':
        return StateManagement.getx;
      case 'none':
      case 'vanilla':
        return StateManagement.none;
      default:
        throw ArgumentError('Unknown state management: $key');
    }
  }
}

/// Routing options supported by fkit.
enum Routing {
  goRouter(
    'go_router',
    'Declarative routing package supporting deep linking and route guards',
  ),
  autoRoute(
    'auto_route',
    'Strongly-typed declarative routing with code generation',
  ),
  standard(
    'Navigator',
    'Standard Flutter Navigator 2.0 / imperative routes',
  );

  const Routing(this.label, this.description);
  final String label;
  final String description;

  static Routing fromKey(String key) {
    switch (key.toLowerCase().replaceAll('-', '_')) {
      case 'go_router':
      case 'gorouter':
        return Routing.goRouter;
      case 'auto_route':
      case 'autoroute':
        return Routing.autoRoute;
      case 'standard':
      case 'navigator':
        return Routing.standard;
      default:
        throw ArgumentError('Unknown routing option: $key');
    }
  }
}

/// Networking options supported by fkit.
enum Networking {
  dio(
    'dio',
    'Powerful HTTP client with interceptors, global configuration, and form data',
  ),
  http('http', 'Official Dart composable and future-based HTTP library'),
  none('None', 'No dedicated network client');

  const Networking(this.label, this.description);
  final String label;
  final String description;

  static Networking fromKey(String key) {
    switch (key.toLowerCase().replaceAll('-', '_')) {
      case 'dio':
        return Networking.dio;
      case 'http':
        return Networking.http;
      case 'none':
        return Networking.none;
      default:
        throw ArgumentError('Unknown networking option: $key');
    }
  }
}

/// Local storage options supported by fkit.
enum Storage {
  sharedPreferences(
    'shared_preferences',
    'Key-value persistence for small data sets and settings',
  ),
  hive(
    'hive_flutter',
    'Fast, lightweight NoSQL key-value database written in pure Dart',
  ),
  none('None', 'No local database');

  const Storage(this.label, this.description);
  final String label;
  final String description;

  static Storage fromKey(String key) {
    switch (key.toLowerCase().replaceAll('-', '_')) {
      case 'shared_preferences':
      case 'sharedpreferences':
      case 'prefs':
        return Storage.sharedPreferences;
      case 'hive':
      case 'hive_flutter':
        return Storage.hive;
      case 'none':
        return Storage.none;
      default:
        throw ArgumentError('Unknown storage option: $key');
    }
  }
}

/// Additional project architectural features.
enum ProjectFeature {
  envFlavors(
    'Flavors',
    'AppConfig with development/production environments and dart-define support',
  ),
  strictLinting(
    'Strict linting',
    'very_good_analysis preconfigured in analysis_options.yaml',
  ),
  localization(
    'Localization',
    'l10n.yaml and starter ARB files with internationalization helper',
  ),
  assetsStructure(
    'Assets',
    'assets/images/, icons/, svgs/, and fonts/ created and declared in pubspec.yaml',
  );

  const ProjectFeature(this.label, this.description);
  final String label;
  final String description;
}

/// Popular utility packages for UI, native device access, and formatting.
enum UtilityPackage {
  flutterSvg('flutter_svg', '^2.0.17', 'SVG vector image and icon rendering'),
  cachedNetworkImage(
    'cached_network_image',
    '^3.4.1',
    'Image caching with placeholder and error fallback widgets',
  ),
  gap('gap', '^3.0.1', 'Clean whitespace spacing in flex widgets (Column/Row)'),
  flutterScreenutil(
    'flutter_screenutil',
    '^5.9.3',
    'Responsive UI adaptation and screen sizing (ScreenUtilInit)',
  ),
  imagePicker(
    'image_picker',
    '^1.1.2',
    'Camera photo capture and gallery image/video picker',
  ),
  filePicker(
    'file_picker',
    '^8.1.7',
    'Native cross-platform file, document, and directory picker',
  ),
  permissionHandler(
    'permission_handler',
    '^11.4.0',
    'Cross-platform runtime permissions management',
  ),
  getIt(
    'get_it',
    '^8.0.3',
    'Direct Service Locator / Dependency Injection (initDependencies)',
  ),
  flutterSecureStorage(
    'flutter_secure_storage',
    '^9.2.4',
    'Encrypted key-value storage (Keychain / Keystore)',
  ),
  urlLauncher(
    'url_launcher',
    '^6.3.1',
    'Launch web URLs, phone calls, and email client',
  ),
  uuid('uuid', '^4.5.1', 'RFC-compliant UUID generator');

  const UtilityPackage(this.packageName, this.version, this.description);
  final String packageName;
  final String version;
  final String description;

  static UtilityPackage fromKey(String key) {
    switch (key.toLowerCase().replaceAll('-', '_')) {
      case 'flutter_svg':
      case 'svg':
        return UtilityPackage.flutterSvg;
      case 'cached_network_image':
      case 'cached_image':
      case 'cache_image':
        return UtilityPackage.cachedNetworkImage;
      case 'gap':
        return UtilityPackage.gap;
      case 'flutter_screenutil':
      case 'screenutil':
      case 'screen_util':
        return UtilityPackage.flutterScreenutil;
      case 'image_picker':
      case 'camera':
      case 'image':
        return UtilityPackage.imagePicker;
      case 'file_picker':
      case 'file':
      case 'files':
        return UtilityPackage.filePicker;
      case 'permission_handler':
      case 'permissions':
      case 'permission':
        return UtilityPackage.permissionHandler;
      case 'get_it':
      case 'getit':
      case 'init':
      case 'di':
        return UtilityPackage.getIt;
      case 'flutter_secure_storage':
      case 'secure_storage':
        return UtilityPackage.flutterSecureStorage;
      case 'url_launcher':
      case 'launcher':
        return UtilityPackage.urlLauncher;
      case 'uuid':
        return UtilityPackage.uuid;
      default:
        throw ArgumentError('Unknown utility package: $key');
    }
  }
}

/// Complete configuration for scaffolding a Flutter project.
class ProjectConfig {
  final String projectName;
  final String orgName;
  final String description;
  final String targetDirectory;
  final ArchitecturePattern architecture;
  final StateManagement stateManagement;
  final Routing routing;
  final Networking networking;
  final Storage storage;
  final Set<ProjectFeature> features;
  final Set<UtilityPackage> utilities;
  final bool offline;

  ProjectConfig({
    required this.projectName,
    required this.orgName,
    this.description = 'A new Flutter project created with FKIT CLI.',
    required this.targetDirectory,
    required this.architecture,
    required this.stateManagement,
    required this.routing,
    required this.networking,
    required this.storage,
    required this.features,
    this.utilities = const {},
    this.offline = false,
  });

  bool get hasEnvFlavors => features.contains(ProjectFeature.envFlavors);
  bool get hasStrictLinting => features.contains(ProjectFeature.strictLinting);
  bool get hasLocalization => features.contains(ProjectFeature.localization);
  bool get hasAssetsStructure =>
      features.contains(ProjectFeature.assetsStructure);

  bool get hasFlutterSvg => utilities.contains(UtilityPackage.flutterSvg);
  bool get hasCachedNetworkImage =>
      utilities.contains(UtilityPackage.cachedNetworkImage);
  bool get hasGap => utilities.contains(UtilityPackage.gap);
  bool get hasScreenUtil =>
      utilities.contains(UtilityPackage.flutterScreenutil);
  bool get hasImagePicker => utilities.contains(UtilityPackage.imagePicker);
  bool get hasFilePicker => utilities.contains(UtilityPackage.filePicker);
  bool get hasPermissionHandler =>
      utilities.contains(UtilityPackage.permissionHandler);
  bool get hasGetIt => utilities.contains(UtilityPackage.getIt);
  bool get hasSecureStorage =>
      utilities.contains(UtilityPackage.flutterSecureStorage);
  bool get hasUrlLauncher => utilities.contains(UtilityPackage.urlLauncher);
  bool get hasUuid => utilities.contains(UtilityPackage.uuid);

  /// Computes the list of production dependencies with tested versions.
  Map<String, String> get dependencies {
    final deps = <String, String>{'flutter': 'sdk: flutter'};

    // State management
    switch (stateManagement) {
      case StateManagement.bloc:
        deps['flutter_bloc'] = '^8.1.6';
        deps['equatable'] = '^2.0.7';
        break;
      case StateManagement.riverpod:
        deps['flutter_riverpod'] = '^2.6.1';
        break;
      case StateManagement.provider:
        deps['provider'] = '^6.1.2';
        break;
      case StateManagement.getx:
        deps['get'] = '^4.6.6';
        break;
      case StateManagement.none:
        break;
    }

    // Routing
    switch (routing) {
      case Routing.goRouter:
        deps['go_router'] = '^14.8.0';
        break;
      case Routing.autoRoute:
        deps['auto_route'] = '^9.3.0';
        break;
      case Routing.standard:
        break;
    }

    // Networking
    switch (networking) {
      case Networking.dio:
        deps['dio'] = '^5.8.0+1';
        break;
      case Networking.http:
        deps['http'] = '^1.3.0';
        break;
      case Networking.none:
        break;
    }

    // Storage
    switch (storage) {
      case Storage.sharedPreferences:
        deps['shared_preferences'] = '^2.5.2';
        break;
      case Storage.hive:
        deps['hive'] = '^2.2.3';
        deps['hive_flutter'] = '^1.1.0';
        break;
      case Storage.none:
        break;
    }

    // Localization
    if (hasLocalization) {
      deps['flutter_localizations'] = 'sdk: flutter';
      deps['intl'] = '^0.20.2';
    }

    // Utility packages (flutter_svg, cached_network_image, gap, etc.)
    for (final util in utilities) {
      deps[util.packageName] = util.version;
    }

    return deps;
  }

  /// Computes the list of dev dependencies with tested versions.
  Map<String, String> get devDependencies {
    final devDeps = <String, String>{'flutter_test': 'sdk: flutter'};

    if (hasStrictLinting) {
      devDeps['very_good_analysis'] = '^7.0.0';
    } else {
      devDeps['flutter_lints'] = '^5.0.0';
    }

    if (routing == Routing.autoRoute) {
      devDeps['auto_route_generator'] = '^9.0.0';
      devDeps['build_runner'] = '^2.4.15';
    }

    return devDeps;
  }
}
