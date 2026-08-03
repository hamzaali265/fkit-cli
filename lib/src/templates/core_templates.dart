import '../models/project_config.dart';

/// Generates `lib/.../theme/app_colors.dart`.
String renderAppColors() {
  return '''
import 'package:flutter/material.dart';

/// Centralized brand and semantic color tokens.
class AppColors {
  AppColors._();

  // Brand
  static const Color primary = Color(0xFF2563EB);
  static const Color primaryDark = Color(0xFF1D4ED8);
  static const Color secondary = Color(0xFF3B82F6);
  static const Color accent = Color(0xFF06B6D4);

  // Neutrals
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF0F172A);
  static const Color border = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFCBD5E1);

  // Text
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textDisabled = Color(0xFF94A3B8);

  // Semantic
  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFDC2626);
  static const Color info = Color(0xFF0EA5E9);
}
''';
}

/// Generates `lib/.../theme/app_fonts.dart`.
String renderAppFonts() {
  return '''
import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Font family names and reusable [TextStyle] tokens.
///
/// Uncomment the matching `fonts:` entries in `pubspec.yaml` and drop the
/// `.ttf` files into `assets/fonts/` before using custom families.
class AppFonts {
  AppFonts._();

  /// Primary UI font — matches the commented Schyler family in pubspec.
  static const String primary = 'Schyler';

  /// Display / heading font — matches the commented Trajan Pro family.
  static const String display = 'Trajan Pro';

  /// Falls back to the platform default until custom fonts are registered.
  static const String fallback = 'Roboto';

  // Sizes
  static const double sizeXs = 12;
  static const double sizeSm = 14;
  static const double sizeMd = 16;
  static const double sizeLg = 18;
  static const double sizeXl = 22;
  static const double sizeDisplay = 32;

  static TextStyle get displayLarge => const TextStyle(
        fontFamily: display,
        fontSize: sizeDisplay,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.2,
      );

  static TextStyle get heading => const TextStyle(
        fontFamily: primary,
        fontSize: sizeXl,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.3,
      );

  static TextStyle get title => const TextStyle(
        fontFamily: primary,
        fontSize: sizeLg,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.35,
      );

  static TextStyle get body => const TextStyle(
        fontFamily: primary,
        fontSize: sizeMd,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        height: 1.5,
      );

  static TextStyle get bodySmall => const TextStyle(
        fontFamily: primary,
        fontSize: sizeSm,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.45,
      );

  static TextStyle get label => const TextStyle(
        fontFamily: primary,
        fontSize: sizeSm,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
        height: 1.4,
      );

  static TextStyle get button => const TextStyle(
        fontFamily: primary,
        fontSize: sizeMd,
        fontWeight: FontWeight.w600,
        color: AppColors.textOnPrimary,
        height: 1.2,
      );
}
''';
}

/// Generates `lib/core/theme/app_theme.dart`.
String renderAppTheme() {
  return '''
import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_fonts.dart';

/// Centralized application theme definitions.
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: AppFonts.primary,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        error: AppColors.error,
        surface: AppColors.surface,
      ),
      scaffoldBackgroundColor: AppColors.background,
      textTheme: TextTheme(
        displayLarge: AppFonts.displayLarge,
        headlineMedium: AppFonts.heading,
        titleLarge: AppFonts.title,
        bodyLarge: AppFonts.body,
        bodyMedium: AppFonts.bodySmall,
        labelLarge: AppFonts.label,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          textStyle: AppFonts.button,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      dividerColor: AppColors.divider,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: AppFonts.primary,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.secondary,
        brightness: Brightness.dark,
        primary: AppColors.secondary,
        secondary: AppColors.accent,
        error: AppColors.error,
        surface: AppColors.surfaceDark,
      ),
      scaffoldBackgroundColor: AppColors.surfaceDark,
      textTheme: TextTheme(
        displayLarge: AppFonts.displayLarge.copyWith(color: AppColors.white),
        headlineMedium: AppFonts.heading.copyWith(color: AppColors.white),
        titleLarge: AppFonts.title.copyWith(color: AppColors.white),
        bodyLarge: AppFonts.body.copyWith(color: AppColors.white),
        bodyMedium: AppFonts.bodySmall.copyWith(color: AppColors.textDisabled),
        labelLarge: AppFonts.label.copyWith(color: AppColors.textDisabled),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.surfaceDark,
        foregroundColor: AppColors.white,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        color: AppColors.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.secondary,
          foregroundColor: AppColors.textOnPrimary,
          textStyle: AppFonts.button,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      dividerColor: AppColors.border,
    );
  }
}
''';
}

/// Generates barrel `theme.dart` exporting all theme files.
String renderThemeBarrel() {
  return '''
export 'app_colors.dart';
export 'app_fonts.dart';
export 'app_theme.dart';
''';
}

/// Generates `lib/core/config/app_config.dart` for environment flavors.
String renderAppConfig([ProjectConfig? config]) {
  final appName = config?.projectName ?? 'my_app';
  return '''
/// Environment config with dart-define support.
class AppConfig {
  AppConfig._();

  static const String appName = String.fromEnvironment(
    'APP_NAME',
    defaultValue: '$appName',
  );

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.example.com/v1',
  );

  static const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'development',
  );

  static bool get isProduction => environment == 'production';
  static bool get isDevelopment => environment == 'development';
}
''';
}

