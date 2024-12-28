import 'package:darted_cli/console_helper.dart';
import 'package:darted_cli/io_helper.dart';
import 'package:darted_cli/yaml_module.dart';
import '../shared/clear_path_trails.dart';
import 'find_hardcoded_strings.dart';
import 'generate_output.dart';
import 'generate_visit_log.dart';
import 'refine_finds.dart';
import 'stringify_finds.dart';
import 'temporary_directory_change.dart';
import '../shared/validators/config-file/config_file.dart';
import '../shared/validators/config-file/config_file_pathes.dart';
import 'validators/directory_supplied.dart';
import '../../models/loc_match.model.dart';
import '../shared/validators/regex_pattern.dart';

/// Main callback to extract the hard-coded strings from the supplied directory and dump it to the `flutter_loc.txt` file.
Future<void> extractCallback(Map<String, dynamic>? args, Map<String, bool>? flags) async {
  assert(args != null, 'You need to provide arguments to do the extraction process, for help use the -h flag.');
  // Values that need to be extracted in the Extraction Phase...
  String? configFilePath;
  late String sourceDirectoryArg;
  String? generationDirectoryArg;
  //
  List<String>? includedExtensions;
  List<String>? excludedPathes;
  //
  late bool isOverwrite;
  late bool willGenerateVisitLog;
  String? customRefinementLogicPath;
  //
  late bool isKeyGenerationEnabled;
  //
  String? generatedKeyPrefix;
  int? generatedKeyMaxValue;
  String? generatedKeySuffix;
  String? generatedKeySeparator;

  // Check if i have a config file to extract from...
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
      process: () => YamlModule.load(configFilePath!).then((yamlcontent) => YamlModule.extractData(yamlcontent)).then((v) => extractedData = v),
    );

    // Validate pathes in the extracted data
    await ConsoleHelper.loadWithTask(
      task: 'Validating the working pathes in the provided config file...',
      process: () => temporaryDirectoryChange<void>(
          File(configFilePath!).parent.path,
          () => validateConfigFilePathes(
                extractedData,
                filesToCheck: [
                  extractedData['extraction']['custom_refinement_logic_file'],
                ],
                dirsToCheck: [
                  extractedData['extraction']['working_directory'],
                ],
              )),
    );

    // Get the required arguments/data
    sourceDirectoryArg = extractedData['extraction']['working_directory'];
    generationDirectoryArg = extractedData['extraction']['generation_directory'];
    //
    includedExtensions = (extractedData['extraction']['include_extensions'] as List?)?.map((item) => item.toString()).toList();
    excludedPathes = (extractedData['extraction']['exclude_paths'] as List?)?.map((item) => item.toString()).toList()?..removeWhere((item) => item.isEmpty);
    validateRegexPatterns(excludedPathes);
    //
    isOverwrite = extractedData['extraction']['overwrite'] ?? false;
    willGenerateVisitLog = extractedData['extraction']['generate_visit_log'] ?? true;
    customRefinementLogicPath = extractedData['extraction']['custom_refinement_logic_file'];
    //
    isKeyGenerationEnabled = extractedData['extraction']['key_format']['enabled'] ?? false;
    generatedKeyMaxValue = extractedData['extraction']['key_format']['max_value_length'] ?? 4;
    //
    generatedKeyPrefix = extractedData['extraction']['key_format']['prefix'];
    generatedKeySuffix = extractedData['extraction']['key_format']['suffix'];
    generatedKeySeparator = extractedData['extraction']['key_format']['separator'];
  } else {
    // Parse the arguments i need.
    validateDirectorySupplied(args);
    sourceDirectoryArg = args['directory'] ?? args['d'];
    generationDirectoryArg = args['output'] ?? args['o'];
    //
    isOverwrite = flags?['overwrite'] ?? flags?['ow'] ?? false;
    willGenerateVisitLog = flags?['log'] ?? flags?['l'] ?? true;
    isKeyGenerationEnabled = flags?['populate'] ?? flags?['pop'] ?? false;
  }

  // Define the directories
  Directory sourceDirectory = configFilePath != null ? Directory(File(configFilePath).parent.path + Platform.pathSeparator + sourceDirectoryArg) : Directory(sourceDirectoryArg);
  Directory? outputDirectory = generationDirectoryArg != null
      ? (configFilePath != null ? Directory(File(configFilePath).parent.path + Platform.pathSeparator + generationDirectoryArg) : Directory(generationDirectoryArg))
      : null;

  // Finds
  Map<String, List<LocMatch>> finds = {};

  // Find all the hardcoded strings...
  await ConsoleHelper.loadWithTask(
    task: 'Searching files for hardcoded strings...',
    process: () => temporaryDirectoryChange(
        sourceDirectory.path,
        () async => await findHardcodedStrings(
              extensionsToInclude: includedExtensions,
              filesToExclude: excludedPathes?.map((item) => RegExp(item)).toList(),
            ).then((v) => finds = v)),
  );

  // Refinements on the search results...
  await ConsoleHelper.loadWithTask(
      task: 'Doing refinements on the extracted lines...',
      process: () => temporaryDirectoryChange(
          configFilePath != null ? File(configFilePath).parent.path : null, () async => await refineFinds(finds, customRefinementLogicPath: customRefinementLogicPath).then((v) => finds = v)));

  if (willGenerateVisitLog) {
    // Generate the visit log.
    await ConsoleHelper.loadWithTask(
        task: 'Generating the visit log...',
        process: () => generateVisitLog(
              sourceDirectory.path,
              finds,
              outputDirectory?.path ?? '.',
              extensionsToInclude: includedExtensions,
              filesToExclude: excludedPathes?.map((item) => RegExp(item)).toList(),
            ));
  }

  // Combine the refined data into a string...
  String stringifiedFinds = stringifyFinds(
    finds,
    isKeyGenerationEnabled,
    generatedKeyMaxValue: generatedKeyMaxValue,
    generatedKeyPrefix: generatedKeyPrefix,
    generatedKeySuffix: generatedKeySuffix,
    generatedKeySeparator: generatedKeySeparator,
  );

  // Export the refined data to an external file...
  await ConsoleHelper.loadWithTask(
    task: 'Generating the flutter_loc file...',
    process: () async => generateOutput(stringifiedFinds, outputDirectory?.path ?? '.', isOverwrite),
  );
  ConsoleHelper.write('Done with the extraction!'.withColor(ConsoleColor.green), newLine: true);
  ConsoleHelper.write(
      'You will find the generated loc file at ' + '${outputDirectory?.absolute.path ?? Directory('.').absolute.path}${Platform.pathSeparator}flutter_loc.txt'.withColor(ConsoleColor.magenta),
      newLine: true);
  ;
  ConsoleHelper.exit(0);
}
