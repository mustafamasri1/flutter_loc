import 'package:darted_cli/darted_cli.dart';
import 'callbacks/callbacks.exports.dart';

//
List<DartedCommand> commandsTree = [
  //S1 - Extract
  DartedCommand(
    name: 'extract',
    helperDescription: "Extract potential hard-coded strings.",
    arguments: [
      DartedArgument(name: 'directory', abbreviation: 'd', isMultiOption: false, defaultValue: 'lib', describtion: 'choose the directory to search in.'),
      DartedArgument(name: 'output', abbreviation: 'o', isMultiOption: false, defaultValue: '.', describtion: 'choose the output directory for the generated extraction files.'),
      DartedArgument(name: 'config', abbreviation: 'f', isMultiOption: false, describtion: 'configure the process for advanced refinements with a config yaml file.'),
    ],
    flags: [
      DartedFlag.help,
      DartedFlag(
          name: 'dry-run',
          abbreviation: 'dr',
          canBeNegated: false,
          appliedByDefault: false,
          describtion: 'run the extraction with the logging enabled to see the match stats without doing the extraction.'),
      DartedFlag(name: 'overwrite', abbreviation: 'ow', canBeNegated: false, appliedByDefault: false, describtion: 'overwrite the current flutter_loc file.'),
      DartedFlag(name: 'populate', abbreviation: 'pop', canBeNegated: false, appliedByDefault: false, describtion: 'populate the placeholders in the extracted file with the template: `text1_text2`.'),
      DartedFlag(name: 'log', abbreviation: 'l', canBeNegated: false, appliedByDefault: true, describtion: 'generate a log file `visit_log.txt`.'),
    ],
    callback: (args, flags) async => await extractCallback(args, flags),
  ),
  //S1 - Replace
  DartedCommand(
    name: 'replace',
    helperDescription: "Replace all the hard-coded strings from the generated flutter_loc file",
    arguments: [
      DartedArgument(name: 'path', abbreviation: 'p', isMultiOption: false, defaultValue: 'flutter_loc.txt', describtion: 'path to the `flutter_loc.txt` file.'),
      DartedArgument(name: 'languages', abbreviation: 'l', isMultiOption: false, defaultValue: 'en', optionsSeparator: ',', describtion: 'languages to generate the json files for.'),
      DartedArgument(
          name: 'main-language',
          abbreviation: 'm',
          isMultiOption: false,
          defaultValue: 'en',
          describtion: 'the main language in the app to populate the extracted strings in the corresponding json file.'),
      DartedArgument(name: 'config', abbreviation: 'f', isMultiOption: false, describtion: 'configure the process for advanced refinements with a config yaml file.'),
    ],
    flags: [
      DartedFlag.help,
      DartedFlag(name: 'generate-json', abbreviation: 'j', canBeNegated: false, appliedByDefault: true, describtion: 'wheather to genrate the json language files or not.'),
    ],
    callback: (args, flags) async => await replaceCallback(args, flags),
  ),
];
