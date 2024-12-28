import 'package:darted_cli/io_helper.dart';
import '../../models/loc_match.model.dart';

/// Find hard-coded strings in the supplied directory.
Future<Map<String, List<LocMatch>>> findHardcodedStrings({List<RegExp>? filesToExclude, List<String>? extensionsToInclude}) async {
  Map<String, List<LocMatch>> ret = {};
  String currentWD = IOHelper.directory.getCurrent();
  // Break down the RegExp into smaller, more manageable parts
  final String tripleDoubleQuoted = r'"""(?:(?!""")[\s\S])*?"""'; // Non-greedy triple double-quoted strings
  final String tripleSingleQuoted = r"'''(?:(?!''')[\s\S])*?'''"; // Non-greedy triple single-quoted strings
  final String doubleQuoted = r'"[^"\\\r\n]*(?:\\.[^"\\\r\n]*)*"'; // Double-quoted strings
  final String singleQuoted = r"'[^'\\\r\n]*(?:\\.[^'\\\r\n]*)*'"; // Single-quoted strings

// Combine patterns with alternation
  final RegExp stringPattern = RegExp(
    '$tripleDoubleQuoted|$tripleSingleQuoted|$doubleQuoted|$singleQuoted',
    multiLine: true,
    dotAll: true,
  );

  // Search the directory for the hard-coded strings (Strings include their quotation marks!)
  Map<String, List<(int, String, Map<int, String>)>> searchResult = await IOHelper.file.search(
    currentWD,
    stringPattern,
    ignoreHidden: true,
    excluded: [
      RegExp('commands_tree.dart'),
      RegExp('flutter_loc.txt'),
      RegExp('visits_analysis.txt'),
      RegExp('custom_refinement_logic.dart'),
      ...?filesToExclude,
    ],
    allowed: [
      RegExp(r'.*\.dart$'),
      ...?extensionsToInclude?.map((p) => RegExp(r'.*' '${RegExp.escape(p)}' r'$')),
    ],
  );
  // Convert the matches to a map of <File path, LocMatch>
  ret = Map.fromEntries(searchResult.entries
      .map((entry) => MapEntry(Uri.directory(Directory(entry.key).absolute.path).path, entry.value.map((v) => LocMatch(linePosition: v.$1, lineContent: v.$2, matchesInLine: v.$3)).toList())));
  return ret;
}
