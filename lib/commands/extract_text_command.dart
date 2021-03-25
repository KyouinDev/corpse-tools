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
    var input = getFileFromArg(
      arg: argResults!['input'],
      command: 'extract-text',
      expected: '.BIN',
    );

    if (input == null) return;

    var time = DateTime.now();
    var readableContent = getReadableContent(readFileAsHexString(input));
    var replacedContent = replaceSequences(readableContent);
    var count = replacedContent.count(AppDef().replacements.values.first) + 1;
    writeToFile(File(input.path.replaceAll('.BIN', '.txt')), replacedContent);
    print('Done successfully. Total lines extracted: $count.');
    printElapsedTime(time);
  }
}
