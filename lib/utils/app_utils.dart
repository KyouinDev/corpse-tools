import 'package:corpse_tools/app_def.dart';
import 'package:corpse_tools/entities/compare_result.dart';
import 'package:corpse_tools/utils.dart';

String getUnreadableLines(String hex) {
  return hex.substring(0, hex.lastIndexOf('02') + 2);
}

String getReadableLines(String hex) {
  return hex.substring(hex.lastIndexOf('02') + 3);
}

String replaceSequences(String hex, {bool extract = true}) {
  for (var replacement in AppDef().replacements) {
    if (extract) {
      hex = hex.replaceAll(replacement.pattern, replacement.replaceWith);
    } else {
      hex = hex.replaceAll(replacement.replaceWith, replacement.pattern);
    }
  }

  return hex;
}

CompareResult compareEdit(String original, String modified) {
  var lineSeparator = AppDef().replacements[0].replaceWith;
  var originalLines = original.split(lineSeparator);
  var modifiedLines = modified.split(lineSeparator);

  if (originalLines.length != modifiedLines.length) {
    return CompareResult(false, ['Number of lines does not match.'], 0);
  }

  var messages = <String>[];
  var changedLines = 0;
  var success = true;

  for (var i = 0; i < originalLines.length; i++) {
    var originalLine = originalLines[i];
    var modifiedLine = modifiedLines[i];

    for (var replacement in AppDef().replacements) {
      var entity = replacement.replaceWith;

      if (replacement.skipComparison) {
        originalLine = originalLine.replaceAll(entity, '');
        modifiedLine = modifiedLine.replaceAll(entity, '');
        continue;
      }

      var name = String.fromCharCodes(hexStringToIntList(entity));
      var c1 = originalLine.count(entity);
      var c2 = modifiedLine.count(entity);
      success = c1 == c2 && success;

      if (c1 > c2) {
        messages.add('Line ${i + 1}: found less $name than expected');
      } else if (c2 > c1) {
        messages.add('Line ${i + 1}: found more $name entities than expected');
      }
    }

    if (originalLine != modifiedLine) changedLines++;
  }

  return CompareResult(success, messages, changedLines);
}

extension SequenceCount on String {
  int count(Pattern pattern) {
    return split(pattern).length - 1;
  }
}
