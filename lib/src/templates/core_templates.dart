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

/// Generates `lib/core/network/api_contract.dart`.
String renderApiContract([ProjectConfig? config]) {
  if (config?.networking == Networking.http) {
    return '''
import 'dart:io';

abstract interface class ApiContract {
  Future<String?> get(
    String path, {
    Map<String, dynamic>? query,
    Map<String, String>? header,
  });
  Future<String?> post(
    String path, {
    Object? body,
    Map<String, dynamic>? query,
    Map<String, String>? header,
    String? contentType,
  });
  Future<String?> patch(
    String path, {
    Object? body,
    Map<String, String>? header,
  });
  Future<String?> update(
    String path,
    Map<String, dynamic>? data,
  );
  Future<String?> create(
    String path,
    Map<String, dynamic>? data,
  );
  Future<String?> delete(
    String path, {
    Object? body,
    Map<String, String>? header,
  });
  Future<String?> put(
    String url, {
    Object? body,
    File? file,
    String? mime,
    Map<String, String>? header,
  });
}
''';
  }

  return '''
import 'dart:io';
import 'package:dio/dio.dart';

abstract interface class ApiContract {
  Future<String?> get(
    String path, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? header,
    CancelToken? cancelToken,
  });
  Future<String?> post(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? query,
    Map<String, dynamic>? header,
    String? contentType,
    CancelToken? cancelToken,
  });
  Future<String?> patch(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? header,
    CancelToken? cancelToken,
  });
  Future<String?> update(
    String path,
    Map<String, dynamic>? data, {
    CancelToken? cancelToken,
  });
  Future<String?> create(
    String path,
    Map<String, dynamic>? data, {
    CancelToken? cancelToken,
  });
  Future<String?> delete(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? header,
    CancelToken? cancelToken,
  });
  Future<String?> put(
    String url, {
    Map<String, dynamic>? body,
    File? file,
    String? mime,
    ProgressCallback? onSendProgress,
    Map<String, dynamic>? header,
    CancelToken? cancelToken,
  });
}
''';
}

/// Generates `lib/core/network/api_endpoint.dart`.
String renderApiEndpoint([ProjectConfig? config]) {
  return '''
/// Centralized API endpoint constants.
class ApiEndpoint {
  ApiEndpoint._();

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refresh = '/auth/refresh';
  static const String logout = '/auth/logout';

  // User
  static const String currentUser = '/users/me';
  static const String updateProfile = '/users/profile';

  // Sample Resources
  static const String posts = '/posts';
  static const String counter = '/counter';
}
''';
}

/// Generates `lib/core/network/api_response.dart`.
String renderApiResponse() {
  return '''
/// Generic API response wrapper tracking request lifecycle status.
class ApiResponse<T> {
  ApiResponse.idle(this.message) : status = LoadStatus.idle;
  ApiResponse.loading(this.message) : status = LoadStatus.loading;
  ApiResponse.loadingNextPage(this.message)
      : status = LoadStatus.loadingNextPage;
  ApiResponse.completed(this.data) : status = LoadStatus.completed;
  ApiResponse.error(this.message) : status = LoadStatus.error;
  ApiResponse.isSuccessful(this.isSuccessful)
      : status = LoadStatus.isSuccessful;

  LoadStatus? status;
  T? data;
  String? message;
  bool? isSuccessful;
}

enum LoadStatus {
  idle,
  loading,
  loadingNextPage,
  completed,
  error,
  isSuccessful,
}
''';
}

