import 'package:fkit_cli/fkit.dart';
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
  });
}
