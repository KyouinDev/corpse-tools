import 'dart:io';

import 'package:corpse_tools/utils.dart';

String readFileAsHexString(File file) {
  var bytes = file.readAsBytesSync();
  return intListToHexString(bytes);
}

void writeToFile(File file, String hexCodes) {
  var bytes = hexStringToIntList(hexCodes);
  file.writeAsBytesSync(bytes);
}