/// Generates `lib/core/network/app_exception.dart`.
String renderAppException([ProjectConfig? config]) {
  if (config?.networking == Networking.http) {
    return '''
import 'dart:convert';
import 'package:http/http.dart' as http;

/// Base class for all application specific exceptions.
class AppException implements Exception {
  const AppException({
    required this.message,
    this.prefix,
    this.statusCode,
  });

  final String message;
  final String? prefix;
  final int? statusCode;

  @override
  String toString() => message;
}

/// Generic data fetching exception.
class FetchDataException extends AppException {
  FetchDataException([String? message])
      : super(
          message: message ??
              'Oops! We encountered an issue while loading data. Please try again.',
          prefix: 'Connection Error',
        );
}

/// 400 Bad Request
class BadRequestException extends AppException {
  BadRequestException([String? message])
      : super(
          message: message ??
              'Oops! Something went wrong with your request. Please try again.',
          statusCode: 400,
        );
}

/// 401 Unauthorized
class UnauthorizedException extends AppException {
  UnauthorizedException([String? message])
      : super(
          message: message ?? 'Session expired. Log in again.',
          statusCode: 401,
        );
}

/// 403 Forbidden
class ForbiddenException extends AppException {
  ForbiddenException([String? message])
      : super(
          message: message ??
              "Access denied. You don't have permission for this action.",
          statusCode: 403,
        );
}

/// 404 Not Found
class NotFoundException extends AppException {
  NotFoundException([String? message])
      : super(
          message: message ?? "Oops! We couldn't find what you were looking for.",
          statusCode: 404,
        );
}

/// 409 Conflict
class ConflictException extends AppException {
  ConflictException([String? message])
      : super(
          message: message ?? 'This already exists! Try something else.',
          statusCode: 409,
        );
}

/// 429 Too Many Requests
class RateLimitException extends AppException {
  RateLimitException([String? message])
      : super(
          message: message ??
              'Rate limit exceeded. Please wait a moment before trying again.',
          statusCode: 429,
        );
}

/// 500+ Internal Server Error
class ServerException extends AppException {
  ServerException([String? message])
      : super(
          message: message ?? 'The server is busy, please try again later.',
          statusCode: 500,
        );
}

/// Internet Connectivity Exceptions
class NoInternetException extends AppException {
  NoInternetException()
      : super(
          message: 'No signal! Please check your internet connection.',
          prefix: 'Internet Connection Error',
        );
}

class TimeoutException extends AppException {
  TimeoutException()
      : super(
          message: 'The connection timed out. Please try again later.',
          prefix: 'Connection Timeout',
        );
}

/// Utility class to handle and map HTTP responses to AppExceptions.
class ExceptionHandler {
  static AppException handleResponse(http.Response? response) {
    if (response == null) {
      return NoInternetException();
    }

    final statusCode = response.statusCode;
    final responseData = response.body;
    String? errorMessage;

    try {
      if (responseData.isNotEmpty) {
        final dynamic data = jsonDecode(responseData);

        if (data is Map) {
          errorMessage = data['message'] as String? ??
              (data['errors'] is Map
                  ? (data['errors'] as Map)['detail'] as String?
                  : null) ??
              (data['error'] is Map
                  ? (data['error'] as Map)['message'] as String?
                  : null);
        }
      }
    } on Exception {
      // Ignore parsing errors and use default messages
    }

    switch (statusCode) {
      case 400:
        return BadRequestException(errorMessage);
      case 401:
        return UnauthorizedException(errorMessage);
      case 403:
        return ForbiddenException(errorMessage);
      case 404:
        return NotFoundException(errorMessage);
      case 409:
        return ConflictException(errorMessage);
      case 422:
        return BadRequestException(
          errorMessage ?? 'Check your details and try again.',
        );
      case 429:
        return RateLimitException();
      case 500:
      case 502:
      case 503:
      case 504:
        return ServerException();
      default:
        return FetchDataException();
    }
  }
}
''';
  }

  return '''
import 'dart:convert';
import 'package:dio/dio.dart';

/// Base class for all application specific exceptions.
class AppException implements Exception {
  const AppException({
    required this.message,
    this.prefix,
    this.statusCode,
  });

  final String message;
  final String? prefix;
  final int? statusCode;

  @override
  String toString() => message;
}

/// Generic data fetching exception.
class FetchDataException extends AppException {
  FetchDataException([String? message])
      : super(
          message: message ??
              'Oops! We encountered an issue while loading data. Please try again.',
          prefix: 'Connection Error',
        );
}

/// 400 Bad Request
class BadRequestException extends AppException {
  BadRequestException([String? message])
      : super(
          message: message ??
              'Oops! Something went wrong with your request. Please try again.',
          statusCode: 400,
        );
}

/// 401 Unauthorized
class UnauthorizedException extends AppException {
  UnauthorizedException([String? message])
      : super(
          message: message ?? 'Session expired. Log in again.',
          statusCode: 401,
        );
}

/// 403 Forbidden
class ForbiddenException extends AppException {
  ForbiddenException([String? message])
      : super(
          message: message ??
              "Access denied. You don't have permission for this action.",
          statusCode: 403,
        );
}

/// 404 Not Found
class NotFoundException extends AppException {
  NotFoundException([String? message])
      : super(
          message: message ?? "Oops! We couldn't find what you were looking for.",
          statusCode: 404,
        );
}

/// 409 Conflict
class ConflictException extends AppException {
  ConflictException([String? message])
      : super(
          message: message ?? 'This already exists! Try something else.',
          statusCode: 409,
        );
}

/// 429 Too Many Requests
class RateLimitException extends AppException {
  RateLimitException([String? message])
      : super(
          message: message ??
              'Rate limit exceeded. Please wait a moment before trying again.',
          statusCode: 429,
        );
}

/// 500+ Internal Server Error
class ServerException extends AppException {
  ServerException([String? message])
      : super(
          message: message ?? 'The server is busy, please try again later.',
          statusCode: 500,
        );
}

/// Internet Connectivity Exceptions
class NoInternetException extends AppException {
  NoInternetException()
      : super(
          message: 'No signal! Please check your internet connection.',
          prefix: 'Internet Connection Error',
        );
}

class TimeoutException extends AppException {
  TimeoutException()
      : super(
          message: 'The connection timed out. Please try again later.',
          prefix: 'Connection Timeout',
        );
}

/// Utility class to handle and map Dio responses to AppExceptions.
class ExceptionHandler {
  static AppException handleResponse(Response<dynamic>? response) {
    if (response == null) {
      return NoInternetException();
    }

    final statusCode = response.statusCode;
    final responseData = response.data;
    String? errorMessage;

    try {
      if (responseData != null) {
        final data = responseData is String
            ? jsonDecode(responseData)
            : responseData;

        if (data is Map) {
          errorMessage = data['message'] as String? ??
              (data['errors'] is Map
                  ? (data['errors'] as Map)['detail'] as String?
                  : null) ??
              (data['error'] is Map
                  ? (data['error'] as Map)['message'] as String?
                  : null);
        }
      }
    } on Exception {
      // Ignore parsing errors and use default messages
    }

    switch (statusCode) {
      case 400:
        return BadRequestException(errorMessage);
      case 401:
        return UnauthorizedException(errorMessage);
      case 403:
        return ForbiddenException(errorMessage);
      case 404:
        return NotFoundException(errorMessage);
      case 409:
        return ConflictException(errorMessage);
      case 422:
        return BadRequestException(
          errorMessage ?? 'Check your details and try again.',
        );
      case 429:
        return RateLimitException();
      case 500:
      case 502:
      case 503:
      case 504:
        return ServerException();
      default:
        return FetchDataException();
    }
  }

  static AppException handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException();
      case DioExceptionType.connectionError:
        return NoInternetException();
      case DioExceptionType.badResponse:
        return handleResponse(e.response);
      case DioExceptionType.cancel:
        return const AppException(message: 'Request was cancelled.');
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
      case DioExceptionType.transformTimeout:
        return FetchDataException();
    }
  }
}
''';
}

