import 'dart:io';
import 'package:fkit_cli/fkit_cli.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  late Directory tempDir;

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('fkit_test_');
  });

  tearDown(() {
    if (tempDir.existsSync()) {
      try {
        tempDir.deleteSync(recursive: true);
      } catch (_) {}
    }
  });

  group('End-to-End Generation', () {
    test(
      'creates a valid Feature-First BLoC project that passes flutter analyze',
      () async {
        const projectName = 'sample_feature_app';
        final projectDir = p.join(tempDir.path, projectName);

        final config = ProjectConfig(
          projectName: projectName,
          orgName: 'com.testboot',
          targetDirectory: projectDir,
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

        final generator = ProjectGenerator();
        final success = await generator.generate(config);

        expect(success, isTrue);

        // Verify key files exist
        expect(File(p.join(projectDir, 'pubspec.yaml')).existsSync(), isTrue);
        expect(
          File(p.join(projectDir, 'lib', 'main.dart')).existsSync(),
          isTrue,
        );
        expect(
          File(
            p.join(
              projectDir,
              'lib',
              'features',
              'counter',
              'presentation',
              'screens',
              'counter_screen.dart',
            ),
          ).existsSync(),
          isTrue,
        );

        // Run flutter analyze on the generated project
        final analyzeResult = await Process.run(
          'flutter',
          ['analyze'],
          workingDirectory: projectDir,
          runInShell: true,
        );

        expect(
          analyzeResult.exitCode,
          equals(0),
          reason:
              'flutter analyze failed on generated project: \n${analyzeResult.stdout}\n${analyzeResult.stderr}',
        );
      },
      timeout: const Timeout(Duration(minutes: 3)),
    );

    test(
      'creates a valid Layer-First Riverpod project that passes flutter analyze',
      () async {
        const projectName = 'sample_layer_app';
        final projectDir = p.join(tempDir.path, projectName);

        final config = ProjectConfig(
          projectName: projectName,
          orgName: 'com.testboot',
          targetDirectory: projectDir,
          architecture: ArchitecturePattern.layerFirst,
          stateManagement: StateManagement.riverpod,
          routing: Routing.goRouter,
          networking: Networking.http,
          storage: Storage.sharedPreferences,
          features: {ProjectFeature.strictLinting, ProjectFeature.localization},
        );

        final generator = ProjectGenerator();
        final success = await generator.generate(config);

        expect(success, isTrue);

        final analyzeResult = await Process.run(
          'flutter',
          ['analyze'],
          workingDirectory: projectDir,
          runInShell: true,
        );

        expect(
          analyzeResult.exitCode,
          equals(0),
          reason:
              'flutter analyze failed on generated layer-first project: \n${analyzeResult.stdout}\n${analyzeResult.stderr}',
        );
      },
      timeout: const Timeout(Duration(minutes: 3)),
    );

    test(
      'creates a valid MVVM Provider project that passes flutter analyze',
      () async {
        const projectName = 'sample_mvvm_app';
        final projectDir = p.join(tempDir.path, projectName);

        final config = ProjectConfig(
          projectName: projectName,
          orgName: 'com.testboot',
          targetDirectory: projectDir,
          architecture: ArchitecturePattern.mvvm,
          stateManagement: StateManagement.provider,
          routing: Routing.goRouter,
          networking: Networking.dio,
          storage: Storage.sharedPreferences,
          features: {ProjectFeature.strictLinting},
        );

        final generator = ProjectGenerator();
        final success = await generator.generate(config);

        expect(success, isTrue);

        final analyzeResult = await Process.run(
          'flutter',
          ['analyze'],
          workingDirectory: projectDir,
          runInShell: true,
        );

        expect(
          analyzeResult.exitCode,
          equals(0),
          reason:
              'flutter analyze failed on generated MVVM project: \n${analyzeResult.stdout}\n${analyzeResult.stderr}',
        );
      },
      timeout: const Timeout(Duration(minutes: 3)),
    );
  });
}
