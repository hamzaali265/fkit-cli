import 'package:mason_logger/mason_logger.dart';

import '../models/project_config.dart';
import 'cli_theme.dart';

/// Modern styling, banners, and panel components for fkit terminal UI.
class CliUi {
  /// Creates a new [CliUi] instance.
  const CliUi(this._logger);

  final Logger _logger;

  /// Prints the FKIT CLI hero with block-font FKIT wordmark.
  void printHeroBanner({String version = '1.0.0', int? columns}) {
    _logger.info('');
    _logger.info(
      '  ${CliTheme.accent(CliTheme.spark)} '
      '${CliTheme.boldText('Welcome to ${CliTheme.displayName}!')}',
    );
    _logger.info('');

    if (CliTheme.canShowAsciiLogo(columns: columns)) {
      for (final row in CliTheme.fkitLogoRows) {
        _logger.info(
          '  ${CliTheme.colorFkitLogoRow(row.$1, row.$2)}',
        );
      }
    } else {
      _logger.info(
        '  ${CliTheme.accent(CliTheme.boldText(CliTheme.displayName))}',
      );
    }

    _logger.info('');
    _logger.info(
      '  ${white.wrap('Modern Flutter scaffolding for production apps.')}',
    );
    _logger.info('  ${CliTheme.muted('v$version')}');
    _logger.info('');
  }

  /// Prints a soft hairline separator used on the home screen.
  void printHairline([int width = 48]) {
    _logger.info('  ${CliTheme.hairline(width)}');
  }

  /// Compact step header: title, progress, one muted line — no heavy chrome.
  void printStepHeader({
    required int step,
    required int total,
    required String title,
    required String description,
  }) {
    final dots = CliTheme.progressDots(step, total);

    _logger.info('');
    _logger.info(
      '  ${CliTheme.accent(CliTheme.spark)} '
      '${CliTheme.boldText(title)} '
      '${CliTheme.muted('$step/$total')}',
    );
    _logger.info('  $dots');
    _logger.info('  ${CliTheme.muted(description)}');
    _logger.info('  ${CliTheme.hairline(CliTheme.panelWidth)}');
  }

  /// Prints a properly sized rounded panel with optional title and body lines.
  void printPanel({
    String? title,
    required List<String> lines,
    int width = CliTheme.panelWidth,
  }) {
    final inner = width - 6;
    _logger.info('');
    _logger.info('  ${CliTheme.topBorder(width, title: title)}');
    for (final line in lines) {
      _logger.info('  ${CliTheme.boxLine(line, inner)}');
    }
    _logger.info('  ${CliTheme.bottomBorder(width)}');
  }

  /// Prints a subtle keyboard navigation hint footer for interactive prompts.
  void printKeyHints({
    bool isMultiSelect = false,
    bool forHome = false,
    bool forBrowse = false,
  }) {
    final String hints;
    if (forHome) {
      hints =
          '${CliTheme.muted('↑/↓')} ${CliTheme.muted(CliTheme.midDot)} '
          '${CliTheme.muted('enter')} ${CliTheme.muted(CliTheme.midDot)} '
          '${CliTheme.muted('ctrl+c')}';
    } else if (forBrowse) {
      hints =
          '${CliTheme.muted('↑/↓ move')} ${CliTheme.muted(CliTheme.midDot)} '
          '${CliTheme.muted('enter open / select')} ${CliTheme.muted(CliTheme.midDot)} '
          '${CliTheme.muted('ctrl+c quit')}';
    } else if (isMultiSelect) {
      hints =
          '${CliTheme.muted('↑/↓')} ${CliTheme.muted(CliTheme.midDot)} '
          '${CliTheme.muted('space toggle')} ${CliTheme.muted(CliTheme.midDot)} '
          '${CliTheme.muted('enter confirm')}';
    } else {
      hints =
          '${CliTheme.muted('↑/↓')} ${CliTheme.muted(CliTheme.midDot)} '
          '${CliTheme.muted('enter')} ${CliTheme.muted(CliTheme.midDot)} '
          '${CliTheme.muted('ctrl+c')}';
    }

    _logger.info('  $hints');
  }

