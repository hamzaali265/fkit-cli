import '../models/project_config.dart';

/// Markdown-style ASCII folder graphs for each architecture pattern.
abstract final class ArchitectureDiagrams {
  /// Returns a folder-tree diagram for [pattern].
  static List<String> forPattern(ArchitecturePattern pattern) {
    switch (pattern) {
      case ArchitecturePattern.featureFirst:
        return const [
          'lib/',
          '└── features/',
          '    └── <feature>/',
          '        ├── presentation/',
          '        │   ├── pages/',
          '        │   ├── widgets/',
          '        │   └── bloc/  (or providers)',
          '        ├── domain/',
          '        │   ├── entities/',
          '        │   ├── repositories/',
          '        │   └── usecases/',
          '        └── data/',
          '            ├── models/',
          '            ├── datasources/',
          '            └── repositories/',
          '',
          '          ┌─────────────┐',
          '          │ presentation│',
          '          └──────┬──────┘',
          '                 │',
          '          ┌──────▼──────┐',
          '          │   domain    │',
          '          └──────┬──────┘',
          '                 │',
          '          ┌──────▼──────┐',
          '          │    data     │',
          '          └─────────────┘',
        ];
      case ArchitecturePattern.layerFirst:
        return const [
          'lib/',
          '├── presentation/',
          '│   ├── pages/',
          '│   ├── widgets/',
          '│   └── routes/',
          '├── domain/',
          '│   ├── entities/',
          '│   ├── repositories/',
          '│   └── usecases/',
          '└── data/',
          '    ├── models/',
          '    ├── datasources/',
          '    └── repositories/',
          '',
          '  presentation ──► domain ──► data',
          '       UI              rules         IO',
        ];
      case ArchitecturePattern.mvvm:
        return const [
          'lib/',
          '├── views/',
          '│   └── home_view.dart',
          '├── viewmodels/',
          '│   └── home_viewmodel.dart',
          '├── models/',
          '│   └── counter.dart',
          '└── services/',
          '    └── api_service.dart',
          '',
          '   ┌────────┐     ┌────────────┐     ┌──────────┐',
          '   │  View  │────►│ ViewModel  │────►│  Model / │',
          '   │  (UI)  │◄────│  (state)   │◄────│ Services │',
          '   └────────┘     └────────────┘     └──────────┘',
        ];
      case ArchitecturePattern.simpleMvc:
        return const [
          'lib/',
          '├── screens/',
          '│   └── home_screen.dart',
          '├── controllers/',
          '│   └── home_controller.dart',
          '├── models/',
          '│   └── counter.dart',
          '├── services/',
          '│   └── api_service.dart',
          '└── widgets/',
          '    └── counter_text.dart',
          '',
          '   Screen ──► Controller ──► Model / Service',
          '     ▲                           │',
          '     └───────── rebuild ─────────┘',
        ];
      case ArchitecturePattern.modular:
        return const [
          'lib/',
          '├── core/            (theme, network, routes)',
          '├── shared/          (widgets, utils, extensions)',
          '└── modules/',
          '    └── <module>/',
          '        ├── logic/        (controllers / cubits)',
          '        ├── providers/    (state providers)',
          '        ├── repositories/ (data sources & repositories)',
          '        ├── screens/      (views / pages)',
          '        └── models/       (entities & models)',
        ];
    }
  }
}
