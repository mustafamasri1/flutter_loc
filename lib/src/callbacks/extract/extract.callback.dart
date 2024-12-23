import 'package:darted_cli/console_helper.dart';
import 'package:darted_cli/io_helper.dart';
import 'find_hardcoded_strings.dart';
import 'generate_visit_log.dart';
import 'refine_finds.dart';
import 'stringify_finds.dart';
import 'validators/directory_supplied.dart';
import '../../helpers/error_helper.dart';
import '../../models/loc_match.model.dart';

/// Main callback to extract the hard-coded strings from the supplied directory and dump it to the `flutter_loc.txt` file.
Future<void> extractCallback(
    Map<String, dynamic>? args, Map<String, bool>? flags) async {
  // Make sure i have the required arguments.
  validateDirectorySupplied(args);

  // Parse the arguments i need.
  String sourceDirectoryArg = args!['directory'] ?? args['d'];
  String? outputDirectoryArg = args['output'] ?? args['o'];
  bool isDryRun = flags?['dry-run'] ?? flags?['dr'] ?? false;
  bool isOverwrite = flags?['overwrite'] ?? flags?['ow'] ?? false;
  bool willGenerateVisitLog = flags?['log'] ?? flags?['l'] ?? false;
  bool populatePlaceholders = flags?['populate'] ?? flags?['pop'] ?? false;

  // Define the directories
  Directory sourceDirectory = Directory(sourceDirectoryArg);
  Directory? outputDirectory =
      outputDirectoryArg != null ? Directory(outputDirectoryArg) : null;

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
    process: () => refineFinds(finds).then((v) => finds = v),
  );

  if (willGenerateVisitLog) {
    // Generate the visit log.
    await ConsoleHelper.loadWithTask(
      task: 'Generating the visit log...',
      process: () => generateVisitLog(wd, finds),
    );
  }

  // Combine the refined data into a string...
  String stringifiedFinds = stringifyFinds(finds, populatePlaceholders);

  // Export the refined data to an external file...
  if (!isDryRun) {
    File outputFile = File(
        '${outputDirectory?.path ?? '.'}${Platform.pathSeparator}flutter_loc.txt');
    await ConsoleHelper.loadWithTask(
      task: 'Generating flutter_loc file...',
      process: () async {
        if (!await IOHelper.file.exists(outputFile.path) || isOverwrite) {
          return outputFile.writeAsString(stringifiedFinds);
        } else {
          // Throw an error that the file already exists.
          ErrorHelper.print(
              "The file already exists in the supplied directory. Either change the output directory or use the '--overwrite | -ow' flag");
          ConsoleHelper.exit(1);
        }
      },
    );
  } else {
    // Output dry run statistics.
    ConsoleHelper.write('==== Dry run ===='.withColor(ConsoleColor.cyan),
        newLine: true);
    ConsoleHelper.writeSpace();
    ConsoleHelper.write(
        "Found ${finds.entries.map((a) => a.value).toList().reduce((b, c) => [...b, ...c]).toList().map((d) => d.matchesInLine.entries.toList()).toList().reduce((e, f) => [
                  ...e,
                  ...f
                ]).toList().length} matches in ${finds.entries.length} files."
            .withColor(ConsoleColor.lightWhite),
        newLine: true);
    ConsoleHelper.write(
        "To extract the data into the output file, Run the command without the '--dry-run' flag"
            .withColor(ConsoleColor.grey),
        newLine: true);
    ConsoleHelper.writeSpace();
    ConsoleHelper.write('==== Dry run ===='.withColor(ConsoleColor.cyan),
        newLine: true);
    ConsoleHelper.writeSpace();
    ConsoleHelper.exit(0);
  }
}
