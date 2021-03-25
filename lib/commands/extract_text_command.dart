import 'dart:io';

import 'package:args/command_runner.dart';

import '../app_def.dart';
import '../utils.dart';

class ExtractTextCommand extends Command {
  @override
  String get name => 'extract-text';

  @override
  String get description => 'Extract readable text from the given file';

  ExtractTextCommand() {
    argParser.addOption(
      'input',
      abbr: 'i',
      help: 'Input file path',
      valueHelp: 'file-path',
    );
  }

  @override
  void run() {
    if (argResults?['input'] == null) {
      print('Missing parameters. '
          'Run "corpse_tools.exe help extract-text" for info.');
      return;
    }

    var input = File(argResults?['input']);

    if (!input.existsSync() || !input.path.endsWith('.BIN')) {
      print('Input file does not exist or not a .BIN type.');
      return;
    }

    var lastLine = getReadableLines(readFileAsHexString(input));
    var formatLine = replaceSequences(lastLine);
    var linesCount = formatLine.count(AppDef().replacements[0].replaceWith) + 1;
    writeToFile(File(input.path.replaceAll('.BIN', '.txt')), formatLine);
    print('Done successfully. Total lines extracted: $linesCount.');
  }
}
