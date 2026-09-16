import 'package:fkit_cli/fkit_cli.dart';
import 'package:test/test.dart';

void main() {
  const engine = TemplateEngine();

  group('TemplateEngine', () {
    test(
      'generates all expected files for Feature-first BLoC config with domain and data layers',
      () {
        final config = ProjectConfig(
          projectName: 'bloc_app',
          orgName: 'com.example',
          targetDirectory: '/tmp/bloc_app',
          architecture: ArchitecturePattern.featureFirst,
          stateManagement: StateManagement.bloc,
          routing: Routing.goRouter,
          networking: Networking.dio,
          storage: Storage.sharedPreferences,
          features: {
            ProjectFeature.envFlavors,
            ProjectFeature.strictLinting,
            ProjectFeature.localization,
            ProjectFeature.assetsStructure,
          },
          utilities: {
            UtilityPackage.flutterSvg,
            UtilityPackage.cachedNetworkImage,
            UtilityPackage.gap,
          },
        );

        final files = engine.generateFiles(config);

        // Root files
        expect(files.containsKey('pubspec.yaml'), isTrue);
        expect(files.containsKey('analysis_options.yaml'), isTrue);
        expect(files.containsKey('README.md'), isTrue);
        expect(files.containsKey('l10n.yaml'), isTrue);
        expect(files.containsKey('lib/l10n/app_en.arb'), isTrue);
        expect(files.containsKey('lib/l10n/app_localizations.dart'), isTrue);

        // Core files
        expect(files.containsKey('lib/core/theme/app_colors.dart'), isTrue);
        expect(files.containsKey('lib/core/theme/app_fonts.dart'), isTrue);
        expect(files.containsKey('lib/core/theme/app_theme.dart'), isTrue);
        expect(files.containsKey('lib/core/theme/theme.dart'), isTrue);
        expect(
          files['lib/core/theme/app_colors.dart'],
          contains('class AppColors'),
        );
        expect(
          files['lib/core/theme/app_fonts.dart'],
          contains('class AppFonts'),
        );
        expect(
          files['lib/core/theme/theme.dart'],
          allOf(
            contains("export 'app_colors.dart';"),
            contains("export 'app_fonts.dart';"),
            contains("export 'app_theme.dart';"),
          ),
        );
        expect(
          files['lib/core/theme/app_theme.dart'],
          contains("import 'app_colors.dart';"),
        );
        expect(files.containsKey('lib/core/config/app_config.dart'), isTrue);
        expect(files.containsKey('lib/core/network/api_client.dart'), isTrue);
        expect(
          files.containsKey('lib/core/storage/storage_service.dart'),
          isTrue,
        );
        expect(
          files.containsKey('lib/shared/widgets/app_network_image.dart'),
          isTrue,
        );
        expect(files.containsKey('lib/shared/widgets/app_button.dart'), isTrue);
        expect(
          files.containsKey('lib/shared/extensions/context_extensions.dart'),
          isTrue,
        );
        expect(
          files.containsKey('lib/shared/extensions/string_extensions.dart'),
          isTrue,
        );
        expect(
          files.containsKey('lib/shared/extensions/widget_extensions.dart'),
          isTrue,
        );
        expect(
          files.containsKey('lib/shared/extensions/extensions.dart'),
          isTrue,
        );
        expect(
          files['lib/shared/extensions/extensions.dart'],
          allOf(
            contains("export 'context_extensions.dart';"),
            contains("export 'string_extensions.dart';"),
            contains("export 'widget_extensions.dart';"),
          ),
        );
        expect(files.containsKey('lib/shared/widgets/widgets.dart'), isTrue);
        expect(
          files['lib/shared/widgets/widgets.dart'],
          contains("export 'app_button.dart';"),
        );
        expect(files.containsKey('lib/shared/utils/utils.dart'), isTrue);
        expect(
          files.containsKey('lib/shared/utils/app_formatters.dart'),
          isTrue,
        );
        expect(files.containsKey('assets/icons/app_logo.svg'), isTrue);
        expect(files.containsKey('assets/svgs/app_logo.svg'), isTrue);
        expect(files.containsKey('assets/fonts/.gitkeep'), isTrue);
        expect(files.containsKey('assets/svgs/.gitkeep'), isTrue);
        expect(
          files.containsKey('lib/shared/constants/app_assets.dart'),
          isTrue,
        );
        expect(
          files.containsKey('lib/shared/constants/constants.dart'),
          isTrue,
        );
        expect(
          files['lib/shared/constants/app_assets.dart'],
          allOf(
            contains("static const String images = 'assets/images/';"),
            contains("static const String icons = 'assets/icons/';"),
            contains("static const String svgs = 'assets/svgs/';"),
            contains("static const String fonts = 'assets/fonts/';"),
            contains('appLogoSvg'),
          ),
        );
        expect(
          files['lib/shared/constants/constants.dart'],
          contains("export 'app_assets.dart';"),
        );

        final pubspec = files['pubspec.yaml']!;
        expect(pubspec, contains('assets/svgs/'));
        expect(pubspec, contains('# fonts:'));
        expect(pubspec, contains('assets/fonts/Schyler-Regular.ttf'));

        // Domain layer within feature
        expect(
          files.containsKey(
            'lib/features/counter/domain/entities/counter_entity.dart',
          ),
          isTrue,
        );
        expect(
          files.containsKey(
            'lib/features/counter/domain/repositories/counter_repository.dart',
          ),
          isTrue,
        );

        // Data layer within feature
        expect(
          files.containsKey(
            'lib/features/counter/data/models/counter_model.dart',
          ),
          isTrue,
        );
        expect(
          files.containsKey(
            'lib/features/counter/data/repositories/counter_repository_impl.dart',
          ),
          isTrue,
        );

        // Presentation layer within feature
        expect(
          files.containsKey(
            'lib/features/counter/presentation/bloc/counter_controller.dart',
          ),
          isTrue,
        );
        expect(
          files.containsKey(
            'lib/features/counter/presentation/screens/counter_screen.dart',
          ),
          isTrue,
        );
        expect(files.containsKey('lib/core/routes/app_router.dart'), isTrue);
        expect(files.containsKey('lib/main.dart'), isTrue);
      },
    );

    test('generates Riverpod and Layer-first structure with usecases', () {
      final config = ProjectConfig(
        projectName: 'riverpod_app',
        orgName: 'com.example',
        targetDirectory: '/tmp/riverpod_app',
        architecture: ArchitecturePattern.layerFirst,
        stateManagement: StateManagement.riverpod,
        routing: Routing.standard,
        networking: Networking.none,
        storage: Storage.none,
        features: {},
      );

      final files = engine.generateFiles(config);

      // Domain layer
      expect(
        files.containsKey('lib/domain/entities/counter_entity.dart'),
        isTrue,
      );
      expect(
        files.containsKey('lib/domain/repositories/counter_repository.dart'),
        isTrue,
      );
      expect(
        files.containsKey('lib/domain/usecases/counter_usecases.dart'),
        isTrue,
      );

      // Data layer
      expect(files.containsKey('lib/data/models/counter_model.dart'), isTrue);
      expect(
        files.containsKey('lib/data/repositories/counter_repository_impl.dart'),
        isTrue,
      );

      // Presentation layer
      expect(
        files.containsKey('lib/presentation/providers/counter_controller.dart'),
        isTrue,
      );
      expect(
        files.containsKey('lib/presentation/pages/counter_page.dart'),
        isTrue,
      );
      expect(
        files.containsKey('lib/presentation/routes/app_router.dart'),
        isTrue,
      );
      expect(
        files['lib/presentation/routes/app_router.dart'],
        contains('class AppRouter'),
      );

      expect(files.containsKey('lib/shared/widgets/app_button.dart'), isTrue);
      expect(
        files.containsKey('lib/shared/extensions/context_extensions.dart'),
        isTrue,
      );
      expect(files.containsKey('lib/shared/utils/app_formatters.dart'), isTrue);

      final mainDart = files['lib/main.dart']!;
      expect(mainDart, contains('ProviderScope'));
    });

    test('generates MVVM structure properly with ViewModels and Views', () {
      final config = ProjectConfig(
        projectName: 'mvvm_app',
        orgName: 'com.example',
        targetDirectory: '/tmp/mvvm_app',
        architecture: ArchitecturePattern.mvvm,
        stateManagement: StateManagement.bloc,
        routing: Routing.goRouter,
        networking: Networking.dio,
        storage: Storage.sharedPreferences,
        features: {ProjectFeature.assetsStructure},
        utilities: {
          UtilityPackage.flutterSvg,
          UtilityPackage.cachedNetworkImage,
        },
      );

      final files = engine.generateFiles(config);

      expect(files.containsKey('lib/models/counter_model.dart'), isTrue);
      expect(
        files.containsKey('lib/viewmodels/counter_viewmodel.dart'),
        isTrue,
      );
      expect(files.containsKey('lib/views/counter/counter_view.dart'), isTrue);
      expect(files.containsKey('lib/routes/app_router.dart'), isTrue);
      expect(files.containsKey('lib/services/api_client.dart'), isTrue);
      expect(
        files.containsKey('lib/shared/widgets/app_network_image.dart'),
        isTrue,
      );
      expect(files.containsKey('lib/shared/widgets/app_button.dart'), isTrue);
      expect(
        files.containsKey('lib/shared/extensions/context_extensions.dart'),
        isTrue,
      );
      expect(files.containsKey('lib/shared/utils/app_formatters.dart'), isTrue);

      final view = files['lib/views/counter/counter_view.dart']!;
      expect(
        view,
        contains("import '../../viewmodels/counter_viewmodel.dart';"),
      );

      final mainDart = files['lib/main.dart']!;
      expect(mainDart, contains("import 'routes/app_router.dart';"));
    });

    test('generates AppRouter hub for standard, go_router, and auto_route', () {
      for (final routing in Routing.values) {
        final config = ProjectConfig(
          projectName: 'router_app',
          orgName: 'com.example',
          targetDirectory: '/tmp/router_app',
          architecture: ArchitecturePattern.simpleMvc,
          stateManagement: StateManagement.none,
          routing: routing,
          networking: Networking.none,
          storage: Storage.none,
          features: {},
        );

        final files = engine.generateFiles(config);
        final router = files['lib/routes/app_router.dart']!;
        final mainDart = files['lib/main.dart']!;

        expect(router, contains('class AppRouter'));
        expect(mainDart, contains("import 'routes/app_router.dart';"));

        switch (routing) {
          case Routing.standard:
            expect(router, contains('generateRoutes'));
            expect(router, contains('static Future<T?> push'));
            expect(router, contains('static void pop'));
            expect(mainDart, contains('navigatorKey: AppRouter.key'));
            expect(
              mainDart,
              contains('onGenerateRoute: AppRouter.generateRoutes'),
            );
          case Routing.goRouter:
            expect(router, contains('static final GoRouter router'));
            expect(router, contains('static void go'));
            expect(mainDart, contains('routerConfig: AppRouter.router'));
          case Routing.autoRoute:
            expect(router, contains('@AutoRouterConfig'));
            expect(router, contains('static final AppRouter instance'));
            expect(
              files['lib/screens/counter_screen.dart'],
              contains('@RoutePage()'),
            );
            expect(mainDart, contains('AppRouter.instance.config()'));
        }
      }
    });

    test('generates Simple MVC with Provider and HTTP', () {
      final config = ProjectConfig(
        projectName: 'mvc_app',
        orgName: 'com.example',
        targetDirectory: '/tmp/mvc_app',
        architecture: ArchitecturePattern.simpleMvc,
        stateManagement: StateManagement.provider,
        routing: Routing.standard,
        networking: Networking.http,
        storage: Storage.sharedPreferences,
        features: {ProjectFeature.assetsStructure},
        utilities: {
          UtilityPackage.flutterSvg,
          UtilityPackage.cachedNetworkImage,
          UtilityPackage.gap,
        },
      );

      final files = engine.generateFiles(config);

      expect(
        files.containsKey('lib/controllers/counter_controller.dart'),
        isTrue,
      );
      expect(files.containsKey('lib/screens/counter_screen.dart'), isTrue);
      expect(files.containsKey('lib/services/api_client.dart'), isTrue);
      expect(
        files.containsKey('lib/shared/widgets/app_network_image.dart'),
        isTrue,
      );
      expect(files.containsKey('lib/shared/widgets/app_button.dart'), isTrue);
      expect(
        files.containsKey('lib/shared/extensions/context_extensions.dart'),
        isTrue,
      );
      expect(files.containsKey('lib/shared/utils/app_formatters.dart'), isTrue);
      expect(files.containsKey('assets/icons/app_logo.svg'), isTrue);

      final controller = files['lib/controllers/counter_controller.dart']!;
      expect(controller, contains('class CounterModel extends ChangeNotifier'));
    });

    test(
      'generates ScreenUtilInit and get_it injection container when requested',
      () {
        final config = ProjectConfig(
          projectName: 'init_app',
          orgName: 'com.init',
          targetDirectory: '/tmp/init_app',
          architecture: ArchitecturePattern.featureFirst,
          stateManagement: StateManagement.bloc,
          routing: Routing.goRouter,
          networking: Networking.none,
          storage: Storage.none,
          features: {ProjectFeature.strictLinting},
          utilities: {UtilityPackage.flutterScreenutil, UtilityPackage.getIt},
        );

        final files = engine.generateFiles(config);

        expect(
          files.containsKey('lib/core/di/injection_container.dart'),
          isTrue,
        );
        final diFile = files['lib/core/di/injection_container.dart']!;
        expect(diFile, contains('initDependencies()'));
        expect(diFile, contains('GetIt.instance'));

        final mainDart = files['lib/main.dart']!;
        expect(
          mainDart,
          contains(
            "import 'package:flutter_screenutil/flutter_screenutil.dart';",
          ),
        );
        expect(
          mainDart,
          contains("import 'core/di/injection_container.dart';"),
        );
        expect(mainDart, contains('ScreenUtilInit('));
        expect(mainDart, contains('await initDependencies();'));
      },
    );

    test(
      'generates ImagePickerService and FilePickerService with GetIt registration',
      () {
        final config = ProjectConfig(
          projectName: 'pickers_app',
          orgName: 'com.pickers',
          targetDirectory: '/tmp/pickers_app',
          architecture: ArchitecturePattern.featureFirst,
          stateManagement: StateManagement.bloc,
          routing: Routing.goRouter,
          networking: Networking.none,
          storage: Storage.none,
          features: {},
          utilities: {
            UtilityPackage.imagePicker,
            UtilityPackage.filePicker,
            UtilityPackage.getIt,
          },
        );

        final files = engine.generateFiles(config);

        // Core services
        expect(
          files.containsKey('lib/core/services/image_picker_service.dart'),
          isTrue,
        );
        expect(
          files.containsKey('lib/core/services/file_picker_service.dart'),
          isTrue,
        );

        final imagePickerService =
            files['lib/core/services/image_picker_service.dart']!;
        expect(imagePickerService, contains('class ImagePickerService'));
        expect(imagePickerService, contains('Future<File?> takePhoto'));
        expect(
          imagePickerService,
          contains('Future<File?> pickImageFromGallery'),
        );
        expect(
          imagePickerService,
          contains('Future<List<File>> pickMultiImage'),
        );
        expect(imagePickerService, contains('Future<File?> recordVideo'));
        expect(
          imagePickerService,
          contains('Future<File?> pickVideoFromGallery'),
        );

        final filePickerService =
            files['lib/core/services/file_picker_service.dart']!;
        expect(filePickerService, contains('class FilePickerService'));
        expect(filePickerService, contains('Future<File?> pickFile'));
        expect(
          filePickerService,
          contains('Future<List<File>> pickMultipleFiles'),
        );
        expect(filePickerService, contains('Future<File?> pickPdf'));
        expect(
          filePickerService,
          contains('Future<String?> pickDirectory'),
        );

        // DI container auto-registration
        final di = files['lib/core/di/injection_container.dart']!;
        expect(di, contains("import '../services/image_picker_service.dart';"));
        expect(di, contains("import '../services/file_picker_service.dart';"));
        expect(
          di,
          contains(
            'serviceLocator.registerLazySingleton<ImagePickerService>(ImagePickerService.new);',
          ),
        );
        expect(
          di,
          contains(
            'serviceLocator.registerLazySingleton<FilePickerService>(FilePickerService.new);',
          ),
        );
      },
    );

    test(
      'generates ImagePickerService and FilePickerService in lib/services/ for MVVM',
      () {
        final config = ProjectConfig(
          projectName: 'mvvm_pickers',
          orgName: 'com.pickers',
          targetDirectory: '/tmp/mvvm_pickers',
          architecture: ArchitecturePattern.mvvm,
          stateManagement: StateManagement.riverpod,
          routing: Routing.standard,
          networking: Networking.none,
          storage: Storage.none,
          features: {},
          utilities: {
            UtilityPackage.imagePicker,
            UtilityPackage.filePicker,
            UtilityPackage.getIt,
          },
        );

        final files = engine.generateFiles(config);

        expect(
          files.containsKey('lib/services/image_picker_service.dart'),
          isTrue,
        );
        expect(
          files.containsKey('lib/services/file_picker_service.dart'),
          isTrue,
        );

        final di = files['lib/services/injection_container.dart']!;
        expect(di, contains("import 'image_picker_service.dart';"));
        expect(di, contains("import 'file_picker_service.dart';"));
        expect(
          di,
          contains(
            'serviceLocator.registerLazySingleton<ImagePickerService>(ImagePickerService.new);',
          ),
        );
        expect(
          di,
          contains(
            'serviceLocator.registerLazySingleton<FilePickerService>(FilePickerService.new);',
          ),
        );
      },
    );

    test(
      'generates Hive StorageService with complete getInt, setInt, and typed helpers',
      () {
        final config = ProjectConfig(
          projectName: 'hive_app',
          orgName: 'com.example',
          targetDirectory: '/tmp/hive_app',
          architecture: ArchitecturePattern.featureFirst,
          stateManagement: StateManagement.bloc,
          routing: Routing.goRouter,
          networking: Networking.none,
          storage: Storage.hive,
          features: {},
        );

        final files = engine.generateFiles(config);
        final storage = files['lib/core/storage/storage_service.dart']!;
        expect(
          storage,
          contains(
            'static Future<void> setInt(String key, int value) => put(key, value);',
          ),
        );
        expect(
          storage,
          contains('static int? getInt(String key) => get<int>(key);'),
        );
        expect(
          storage,
          contains(
            'static Future<void> setString(String key, String value) => put(key, value);',
          ),
        );
        expect(
          storage,
          contains('static String? getString(String key) => get<String>(key);'),
        );
      },
    );

    test('generates AppFormatters with DateFormat when intl is enabled', () {
      final config = ProjectConfig(
        projectName: 'intl_app',
        orgName: 'com.example',
        targetDirectory: '/tmp/intl_app',
        architecture: ArchitecturePattern.mvvm,
        stateManagement: StateManagement.none,
        routing: Routing.standard,
        networking: Networking.none,
        storage: Storage.none,
        features: const {},
        utilities: {UtilityPackage.intl},
      );

      final files = engine.generateFiles(config);
      final formatters = files['lib/shared/utils/app_formatters.dart']!;
      expect(formatters, contains("import 'package:intl/intl.dart';"));
      expect(formatters, contains('static String formatDate('));
      expect(formatters, contains('static String formatCurrency('));
      expect(formatters, contains('DateFormat(format, locale).format(date)'));
    });

    test(
      'generates sqflite StorageService, AppCrypto, AppWebView, and LocationService',
      () {
        final config = ProjectConfig(
          projectName: 'rich_app',
          orgName: 'com.example',
          targetDirectory: '/tmp/rich_app',
          architecture: ArchitecturePattern.featureFirst,
          stateManagement: StateManagement.riverpod,
          routing: Routing.goRouter,
          networking: Networking.none,
          storage: Storage.sqflite,
          features: const {},
          utilities: {
            UtilityPackage.crypto,
            UtilityPackage.webviewFlutter,
            UtilityPackage.geolocator,
            UtilityPackage.getIt,
          },
        );

        final files = engine.generateFiles(config);

        // sqflite StorageService
        final storage = files['lib/core/storage/storage_service.dart']!;
        expect(storage, contains("import 'package:sqflite/sqflite.dart';"));
        expect(storage, contains("import 'package:path/path.dart' as p;"));
        expect(storage, contains('CREATE TABLE IF NOT EXISTS settings'));

        // AppCrypto
        final crypto = files['lib/shared/utils/app_crypto.dart']!;
        expect(
          crypto,
          contains("import 'package:crypto/crypto.dart' as crypto;"),
        );
        expect(crypto, contains('static String sha256(String input)'));
        expect(crypto, contains('static String md5(String input)'));
        expect(
          crypto,
          contains('static String hmacSha256(String secretKey, String input)'),
        );

        // AppWebView
        final webview = files['lib/shared/widgets/app_webview.dart']!;
        expect(
          webview,
          contains("import 'package:webview_flutter/webview_flutter.dart';"),
        );
        expect(webview, contains('class AppWebView extends StatefulWidget'));

        // LocationService
        final location = files['lib/core/services/location_service.dart']!;
        expect(
          location,
          contains("import 'package:geolocator/geolocator.dart';"),
        );
        expect(location, contains('class LocationService'));
        expect(location, contains('getCurrentPosition('));

        // Barrels
        final utilsBarrel = files['lib/shared/utils/utils.dart']!;
        expect(utilsBarrel, contains("export 'app_crypto.dart';"));

        final widgetsBarrel = files['lib/shared/widgets/widgets.dart']!;
        expect(widgetsBarrel, contains("export 'app_webview.dart';"));

        // Injection container
        final di = files['lib/core/di/injection_container.dart']!;
        expect(di, contains("import '../services/location_service.dart';"));
        expect(
          di,
          contains(
            'serviceLocator.registerLazySingleton<LocationService>(LocationService.new);',
          ),
        );
      },
    );
  });
}
