import '../models/project_config.dart';
import 'architecture_diagrams.dart';
import 'detailed_chooser.dart';

/// Short + detail catalogs for wizard choice lists.
abstract final class ChoiceCatalog {
  /// Architecture options.
  static List<ChoiceOption<ArchitecturePattern>> architecture() => [
    for (final item in ArchitecturePattern.values)
      ChoiceOption(
        value: item,
        label: item.label,
        shortDescription: switch (item) {
          ArchitecturePattern.featureFirst => 'by feature',
          ArchitecturePattern.layerFirst => 'data · domain · ui',
          ArchitecturePattern.mvvm => 'views · viewmodels',
          ArchitecturePattern.simpleMvc => 'screens · services',
        },
        detail: item.description,
        diagram: ArchitectureDiagrams.forPattern(item),
      ),
  ];

  /// State management options.
  static List<ChoiceOption<StateManagement>> state() => [
    for (final item in StateManagement.values)
      ChoiceOption(
        value: item,
        label: item.label,
        shortDescription: switch (item) {
          StateManagement.bloc => 'flutter_bloc',
          StateManagement.riverpod => 'flutter_riverpod',
          StateManagement.provider => 'scoped DI',
          StateManagement.getx => 'reactive',
          StateManagement.none => 'vanilla',
        },
        detail: item.description,
      ),
  ];

  /// Routing options.
  static List<ChoiceOption<Routing>> routing() => [
    for (final item in Routing.values)
      ChoiceOption(
        value: item,
        label: item.label,
        shortDescription: switch (item) {
          Routing.goRouter => 'declarative',
          Routing.autoRoute => 'codegen',
          Routing.standard => 'imperative',
        },
        detail: item.description,
      ),
  ];

  /// Networking options.
  static List<ChoiceOption<Networking>> networking() => [
    for (final item in Networking.values)
      ChoiceOption(
        value: item,
        label: item.label,
        shortDescription: switch (item) {
          Networking.dio => 'interceptors',
          Networking.http => 'official',
          Networking.none => 'skip',
        },
        detail: item.description,
      ),
  ];

  /// Storage options.
  static List<ChoiceOption<Storage>> storage() => [
    for (final item in Storage.values)
      ChoiceOption(
        value: item,
        label: item.label,
        shortDescription: switch (item) {
          Storage.sharedPreferences => 'key-value',
          Storage.hive => 'nosql',
          Storage.sqflite => 'sqlite db',
          Storage.none => 'skip',
        },
        detail: item.description,
      ),
  ];

  /// Utility packages.
  static List<ChoiceOption<UtilityPackage>> utilities() => [
    for (final item in UtilityPackage.values)
      ChoiceOption(
        value: item,
        label: item.packageName,
        shortDescription: _utilityShort(item),
        detail: item.description,
      ),
  ];

  /// Project features.
  static List<ChoiceOption<ProjectFeature>> features() => [
    for (final item in ProjectFeature.values)
      ChoiceOption(
        value: item,
        label: item.label,
        shortDescription: switch (item) {
          ProjectFeature.envFlavors => 'dev/prod',
          ProjectFeature.strictLinting => 'analysis',
          ProjectFeature.localization => 'l10n',
          ProjectFeature.assetsStructure => 'images/icons/svgs/fonts',
        },
        detail: item.description,
      ),
  ];

  static String _utilityShort(UtilityPackage item) {
    switch (item) {
      case UtilityPackage.imagePicker:
        return 'camera';
      case UtilityPackage.filePicker:
        return 'files';
      case UtilityPackage.flutterSvg:
        return 'svg';
      case UtilityPackage.cachedNetworkImage:
        return 'cache';
      case UtilityPackage.intl:
        return 'i18n';
      case UtilityPackage.urlLauncher:
        return 'links';
      case UtilityPackage.permissionHandler:
        return 'permissions';
      case UtilityPackage.flutterSecureStorage:
        return 'secure';
      case UtilityPackage.gap:
        return 'spacing';
      case UtilityPackage.flutterScreenutil:
        return 'responsive';
      case UtilityPackage.getIt:
        return 'di';
      case UtilityPackage.equatable:
        return 'equality';
      case UtilityPackage.geolocator:
        return 'location';
      case UtilityPackage.webviewFlutter:
        return 'browser';
      case UtilityPackage.uuid:
        return 'ids';
      case UtilityPackage.crypto:
        return 'hashing';
      case UtilityPackage.sqflite:
        return 'sqlite';
    }
  }
}
