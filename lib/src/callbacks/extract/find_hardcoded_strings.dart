import 'package:darted_cli/io_helper.dart';
import '../../models/loc_match.model.dart';

/// Find hard-coded strings in the supplied directory.
Future<Map<String, List<LocMatch>>> findHardcodedStrings(String wd,
    {List<RegExp>? filesToExclude}) async {
  Map<String, List<LocMatch>> ret = {};

  // Break down the RegExp into smaller, more manageable parts
  final String tripleDoubleQuoted =
      r'"""[^"]*(?:"[^"]*)*"""'; // Triple double-quoted strings
  final String tripleSingleQuoted =
      r"'''[^']*(?:'[^']*)*'''"; // Triple single-quoted strings
  final String doubleQuoted =
      r'"[^"\\\r\n]*(?:\\.[^"\\\r\n]*)*"'; // Double-quoted strings
  final String singleQuoted =
      r"'[^'\\\r\n]*(?:\\.[^'\\\r\n]*)*'"; // Single-quoted strings

  // Combine patterns with alternation
  final RegExp stringPattern = RegExp(
      '$tripleDoubleQuoted|$tripleSingleQuoted|$doubleQuoted|$singleQuoted',
      multiLine: true,
      dotAll: true);

  // Search the directory for the hard-coded strings (Strings include their quotation marks!)
  Map<String, List<(int, String, Map<int, String>)>> searchResult =
      await IOHelper.file.search(
    wd,
    stringPattern,
    ignoreHidden: true,
    excluded: [
      RegExp('commands_tree.dart'),
      RegExp('flutter_loc.txt'),
      RegExp('visits_analysis.txt')
    ],
    allowed: [RegExp(r'.*\.dart$')],
  );
  // Convert the matches to a map of <File path, LocMatch>
  ret = Map.fromEntries(searchResult.entries.map((entry) => MapEntry(
      entry.key,
      entry.value
          .map((v) => LocMatch(
              linePosition: v.$1, lineContent: v.$2, matchesInLine: v.$3))
          .toList())));
  return ret;
}
