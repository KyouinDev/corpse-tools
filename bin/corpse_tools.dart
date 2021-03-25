import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:corpse_tools/commands.dart';

void main(List<String> args) {
  var desc = 'CorpseTools v0.1.1 made by Kyouin.\n'
      'Supported game(s):\n'
      ' - Corpse Party: Book of Shadows (PC)';
  var runner = CommandRunner('corpse_tools', desc)
    ..addCommand(ExtractTextCommand())
    ..addCommand(ReplaceTextCommand());
  runner.run(args).catchError((error) {
    if (error is! UsageException) throw error;

    print(error);
    exit(-1);
  });
}
