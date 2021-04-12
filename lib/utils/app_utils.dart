import '../entities/compare_result.dart';
import '../utils.dart';

Map<String, String> replacements = {
  "00": "0A",
  "81 79": "5B 6E 61 6D 65 5D",
  "81 7A": "5B 74 65 78 74 5D",
  "25 4E": "5B 62 72 65 61 6B 5D",
  "25 4B 25 50": "5B 65 6E 64 5D",
  "25 4B 25 70": "5B 63 68 6F 69 63 65 5D",
};

List<String> skipComparison = [
  "0A",
  "5B 62 72 65 61 6B 5D",
];

String getUnreadableContent(String hex) {
  return hex.substring(0, hex.lastIndexOf('02') + 2);
}

String getReadableContent(String hex) {
  return hex.substring(hex.lastIndexOf('02') + 3);
}

String replaceSequences(String hex, {bool extract = true}) {
  for (var replacement in replacements.entries) {
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
  var separator = replacements.values.first;
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

    for (var toSkip in skipComparison) {
      origLine = origLine.replaceAll(toSkip, '');
      modifLine = modifLine.replaceAll(toSkip, '');
    }

    var notSkip = replacements.entries.where((entry) {
      return !skipComparison.contains(entry.value);
    }).map((entry) => entry.value);

    for (var replacement in notSkip) {
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
