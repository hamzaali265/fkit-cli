import 'dart:io';

import 'package:fkit/fkit.dart';

Future<void> main(List<String> args) async {
  final runner = FkitCommandRunner();
  final exitCode = await runner.run(args);
  exit(exitCode);
}
