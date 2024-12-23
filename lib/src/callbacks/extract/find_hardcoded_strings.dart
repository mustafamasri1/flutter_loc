import 'package:darted_cli/io_helper.dart';
import 'package:flutter_loc/src/models/loc_match.model.dart';

Future<Map<String, List<LocMatch>>> findHardcodedStrings(String wd, {List<RegExp>? filesToExclude}) async {
  Map<String, List<LocMatch>> ret = {};

  // Search the directory for the hard-coded strings (Strings include their quotation marks!)
  Map<String, List<(int, String, Map<int, String>)>> searchResult = await IOHelper.file.search(
    wd,
    // RegExp(
    //     r'"""[\s\S]*?"""|' // Match triple double-quoted strings, including multiline
    //     r"'''[\s\S]*?'''|" // Match triple single-quoted strings, including multiline
    //     r"'(?:\\.|[^'\\])*'|" // Match single-quoted strings
    //     r'"(?:\\.|[^"\\])*"', // Match double-quoted strings
    //     dotAll: true // Ensure dot matches newlines
    //     ),
    // RegExp(
    //   r'"""[\s\S]*?"""|' // Match triple double-quoted strings, including multiline
    //   r"'''[\s\S]*?'''" // Match triple single-quoted strings, including multiline
    //   r"\'(?:\\.|[^\'\\])*\'|" // Match single-quoted strings, allowing escape sequences
    //   r'"(?:\\.|[^"\\])*"', // Match double-quoted strings, allowing escape sequences
    //   dotAll: true, // Ensure dot matches newlines
    // ),
    // RegExp(
    //     r'"""(?!.*""$)[\s\S]*?"""|' // Match triple double-quoted strings, including multiline
    //     r"'''(?!.*''$)[\s\S]*?'''|" // Match triple single-quoted strings, including multiline
    //     r"'(?!\\.)(?:\\.|[^'\\])*'|" // Match single-quoted strings, excluding escaped quotes
    //     r'"(?!\\.)(?:\\.|[^"\\])*"', // Match double-quoted strings, excluding escaped quotes
    //     dotAll: true // Ensure dot matches newlines
    //     ),
    RegExp(
        r'"""(?!.*""$)[\s\S]*?"""|' // Match triple double-quoted strings, including multiline
        r"'''(?!.*''$)[\s\S]*?'''|" // Match triple single-quoted strings, including multiline
        r"'(?!(?<!\\)\\.)(?:\\.|[^'\\])*'|" // Match single-quoted strings, excluding escaped quotes
        r'"(?!(?<!\\)\\.)(?:\\.|[^"\\])*"', // Match double-quoted strings, excluding escaped quotes
        dotAll: true // Ensure dot matches newlines
        ),
    excluded: [RegExp('commands_tree.dart'), RegExp('flutter_loc.txt')],
    allowed: [RegExp(r'.*\.dart$')],
  );

  // Convert the matches to a map of <File path, LocMatch>
  ret = Map.fromEntries(searchResult.entries.map((entry) => MapEntry(entry.key, entry.value.map((v) => LocMatch(linePosition: v.$1, lineContent: v.$2, matchesInLine: v.$3)).toList())));
  return ret;
}

// Future<Map<String, List<(int matchLine, String lineContent, Map<int, String> matchPositions)>>> searchFilesContents(
//   String rootPath,
//   RegExp query, {
//   bool ignoreHidden = true,
//   List<RegExp>? excluded,
//   List<RegExp>? only,
//   String? replacement,
// }) async {
//   List<String> fileNamesGotten = [];
//   final matches = <String, List<(int matchLine, String lineContent, Map<int, String> matchPositions)>>{};
//   final dir = Directory(rootPath);

//   if (await IOHelper.directory.exists(rootPath)) {
//     await for (final entity in dir.list(recursive: true, followLinks: true)) {
//       final name = entity.uri.pathSegments.last;

//       // Check if the entity should be excluded based on RegExp patterns
//       if (excluded != null && excluded.isNotEmpty && excluded.any((pattern) => pattern.hasMatch(name))) {
//         continue;
//       }

