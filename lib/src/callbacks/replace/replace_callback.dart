import 'dart:convert';
import 'package:darted_cli/console_helper.dart';
import 'package:darted_cli/io_helper.dart';
import 'package:flutter_loc/src/callbacks/replace/validators/loc_file_supplied.dart';
import 'package:flutter_loc/src/models/loc_replacement.model.dart';

import '../../models/loc_match.model.dart';
import 'parse_content.dart';
import 'replace_content.dart';

Future<void> replaceCallback(Map<String, dynamic>? args, Map<String, bool>? flags) async {
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
    process: () async => await parseFileContent(fileData).then((v) => parsedReplacementMap = v),
  );

  // Replace all the parsed data.
  await ConsoleHelper.loadWithTask(
    task: 'Replacing the hard-coded strings with the provided replacements...',
    process: () async => await replaceFileContent(parsedReplacementMap),
  );

  // Get the desired language files.
  // List<String> langs = (args?['languages'] ?? args?['l'])?.toString().split(',') ?? ['en'];
  // String mainLang = (args?['main-language'] ?? args?['m']) ?? 'en';

  // Generate the l10n files
  // await ConsoleHelper.loadWithTask(
  //   task: 'Generating l10n files...',
  //   process: () async => await generateLangFiles(flutterLocFile.parent.path, parsedMap, langs, mainLang),
  // );

  // flutterLocFile.writeAsString("\n\n\n======== DONE with the replacements! ========", mode: FileMode.append);
}

generateLangFiles(
  String path,
  Map<String, List<(int, String, String)>> parsedMap,
  List<String> langs,
  String mainLang,
) async {
  //Create the directory
  Directory d = await IOHelper.directory.create("$path/l10n");

  await Future.forEach(langs, (lang) async {
    // Create the files
    File langFile = await IOHelper.file.create("${d.path}/$lang.json");

    Map<String, dynamic> jsonMap = Map.fromEntries(parsedMap.values.reduce((a, b) => [...a, ...b]).toList().map((l) => MapEntry(l.$3.trim(), lang == mainLang ? l.$2.trim() : '')));

    // Write the data to the files...
    await langFile.writeAsString(jsonEncode(jsonMap));
  });
}
