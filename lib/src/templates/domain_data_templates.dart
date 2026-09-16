/// Generates domain entity (pure Dart model with zero framework dependencies).
String renderCounterEntity() {
  return '''
/// Pure domain entity representing counter data.
class CounterEntity {
  const CounterEntity({required this.value});

  final int value;
}
''';
}

/// Generates abstract domain repository interface.
String renderCounterRepositoryInterface(String entityImport) {
  return '''
$entityImport

/// Domain repository contract for counter operations.
abstract class CounterRepository {
  Future<CounterEntity> getCounter();
  Future<void> saveCounter(CounterEntity entity);
}
''';
}

/// Generates data model (DTO with JSON serialization).
String renderCounterModel(String entityImport) {
  return '''
$entityImport

/// Data Transfer Object (DTO) for counter serialization.
class CounterModel extends CounterEntity {
  const CounterModel({required super.value});

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
}

/// Generates repository implementation for data layer.
String renderCounterRepositoryImpl({
  required String entityImport,
  required String repoInterfaceImport,
  required String storageServiceImport,
  required bool hasStorage,
}) {
  final imports = [
    if (storageServiceImport.isNotEmpty) storageServiceImport,
    entityImport,
    repoInterfaceImport,
  ]..sort();

  return '''
${imports.join('\n')}

/// Implementation of [CounterRepository] handling data persistence.
class CounterRepositoryImpl implements CounterRepository {
  static const String _storageKey = 'counter_value';

  @override
  Future<CounterEntity> getCounter() async {
${hasStorage ? '    final value = await StorageService.getInt(_storageKey) ?? 0;\n    return CounterEntity(value: value);' : '    return const CounterEntity(value: 0);'}
  }

  @override
  Future<void> saveCounter(CounterEntity entity) async {
${hasStorage ? '    await StorageService.setInt(_storageKey, entity.value);' : '    // In-memory or fallback persistence'}
  }
}
''';
}

/// Generates use cases for Clean Architecture.
String renderCounterUseCases({
  required String entityImport,
  required String repoInterfaceImport,
}) {
  final imports = [entityImport, repoInterfaceImport]..sort();

  return '''
${imports.join('\n')}

/// Use case for retrieving the current counter count.
class GetCounterUseCase {
  const GetCounterUseCase(this.repository);

  final CounterRepository repository;

  Future<CounterEntity> call() => repository.getCounter();
}

/// Use case for incrementing the counter count.
class IncrementCounterUseCase {
  const IncrementCounterUseCase(this.repository);

  final CounterRepository repository;

  Future<CounterEntity> call(CounterEntity current) async {
    final next = CounterEntity(value: current.value + 1);
    await repository.saveCounter(next);
    return next;
  }
}
''';
}
