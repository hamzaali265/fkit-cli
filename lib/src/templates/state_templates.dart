import '../models/project_config.dart';

/// Generates state management controller / cubit / notifier file.
String renderStateController(ProjectConfig config) {
  switch (config.stateManagement) {
    case StateManagement.bloc:
      return '''
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// State for the counter feature.
class CounterState extends Equatable {
  const CounterState({this.value = 0});

  final int value;

  CounterState copyWith({int? value}) {
    return CounterState(value: value ?? this.value);
  }

  @override
  List<Object?> get props => [value];
}

/// Cubit managing counter state.
class CounterCubit extends Cubit<CounterState> {
  CounterCubit() : super(const CounterState());

  void increment() => emit(state.copyWith(value: state.value + 1));
  void decrement() => emit(state.copyWith(value: state.value - 1));
  void reset() => emit(const CounterState());
}
''';

    case StateManagement.riverpod:
      return '''
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Riverpod StateNotifier managing the counter value.
class CounterNotifier extends StateNotifier<int> {
  CounterNotifier() : super(0);

  void increment() => state++;
  void decrement() => state--;
  void reset() => state = 0;
}

/// Global provider for the counter state.
final counterProvider = StateNotifierProvider<CounterNotifier, int>((ref) {
  return CounterNotifier();
});
''';

    case StateManagement.provider:
      return '''
import 'package:flutter/foundation.dart';

/// ChangeNotifier managing the counter value for Provider.
class CounterModel extends ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }

  void decrement() {
    _count--;
    notifyListeners();
  }

  void reset() {
    _count = 0;
    notifyListeners();
  }
}
''';

    case StateManagement.getx:
      return '''
import 'package:get/get.dart';

/// GetX controller managing reactive counter state.
class CounterController extends GetxController {
  final RxInt count = 0.obs;

  void increment() => count.value++;
  void decrement() => count.value--;
  void reset() => count.value = 0;
}
''';

    case StateManagement.none:
      return '';
  }
}