/// Generates `lib/core/network/api_client.dart`.
String renderApiClient(ProjectConfig config) {
  if (config.networking == Networking.dio) {
    final baseConfig = config.hasEnvFlavors
        ? 'baseUrl: AppConfig.apiBaseUrl,'
        : "baseUrl: 'https://api.example.com/v1',";
    final importConfig = config.hasEnvFlavors
        ? "import '../config/app_config.dart';"
        : '';

    return '''
import 'package:dio/dio.dart';
$importConfig

/// Base network client powered by Dio.
class ApiClient {
  ApiClient([Dio? dio])
      : _dio = dio ??
            Dio(
              BaseOptions(
                $baseConfig
                connectTimeout: const Duration(seconds: 15),
                receiveTimeout: const Duration(seconds: 15),
                headers: {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                },
              ),
            ) {
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
      ),
    );
  }

  final Dio _dio;

  Dio get client => _dio;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
}
''';
  } else if (config.networking == Networking.http) {
    final baseConfig = config.hasEnvFlavors
        ? 'static const String _baseUrl = AppConfig.apiBaseUrl;'
        : "static const String _baseUrl = 'https://api.example.com/v1';";
    final importConfig = config.hasEnvFlavors
        ? "import '../config/app_config.dart';"
        : '';

    return '''
import 'package:http/http.dart' as http;
$importConfig

/// Base network client powered by standard http package.
class ApiClient {
  ApiClient([http.Client? client]) : _client = client ?? http.Client();

  final http.Client _client;
  $baseConfig

  Future<http.Response> get(String endpoint) async {
    return _client.get(
      Uri.parse('\$_baseUrl\$endpoint'),
      headers: {'Accept': 'application/json'},
    );
  }

  Future<http.Response> post(String endpoint, {Object? body}) async {
    return _client.post(
      Uri.parse('\$_baseUrl\$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: body,
    );
  }

  void close() => _client.close();
}
''';
  }

  return '';
}

/// Generates `lib/core/storage/storage_service.dart`.
String renderStorageService(ProjectConfig config) {
  if (config.storage == Storage.sharedPreferences) {
    return '''
import 'package:shared_preferences/shared_preferences.dart';

/// Key-value local storage service using SharedPreferences.
class StorageService {
  StorageService._();

  static SharedPreferences? _prefs;

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences get instance {
    if (_prefs == null) {
      throw StateError('StorageService has not been initialized. Call initialize() in main().');
    }
    return _prefs!;
  }

  static Future<bool> setString(String key, String value) => instance.setString(key, value);
  static String? getString(String key) => instance.getString(key);

  static Future<bool> setInt(String key, int value) => instance.setInt(key, value);
  static int? getInt(String key) => instance.getInt(key);

  static Future<bool> setBool(String key, bool value) => instance.setBool(key, value);
  static bool? getBool(String key) => instance.getBool(key);

  static Future<bool> remove(String key) => instance.remove(key);
  static Future<bool> clear() => instance.clear();
}
''';
  } else if (config.storage == Storage.hive) {
    return '''
import 'package:hive_flutter/hive_flutter.dart';

/// Local NoSQL storage service using Hive.
class StorageService {
  StorageService._();

  static const String appBoxName = 'app_data';

  static Future<void> initialize() async {
    await Hive.initFlutter();
    await Hive.openBox<dynamic>(appBoxName);
  }

  static Box<dynamic> get appBox => Hive.box<dynamic>(appBoxName);

  static Future<void> put(String key, dynamic value) => appBox.put(key, value);
  static T? get<T>(String key, {T? defaultValue}) => appBox.get(key, defaultValue: defaultValue) as T?;

  static Future<void> setString(String key, String value) => put(key, value);
  static String? getString(String key) => get<String>(key);

  static Future<void> setInt(String key, int value) => put(key, value);
  static int? getInt(String key) => get<int>(key);

  static Future<void> setBool(String key, bool value) => put(key, value);
  static bool? getBool(String key) => get<bool>(key);

  static Future<void> remove(String key) => delete(key);
  static Future<void> delete(String key) => appBox.delete(key);
  static Future<int> clear() => appBox.clear();
}
''';
  }

  return '';
}

/// Generates dependency injection setup using get_it.
String renderInjectionContainer(
  ProjectConfig config, {
  required bool usesCoreDir,
}) {
  final imports = <String>["import 'package:get_it/get_it.dart';"];
  final registrations = <String>[];

  if (config.hasImagePicker) {
    imports.add(
      usesCoreDir
          ? "import '../services/image_picker_service.dart';"
          : "import 'image_picker_service.dart';",
    );
    registrations.add(
      '  serviceLocator.registerLazySingleton<ImagePickerService>(ImagePickerService.new);',
    );
  }

  if (config.hasFilePicker) {
    imports.add(
      usesCoreDir
          ? "import '../services/file_picker_service.dart';"
          : "import 'file_picker_service.dart';",
    );
    registrations.add(
      '  serviceLocator.registerLazySingleton<FilePickerService>(FilePickerService.new);',
    );
  }

  imports.sort();

  final regBody = registrations.isNotEmpty
      ? registrations.join('\n')
      : '  // Register singletons, factories, and services here';

  return '''
${imports.join('\n')}

/// Global service locator instance.
final serviceLocator = GetIt.instance;

/// Initializes dependency injection and registers service locators.
Future<void> initDependencies() async {
$regBody
}
''';
}
