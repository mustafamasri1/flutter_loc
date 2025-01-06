import 'dart:io';
import 'package:darted_cli/console_helper.dart';
import 'package:darted_cli/io_helper.dart';
import 'package:darted_cli/yaml_module.dart';

import './replace.exports.dart';

/// Main callback to replace the hard-coded strings with the supplied keys and generate specified lang files.
Future<void> replaceCallback(
    Map<String, dynamic>? args, Map<String, bool>? flags) async {
  assert(args != null,
      'You need to provide arguments to do the extraction process, for help use the -h flag.');
  // Values that need to be extracted in the Replacement Phase...
  String? configFilePath;
  String generationDirectoryArg;
  String? outputDirectoryArg;
  //
  String? valueShifter;
  String? importingLine;
  String? outputFormat;
  String defLanguage;
  List<String> langsSupported;

  if (args!.containsKey('config') || args.containsKey('f')) {
    configFilePath = args['config'] ?? args['f'];

    // Validate the content.
    await ConsoleHelper.loadWithTask(
      task: 'Validating the provided config file...',
      process: () => validateConfigFile(configFilePath!),
    );

    // Extract the data from the Yaml File
    Map<String, dynamic> extractedData = {};
    await ConsoleHelper.loadWithTask(
      task: 'Extracting data from the provided config file...',
      process: () => YamlModule.load(configFilePath!)
          .then((yamlcontent) => YamlModule.extractData(yamlcontent))
          .then((v) => extractedData = v),
    );

    // Get the required arguments/data
    generationDirectoryArg =
        extractedData['extraction']['generation_directory'];
    outputDirectoryArg = extractedData['replacement']['output_directory'];
    //
    outputFormat = extractedData['replacement']['output_format'];
    defLanguage = extractedData['replacement']['default_language'] ?? 'en';
    langsSupported =
        (extractedData['replacement']['supported_languages'] as List?)
                ?.map((item) => item.toString())
                .toList() ??
            ['en'];
    valueShifter = extractedData['replacement']['value_shifter'];
    importingLine = extractedData['replacement']['importing_line'];
  } else {
    // Parse the arguments i need.
    generationDirectoryArg = (args['path'] ?? args['p']) != null
        ? File(args['path'] ?? args['p']).parent.path
        : '.';
    langsSupported =
        (args['languages'] ?? args['l'])?.toString().split(',') ?? ['en'];
    defLanguage = (args['main-language'] ?? args['m']) ?? 'en';
    //
  }

  // Validate the supported languages contains the default language.
  if (!langsSupported.contains(defLanguage)) {
    ErrorHelper.print(
        'The default language is not one of the supported languages, Make sure it does.');
    ConsoleHelper.exit(1);
  }

  // Validate Output format...
  List<String> acceptedOutputFormats = ['json'];
  if (outputFormat != null && !acceptedOutputFormats.contains(outputFormat)) {
    ErrorHelper.print(
        'The output format you supplied is not currently accepted. Check the example yaml file for accepted values.');
    ConsoleHelper.exit(1);
  }

  // Get the loc file & prepate the directory...
  late Directory outputDirectory;
  String fileData = '';
  File flutterLocFile = File(
      (generationDirectoryArg + Platform.pathSeparator + 'flutter_loc.txt')
          .replaceSeparator());
  await temporaryDirectoryChange<void>(
      configFilePath != null ? File(configFilePath).parent.path : null,
      () async {
    // Validate the loc file supplied...
    await validateLocFileSupplied(flutterLocFile);
    outputDirectory =
        Directory(outputDirectoryArg ?? flutterLocFile.parent.path);

    // Get the content of the file...
    await ConsoleHelper.loadWithTask(
      task: 'Reading flutter_loc file...',
      process: () => flutterLocFile.readAsString().then((v) => fileData = v),
    );
  });

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
    process: () async => await replaceFileContent(parsedReplacementMap,
            valueShifter: valueShifter, importingLine: importingLine)
        .then((v) => redefinedMap = v),
  );

  // Generate the l10n files
  await ConsoleHelper.loadWithTask(
    task: 'Generating l10n files...',
    process: () async => temporaryDirectoryChange(
        configFilePath != null ? File(configFilePath).parent.path : null,
        () async => await generateLangFiles(outputDirectory.path, redefinedMap,
            langsSupported, defLanguage, outputFormat ?? 'json')),
  );

  // Mark the loc file as generated.
  temporaryDirectoryChange<void>(
      configFilePath != null ? File(configFilePath).parent.path : null,
      () async {
    await flutterLocFile.writeAsString(
        "\n\n\n======== DONE with the replacements! at ${DateTime.now().toLocal().toIso8601String()} ========",
        mode: FileMode.append);
  });

  ConsoleHelper.write(
      'Done with the replacements!'.withColor(ConsoleColor.green),
      newLine: true);
  ConsoleHelper.exit(0);
}
