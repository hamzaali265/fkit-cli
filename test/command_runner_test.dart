import 'package:fkit_cli/fkit.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:test/test.dart';

void main() {
  late FkitCommandRunner runner;

  setUp(() {
    runner = FkitCommandRunner();
  });

  group('FkitCommandRunner', () {
    test('--version returns exit code 0', () async {
      final exitCode = await runner.run(['--version']);
      expect(exitCode, equals(0));
    });

    test('list command returns exit code 0', () async {
      final exitCode = await runner.run(['list']);
      expect(exitCode, equals(0));
    });

    test('list --no-hero skips hero banner content', () async {
      final logger = _CapturingLogger();
      final local = FkitCommandRunner(logger: logger);
      final exitCode = await local.run(['list', '--no-hero']);
      expect(exitCode, equals(0));
      final output = logger.logs.join('\n');
      expect(output, isNot(contains('Welcome to FKIT CLI!')));
      expect(output, contains('Architecture Patterns'));
    });

    test('bare fkit invokes home screen', () async {
      final home = _StubHomeScreen();
      final local = FkitCommandRunner(homeScreen: home);
      final exitCode = await local.run([]);
      expect(exitCode, equals(0));
      expect(home.called, isTrue);
    });

    test('invalid command returns usage error code 64', () async {
      final exitCode = await runner.run(['unknown_command']);
      expect(exitCode, equals(64));
    });

    test('invalid flag returns usage error code 64', () async {
      final exitCode = await runner.run(['create', '--invalid-flag']);
      expect(exitCode, equals(64));
    });
  });
}

class _StubHomeScreen extends HomeScreen {
  _StubHomeScreen() : super(runCommand: (_) async => 0);

  bool called = false;

  @override
  Future<int> run({List<HomeAction>? actions}) async {
    called = true;
    return ExitCode.success.code;
  }
}

class _CapturingLogger extends Logger {
  final List<String> logs = [];

  @override
  void info(String? message, {LogStyle? style}) {
    if (message != null) logs.add(message);
  }
}
