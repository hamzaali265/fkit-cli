import '../models/project_config.dart';

/// Generates `lib/main.dart` connecting router, state, theme, storage, and localization.
String renderMainDart(
  ProjectConfig config, {
  required String themeImport,
  required String routerImport,
  required String screenImport,
  required String storageImport,
  String diImport = '',
}) {
  final buffer = StringBuffer();
  final packageImports = <String>["import 'package:flutter/material.dart';"];

  if (config.hasLocalization) {
    packageImports.add(
      "import 'package:${config.projectName}/l10n/app_localizations.dart';",
    );
  }

  if (config.stateManagement == StateManagement.riverpod) {
    packageImports.add(
      "import 'package:flutter_riverpod/flutter_riverpod.dart';",
    );
  } else if (config.stateManagement == StateManagement.getx) {
    packageImports.add("import 'package:get/get.dart';");
  }

  if (config.hasScreenUtil) {
    packageImports.add(
      "import 'package:flutter_screenutil/flutter_screenutil.dart';",
    );
  }

  packageImports.sort();
  for (final imp in packageImports) {
    buffer.writeln(imp);
  }

  final relativeImports = <String>[themeImport, routerImport];

  if (config.storage != Storage.none) {
    relativeImports.add(storageImport);
  }

  if (config.hasGetIt && diImport.isNotEmpty) {
    relativeImports.add(diImport);
  }

  relativeImports.sort();
  buffer.writeln();
  for (final imp in relativeImports) {
    buffer.writeln(imp);
  }
  buffer.writeln();

  final needsAsyncMain = config.storage != Storage.none || config.hasGetIt;
  final appRunner = config.stateManagement == StateManagement.riverpod
      ? 'const ProviderScope(child: MyApp())'
      : 'const MyApp()';

  if (needsAsyncMain) {
    buffer.writeln('''
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
${config.hasGetIt ? '  await initDependencies();\n' : ''}${config.storage != Storage.none ? '  await StorageService.initialize();\n' : ''}  runApp($appRunner);
}
''');
  } else {
    buffer.writeln('''
void main() {
  runApp($appRunner);
}
''');
  }

  final usesRouterWidget =
      config.routing == Routing.goRouter || config.routing == Routing.autoRoute;

  final appWidgetClass = config.stateManagement == StateManagement.getx
      ? (usesRouterWidget ? 'GetMaterialApp.router' : 'GetMaterialApp')
      : (usesRouterWidget ? 'MaterialApp.router' : 'MaterialApp');

  buffer.writeln('''
/// Root application widget.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
''');

  final appBody = StringBuffer()
    ..writeln('      title: \'${config.projectName}\',')
    ..writeln('      debugShowCheckedModeBanner: false,')
    ..writeln('      theme: AppTheme.lightTheme,')
    ..writeln('      darkTheme: AppTheme.darkTheme,');

  if (config.hasLocalization) {
    appBody
      ..writeln(
        '      localizationsDelegates: AppLocalizations.localizationsDelegates,',
      )
      ..writeln('      supportedLocales: AppLocalizations.supportedLocales,');
  }

  switch (config.routing) {
    case Routing.goRouter:
      appBody.writeln('      routerConfig: AppRouter.router,');
    case Routing.autoRoute:
      appBody.writeln('      routerConfig: AppRouter.instance.config(),');
    case Routing.standard:
      appBody
        ..writeln('      navigatorKey: AppRouter.key,')
        ..writeln('      initialRoute: AppRouter.home,')
        ..writeln('      onGenerateRoute: AppRouter.generateRoutes,');
  }

  if (config.hasScreenUtil) {
    buffer.writeln('''
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, _) => $appWidgetClass(
$appBody      ),
    );
  }
}
''');
  } else {
    buffer.writeln('''
    return $appWidgetClass(
$appBody    );
  }
}
''');
  }

  return '${buffer.toString().trimRight()}\n';
}
