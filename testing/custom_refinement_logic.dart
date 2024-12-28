import 'package:darted_cli/console_helper.dart';
import 'package:flutter_loc/flutter_loc.dart';

void main(List<String> args, SendPort sendPort) => CustomRefinementHelper.entry(
    sendPort,
    (
      filePath,
      lineContent,
      matchedString,
    ) =>
        refineExtraction(filePath, lineContent, matchedString));

/// This function is called for each found hard-coded string.
///
/// - `originalString`: The hard-coded string found in the source code.
/// - `filePath`: The file where the string was found.
/// - `lineNumber`: The line number where the string was found.
///
/// Return `true` to extract the string, or `false` to skip it.
bool refineExtraction(String filePath, String lineContent, String matchedString) {
  // ConsoleHelper.write('Custom matching in: $filePath', newLine: true);
  // Example: Skip extracting strings found in test files.
  if (filePath.contains('/test/')) return false;

  // Example: Skip strings shorter than 5 characters.
  if (matchedString.length < 5) return false;

  // Example: Skip specific strings.
  if (matchedString == 'DEBUG') return false;

  // Example: Skip specific lines.
  if (lineContent.startsWith('import')) return false;

  // Otherwise, extract the string.
  return true;
}
