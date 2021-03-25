import 'dart:io';

import 'package:args/command_runner.dart';

import '../utils.dart';

class ReplaceTextCommand extends Command {
  @override
  String get name => 'replace-text';

  @override
  String get description => 'Replace modified text of the given file';

  ReplaceTextCommand() {
    argParser.addOption(
      'original',
      abbr: 'o',
      help: 'Original .BIN file path',
      valueHelp: 'file-path',
    );
    argParser.addOption(
      'modified',
      abbr: 'm',
      help: 'Modified .txt file path',
      valueHelp: 'file-path',
    );
  }

  @override
  void run() {
    if (argResults?['original'] == null || argResults?['modified'] == null) {
      print('Missing parameters. '
          'Run "corpse_tools.exe help replace-text" for info.');
      return;
    }

    var original = File(argResults?['original']);
    var modified = File(argResults?['modified']);

    if (!original.existsSync() || !original.path.endsWith('.BIN')) {
      print('Original file does not exist or not a .BIN type.');
      return;
    }

    if (!modified.existsSync() || !modified.path.endsWith('.txt')) {
      print('Modified file does not exist or not a .txt type.');
      return;
    }

    var modifiedLine = readFileAsHexString(modified);
    var originalLine = getReadableLines(readFileAsHexString(original));
    var result = compareEdit(replaceSequences(originalLine), modifiedLine);

    if (result.success) {
      if (result.changedLines == 0) {
        print('No lines were changed.');
        return;
      }

      var lines = getUnreadableLines(readFileAsHexString(original));
      var replacedLines = replaceSequences(modifiedLine, extract: false);
      writeToFile(original, '$lines $replacedLines');
      print('Done successfully. Total lines replaced: ${result.changedLines}.');
    } else {
      print('Error while trying to replace modified text:');

      for (var s in result.messages) {
        print(' - $s');
      }
    }
  }
}
