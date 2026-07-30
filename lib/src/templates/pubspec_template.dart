import '../models/project_config.dart';

/// Generates the contents of `pubspec.yaml` based on [ProjectConfig].
String renderPubspecYaml(ProjectConfig config) {
  final buffer = StringBuffer()
    ..writeln('name: ${config.projectName}')
    ..writeln('description: "${config.description}"')
    ..writeln('publish_to: "none"')
    ..writeln('version: 1.0.0+1')
    ..writeln()
    ..writeln('environment:')
    ..writeln("  sdk: '>=3.0.0 <4.0.0'")
    ..writeln("  flutter: '>=3.19.0'")
    ..writeln()
    ..writeln('dependencies:');

  final sortedDeps = Map.fromEntries(
    config.dependencies.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key)),
  );

  for (final entry in sortedDeps.entries) {
    if (entry.value.startsWith('sdk:')) {
      buffer.writeln('  ${entry.key}:');
      buffer.writeln('    ${entry.value}');
    } else {
      buffer.writeln('  ${entry.key}: ${entry.value}');
    }
  }

  buffer
    ..writeln()
    ..writeln('dev_dependencies:');

  final sortedDevDeps = Map.fromEntries(
    config.devDependencies.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key)),
  );

  for (final entry in sortedDevDeps.entries) {
    if (entry.value.startsWith('sdk:')) {
      buffer.writeln('  ${entry.key}:');
      buffer.writeln('    ${entry.value}');
    } else {
      buffer.writeln('  ${entry.key}: ${entry.value}');
    }
  }

  buffer
    ..writeln()
    ..writeln('flutter:')
    ..writeln('  uses-material-design: true');

  if (config.hasLocalization) {
    buffer.writeln('  generate: true');
  }

  if (config.hasAssetsStructure) {
    buffer
      ..writeln()
      ..writeln('  # To add assets to your application, add an assets section, like this:')
      ..writeln('  assets:')
      ..writeln('    - assets/images/')
      ..writeln('    - assets/icons/')
      ..writeln('    - assets/svgs/')
      ..writeln()
      ..writeln(
        '  # An image asset can refer to one or more resolution-specific "variants", see',
      )
      ..writeln('  # https://flutter.dev/to/resolution-aware-images')
      ..writeln()
      ..writeln(
        '  # For details regarding adding assets from package dependencies, see',
      )
      ..writeln('  # https://flutter.dev/to/asset-from-package')
      ..writeln()
      ..writeln(
        '  # To add custom fonts to your application, add a fonts section here,',
      )
      ..writeln(
        '  # in this "flutter" section. Each entry in this list should have a',
      )
      ..writeln(
        '  # "family" key with the font family name, and a "fonts" key with a',
      )
      ..writeln(
        '  # list giving the asset and other descriptors for the font. For',
      )
      ..writeln('  # example:')
      ..writeln('  # fonts:')
      ..writeln('  #   - family: Schyler')
      ..writeln('  #     fonts:')
      ..writeln('  #       - asset: assets/fonts/Schyler-Regular.ttf')
      ..writeln('  #       - asset: assets/fonts/Schyler-Italic.ttf')
      ..writeln('  #         style: italic')
      ..writeln('  #   - family: Trajan Pro')
      ..writeln('  #     fonts:')
      ..writeln('  #       - asset: assets/fonts/TrajanPro.ttf')
      ..writeln('  #       - asset: assets/fonts/TrajanPro_Bold.ttf')
      ..writeln('  #         weight: 700')
      ..writeln('  #')
      ..writeln('  # For details regarding fonts from package dependencies,')
      ..writeln('  # see https://flutter.dev/to/font-from-package');
  }

  return buffer.toString();
}