  /// Prints a configuration summary card with aligned columns and pill badges.
  void printSummaryCard(ProjectConfig config) {
    const width = CliTheme.panelWidth;
    final inner = width - 6;
    const labelWidth = 14;
    final valueWidth = inner - labelWidth - 1;

    _logger.info('');
    _logger.info('  ${CliTheme.topBorder(width, title: 'Summary')}');

    void printRow(String label, String value) {
      final lines = CliTheme.wrap(value, valueWidth);
      for (var i = 0; i < lines.length; i++) {
        final labelPart = i == 0
            ? CliTheme.muted(label.padRight(labelWidth))
            : ' ' * labelWidth;
        _logger.info(
          '  ${CliTheme.boxLine('$labelPart ${lines[i]}', inner)}',
        );
      }
    }

    String pills(Iterable<String> items) {
      final list = items.toList();
      if (list.isEmpty) return CliTheme.muted('None');
      return list.map(CliTheme.pill).join(' ');
    }

    printRow('Name', config.projectName);
    printRow('Org', config.orgName);
    printRow('Path', config.targetDirectory);
    printRow('Architecture', CliTheme.pill(config.architecture.label, active: true));
    printRow('State', CliTheme.pill(config.stateManagement.label, active: true));
    printRow('Routing', CliTheme.pill(config.routing.label, active: true));
    printRow('Network', CliTheme.pill(config.networking.label, active: true));
    printRow('Storage', CliTheme.pill(config.storage.label, active: true));
    printRow(
      'Utilities',
      pills(config.utilities.map((u) => u.packageName)),
    );
    printRow(
      'Features',
      pills(config.features.map((f) => f.label)),
    );

    _logger.info('  ${CliTheme.bottomBorder(width)}');
    _logger.info('');
  }

  /// Prints a success card with next steps commands.
  void printSuccessCard(ProjectConfig config, {required String relativePath}) {
    const width = CliTheme.panelWidth;
    final inner = width - 6;

    _logger.info('');
    _logger.info('  ${CliTheme.topBorder(width, title: 'Ready')}');
    for (final line in CliTheme.wrap(
      '${CliTheme.success(CliTheme.boldText('Success'))}  "${config.projectName}" is ready',
      inner,
    )) {
      _logger.info('  ${CliTheme.boxLine(line, inner)}');
    }
    _logger.info('  ${CliTheme.midBorder(width)}');
    _logger.info(
      '  ${CliTheme.boxLine(CliTheme.muted('Get started:'), inner)}',
    );
    for (final line in CliTheme.wrap(CliTheme.accent('cd $relativePath'), inner)) {
      _logger.info('  ${CliTheme.boxLine(line, inner)}');
    }
    if (config.offline) {
      _logger.info(
        '  ${CliTheme.boxLine(CliTheme.accent('flutter pub get'), inner)}',
      );
    }
    _logger.info(
      '  ${CliTheme.boxLine(CliTheme.accent('flutter run'), inner)}',
    );
    _logger.info('  ${CliTheme.bottomBorder(width)}');
    _logger.info('');
  }

  /// Prints a stylized category header with box lines for the `list` command.
  void printListCategory(String title, List<MapEntry<String, String>> items) {
    const width = CliTheme.panelWidth;
    final inner = width - 6;

    _logger.info('');
    _logger.info('  ${CliTheme.topBorder(width, title: title)}');
    for (final item in items) {
      final key = item.key.padRight(18);
      final keyWidth = 18;
      final maxDesc = (inner - keyWidth - 1).clamp(8, inner);
      var desc = item.value;
      if (CliTheme.visibleLength(desc) > maxDesc) {
        desc = '${desc.substring(0, maxDesc - 1)}…';
      }
      final row = '${CliTheme.label(key)} ${CliTheme.muted(desc)}';
      _logger.info('  ${CliTheme.boxLine(row, inner)}');
    }
    _logger.info('  ${CliTheme.bottomBorder(width)}');
  }
}