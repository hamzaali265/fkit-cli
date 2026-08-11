import '../models/project_config.dart';

/// Generates a reusable `AppNetworkImage` widget wrapping `CachedNetworkImage`.
String renderAppNetworkImage(ProjectConfig config) {
  return '''
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Reusable network image with built-in caching, shimmer placeholder, and error fallback.
class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    required this.imageUrl,
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = BorderRadius.zero,
  });

  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => Container(
          width: width,
          height: height,
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: const Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          width: width,
          height: height,
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Icon(
            Icons.broken_image_outlined,
            color: Theme.of(context).colorScheme.error,
          ),
        ),
      ),
    );
  }
}
''';
}

/// Generates starter SVG content for assets/icons/app_logo.svg.
String renderStarterSvg(ProjectConfig config) {
  return '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100" width="100" height="100">
  <defs>
    <linearGradient id="grad" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" style="stop-color:#6750A4;stop-opacity:1" />
      <stop offset="100%" style="stop-color:#9A82DB;stop-opacity:1" />
    </linearGradient>
  </defs>
  <rect width="100" height="100" rx="24" fill="url(#grad)" />
  <path d="M30 65 L50 35 L70 65 Z" fill="#FFFFFF" opacity="0.9" />
  <circle cx="50" cy="48" r="8" fill="#FFD700" />
</svg>
''';
}

/// Generates a reusable `AppButton` widget for shared UI elements.
String renderAppButton() {
  return '''
import 'package:flutter/material.dart';

/// A reusable styled primary button used across features.
class AppButton extends StatelessWidget {
  const AppButton({
    required this.text,
    required this.onPressed,
    super.key,
    this.isLoading = false,
    this.icon,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : icon != null
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 18),
                    const SizedBox(width: 8),
                    Text(text),
                  ],
                )
              : Text(text),
    );
  }
}
''';
}

/// Generates `lib/shared/extensions/context_extensions.dart`.
String renderContextExtensions() {
  return '''
import 'package:flutter/material.dart';

/// Extension methods on [BuildContext] for ergonomic theme, text theme, and media queries.
extension ContextExtensions on BuildContext {
  /// Theme of the current context.
  ThemeData get theme => Theme.of(this);

  /// ColorScheme of the current theme.
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// TextTheme of the current theme.
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Screen width from [MediaQuery].
  double get screenWidth => MediaQuery.sizeOf(this).width;

  /// Screen height from [MediaQuery].
  double get screenHeight => MediaQuery.sizeOf(this).height;
}
''';
}

/// Generates `lib/shared/extensions/widget_extensions.dart`.
String renderWidgetExtensions() {
  return '''
import 'package:flutter/material.dart';

extension SizedBoxExtension on num {
  /// Creates a [SizedBox] with the height of this number.
  /// Usage: 16.h
  Widget get h => SizedBox(height: toDouble());

  /// Creates a [SizedBox] with the width of this number.
  /// Usage: 24.w
  Widget get w => SizedBox(width: toDouble());

  /// Creates a square [SizedBox] with both height and width of this number.
  /// Usage: 48.sz
  Widget get sz => SizedBox(height: toDouble(), width: toDouble());
}

extension WidgetPaddingExtension on Widget {
  /// Wraps this widget with [Padding] on all sides.
  Widget pAll(double value) =>
      Padding(padding: EdgeInsets.all(value), child: this);

  /// Wraps this widget with symmetric [Padding].
  Widget pSymmetric({double h = 0, double v = 0}) => Padding(
        padding: EdgeInsets.symmetric(horizontal: h, vertical: v),
        child: this,
      );

  /// Shorthand for horizontal [Padding].
  Widget px(double value) => pSymmetric(h: value);

  /// Shorthand for vertical [Padding].
  Widget py(double value) => pSymmetric(v: value);

  /// Wraps this widget with specific [Padding] for each side.
  Widget pOnly({
    double l = 0,
    double t = 0,
    double r = 0,
    double b = 0,
  }) =>
      Padding(
        padding: EdgeInsets.only(left: l, top: t, right: r, bottom: b),
        child: this,
      );
}
''';
}

/// Generates `lib/shared/extensions/string_extensions.dart`.
String renderStringExtensions() {
  return '''
extension StringExtension on String {
  /// Capitalizes the first character of this string.
  /// Example: 'hello' -> 'Hello'
  String get capitalize =>
      isNotEmpty ? '\${this[0].toUpperCase()}\${substring(1)}' : this;

  /// Validates if the string is a correct email format.
  bool get isValidEmail =>
      RegExp(r'^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}\$').hasMatch(this);

  /// Helper for hardcoded strings (useful for potential localization later).
  String get hardcoded => this;

  /// Whether this string is empty or only whitespace.
  bool get isBlank => trim().isEmpty;

