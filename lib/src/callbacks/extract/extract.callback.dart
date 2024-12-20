import 'package:darted_cli/console_helper.dart';
import 'package:darted_cli/io_helper.dart';
import 'package:flutter_loc/src/callbacks/extract/find_hardcoded_strings.dart';
import 'package:flutter_loc/src/callbacks/extract/refine_finds.dart';
import 'package:flutter_loc/src/callbacks/extract/validators/directory_supplied.dart';
import 'package:flutter_loc/src/models/loc_match.model.dart';

Future<void> extractCallback(Map<String, dynamic>? args, Map<String, bool>? flags) async {
  // Make sure i have the required arguments.
  validateDirectorySupplied(args);

  // Parse the arguments i need.
  String sourceDirectoryArg = args!['directory'] ?? args['d'];
  String? outputDirectoryArg = args['output'] ?? args['o'];
  bool isDryRun = flags?['dry-run'] ?? flags?['dr'] ?? false;
  bool isOverwrite = flags?['overwrite'] ?? flags?['ow'] ?? false;

  // Define the directories
  Directory sourceDirectory = Directory(sourceDirectoryArg);
  Directory? outputDirectory = outputDirectoryArg != null ? Directory(outputDirectoryArg) : null;

  // Change into that directory
  await IOHelper.directory.change(sourceDirectory.path);

  // Get the new pwd
  String wd = IOHelper.directory.getCurrent();

  // Finds
  Map<String, List<LocMatch>> finds = {};

  // Find all the hardcoded strings...
  await ConsoleHelper.loadWithTask(
    task: 'Searching files for hardcoded strings...',
    process: () => findHardcodedStrings(wd).then((v) => finds = v),
  );

  // Refinements on the search results...
  await ConsoleHelper.loadWithTask(
    task: 'Doing refinements on the extracted lines...',
    process: () => refineFinds(finds),
  );

  // Combine the refined data into a string...
  String hardcodedStrings = finds.entries
          .map((map) => map.value.isNotEmpty
              ? "##PATH\n(file://${map.key})\n#\n${map.value.map((e) => "[${e.$1}] ${RegExp('["\'](.*?)["\']').hasMatch(e.$2) ? RegExp('["\'](.*?)["\']').firstMatch(e.$2)?.group(0) : 'N/A'} => '';").toList().reduceIfNotEmpty((aa, bb) => "$aa\n$bb") ?? []}"
              : '')
          .toList()
          .reduceIfNotEmpty(
            (p1, p2) => p1.trim().isEmpty
                ? '\n\n$p2'
                : p2.trim().isEmpty
                    ? "$p1\n"
                    : "$p1\n#\n#!PATH\n\n$p2",
          ) ??
      '';

  // Export the refined data to an external file...
  File outputFile = File('flutter_loc.txt');
  await ConsoleHelper.loadWithTask(
    task: 'Generating flutter_loc file...',
    process: () => outputFile.writeAsString(hardcodedStrings),
  );
}

extension ListExtension<E> on List<E>? {
  E? reduceIfNotEmpty(E Function(E a, E b) condition) {
    return this == null || this!.isEmpty ? null : this!.reduce((aa, bb) => condition(aa, bb));
  }
}
