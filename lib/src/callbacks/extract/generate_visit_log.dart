import 'package:darted_cli/io_helper.dart';
import 'package:flutter_loc/src/callbacks/extract/stringify_finds.dart';

import '../../models/loc_match.model.dart';

Future<void> generateVisitLog(String wd, Map<String, List<LocMatch>> findResults) async {
  Map<String, int> visitMap = {};

  // List of all the files visited.
  List<File> filesVisited = await IOHelper.file.listAll(
    wd,
    includeHidden: false,
    excluded: [RegExp('commands_tree.dart'), RegExp('flutter_loc.txt'), RegExp('visited_files.txt')],
    allowed: [RegExp(r'.*\.dart$')],
  );

  // Convert files visited to a map of the name and how many matches it has.
  for (var file in filesVisited) {
    if (findResults.keys.toList().contains(file.path)) {
      visitMap.addEntries([MapEntry(file.uri.pathSegments.last, findResults[file.path]!.map((a) => a.matchesInLine.length).toList().reduceIfNotEmpty((aa, bb) => aa + bb) ?? 0)]);
    }
  }

  // Generate the visits file.
  await IOHelper.file
      .writeString("$wd/visited_files.txt", visitMap.entries.map((entry) => "${entry.key}  ===>  (${entry.value} matches)").toList().reduceIfNotEmpty((a, b) => "$a\n$b") ?? 'No Matches!');
}
