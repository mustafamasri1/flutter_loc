import 'dart:convert';
import 'package:darted_cli/console_helper.dart';
import 'package:darted_cli/io_helper.dart';

replaceCallback(Map<String, dynamic>? args, Map<String, bool>? flags) async {
  // Read the flutter_loc file...
  File flutterLocFile = File(args?['path'] ?? args?['p'] ?? 'flutter_loc.txt');

  // Check file existance...
  if (!await flutterLocFile.exists()) {
    throw FileDoesntExist(path: args?['path'] ?? args?['p'] ?? 'flutter_loc.txt');
  }

  // Get the content of the file...
  String fileData = '';
  await ConsoleHelper.loadWithTask(
    task: 'Reading flutter_loc file...',
    process: () => flutterLocFile.readAsString().then((v) => fileData = v),
  );

  // Parse the file data to a map.
  Map<String, List<(int line, String hardString, String replacementString)>> parsedMap = {};
  await ConsoleHelper.loadWithTask(
    task: 'Parsing file content...',
    process: () async => await parseFileContent(fileData).then((v) => parsedMap = v),
  );

  // Replace all the parsed data.
  await ConsoleHelper.loadWithTask(
    task: 'Replacing the hard-coded strings with the provided replacements...',
    process: () async => await replaceFileContent(parsedMap),
  );

  // Get the desired language files.
  List<String> langs = (args?['languages'] ?? args?['l'])?.toString().split(',') ?? ['en'];
  String mainLang = (args?['main-language'] ?? args?['m']) ?? 'en';

  // Generate the l10n files
  await ConsoleHelper.loadWithTask(
    task: 'Generating l10n files...',
    process: () async => await generateLangFiles(flutterLocFile.parent.path, parsedMap, langs, mainLang),
  );

  // flutterLocFile.writeAsString("\n\n\n======== DONE with the replacements! ========", mode: FileMode.append);
}

Future<Map<String, List<(int line, String hardString, String replacementString)>>> parseFileContent(String fileData) async {
  Map<String, List<(int line, String hardString, String replacementString)>> retMap = {};
  //
  List<String> matchedData = RegExp(r'##PATH(.*?)#!PATH').allMatches(fileData.trim().replaceAll('\n', '')).map((match) => match.group(1)).where((s) => s != null).map((s) => s!).toList();
  await Future.forEach(matchedData, (m) async {
    String? path = m.split('#')[0].replaceAll('(', '').replaceAll(')', '');
    List<(int line, String hardString, String replacementString)> mappedList = [];
    await Future.forEach(m.split('#')[1].split(';'), (line) async {
      int lineNumber = int.tryParse(RegExp(r'\[(.*?)\]').firstMatch(line)?.group(1) ?? '') ?? -1;

      String? whatToReplace = line.replaceAll('[$lineNumber]', '').split('=>').length == 2 ? line.replaceAll('[$lineNumber]', '').split('=>')[0].replaceAll("'", '').replaceAll('"', '') : null;

      String? whatToReplaceWith = line.replaceAll('[$lineNumber]', '').split('=>').length == 2 ? line.replaceAll('[$lineNumber]', '').split('=>')[1].replaceAll("'", '').replaceAll('"', '') : null;
      //
      if (lineNumber != -1 &&
          whatToReplace != null &&
          whatToReplace.trim().isNotEmpty &&
          whatToReplaceWith != null &&
          whatToReplaceWith.trim().isNotEmpty &&
          mappedList.where((d) => d.$2 == whatToReplace.trim()).isEmpty) {
        mappedList.add((lineNumber, whatToReplace, whatToReplaceWith));
      }
    });
    if (path.isNotEmpty && mappedList.isNotEmpty) {
      retMap.addEntries([MapEntry(path, mappedList)]);
    }
  });
  //
  return retMap;
}

Future<void> replaceFileContent(Map<String, List<(int line, String hardString, String replacementString)>> parsedMap) async {
  await Future.forEach(parsedMap.entries, (entry) async {
    // Open the file's path
    File file = File(entry.key);

    // Replace all the required entries in the file
    await Future.forEach(entry.value, (entryValue) async {
      // Get the file content
      final String fileContent = await file.readAsString();
      // final String toAddAfterTheAlteredText = ".tr()";
      String alteredCotnet = fileContent.replaceFirst(RegExp.escape(entryValue.$2.trim()), RegExp.escape(entryValue.$3.trim()));
      // print('replacing ${entryValue.$2} with ${entryValue.$3}');
      if (fileContent != alteredCotnet) {
        await file.writeAsString(alteredCotnet);
      }
    });
  });
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
