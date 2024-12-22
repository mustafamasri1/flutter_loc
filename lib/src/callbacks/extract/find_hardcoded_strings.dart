import 'package:darted_cli/io_helper.dart';
import 'package:flutter_loc/src/models/loc_match.model.dart';

Future<Map<String, List<LocMatch>>> findHardcodedStrings(String wd, {List<RegExp>? filesToExclude}) async {
  Map<String, List<LocMatch>> ret = {};

  // Search the directory for the hard-coded strings (Strings include their quotation marks!)
  Map<String, List<(int, String, Map<int, String>)>> searchResult = await IOHelper.file.search(
    wd,
    RegExp(
        r'"""[\s\S]*?"""|' // Match triple double-quoted strings, including multiline
        r"'''[\s\S]*?'''|" // Match triple single-quoted strings, including multiline
        r"'(?:\\.|[^'\\])*'|" // Match single-quoted strings
        r'"(?:\\.|[^"\\])*"', // Match double-quoted strings
        dotAll: true // Ensure dot matches newlines
        ),
    excluded: [RegExp('commands_tree.dart'), RegExp('flutter_loc.txt')],
    allowed: [RegExp(r'.*\.dart$')],
  );

  // Convert the matches to a map of <File path, LocMatch>
  ret = Map.fromEntries(searchResult.entries.map((entry) => MapEntry(entry.key, entry.value.map((v) => LocMatch(linePosition: v.$1, lineContent: v.$2, matchesInLine: v.$3)).toList())));
  print("${ret.entries.first.value[4]}");
  return ret;
}
