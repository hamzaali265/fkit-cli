import '../models/project_config.dart';

/// Generates `l10n.yaml`.
String renderL10nYaml() {
  return '''
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
synthetic-package: false
''';
}

/// Generates `lib/l10n/app_en.arb`.
String renderAppEnArb(ProjectConfig config) {
  return '''
{
  "@@locale": "en",
  "appTitle": "${config.projectName}",
  "@appTitle": {
    "description": "Title of the application"
  },
  "counterTitle": "Counter Example",
  "@counterTitle": {
    "description": "Counter title"
  },
  "incrementTooltip": "Increment",
  "@incrementTooltip": {
    "description": "Tooltip for the increment floating action button"
  },
  "counterMessage": "You have pushed the button this many times:",
  "@counterMessage": {
    "description": "Explaining text for the counter"
  }
}
''';
}

/// Generates starter `lib/l10n/app_localizations.dart` so it is instantly available.
String renderAppLocalizationsDart(ProjectConfig config) {
  return '''
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

/// Callers can lookup localized strings with [AppLocalizations.of(context)].
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
  ];

  String get appTitle;
  String get counterTitle;
  String get incrementTooltip;
  String get counterMessage;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizationsEn());
  }

  @override
  bool isSupported(Locale locale) => <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

/// English localization implementation.
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([super.locale = 'en']);

  @override
  String get appTitle => '${config.projectName}';

  @override
  String get counterTitle => 'Counter Example';

  @override
  String get incrementTooltip => 'Increment';

  @override
  String get counterMessage => 'You have pushed the button this many times:';
}
''';
}
