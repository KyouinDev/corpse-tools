import 'package:args/command_runner.dart';
import 'package:corpse_tools/commands.dart';

void main(List<String> args) async {
  var desc = 'Corpse Tools v0.1.5 made by Kyouin '
      '(https://github.com/KyouinDev/corpse-tools)\n'
      'Supported games:\n'
      ' - Corpse Party: Book of Shadows (2018, PC)\n'
      ' - Corpse Party: Sweet Sachiko\'s Hysteric Birthday Bash (2019, PC)';
  var runner = CommandRunner('corpse_tools.exe', desc)
    ..addCommand(ExtractTextCommand())
    ..addCommand(ReplaceTextCommand());

  try {
    await runner.run(args);
  } on UsageException catch (e) {
    print(e);
  } on Exception catch (e, s) {
    print('Unknown $e\n$s\nPlease report this to the developer.');
  }
}
