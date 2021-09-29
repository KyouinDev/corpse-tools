import 'dart:io';

import 'package:corpse_tools/utils.dart';

File? getFileFromArg({
  required dynamic arg,
  required String command,
  required String expected,
}) {
  if (arg == null) {
    print('Missing parameters. Run "corpse_tools.exe help $command" for info.');
    return null;
  }

  var file = File(arg);
  if (!file.existsSync() || !file.path.endsWith(expected)) {
    print('Input file does not exist or not a $expected type.');
    return null;
  }

  return file;
}

String readFileAsHexString(File file) {
  var bytes = file.readAsBytesSync();
  return intListToHexString(bytes);
}

void writeToFile(File file, String hexCodes) {
  var bytes = hexStringToIntList(hexCodes);
  file.writeAsBytesSync(bytes);
}