  /// Whether this string has non-whitespace content.
  bool get isNotBlank => !isBlank;

  /// Title-cases each whitespace-separated word.
  String get titleCase {
    if (isEmpty) return this;
    return split(RegExp(r'\\s+'))
        .where((word) => word.isNotEmpty)
        .map((word) => word.capitalize)
        .join(' ');
  }

  /// Converts `snake_case`, `kebab-case`, or spaced words to `camelCase`.
  String get toCamelCase {
    final parts =
        split(RegExp(r'[\\s_-]+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '';
    final head = parts.first.toLowerCase();
    final tail = parts.skip(1).map((p) => p.capitalize).join();
    return '\$head\$tail';
  }

  /// Converts camelCase / PascalCase / spaced words to snake_case.
  String get toSnakeCase {
    final withSpaces = replaceAllMapped(
      RegExp('([a-z0-9])([A-Z])'),
      (match) => '\${match[1]}_\${match[2]}',
    );
    return withSpaces
        .replaceAll(RegExp(r'[\\s-]+'), '_')
        .replaceAll(RegExp('_+'), '_')
        .toLowerCase();
  }

  /// Truncates to [max] characters and appends [ellipsis] when longer.
  String truncate(int max, {String ellipsis = '…'}) {
    if (max <= 0) return '';
    if (length <= max) return this;
    if (max <= ellipsis.length) return ellipsis.substring(0, max);
    return '\${substring(0, max - ellipsis.length)}\$ellipsis';
  }

  /// Returns null when blank; otherwise this string.
  String? get nullIfBlank => isBlank ? null : this;
}

/// Nullable helpers for optional strings from APIs / forms.
extension NullableStringExtensions on String? {
  /// True when null, empty, or only whitespace.
  bool get isNullOrBlank => this == null || this!.trim().isEmpty;

  /// True when there is non-whitespace content.
  bool get isNotNullOrBlank => !isNullOrBlank;

  /// Returns [fallback] when null/blank.
  String orEmpty([String fallback = '']) =>
      isNullOrBlank ? fallback : this!;
}
''';
}

/// Generates `lib/shared/utils/app_formatters.dart`.
String renderAppFormatters() {
  return '''
/// Shared formatters and utility string functions.
class AppFormatters {
  AppFormatters._();

  /// Formats a number with thousands separators (e.g. 1,000,000).
  static String formatNumber(num number) {
    final parts = number.toString().split('.');
    final intPart = parts[0].replaceAllMapped(
      RegExp(r'(\\d{1,3})(?=(\\d{3})+(?!\\d))'),
      (match) => '\${match[1]},',
    );
    return parts.length > 1 ? '\$intPart.\${parts[1]}' : intPart;
  }

  /// Capitalizes the first letter of a string.
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return '\${text[0].toUpperCase()}\${text.substring(1)}';
  }
}
''';
}

/// Generates barrel `extensions.dart` exporting all extension files.
String renderExtensionsBarrel() {
  return '''
export 'context_extensions.dart';
export 'string_extensions.dart';
export 'widget_extensions.dart';
''';
}

/// Generates barrel `widgets.dart` exporting shared widgets.
String renderWidgetsBarrel({required bool hasCachedNetworkImage}) {
  final networkImage = hasCachedNetworkImage
      ? "export 'app_network_image.dart';\n"
      : '';
  return '''
export 'app_button.dart';
$networkImage''';
}

/// Generates barrel `utils.dart` exporting shared utilities.
String renderUtilsBarrel() {
  return '''
export 'app_formatters.dart';
''';
}

/// Generates `lib/shared/constants/app_assets.dart` with typed asset paths.
String renderAppAssets({required bool hasFlutterSvg}) {
  final logoPaths = hasFlutterSvg
      ? '''

  // Icons
  static const String appLogoIcon = '\${icons}app_logo.svg';

  // SVGs
  static const String appLogoSvg = '\${svgs}app_logo.svg';
'''
      : '';

  return '''
/// Centralized asset path constants.
///
/// Prefer these over hardcoded strings so renames stay in one place.
class AppAssets {
  AppAssets._();

  // Folders
  static const String images = 'assets/images/';
  static const String icons = 'assets/icons/';
  static const String svgs = 'assets/svgs/';
  static const String fonts = 'assets/fonts/';
$logoPaths
  // Fonts (uncomment matching entries in pubspec.yaml first)
  static const String schylerRegular = '\${fonts}Schyler-Regular.ttf';
  static const String schylerItalic = '\${fonts}Schyler-Italic.ttf';
  static const String trajanPro = '\${fonts}TrajanPro.ttf';
  static const String trajanProBold = '\${fonts}TrajanPro_Bold.ttf';
}
''';
}

/// Generates barrel `constants.dart` exporting shared constants.
String renderConstantsBarrel() {
  return '''
export 'app_assets.dart';
''';
}
