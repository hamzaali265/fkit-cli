import 'dart:io';
import 'package:fkit_cli/fkit_cli.dart';
import 'package:mason_logger/mason_logger.dart';

/// Example showcasing programmatic API usage and CLI models in FKIT CLI.
void main(List<String> args) async {
  final logger = Logger();

  logger.info('=============================================');
  logger.info('  FKIT CLI — Programmatic API & Usage Example');
  logger.info('=============================================\n');

  // 1. Inspect Supported Architectures and Configurations
  logger.info('Supported Architectures:');
  for (final pattern in ArchitecturePattern.values) {
    logger.info('  • ${pattern.label} [${pattern.name}]: ${pattern.description}');
  }

  // 2. Build a Project Configuration Programmatically
  final config = ProjectConfig(
    projectName: 'my_flutter_app',
    orgName: 'com.example',
    description: 'A production Flutter app configured via FKIT CLI.',
    targetDirectory: Directory.current.path,
    architecture: ArchitecturePattern.featureFirst,
    stateManagement: StateManagement.bloc,
    routing: Routing.goRouter,
    networking: Networking.dio,
    storage: Storage.hive,
    features: {
      ProjectFeature.envFlavors,
      ProjectFeature.strictLinting,
      ProjectFeature.localization,
      ProjectFeature.assetsStructure,
    },
    utilities: {
      UtilityPackage.getIt,
      UtilityPackage.flutterSvg,
      UtilityPackage.cachedNetworkImage,
      UtilityPackage.gap,
    },
  );

  logger.info('\nSample Project Configuration:');
  logger.info('  Project Name: ${config.projectName}');
  logger.info('  Architecture: ${config.architecture.label}');
  logger.info('  State Management: ${config.stateManagement.label}');
  logger.info('  Routing: ${config.routing.label}');
  logger.info('  Networking: ${config.networking.label}');
  logger.info('  Storage: ${config.storage.label}');
  logger.info('  Features: ${config.features.map((f) => f.label).join(', ')}');
  logger.info('  Utilities: ${config.utilities.map((u) => u.packageName).join(', ')}');

  // 3. Inspect CLI Commands via FkitCommandRunner
  logger.info('\nFKIT CLI Command Runner:');
  final runner = FkitCommandRunner();
  logger.info('Executable: ${runner.executableName}');
  logger.info('Available commands: ${runner.commands.keys.join(', ')}');
}
