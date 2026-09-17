import 'dart:io';
import 'package:fkit_cli/fkit_cli.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  group('FeatureGenerator', () {
    const generator = FeatureGenerator();

    test('generates Feature-first BLoC clean architecture feature correctly', () {
      final config = ProjectConfig(
        projectName: 'demo_app',
        orgName: 'com.example',
        targetDirectory: '/tmp/demo',
        architecture: ArchitecturePattern.featureFirst,
        stateManagement: StateManagement.bloc,
        routing: Routing.goRouter,
        networking: Networking.dio,
        storage: Storage.sharedPreferences,
        features: const {},
      );

      final files = generator.generateFeature(
        featureName: 'user_profile',
        config: config,
      );

      expect(files.containsKey('lib/features/user_profile/domain/entities/user_profile_entity.dart'), isTrue);
      expect(files.containsKey('lib/features/user_profile/domain/repositories/user_profile_repository.dart'), isTrue);
      expect(files.containsKey('lib/features/user_profile/data/models/user_profile_model.dart'), isTrue);
      expect(files.containsKey('lib/features/user_profile/data/repositories/user_profile_repository_impl.dart'), isTrue);
      expect(files.containsKey('lib/features/user_profile/presentation/bloc/user_profile_cubit.dart'), isTrue);
      expect(files.containsKey('lib/features/user_profile/presentation/views/user_profile_view.dart'), isTrue);

      final entityCode = files['lib/features/user_profile/domain/entities/user_profile_entity.dart']!;
      expect(entityCode, contains('class UserProfileEntity'));

      final cubitCode = files['lib/features/user_profile/presentation/bloc/user_profile_cubit.dart']!;
      expect(cubitCode, contains('class UserProfileCubit extends Cubit<UserProfileState>'));
    });

    test('generates Layer-first Riverpod feature correctly', () {
      final config = ProjectConfig(
        projectName: 'demo_app',
        orgName: 'com.example',
        targetDirectory: '/tmp/demo',
        architecture: ArchitecturePattern.layerFirst,
        stateManagement: StateManagement.riverpod,
        routing: Routing.goRouter,
        networking: Networking.dio,
        storage: Storage.sharedPreferences,
        features: const {},
      );

      final files = generator.generateFeature(
        featureName: 'cart',
        config: config,
      );

      expect(files.containsKey('lib/domain/entities/cart_entity.dart'), isTrue);
      expect(files.containsKey('lib/domain/repositories/cart_repository.dart'), isTrue);
      expect(files.containsKey('lib/data/models/cart_model.dart'), isTrue);
      expect(files.containsKey('lib/data/repositories/cart_repository_impl.dart'), isTrue);
      expect(files.containsKey('lib/presentation/cart/providers/cart_provider.dart'), isTrue);
      expect(files.containsKey('lib/presentation/cart/views/cart_view.dart'), isTrue);
    });

    test('generates MVVM feature correctly with ViewModel and View', () {
      final config = ProjectConfig(
        projectName: 'demo_app',
        orgName: 'com.example',
        targetDirectory: '/tmp/demo',
        architecture: ArchitecturePattern.mvvm,
        stateManagement: StateManagement.provider,
        routing: Routing.goRouter,
        networking: Networking.dio,
        storage: Storage.sharedPreferences,
        features: const {},
      );

      final files = generator.generateFeature(
        featureName: 'orders',
        config: config,
      );

      expect(files.containsKey('lib/models/orders_model.dart'), isTrue);
      expect(files.containsKey('lib/viewmodels/orders_viewmodel.dart'), isTrue);
      expect(files.containsKey('lib/views/orders_view.dart'), isTrue);

      final vm = files['lib/viewmodels/orders_viewmodel.dart']!;
      expect(vm, contains('class OrdersViewModel extends ChangeNotifier'));
    });
  });

  group('FeatureCommand E2E', () {
    late Directory tempDir;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('fkit_feature_test_');
    });

    tearDown(() {
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    });

    test('reads .fkit.json and scaffolds feature in project directory', () async {
      final fkitJson = '''
{
  "name": "mock_app",
  "architecture": "featureFirst",
  "state_management": "bloc",
  "routing": "goRouter",
  "networking": "dio",
  "storage": "sharedPreferences",
  "features": []
}
''';
      File(p.join(tempDir.path, '.fkit.json')).writeAsStringSync(fkitJson);

      final runner = FkitCommandRunner();
      final exitCode = await runner.run(['feature', 'billing', '-p', tempDir.path]);

      expect(exitCode, equals(0));
      expect(File(p.join(tempDir.path, 'lib/features/billing/domain/entities/billing_entity.dart')).existsSync(), isTrue);
      expect(File(p.join(tempDir.path, 'lib/features/billing/presentation/bloc/billing_cubit.dart')).existsSync(), isTrue);
    });
  });
}
