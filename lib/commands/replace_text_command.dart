import 'package:args/command_runner.dart';
import 'package:corpse_tools/entities/elapsed_time.dart';
import 'package:corpse_tools/utils.dart';

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
    var original = getFileFromArg(
      arg: argResults!['original'],
      command: 'replace-text',
      expected: '.BIN',
    );
    if (original == null) return;

    var modified = getFileFromArg(
      arg: argResults!['modified'],
      command: 'replace-text',
      expected: '.txt',
    );
    if (modified == null) return;

    var time = ElapsedTime();
    var modifContent = readFileAsHexString(modified);
    var origHexString = readFileAsHexString(original);
    var origContent = getReadableContent(origHexString);
    var result = compareEdit(replaceSequences(origContent), modifContent);
    if (!result.success) {
      print('Error while trying to replace modified text:');
      printError(s) => print(' - $s'); //aux function
      result.messages.forEach(printError);
      return;
    }
    if (result.changedLines == 0) {
      print('No lines were changed.');
      time.end();
      return;
    }

    var unreadable = getUnreadableContent(origHexString);
    var modifReplacedContent = replaceSequences(modifContent, extract: false);
    writeToFile(original, '$unreadable $modifReplacedContent');
    print('Done successfully. Total lines replaced: ${result.changedLines}.');
    time.end();
  }
}
