import 'package:darted_cli/io_helper.dart';

import '../../models/loc_match.model.dart';
import '../shared/list_extension.dart';

/// Generate the visited file log file.
Future<void> generateVisitLog(String sourcingDirectory, Map<String, List<LocMatch>> findResults, String generationDirectory, {List<RegExp>? filesToExclude, List<String>? extensionsToInclude}) async {
  Map<String, int> visitMap = {};
  // List of all the files visited.
  List<File> filesVisited = await IOHelper.file.listAll(
    sourcingDirectory,
    includeHidden: false,
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

  // Convert files visited to a map of the name and how many matches it has.
  for (var file in filesVisited) {
    print('List is ${findResults.keys.toList()} and now i have ${file.absolute.path}');
    if (findResults.keys.toList().contains(file.absolute.path.replaceAll('/./', '/').replaceAll('\\.\\', '\\'))) {
      visitMap.addEntries([
        MapEntry(file.uri.pathSegments.last,
            findResults[file.absolute.path.replaceAll('/./', '/').replaceAll('\\.\\', '\\')]!.map((a) => a.matchesInLine.length).toList().reduceIfNotEmpty((aa, bb) => aa + bb) ?? 0)
      ]);
    }
  }

  // Generate the output directory if doesn't exist.
  if (!await IOHelper.directory.exists(generationDirectory)) {
    await IOHelper.directory.create(generationDirectory);
  }

  // Generate the visits file.
  await IOHelper.file.writeString(
      "$generationDirectory/visit_log.txt", visitMap.entries.map((entry) => "${entry.key}  ===>  (${entry.value} matches)").toList().reduceIfNotEmpty((a, b) => "$a\n$b") ?? 'No Matches!');
}
