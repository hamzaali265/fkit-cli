import '../models/project_config.dart';

/// Generates `analysis_options.yaml` based on linting preferences.
String renderAnalysisOptions(ProjectConfig config) {
  if (config.hasStrictLinting) {
    return '''
include: package:very_good_analysis/analysis_options.yaml

linter:
  rules:
    public_member_api_docs: false
    lines_longer_than_80_chars: false
    always_use_package_imports: false
    avoid_positional_boolean_parameters: false
    avoid_redundant_argument_values: false
''';
  }

  return '''
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    prefer_const_constructors: true
    prefer_const_declarations: true
    avoid_print: true
''';
}
