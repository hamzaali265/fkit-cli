import '../models/project_config.dart';

/// Generates the CounterScreen widget showcasing state management and theme.
String renderCounterScreen(ProjectConfig config, String controllerImport) {
  final buffer = StringBuffer();
  final packageImports = <String>["import 'package:flutter/material.dart';"];

  if (config.hasLocalization) {
    packageImports.add(
      "import 'package:${config.projectName}/l10n/app_localizations.dart';",
    );
  }

  if (config.routing == Routing.autoRoute) {
    packageImports.add("import 'package:auto_route/auto_route.dart';");
  }

  // State management imports
  switch (config.stateManagement) {
    case StateManagement.bloc:
      packageImports.add("import 'package:flutter_bloc/flutter_bloc.dart';");
      break;
    case StateManagement.riverpod:
      packageImports.add(
        "import 'package:flutter_riverpod/flutter_riverpod.dart';",
      );
      break;
    case StateManagement.provider:
      packageImports.add("import 'package:provider/provider.dart';");
      break;
    case StateManagement.getx:
      packageImports.add("import 'package:get/get.dart';");
      break;
    case StateManagement.none:
      break;
  }

  packageImports.sort();
  for (final imp in packageImports) {
    buffer.writeln(imp);
  }

  if (controllerImport.isNotEmpty) {
    buffer.writeln();
    buffer.writeln(controllerImport);
  }

  buffer.writeln();

  final titleWidget = config.hasLocalization
      ? "Text(l10n?.counterTitle ?? 'Counter Example')"
      : "const Text('Counter Example')";

  final messageWidget = config.hasLocalization
      ? "Text(l10n?.counterMessage ?? 'You have pushed the button this many times:')"
      : "const Text('You have pushed the button this many times:')";

  final tooltipText = config.hasLocalization
      ? "l10n?.incrementTooltip ?? 'Increment'"
      : "'Increment'";

  final routeAnnotation = config.routing == Routing.autoRoute
      ? '@RoutePage()\n'
      : '';

  // Screen Implementation
  switch (config.stateManagement) {
    case StateManagement.bloc:
      buffer.writeln('''
/// Counter demonstration screen using flutter_bloc.
${routeAnnotation}class CounterScreen extends StatelessWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    ${config.hasLocalization ? 'final l10n = AppLocalizations.of(context);' : ''}

    return BlocProvider(
      create: (_) => CounterCubit(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: $titleWidget,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  $messageWidget,
                  const SizedBox(height: 16),
                  BlocBuilder<CounterCubit, CounterState>(
                    builder: (context, state) {
                      return Text(
                        '\${state.value}',
                        style: theme.textTheme.displayLarge?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  heroTag: 'increment',
                  onPressed: () => context.read<CounterCubit>().increment(),
                  tooltip: $tooltipText,
                  child: const Icon(Icons.add),
                ),
                const SizedBox(height: 8),
                FloatingActionButton.small(
                  heroTag: 'decrement',
                  onPressed: () => context.read<CounterCubit>().decrement(),
                  child: const Icon(Icons.remove),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
''');
      break;

    case StateManagement.riverpod:
      buffer.writeln('''
/// Counter demonstration screen using flutter_riverpod.
${routeAnnotation}class CounterScreen extends ConsumerWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);
    final theme = Theme.of(context);
    ${config.hasLocalization ? 'final l10n = AppLocalizations.of(context);' : ''}

    return Scaffold(
      appBar: AppBar(
        title: $titleWidget,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            $messageWidget,
            const SizedBox(height: 16),
            Text(
              '\$count',
              style: theme.textTheme.displayLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'increment',
            onPressed: () => ref.read(counterProvider.notifier).increment(),
            tooltip: $tooltipText,
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 8),
          FloatingActionButton.small(
            heroTag: 'decrement',
            onPressed: () => ref.read(counterProvider.notifier).decrement(),
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
''');
      break;

    case StateManagement.provider:
      buffer.writeln('''
/// Counter demonstration screen using Provider.
${routeAnnotation}class CounterScreen extends StatelessWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    ${config.hasLocalization ? 'final l10n = AppLocalizations.of(context);' : ''}

    return ChangeNotifierProvider(
      create: (_) => CounterModel(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: $titleWidget,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  $messageWidget,
                  const SizedBox(height: 16),
                  Consumer<CounterModel>(
                    builder: (context, counter, _) {
                      return Text(
                        '\${counter.count}',
                        style: theme.textTheme.displayLarge?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  heroTag: 'increment',
                  onPressed: () => context.read<CounterModel>().increment(),
                  tooltip: $tooltipText,
                  child: const Icon(Icons.add),
                ),
                const SizedBox(height: 8),
                FloatingActionButton.small(
                  heroTag: 'decrement',
                  onPressed: () => context.read<CounterModel>().decrement(),
                  child: const Icon(Icons.remove),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
''');
      break;

    case StateManagement.getx:
      buffer.writeln('''
/// Counter demonstration screen using GetX.
${routeAnnotation}class CounterScreen extends StatelessWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CounterController());
    final theme = Theme.of(context);
    ${config.hasLocalization ? 'final l10n = AppLocalizations.of(context);' : ''}

    return Scaffold(
      appBar: AppBar(
        title: $titleWidget,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            $messageWidget,
            const SizedBox(height: 16),
            Obx(
              () => Text(
                '\${controller.count.value}',
                style: theme.textTheme.displayLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'increment',
            onPressed: controller.increment,
            tooltip: $tooltipText,
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 8),
          FloatingActionButton.small(
            heroTag: 'decrement',
            onPressed: controller.decrement,
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
''');
      break;

    case StateManagement.none:
      buffer.writeln('''
/// Counter demonstration screen using vanilla Flutter.
${routeAnnotation}class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int _counter = 0;

  void _increment() => setState(() => _counter++);
  void _decrement() => setState(() => _counter--);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    ${config.hasLocalization ? 'final l10n = AppLocalizations.of(context);' : ''}

    return Scaffold(
      appBar: AppBar(
        title: $titleWidget,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            $messageWidget,
            const SizedBox(height: 16),
            Text(
              '\$_counter',
              style: theme.textTheme.displayLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'increment',
            onPressed: _increment,
            tooltip: $tooltipText,
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 8),
          FloatingActionButton.small(
            heroTag: 'decrement',
            onPressed: _decrement,
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
''');
      break;
  }

  return '${buffer.toString().trimRight()}\n';
}