/// Generates `lib/core/network/api_interceptor.dart`.
String renderApiInterceptor([ProjectConfig? config]) {
  if (config?.networking == Networking.http) {
    return '''
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;

/// Production-ready HTTP client wrapper with automatic headers and logging.
class ApiInterceptor extends http.BaseClient {
  ApiInterceptor([http.Client? inner, this._tokenProvider])
      : _inner = inner ?? http.Client();

  final http.Client _inner;
  final String? Function()? _tokenProvider;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    request.headers['x-client-platform'] = 'mobile';
    request.headers['x-client-device'] = Platform.isIOS ? 'ios' : 'android';
    if (!request.headers.containsKey('Content-Type')) {
      request.headers['Content-Type'] = 'application/json';
    }
    if (!request.headers.containsKey('Accept')) {
      request.headers['Accept'] = 'application/json';
    }
    final token = _tokenProvider?.call();
    if (token != null &&
        token.isNotEmpty &&
        !request.headers.containsKey('Authorization')) {
      request.headers['Authorization'] = 'Bearer \$token';
    }

    log('REQUEST[\${request.method}] => PATH: \${request.url}');
    final response = await _inner.send(request);
    log('RESPONSE[\${response.statusCode}] => PATH: \${request.url}');
    return response;
  }

  @override
  void close() {
    _inner.close();
    super.close();
  }
}
''';
  }

  return '''
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';

/// Production-ready network interceptor with headers, logging, and error tracking.
class ApiInterceptor extends Interceptor {
  ApiInterceptor([this._tokenProvider]);

  final String? Function()? _tokenProvider;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['x-client-platform'] = 'mobile';
    options.headers['x-client-device'] = Platform.isIOS ? 'ios' : 'android';
    if (options.contentType == null ||
        options.contentType == Headers.jsonContentType) {
      options.headers['Content-Type'] = 'application/json';
    }
    final token = _tokenProvider?.call();
    if (token != null &&
        token.isNotEmpty &&
        !options.headers.containsKey('Authorization')) {
      options.headers['Authorization'] = 'Bearer \$token';
    }
    log('REQUEST[\${options.method}] => PATH: \${options.path}');
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    log('RESPONSE[\${response.statusCode}] => PATH: \${response.requestOptions.path}');
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log('ERROR[\${err.response?.statusCode}] => PATH: \${err.requestOptions.path}');
    return super.onError(err, handler);
  }
}
''';
}

