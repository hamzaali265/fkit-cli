import '../models/project_config.dart';

/// Generates `app_router.dart` for the selected routing package.
///
/// All variants follow the same AppRouter shape used in production apps:
/// route name constants, a central route table, navigator key, and push/pop helpers.
String renderRouter(ProjectConfig config, String screenImport) {
  switch (config.routing) {
    case Routing.goRouter:
      return _renderGoRouter(screenImport);
    case Routing.autoRoute:
      return _renderAutoRoute(screenImport);
    case Routing.standard:
      return _renderStandardNavigator(screenImport);
  }
}

String _renderStandardNavigator(String screenImport) {
  return '''
import 'package:flutter/material.dart';
$screenImport

/// Central navigation hub for the app (Navigator 1.0).
///
/// Add new [static const] route names and [generateRoutes] cases as features grow.
class AppRouter {
  AppRouter._();

  static const String home = '/';
  // Example: static const String settings = 'settings';

  static final GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>();

  static String currentRoute = home;

  /// Builds a [MaterialPageRoute] for [settings.name].
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    currentRoute = settings.name ?? home;

    switch (settings.name) {
      case home:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const CounterScreen(),
          maintainState: true,
        );
      // case settings:
      //   return MaterialPageRoute<void>(
      //     settings: settings,
      //     builder: (_) => SettingsPage(
      //       params: settings.arguments,
      //     ),
      //   );
      default:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const CounterScreen(),
          maintainState: true,
        );
    }
  }

  static Future<T?> push<T extends Object?>(
    String route, {
    Object? arguments,
  }) {
    return key.currentState!.pushNamed<T>(route, arguments: arguments);
  }

  static Future<T?> pushReplacement<T extends Object?, TO extends Object?>(
    String route, {
    Object? arguments,
    TO? result,
  }) {
    return key.currentState!.pushReplacementNamed<T, TO>(
      route,
      arguments: arguments,
      result: result,
    );
  }

  static Future<T?> pushAndReplaceAll<T extends Object?>(
    String route, {
    Object? arguments,
  }) {
    return key.currentState!.pushNamedAndRemoveUntil<T>(
      route,
      (Route<dynamic> route) => false,
      arguments: arguments,
    );
  }

  static void popAndPush(String route, {Object? arguments}) {
    pop();
    key.currentState!.pushNamed(route, arguments: arguments);
  }

  static void pop<T extends Object?>([T? result]) {
    key.currentState!.pop<T>(result);
    currentRoute = home;
  }

  static void popTimes(int count, [Object? result]) {
    var remaining = count;
    while (remaining > 0 && (key.currentState?.canPop() ?? false)) {
      key.currentState!.pop(result);
      remaining--;
    }
  }

  static void popUntilToFirst() {
    key.currentState!.popUntil((route) => route.isFirst);
  }

  static void popUntilTo(String routeName) {
    key.currentState!.popUntil(
      (route) => route.settings.name == routeName,
    );
  }
}
''';
}

String _renderGoRouter(String screenImport) {
  return '''
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
$screenImport

/// Central navigation hub for the app (go_router).
///
/// Add new [static const] paths and [GoRoute] entries as features grow.
class AppRouter {
  AppRouter._();

  static const String home = '/';
  // Example: static const String settings = '/settings';

  static final GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>();

  static String currentRoute = home;

  /// Shared [GoRouter] instance used by [MaterialApp.router].
  static final GoRouter router = GoRouter(
    navigatorKey: key,
    initialLocation: home,
    routes: <RouteBase>[
      GoRoute(
        path: home,
        name: 'home',
        builder: (BuildContext context, GoRouterState state) {
          currentRoute = home;
          return const CounterScreen();
        },
      ),
      // GoRoute(
      //   path: settings,
      //   name: 'settings',
      //   builder: (context, state) => const SettingsPage(),
      // ),
    ],
  );

  static void go(String location, {Object? extra}) {
    router.go(location, extra: extra);
    currentRoute = location;
  }

  static Future<T?> push<T extends Object?>(
    String location, {
    Object? extra,
  }) {
    return router.push<T>(location, extra: extra);
  }

  static Future<T?> pushReplacement<T extends Object?>(
    String location, {
    Object? extra,
  }) {
    return router.pushReplacement<T>(location, extra: extra);
  }

  static void pop<T extends Object?>([T? result]) {
    if (router.canPop()) {
      router.pop<T>(result);
    }
    currentRoute = home;
  }

  static void popUntilToFirst() {
    while (router.canPop()) {
      router.pop();
    }
    currentRoute = home;
  }
}
''';
}

String _renderAutoRoute(String screenImport) {
  return '''
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
$screenImport

part 'app_router.gr.dart';

/// Central navigation hub for the app (auto_route).
///
/// After adding screens, run:
/// `dart run build_runner build --delete-conflicting-outputs`
@AutoRouterConfig(replaceInRouteName: 'Screen|Page|View,Route')
class AppRouter extends RootStackRouter {
  AppRouter({super.navigatorKey});

  /// Route name constants (keep in sync with generated routes).
  static const String home = '/';

  static String currentRoute = home;

  /// Shared router instance for [MaterialApp.router].
  static final AppRouter instance = AppRouter(
    navigatorKey: GlobalKey<NavigatorState>(),
  );

  static GlobalKey<NavigatorState>? get key => instance.navigatorKey;

  @override
  List<AutoRoute> get routes => <AutoRoute>[
        AutoRoute(page: CounterRoute.page, path: home, initial: true),
        // AutoRoute(page: SettingsRoute.page, path: '/settings'),
      ];

  static Future<T?> push<T extends Object?>(PageRouteInfo route) {
    return instance.push<T>(route);
  }

  static Future<T?> replace<T extends Object?>(PageRouteInfo route) {
    return instance.replace<T>(route);
  }

  static void pop<T extends Object?>([T? result]) {
    instance.maybePop<T>(result);
    currentRoute = home;
  }

  static void popUntilRoot() {
    instance.popUntilRoot();
    currentRoute = home;
  }
}
''';
}
