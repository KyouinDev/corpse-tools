import 'package:corpse_tools/entities/compare_result.dart';
import 'package:corpse_tools/utils.dart';

final replacements = {
  "00": "0A", // new line
  "81 79": "5B 6E 61 6D 65 5D", // name
  "81 7A": "5B 74 65 78 74 5D", // text
  "25 4E": "5B 62 72 65 61 6B 5D", // break
  "25 4B 25 50": "5B 65 6E 64 5D", // end
  "25 4B 25 70": "5B 63 68 6F 69 63 65 5D", // choice
};

final skipComparison = [
  "0A", // new line
  "5B 62 72 65 61 6B 5D", // break
];

String getUnreadableContent(String hex) {
  return hex.substring(0, hex.lastIndexOf('02') + 2);
}

String getReadableContent(String hex) {
  return hex.substring(hex.lastIndexOf('02') + 3);
}

String replaceSequences(String hex, {bool extract = true}) {
  for (var key in replacements.keys) {
    hex = extract
        ? hex.replaceAll(key, replacements[key]!)
        : hex.replaceAll(replacements[key]!, key);
  }

  return hex;
}

int compareLine(String originalLine, String modifiedLine, String sequence) {
  return originalLine.count(sequence) - modifiedLine.count(sequence);
}

CompareResult compareEdit(String original, String modified) {
  var separator = replacements.values.first;
  var originalLines = original.split(separator);
  var modifiedLines = modified.split(separator);
  if (originalLines.length != modifiedLines.length) {
    return CompareResult(
      success: false,
      messages: ['Number of lines does not match.'],
      changedLines: 0,
    );
  }

  var success = true;
  var messages = <String>[];
  var changedLines = 0;
  for (var i = 0; i < originalLines.length; i++) {
    var originalLine = originalLines[i];
    var modifiedLine = modifiedLines[i];
    for (var toSkip in skipComparison) {
      originalLine = originalLine.replaceAll(toSkip, '');
      modifiedLine = modifiedLine.replaceAll(toSkip, '');
    }

    var notSkip = replacements.entries
        .where((entry) => !skipComparison.contains(entry.value))
        .map((entry) => entry.value);
    for (var replacement in notSkip) {
      var compare = compareLine(originalLine, modifiedLine, replacement);
      if (compare != 0) {
        var name = String.fromCharCodes(hexStringToIntList(replacement));
        messages.add(
          'Line ${i + 1}: found ${compare > 0 ? 'less' : 'more'}'
          ' $name than expected',
        );
        success = false;
      }
    }

    if (originalLine != modifiedLine) {
      changedLines++;
    }
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