/// Generates `lib/core/network/api_service.dart`.
String renderApiService(ProjectConfig config) {
  final baseUrlVal = config.hasEnvFlavors
      ? 'AppConfig.apiBaseUrl'
      : "'https://api.example.com/v1'";
  final configImport = config.hasEnvFlavors
      ? "import '../config/app_config.dart';\n"
      : '';

  if (config.networking == Networking.http) {
    return '''
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

$configImport import 'api_contract.dart';
import 'api_interceptor.dart';
import 'app_exception.dart';

/// Primary API service implementation powered by http package.
class ApiService implements ApiContract {
  ApiService({
    http.Client? client,
    String? baseUrl,
    String? Function()? tokenProvider,
  })  : _baseUrl = baseUrl ?? $baseUrlVal,
        _tokenProvider = tokenProvider,
        _client = ApiInterceptor(client, tokenProvider);

  final http.Client _client;
  final String _baseUrl;
  final String? Function()? _tokenProvider;

  http.Client get client => _client;
  String get baseUrl => _baseUrl;
  String get baseURL => _baseUrl;

  String? _token;
  String? get token => _token ?? _tokenProvider?.call();
  set token(String? value) => _token = value;

  Uri _buildUri(String path, [Map<String, dynamic>? query]) {
    final cleanPath = path.replaceAll('//', '/');
    final urlString =
        cleanPath.startsWith('http') ? cleanPath : '\$_baseUrl\$cleanPath';
    final uri = Uri.parse(urlString);
    if (query == null || query.isEmpty) return uri;
    return uri.replace(
      queryParameters: {
        ...uri.queryParameters,
        ...query.map((k, v) => MapEntry(k, v.toString())),
      },
    );
  }

  @override
  Future<String?> get(
    String path, {
    Map<String, dynamic>? query,
    Map<String, String>? header,
  }) async {
    debugPrint('GET => PATH: \$path');
    try {
      final uri = _buildUri(path, query);
      final response = await _client.get(uri, headers: header);
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 304) {
        return response.body;
      }
      throw ExceptionHandler.handleResponse(response);
    } on SocketException {
      throw NoInternetException();
    } on HttpException {
      throw NoInternetException();
    } on TimeoutException {
      throw TimeoutException();
    } catch (e) {
      if (e is AppException) rethrow;
      throw FetchDataException('Unexpected error: \$e');
    }
  }

  @override
  Future<String?> post(
    String path, {
    Object? body,
    Map<String, dynamic>? query,
    Map<String, String>? header,
    String? contentType,
  }) async {
    debugPrint('POST => PATH: \$path');
    try {
      final uri = _buildUri(path, query);
      final payload = body is Map || body is List ? jsonEncode(body) : body;
      final headers = {
        if (contentType != null) 'Content-Type': contentType,
        if (header != null) ...header,
      };
      final response = await _client.post(uri, body: payload, headers: headers);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.body;
      }
      throw ExceptionHandler.handleResponse(response);
    } on SocketException {
      throw NoInternetException();
    } on HttpException {
      throw NoInternetException();
    } on TimeoutException {
      throw TimeoutException();
    } catch (e) {
      if (e is AppException) rethrow;
      throw FetchDataException('Unexpected error: \$e');
    }
  }

  @override
  Future<String?> patch(
    String path, {
    Object? body,
    Map<String, String>? header,
  }) async {
    debugPrint('PATCH => PATH: \$path');
    try {
      final uri = _buildUri(path);
      final payload = body is Map || body is List ? jsonEncode(body) : body;
      final response = await _client.patch(uri, body: payload, headers: header);
      if (response.statusCode == 200) return response.body;
      throw ExceptionHandler.handleResponse(response);
    } on SocketException {
      throw NoInternetException();
    } on HttpException {
      throw NoInternetException();
    } on TimeoutException {
      throw TimeoutException();
    } catch (e) {
      if (e is AppException) rethrow;
      throw FetchDataException('Unexpected error: \$e');
    }
  }

  @override
  Future<String?> update(
    String path,
    Map<String, dynamic>? data,
  ) async {
    debugPrint('UPDATE => PATH: \$path');
    try {
      final uri = _buildUri(path);
      final response = await _client.patch(
        uri,
        body: data != null ? jsonEncode(data) : null,
      );
      if (response.statusCode == 200) return response.body;
      throw ExceptionHandler.handleResponse(response);
    } on SocketException {
      throw NoInternetException();
    } on HttpException {
      throw NoInternetException();
    } on TimeoutException {
      throw TimeoutException();
    } catch (e) {
      if (e is AppException) rethrow;
      throw FetchDataException('Unexpected error: \$e');
    }
  }

  @override
  Future<String?> create(
    String path,
    Map<String, dynamic>? data,
  ) async {
    debugPrint('POST (create) => PATH: \$path');
    try {
      final uri = _buildUri(path);
      final response = await _client.post(
        uri,
        body: data != null ? jsonEncode(data) : null,
      );
      if (response.statusCode == 201) return response.body;
      throw ExceptionHandler.handleResponse(response);
    } on SocketException {
      throw NoInternetException();
    } on HttpException {
      throw NoInternetException();
    } on TimeoutException {
      throw TimeoutException();
    } catch (e) {
      if (e is AppException) rethrow;
      throw FetchDataException('Unexpected error: \$e');
    }
  }

  @override
  Future<String?> delete(
    String path, {
    Object? body,
    Map<String, String>? header,
  }) async {
    debugPrint('DELETE => PATH: \$path');
    try {
      final uri = _buildUri(path);
      final payload = body is Map || body is List ? jsonEncode(body) : body;
      final response = await _client.delete(uri, body: payload, headers: header);
      return response.body;
    } on SocketException {
      throw NoInternetException();
    } on HttpException {
      throw NoInternetException();
    } on TimeoutException {
      throw TimeoutException();
    } catch (e) {
      if (e is AppException) rethrow;
      rethrow;
    }
  }

  @override
  Future<String?> put(
    String url, {
    Object? body,
    File? file,
    String? mime,
    Map<String, String>? header,
  }) async {
    debugPrint('PUT => PATH: \$url');
    try {
      final uri = _buildUri(url);
      final headers = {
        if (mime != null) 'Content-Type': mime,
        if (header != null) ...header,
      };
      dynamic payload = body;
      if (file != null) {
        payload = await file.readAsBytes();
      } else if (body is Map || body is List) {
        payload = jsonEncode(body);
      }
      final response = await _client.put(uri, body: payload, headers: headers);
      return response.body;
    } on SocketException {
      throw NoInternetException();
    } on HttpException {
      throw NoInternetException();
    } on TimeoutException {
      throw TimeoutException();
    } catch (e) {
      if (e is AppException) rethrow;
      throw FetchDataException('Unexpected error: \$e');
    }
  }

  void close() => _client.close();
}

/// Backwards-compatible alias for ApiService.
typedef ApiClient = ApiService;
''';
  }

  return '''
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

$configImport import 'api_contract.dart';
import 'api_interceptor.dart';
import 'app_exception.dart';

/// Primary API service implementation powered by Dio.
class ApiService implements ApiContract {
  ApiService({
    Dio? dio,
    String? baseUrl,
    String? Function()? tokenProvider,
  })  : _baseUrl = baseUrl ?? $baseUrlVal,
        _tokenProvider = tokenProvider,
        _dio = dio ?? Dio() {
    _dio.options.connectTimeout = const Duration(seconds: 15);
    _dio.options.receiveTimeout = const Duration(seconds: 15);
    _dio.interceptors.add(ApiInterceptor(_tokenProvider));
  }

  final Dio _dio;
  final String _baseUrl;
  final String? Function()? _tokenProvider;

  Dio get client => _dio;
  String get baseUrl => _baseUrl;
  String get baseURL => _baseUrl;

  String? _token;
  String? get token => _token ?? _tokenProvider?.call();
  set token(String? value) => _token = value;

  @override
  Future<String?> get(
    String path, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? header,
    CancelToken? cancelToken,
  }) async {
    debugPrint('GET => PATH: \$path');
    try {
      final cleanPath = path.replaceAll('//', '/');
      final fullUrl =
          cleanPath.startsWith('http') ? cleanPath : '\$_baseUrl\$cleanPath';
      final response = await _dio.get<String>(
        fullUrl,
        queryParameters: query,
        cancelToken: cancelToken,
        options: Options(
          headers: header ??
              {
                if (token != null && token!.isNotEmpty)
                  'Authorization': 'Bearer \$token',
              },
        ),
      );

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 304) {
        return response.data;
      }

      throw ExceptionHandler.handleResponse(response);
    } on SocketException {
      throw NoInternetException();
    } on HttpException {
      throw NoInternetException();
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) return null;
      throw ExceptionHandler.handleDioException(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw FetchDataException('Unexpected error: \$e');
    }
  }

  @override
  Future<String?> post(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? query,
    Map<String, dynamic>? header,
    String? contentType,
    CancelToken? cancelToken,
  }) async {
    debugPrint('POST => PATH: \$path');
    try {
      final cleanPath = path.replaceAll('//', '/');
      final fullUrl =
          cleanPath.startsWith('http') ? cleanPath : '\$_baseUrl\$cleanPath';
      final response = await _dio.post<String>(
        fullUrl,
        data: body,
        queryParameters: query,
        cancelToken: cancelToken,
        options: Options(
          headers: header ??
              {
                if (token != null && token!.isNotEmpty)
                  'Authorization': 'Bearer \$token',
              },
          contentType: contentType ?? 'application/json',
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      }
      throw ExceptionHandler.handleResponse(response);
    } on SocketException {
      throw NoInternetException();
    } on HttpException {
      throw NoInternetException();
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) return null;
      throw ExceptionHandler.handleDioException(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw FetchDataException('Unexpected error: \$e');
    }
  }

  @override
  Future<String?> patch(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? header,
    CancelToken? cancelToken,
  }) async {
    debugPrint('PATCH => PATH: \$path');
    try {
      final cleanPath = path.replaceAll('//', '/');
      final fullUrl =
          cleanPath.startsWith('http') ? cleanPath : '\$_baseUrl\$cleanPath';
      final response = await _dio.patch<String>(
        fullUrl,
        data: body,
        cancelToken: cancelToken,
        options: Options(
          headers: header ??
              {
                if (token != null && token!.isNotEmpty)
                  'Authorization': 'Bearer \$token',
              },
          contentType: 'application/json',
        ),
      );
      if (response.statusCode == 200) return response.data;
      throw ExceptionHandler.handleResponse(response);
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw FetchDataException('Unexpected error: \$e');
    }
  }

  @override
  Future<String?> update(
    String path,
    Map<String, dynamic>? data, {
    CancelToken? cancelToken,
  }) async {
    debugPrint('UPDATE => PATH: \$path');
    try {
      final cleanPath = path.replaceAll('//', '/');
      final fullUrl =
          cleanPath.startsWith('http') ? cleanPath : '\$_baseUrl\$cleanPath';
      final response = await _dio.patch<String>(
        fullUrl,
        data: data,
        cancelToken: cancelToken,
      );
      if (response.statusCode == 200) return response.data;
      throw ExceptionHandler.handleResponse(response);
    } on SocketException {
      throw NoInternetException();
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw FetchDataException('Unexpected error: \$e');
    }
  }

  @override
  Future<String?> create(
    String path,
    Map<String, dynamic>? data, {
    CancelToken? cancelToken,
  }) async {
    debugPrint('POST (create) => PATH: \$path');
    try {
      final cleanPath = path.replaceAll('//', '/');
      final fullUrl =
          cleanPath.startsWith('http') ? cleanPath : '\$_baseUrl\$cleanPath';
      final response = await _dio.post<String>(
        fullUrl,
        data: data,
        cancelToken: cancelToken,
      );
      if (response.statusCode == 201) return response.data;
      throw ExceptionHandler.handleResponse(response);
    } on SocketException {
      throw NoInternetException();
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw FetchDataException('Unexpected error: \$e');
    }
  }

  @override
  Future<String?> delete(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? header,
    CancelToken? cancelToken,
  }) async {
    debugPrint('DELETE => PATH: \$path');
    try {
      final cleanPath = path.replaceAll('//', '/');
      final fullUrl =
          cleanPath.startsWith('http') ? cleanPath : '\$_baseUrl\$cleanPath';
      final response = await _dio.delete<String>(
        fullUrl,
        data: body,
        cancelToken: cancelToken,
        options: Options(
          headers: header ??
              {
                if (token != null && token!.isNotEmpty)
                  'Authorization': 'Bearer \$token',
              },
          contentType: 'application/json',
        ),
      );
      return response.data;
    } on SocketException {
      throw NoInternetException();
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    } catch (ex) {
      if (ex is AppException) rethrow;
      rethrow;
    }
  }

  @override
  Future<String?> put(
    String url, {
    Map<String, dynamic>? body,
    File? file,
    String? mime,
    ProgressCallback? onSendProgress,
    Map<String, dynamic>? header,
    CancelToken? cancelToken,
  }) async {
    debugPrint('PUT => PATH: \$url');
    Options? options;
    Uint8List? imageBytes;
    if (file != null) {
      final bytes = await file.readAsBytes();
      final base64Image = base64Encode(bytes);
      imageBytes = base64Decode(base64Image);
      options = Options(contentType: mime);
    } else {
      options = Options(
        contentType: mime,
        headers: header ??
            {
              if (token != null && token!.isNotEmpty)
                'Authorization': 'Bearer \$token',
            },
      );
    }

    try {
      final cleanPath = url.replaceAll('//', '/');
      final fullUrl = file != null
          ? url
          : (cleanPath.startsWith('http') ? cleanPath : '\$_baseUrl\$cleanPath');
      final response = await _dio.put<String>(
        fullUrl,
        data: body ?? imageBytes,
        cancelToken: cancelToken,
        options: options,
        onSendProgress: onSendProgress,
      );
      return response.data;
    } on SocketException {
      throw NoInternetException();
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw FetchDataException('Unexpected error: \$e');
    }
  }
}

/// Backwards-compatible alias for ApiService.
typedef ApiClient = ApiService;
''';
}

