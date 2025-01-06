import 'package:darted_cli/io_helper.dart';

import '../../../models/loc_replacement.model.dart';
import '../../shared/clean_content.dart';
import '../../shared/clear_path_trails.dart';

/// Replace the hard-coded strings with the provided l10n keys.
Future<Map<String, String>> replaceFileContent(
    Map<String, List<LocReplacement>> parsedReplacementMap,
    {String? valueShifter,
    String? importingLine}) async {
  Map<String, String> redefinedMap = {};
  // Loop through the replacement file pathes
  await Future.forEach(parsedReplacementMap.entries,
      (parsedReplacementFileEntry) async {
    // Open the file's path
    final File file =
        File.fromUri(Uri(path: parsedReplacementFileEntry.key.clearPathTrails));
    final String fileContent = await file.readAsString();

    // Create a mutable copy of the file content
    String newFileContent = fileContent;

    // Loop through the different replacements to do in that file.
    await Future.forEach(parsedReplacementFileEntry.value,
        (replacementToDo) async {
      // Loop through the positional replacements.
      await Future.forEach(replacementToDo.matchesInLine.entries,
          (positionedReplacement) async {
        String iNeedToReplace = positionedReplacement.value.$1;
        String replaceItWith = positionedReplacement.value.$2;
        //
        if (!_isContentEmpty(replaceItWith.trim())) {
          RegExp matchPattern = RegExp(
              RegExp.escape(_normalizeWhitespace(iNeedToReplace)),
              dotAll: true);
          String fileContentPattern = _normalizeWhitespace(newFileContent);
          //
          final match = matchPattern.firstMatch(fileContentPattern);
          if (match != null && match.group(0) != null) {
            redefinedMap.addEntries([MapEntry(iNeedToReplace, replaceItWith)]);
            newFileContent = fileContentPattern.replaceFirst(matchPattern,
                "${shiftValue(replaceItWith.trim(), valueShifter)}");
          }
        }
      });

      // Update the file.
      if (fileContent != newFileContent) {
        await file.writeAsString(
            (importingLine != null ? "$importingLine\n" : '') + newFileContent);
      }
    });
  });
  return redefinedMap;
}

/// shift the Value's shape based on a valueShifter
String shiftValue(String text, String? valueShifter) {
  if (valueShifter == null || !valueShifter.contains('**V**')) return text;
  return valueShifter.replaceAll('**V**', text);
}

/// Normalize the input's white space.
String _normalizeWhitespace(String input) {
  return input.replaceAll(RegExp(r'\r\n?'), '\n').trim();
}

/// Check if the content is empty or not.
bool _isContentEmpty(String content) {
  String cleanedContent = (cleanContent(content)).trim();
  return cleanedContent.isEmpty ||
      cleanedContent == "" ||
      cleanedContent == '""' ||
      cleanedContent == "''";
}