//       // Check if the entity is allowed by "only" patterns
//       if (only != null && only.isNotEmpty && only.every((pattern) => !pattern.hasMatch(name))) {
//         continue;
//       }

//       if (entity is File && (!ignoreHidden || !name.startsWith('.'))) {
//         fileNamesGotten.add(entity.uri.pathSegments.last);
//         try {
//           // Read the entire file as a single string
//           final content = await entity.readAsString();
//           if (entity.uri.pathSegments.last == 'doctors_filter.screen.dart') {
//             final ms =    RegExp(
//       r'"""[\s\S]*?"""|' // Match triple double-quoted strings, including multiline
//       r"'''[\s\S]*?'''" // Match triple single-quoted strings, including multiline
//       r"\'(?:\\.|[^\'\\])*\'|" // Match single-quoted strings, allowing escape sequences
//       r'"(?:\\.|[^"\\])*"', // Match double-quoted strings, allowing escape sequences
//       dotAll: true, // Ensure dot matches newlines
//     ),.allMatches(content);
//             print('matches: $ms');
//           }
//           // Match the regex against the original content
//           final matchesInFile = query.allMatches(content);
//           final lineMatches = <int, (String lineContent, Map<int, String> matchPositions)>{};

//           for (final match in matchesInFile) {
//             final matchedText = match.group(0)!;

//             // Determine the line number and match position
//             final matchStart = match.start;
//             final lineNumber = content.substring(0, matchStart).split('\n').length;

//             // Calculate the start and end indices of the line in the full content
//             final lineStartIndex = content.lastIndexOf('\n', matchStart - 1) + 1;
//             final lineEndIndex = content.indexOf('\n', lineStartIndex);
//             final lineContent = content.substring(
//               lineStartIndex,
//               lineEndIndex == -1 ? content.length : lineEndIndex,
//             );

//             // Calculate the match position relative to the full line content
//             final relativePosition = matchStart - lineStartIndex;

//             // If the line already exists, merge matches
//             if (lineMatches.containsKey(lineNumber)) {
//               lineMatches[lineNumber]?.$2[relativePosition] = matchedText;
//             } else {
//               lineMatches[lineNumber] = (lineContent, {relativePosition: matchedText});
//             }
//           }

//           // Add all matches from this file to the final result
//           lineMatches.forEach((lineNumber, matchData) {
//             matches.putIfAbsent(entity.path, () => []).add((lineNumber, matchData.$1, matchData.$2));
//           });

//           // Handle replacement if specified
//           if (replacement != null) {
//             final updatedContent = content.replaceAll(query, replacement);

//             // Write updated content back to the file only if changes were made
//             if (updatedContent != content) {
//               await entity.writeAsString(updatedContent);
//             }
//           }
//         } catch (e) {
//           // Handle non-UTF-8 files or other exceptions as needed
//         }
//       }
//     }
//     await IOHelper.file.writeString('./files_visited.txt', "${fileNamesGotten.map((i) => "$i\n").toList()}");
//     print('i have gotten ${fileNamesGotten.map((i) => "$i\n")} files.');
//   } else {
//     throw DirectoryDoesntExist(path: rootPath);
//   }

//   return matches;
// }

// Future<int> countFilesMatchingPattern(String rootPath, RegExp fileNamePattern) async {
//   int count = 0;

//   // Ensure the root directory exists
//   final rootDir = Directory(rootPath);
//   if (!await rootDir.exists()) {
//     throw Exception('The directory does not exist: $rootPath');
//   }

//   // Recursively iterate through the directory
//   await for (var entity in rootDir.list(recursive: true, followLinks: false)) {
//     if (entity is File) {
//       final fileName = entity.uri.pathSegments.last;
//       if (fileNamePattern.hasMatch(fileName)) {
//         count++;
//       }
//     }
//   }

//   return count;
// }

// String normalizeWhitespace(String input) {
//   return input.replaceAll(RegExp(r'\r\n?'), '\n').trim();
// }
