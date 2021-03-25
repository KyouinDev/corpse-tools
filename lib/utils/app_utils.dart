import '../app_def.dart';
import '../entities/compare_result.dart';
import '../entities/replacement.dart';
import '../utils.dart';

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
    return CompareResult(
      success: false,
      messages: ['Number of lines does not match.'],
      changedLines: 0,
    );
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

      if (c1 != c2) {
        messages.add('Line ${i + 1}: found ${c1 > c2 ? 'less' : 'more'}'
            ' $name than expected');
        success = false;
      }
    }

    if (originalLine != modifiedLine) changedLines++;
  }

  return CompareResult(
    success: success,
    messages: messages,
    changedLines: changedLines,
  );
}

extension SequenceCount on String {
  int count(Pattern pattern) => split(pattern).length - 1;
}
