import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:corpse_tools/entities/elapsed_time.dart';
import 'package:corpse_tools/utils.dart';

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

    var time = ElapsedTime();
    var readableContent = getReadableContent(readFileAsHexString(input));
    var replacedContent = replaceSequences(readableContent);
    var linesCount = replacedContent.count(replacements.values.first) + 1;
    var hexCount = (replacedContent.length + 1) ~/ 3;
    if (hexCount == linesCount - 1) {
      print('The provided file does not contain any readable text.');
      return;
    }

    writeToFile(File(input.path.replaceAll('.BIN', '.txt')), replacedContent);
    print('Done successfully. Total lines extracted: $linesCount.');
    time.end();
  }
}
