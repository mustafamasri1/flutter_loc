/* Flutter Localization Tool | Custom Refinement Logic File
This file is divided into two sections: Extraction and Replacement.
Modify this file and reference it in the config file to add custom roles of extraction refinements.
Developed & Maintained by @Micazi
*/
import 'package:flutter_loc/flutter_loc.dart';

void main(List<String> args, SendPort sendPort) => CustomRefinementHelper.entry(
    sendPort,
    (filePath, lineContent, matchedString) => refineExtraction(
          filePath,
          lineContent,
          matchedString,
        ));

/// This function is called for each found hard-coded string.
///
/// - `filePath`: The file where the string was found.
/// - `lineContent`: The content of the entire line from which the match was found.
/// - `matchedString`: The hard-coded string found in the source code.
///
/// Return `true` to extract the string, or `false` to skip it.
bool refineExtraction(
    String filePath, String lineContent, String matchedString) {
  // Example: Skip extracting strings found in test files.
  if (filePath.contains('/test/')) return false;

  // Example: Skip strings shorter than 5 characters.
  if (matchedString.length < 5) return false;

  // Example: Skip specific strings.
  if (matchedString == 'DEBUG') return false;

  // Example: Skip specific lines.
  if (lineContent.startsWith('import')) return false;

  // Example: Skip prints & debugPrints.
  if (lineContent.contains("print($matchedString)") ||
      lineContent.contains("debugPrint($matchedString)")) return false;

  // Otherwise, extract the string.
  return true;
}
