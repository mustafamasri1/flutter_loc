import 'package:darted_cli/io_helper.dart';

import '../../models/loc_replacement.model.dart';

/// Replace the hard-coded strings with the provided l10n keys.
Future<Map<String, String>> replaceFileContent(
    Map<String, List<LocReplacement>> parsedReplacementMap,
    {String? replacementSuffix}) async {
  Map<String, String> redefinedMap = {};
  // Loop through the replacement file pathes
  await Future.forEach(parsedReplacementMap.entries,
      (parsedReplacementFileEntry) async {
    // Open the file's path
    final File file = File(parsedReplacementFileEntry.key);
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
        if (!isContentEmpty(replaceItWith.trim())) {
          RegExp matchPattern = RegExp(
              RegExp.escape(normalizeWhitespace(iNeedToReplace)),
              dotAll: true);
          String fileContentPattern = normalizeWhitespace(newFileContent);
          //
          final match = matchPattern.firstMatch(fileContentPattern);
          if (match != null && match.group(0) != null) {
            redefinedMap.addEntries([MapEntry(iNeedToReplace, replaceItWith)]);
            newFileContent = fileContentPattern.replaceFirst(
                matchPattern, "${replaceItWith.trim()}$replacementSuffix");
          }
        }
      });

      // Update the file.
      if (fileContent != newFileContent) {
        await file.writeAsString(newFileContent);
      }
    });
  });
  return redefinedMap;
}

/// Normalize the input's white space.
String normalizeWhitespace(String input) {
  return input.replaceAll(RegExp(r'\r\n?'), '\n').trim();
}

/// Check if the content is empty or not.
bool isContentEmpty(String content) {
  String cleanedContent = content;

  // Return true if the content itself is empty.
  if (content.isEmpty) return true;

  // Step 1: Identify quote type (single, double, or triple)
  String? quoteType = RegExp(r'''^(['"]{1,3})''').firstMatch(content)?.group(1);

  if (quoteType != null) {
    // Ensure the content has matching opening and closing quotes
    if (content.length >= quoteType.length * 2 && content.endsWith(quoteType)) {
      // Step 3: Remove only the matching quotes
      cleanedContent = content.substring(
          quoteType.length, content.length - quoteType.length);
    }
  }
  // Step 4: Trim and check for empty content
  return cleanedContent.trim().isEmpty ||
      cleanedContent == '""' ||
      cleanedContent == "''" ||
      cleanedContent == "''''''" ||
      cleanedContent == '""""""';
}
