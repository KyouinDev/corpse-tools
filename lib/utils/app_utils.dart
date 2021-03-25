import '../app_def.dart';
import '../entities/compare_result.dart';
import '../utils.dart';

String getUnreadableContent(String hex) {
  return hex.substring(0, hex.lastIndexOf('02') + 2);
}

String getReadableContent(String hex) {
  return hex.substring(hex.lastIndexOf('02') + 3);
}

String replaceSequences(String hex, {bool extract = true}) {
  for (var replacement in AppDef().replacements.entries) {
    if (extract) {
      hex = hex.replaceAll(replacement.key, replacement.value);
    } else {
      hex = hex.replaceAll(replacement.value, replacement.key);
    }
  }

  return hex;
}

int compareLine(String origLine, String modifLine, String sequence) {
  return origLine.count(sequence) - modifLine.count(sequence);
}

CompareResult compareEdit(String original, String modified) {
  var separator = AppDef().replacements.values.first;
  var origLines = original.split(separator);
  var modifLines = modified.split(separator);

  if (origLines.length != modifLines.length) {
    return CompareResult(
      success: false,
      messages: ['Number of lines does not match.'],
      changedLines: 0,
    );
  }

  var messages = <String>[];
  var changedLines = 0;
  var success = true;

  for (var i = 0; i < origLines.length; i++) {
    var origLine = origLines[i];
    var modifLine = modifLines[i];

    for (var toSkip in AppDef().skipComparison) {
      origLine = origLine.replaceAll(toSkip, '');
      modifLine = modifLine.replaceAll(toSkip, '');
    }

    var replacements = AppDef().replacements.entries.where((entry) {
      return !AppDef().skipComparison.contains(entry.value);
    }).map((entry) => entry.value);

    for (var replacement in replacements) {
      var compare = compareLine(origLine, modifLine, replacement);
      var name = String.fromCharCodes(hexStringToIntList(replacement));

      if (compare != 0) {
        messages.add('Line ${i + 1}: found ${compare > 0 ? 'less' : 'more'}'
            ' $name than expected');
        success = false;
      }
    }

    if (origLine != modifLine) changedLines++;
  }

  return CompareResult(
    success: success,
    messages: messages,
    changedLines: changedLines,
  );
}

void printElapsedTime(DateTime from) {
  var elapsed = DateTime.now().difference(from);
  print('Elapsed time: ${elapsed.inMilliseconds} ms.');
}

extension SequenceCount on String {
  int count(Pattern pattern) => split(pattern).length - 1;
}