/// Generates `lib/core/network/network_event_provider.dart`.
String renderNetworkEventProvider([ProjectConfig? config]) {
  return '''
/// Sealed class representing global network events.
sealed class NetworkEvent {
  const NetworkEvent();
}

class BannedEvent extends NetworkEvent {
  const BannedEvent();
}

class RateLimitEvent extends NetworkEvent {
  const RateLimitEvent();
}

class RegionRestrictedEvent extends NetworkEvent {
  const RegionRestrictedEvent();
}
''';
}

/// Generates `lib/core/network/failures/failure.dart`.
String renderFailure() {
  return '''
/// Base Failure class for domain and data layer error propagation.
abstract class Failure {
  const Failure({
    required this.message,
    this.code,
  });

  final String message;
  final int? code;

  @override
  String toString() => message;
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.code});
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message, super.code});
}

class NetworkFailure extends Failure {
  const NetworkFailure({required super.message, super.code});
}

class ImagePickerFailure extends Failure {
  const ImagePickerFailure({required super.message, super.code});
}
''';
}

/// Generates `lib/core/network/failures/exception.dart`.
String renderException() {
  return '''
/// Base exception classes for datasources and device operations.
class ImagePickFailedException implements Exception {
  const ImagePickFailedException({this.code});
  final String? code;
}

class NotValidImageException implements Exception {
  const NotValidImageException();
}

class CacheException implements Exception {
  const CacheException([this.message]);
  final String? message;
}

class NetworkException implements Exception {
  const NetworkException([this.message]);
  final String? message;
}
''';
}

