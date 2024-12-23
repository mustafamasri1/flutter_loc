import 'dart:io';
import 'package:darted_cli/console_helper.dart';
import 'validators/loc_file_supplied.dart';
import '../../models/loc_replacement.model.dart';

import 'generate_lang_files.dart';
import 'parse_content.dart';
import 'replace_content.dart';

Future<void> replaceCallback(
    Map<String, dynamic>? args, Map<String, bool>? flags) async {
  File flutterLocFile = File(args?['path'] ?? args?['p'] ?? 'flutter_loc.txt');

  // Make sure i have the required arguments.
  await validateLocFileSupplied(flutterLocFile);

  // Get the content of the file...
  String fileData = '';
  await ConsoleHelper.loadWithTask(
    task: 'Reading flutter_loc file...',
    process: () => flutterLocFile.readAsString().then((v) => fileData = v),
  );

  // Parse the file data to a map.
  Map<String, List<LocReplacement>> parsedReplacementMap = {};
  await ConsoleHelper.loadWithTask(
    task: 'Parsing file content...',
    process: () async =>
        await parseFileContent(fileData).then((v) => parsedReplacementMap = v),
  );

  // Replace all the parsed data.
  Map<String, String> redefinedMap = {};
  await ConsoleHelper.loadWithTask(
    task: 'Replacing the hard-coded strings with the provided replacements...',
    process: () async => await replaceFileContent(parsedReplacementMap)
        .then((v) => redefinedMap = v),
  );

  // Get the desired language files.
  List<String> langs =
      (args?['languages'] ?? args?['l'])?.toString().split(',') ?? ['en'];
  String mainLang = (args?['main-language'] ?? args?['m']) ?? 'en';

  // Generate the l10n files
  await ConsoleHelper.loadWithTask(
    task: 'Generating l10n files...',
    process: () async => await generateLangFiles(
        flutterLocFile.parent.path, redefinedMap, langs, mainLang),
  );

  flutterLocFile.writeAsString(
      "\n\n\n======== DONE with the replacements! at ${DateTime.now().toLocal().toIso8601String()} ========",
      mode: FileMode.append);
}
