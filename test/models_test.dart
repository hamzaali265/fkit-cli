import 'package:fkit_cli/fkit_cli.dart';
import 'package:test/test.dart';

void main() {
  group('ProjectConfig', () {
    test(
      'constructs custom project config with BLoC, go_router, SVG, and CachedImage',
      () {
        final config = ProjectConfig(
          projectName: 'my_app',
          orgName: 'com.example',
          targetDirectory: '/tmp/my_app',
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
            UtilityPackage.flutterSecureStorage,
            UtilityPackage.urlLauncher,
          },
        );

        expect(config.projectName, equals('my_app'));
        expect(config.orgName, equals('com.example'));
        expect(config.architecture, equals(ArchitecturePattern.featureFirst));
        expect(config.stateManagement, equals(StateManagement.bloc));
        expect(config.routing, equals(Routing.goRouter));
        expect(config.networking, equals(Networking.dio));
        expect(config.storage, equals(Storage.sharedPreferences));
        expect(config.hasLocalization, isTrue);
        expect(config.hasStrictLinting, isTrue);
        expect(config.hasEnvFlavors, isTrue);
        expect(config.hasAssetsStructure, isTrue);

        expect(config.hasFlutterSvg, isTrue);
        expect(config.hasCachedNetworkImage, isTrue);
        expect(config.hasGap, isTrue);

        expect(config.dependencies.containsKey('flutter_bloc'), isTrue);
        expect(config.dependencies.containsKey('go_router'), isTrue);
        expect(config.dependencies.containsKey('dio'), isTrue);
        expect(config.dependencies.containsKey('shared_preferences'), isTrue);
        expect(config.dependencies.containsKey('flutter_svg'), isTrue);
        expect(config.dependencies.containsKey('cached_network_image'), isTrue);
        expect(config.dependencies.containsKey('gap'), isTrue);
        expect(
          config.dependencies.containsKey('flutter_localizations'),
          isTrue,
        );
        expect(
          config.devDependencies.containsKey('very_good_analysis'),
          isTrue,
        );
      },
    );

    test(
      'constructs simple MVC config with Provider, HTTP, and minimal utilities',
      () {
        final config = ProjectConfig(
          projectName: 'simple_app',
          orgName: 'com.test',
          targetDirectory: '/tmp/simple_app',
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

        expect(config.architecture, equals(ArchitecturePattern.simpleMvc));
        expect(config.stateManagement, equals(StateManagement.provider));
        expect(config.routing, equals(Routing.standard));
        expect(config.networking, equals(Networking.http));
        expect(config.storage, equals(Storage.sharedPreferences));
        expect(config.hasLocalization, isFalse);
        expect(config.hasFlutterSvg, isTrue);
        expect(config.hasCachedNetworkImage, isTrue);
        expect(config.dependencies.containsKey('flutter_svg'), isTrue);
        expect(config.dependencies.containsKey('cached_network_image'), isTrue);
      },
    );

    test('constructs Hive and Clean Architecture with all utilities', () {
      final config = ProjectConfig(
        projectName: 'corp_app',
        orgName: 'com.corp',
        targetDirectory: '/tmp/corp_app',
        architecture: ArchitecturePattern.featureFirst,
        stateManagement: StateManagement.bloc,
        routing: Routing.goRouter,
        networking: Networking.dio,
        storage: Storage.hive,
        features: {ProjectFeature.strictLinting},
        utilities: {
          UtilityPackage.flutterSvg,
          UtilityPackage.cachedNetworkImage,
          UtilityPackage.gap,
          UtilityPackage.flutterSecureStorage,
          UtilityPackage.urlLauncher,
          UtilityPackage.uuid,
        },
      );

      expect(config.storage, equals(Storage.hive));
      expect(config.dependencies.containsKey('hive_flutter'), isTrue);
      expect(config.dependencies.containsKey('hive'), isTrue);
      expect(config.dependencies.containsKey('uuid'), isTrue);
    });

    test('supports new utility packages (screenutil, get_it, permissions)', () {
      final config = ProjectConfig(
        projectName: 'utilities_app',
        orgName: 'com.utils',
        targetDirectory: '/tmp/utilities_app',
        architecture: ArchitecturePattern.mvvm,
        stateManagement: StateManagement.riverpod,
        routing: Routing.goRouter,
        networking: Networking.dio,
        storage: Storage.sharedPreferences,
        features: {ProjectFeature.strictLinting},
        utilities: {
          UtilityPackage.flutterScreenutil,
          UtilityPackage.getIt,
          UtilityPackage.permissionHandler,
        },
      );

      expect(config.hasScreenUtil, isTrue);
      expect(config.hasGetIt, isTrue);
      expect(config.hasPermissionHandler, isTrue);

      expect(config.dependencies.containsKey('flutter_screenutil'), isTrue);
      expect(config.dependencies.containsKey('get_it'), isTrue);
      expect(config.dependencies.containsKey('permission_handler'), isTrue);
    });

    test(
      'supports image_picker and file_picker utilities and dependencies',
      () {
        final config = ProjectConfig(
          projectName: 'pickers_app',
          orgName: 'com.pickers',
          targetDirectory: '/tmp/pickers_app',
          architecture: ArchitecturePattern.featureFirst,
          stateManagement: StateManagement.bloc,
          routing: Routing.goRouter,
          networking: Networking.dio,
          storage: Storage.sharedPreferences,
          features: {ProjectFeature.strictLinting},
          utilities: {UtilityPackage.imagePicker, UtilityPackage.filePicker},
        );

        expect(config.hasImagePicker, isTrue);
        expect(config.hasFilePicker, isTrue);
        expect(config.dependencies.containsKey('image_picker'), isTrue);
        expect(config.dependencies.containsKey('file_picker'), isTrue);
      },
    );

    test('supports intl as explicit utility package without full l10n', () {
      final config = ProjectConfig(
        projectName: 'intl_app',
        orgName: 'com.intl',
        targetDirectory: '/tmp/intl_app',
        architecture: ArchitecturePattern.mvvm,
        stateManagement: StateManagement.provider,
        routing: Routing.standard,
        networking: Networking.none,
        storage: Storage.none,
        features: const {},
        utilities: {UtilityPackage.intl},
      );

      expect(config.hasIntl, isTrue);
      expect(config.hasLocalization, isFalse);
      expect(config.dependencies.containsKey('intl'), isTrue);
      expect(config.dependencies.containsKey('flutter_localizations'), isFalse);
    });

    test('fromKey parses intl variants', () {
      expect(UtilityPackage.fromKey('intl'), equals(UtilityPackage.intl));
      expect(UtilityPackage.fromKey('i18n'), equals(UtilityPackage.intl));
      expect(
        UtilityPackage.fromKey('internationalization'),
        equals(UtilityPackage.intl),
      );
    });

    test(
      'supports new packages: equatable, crypto, webview, geolocator, and sqflite storage',
      () {
        final config = ProjectConfig(
          projectName: 'new_packages_app',
          orgName: 'com.packages',
          targetDirectory: '/tmp/new_packages_app',
          architecture: ArchitecturePattern.layerFirst,
          stateManagement: StateManagement.provider,
          routing: Routing.goRouter,
          networking: Networking.none,
          storage: Storage.sqflite,
          features: const {},
          utilities: {
            UtilityPackage.equatable,
            UtilityPackage.crypto,
            UtilityPackage.webviewFlutter,
            UtilityPackage.geolocator,
          },
        );

        expect(config.hasEquatable, isTrue);
        expect(config.hasSqflite, isTrue);
        expect(config.hasCrypto, isTrue);
        expect(config.hasWebview, isTrue);
        expect(config.hasGeolocator, isTrue);

        expect(config.storage, equals(Storage.sqflite));
        expect(config.dependencies.containsKey('equatable'), isTrue);
        expect(config.dependencies.containsKey('sqflite'), isTrue);
        expect(config.dependencies.containsKey('path'), isTrue);
        expect(config.dependencies.containsKey('crypto'), isTrue);
        expect(config.dependencies.containsKey('webview_flutter'), isTrue);
        expect(config.dependencies.containsKey('geolocator'), isTrue);
      },
    );

    test('fromKey parses new package aliases', () {
      expect(
        UtilityPackage.fromKey('equatable'),
        equals(UtilityPackage.equatable),
      );
      expect(UtilityPackage.fromKey('crypto'), equals(UtilityPackage.crypto));
      expect(
        UtilityPackage.fromKey('webview'),
        equals(UtilityPackage.webviewFlutter),
      );
      expect(
        UtilityPackage.fromKey('webview_flutter'),
        equals(UtilityPackage.webviewFlutter),
      );
      expect(
        UtilityPackage.fromKey('geolocator'),
        equals(UtilityPackage.geolocator),
      );
      expect(
        UtilityPackage.fromKey('location'),
        equals(UtilityPackage.geolocator),
      );
      expect(UtilityPackage.fromKey('gps'), equals(UtilityPackage.geolocator));
      expect(Storage.fromKey('sqflite'), equals(Storage.sqflite));
      expect(Storage.fromKey('sqlite'), equals(Storage.sqflite));
    });

    test(
      'toJson and fromJson round-trip correctly preserves configuration',
      () {
        final original = ProjectConfig(
          projectName: 'roundtrip_app',
          orgName: 'com.test.roundtrip',
          description: 'Test roundtrip app',
          targetDirectory: '/path/to/project',
          architecture: ArchitecturePattern.featureFirst,
          stateManagement: StateManagement.bloc,
          routing: Routing.goRouter,
          networking: Networking.dio,
          storage: Storage.hive,
          features: {ProjectFeature.envFlavors, ProjectFeature.localization},
          utilities: {
            UtilityPackage.flutterSvg,
            UtilityPackage.cachedNetworkImage,
            UtilityPackage.intl,
          },
        );

        final json = original.toJson();
        expect(json['name'], equals('roundtrip_app'));
        expect(json['architecture'], equals('featureFirst'));
        expect(json['state_management'], equals('bloc'));
        expect(json['routing'], equals('goRouter'));

        final reconstructed = ProjectConfig.fromJson(
          json,
          targetDirectory: '/path/to/project',
        );
        expect(reconstructed.projectName, equals(original.projectName));
        expect(reconstructed.architecture, equals(original.architecture));
        expect(reconstructed.stateManagement, equals(original.stateManagement));
        expect(reconstructed.routing, equals(original.routing));
        expect(reconstructed.networking, equals(original.networking));
        expect(reconstructed.storage, equals(original.storage));
        expect(reconstructed.hasEnvFlavors, isTrue);
        expect(reconstructed.hasLocalization, isTrue);
        expect(reconstructed.hasFlutterSvg, isTrue);
        expect(reconstructed.hasCachedNetworkImage, isTrue);
      },
    );

    test('ArchitecturePattern.fromKey parses modular aliases', () {
      expect(
        ArchitecturePattern.fromKey('modular'),
        equals(ArchitecturePattern.modular),
      );
      expect(
        ArchitecturePattern.fromKey('module'),
        equals(ArchitecturePattern.modular),
      );
      expect(
        ArchitecturePattern.fromKey('modules'),
        equals(ArchitecturePattern.modular),
      );
    });

    test('round-trips modular architecture in ProjectConfig toJson/fromJson', () {
      final config = ProjectConfig(
        projectName: 'modular_app',
        orgName: 'com.test.modular',
        targetDirectory: '/tmp/modular_app',
        architecture: ArchitecturePattern.modular,
        stateManagement: StateManagement.riverpod,
        routing: Routing.goRouter,
        networking: Networking.dio,
        storage: Storage.sharedPreferences,
        features: const {},
        utilities: const {},
      );

      final json = config.toJson();
      expect(json['architecture'], equals('modular'));

      final reconstructed = ProjectConfig.fromJson(
        json,
        targetDirectory: '/tmp/modular_app',
      );
      expect(reconstructed.architecture, equals(ArchitecturePattern.modular));
    });
  });
}