/// Generates `lib/core/network/network.dart` barrel file.
String renderNetworkBarrel() {
  return '''
export 'api_contract.dart';
export 'api_endpoint.dart';
export 'api_interceptor.dart';
export 'api_response.dart';
export 'api_service.dart';
export 'app_exception.dart';
export 'failures/exception.dart';
export 'failures/failure.dart';
export 'network_event_provider.dart';
''';
}

/// Generates `lib/core/network/api_client.dart` (or simple client for HTTP).
String renderApiClient(ProjectConfig config) {
  if (config.networking == Networking.dio) {
    return renderApiService(config);
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
  } else if (config.storage == Storage.sqflite) {
    return '''
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

/// Local SQLite relational database service.
class StorageService {
  StorageService._();

  static const String _dbName = 'app_database.db';
  static const int _dbVersion = 1;
  static Database? _database;

  static Future<void> initialize() async {
    final databasesPath = await getDatabasesPath();
    final path = p.join(databasesPath, _dbName);

    _database = await openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        await db.execute(\'''
          CREATE TABLE IF NOT EXISTS settings (
            key TEXT PRIMARY KEY,
            value TEXT
          )
        \''');
      },
    );
  }

  static Database get database {
    if (_database == null) {
      throw StateError('StorageService has not been initialized. Call initialize() in main().');
    }
    return _database!;
  }

  static Future<void> setString(String key, String value) async {
    await database.insert(
      'settings',
      {'key': key, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<String?> getString(String key) async {
    final results = await database.query(
      'settings',
      where: 'key = ?',
      whereArgs: [key],
      limit: 1,
    );
    if (results.isNotEmpty) {
      return results.first['value'] as String?;
    }
    return null;
  }

  static Future<void> setInt(String key, int value) async {
    await setString(key, value.toString());
  }

  static Future<int?> getInt(String key) async {
    final value = await getString(key);
    if (value != null) {
      return int.tryParse(value);
    }
    return null;
  }

  static Future<void> setBool(String key, bool value) async {
    await setString(key, value ? '1' : '0');
  }

  static Future<bool?> getBool(String key) async {
    final value = await getString(key);
    if (value != null) {
      return value == '1' || value == 'true';
    }
    return null;
  }

  static Future<int> remove(String key) async {
    return database.delete(
      'settings',
      where: 'key = ?',
      whereArgs: [key],
    );
  }

  static Future<int> clear() async {
    return database.delete('settings');
  }

  static Future<void> close() async {
    await _database?.close();
    _database = null;
  }
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

  if (config.hasGeolocator) {
    imports.add(
      usesCoreDir
          ? "import '../services/location_service.dart';"
          : "import 'location_service.dart';",
    );
    registrations.add(
      '  serviceLocator.registerLazySingleton<LocationService>(LocationService.new);',
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
