import 'package:darted_cli/darted_cli.dart';
import 'callbacks/callbacks.exports.dart';

//
List<DartedCommand> commandsTree = [
  //S1 - Extract
  DartedCommand(
    name: 'extract',
    helperDescription: "Extract potential hard-coded strings.",
    arguments: [
      DartedArgument(name: 'directory', abbreviation: 'd', isMultiOption: false, defaultValue: 'lib'),
      DartedArgument(name: 'output', abbreviation: 'o', isMultiOption: false, defaultValue: '.'),
    ],
    flags: [
      DartedFlag(name: 'dry-run', abbreviation: 'dr', canBeNegated: false, appliedByDefault: false),
      DartedFlag(name: 'overwrite', abbreviation: 'ow', canBeNegated: false, appliedByDefault: false),
      DartedFlag(name: 'populate', abbreviation: 'pop', canBeNegated: false, appliedByDefault: false),
    ],
    callback: (args, flags) async => await extractCallback(args, flags),
  ),
  //S1 - Replace
  DartedCommand(
    name: 'replace',
    helperDescription: "Replace all the hard-coded strings from the generated flutter_loc file",
    arguments: [
      DartedArgument(name: 'path', abbreviation: 'p', isMultiOption: false, defaultValue: 'flutter_loc.txt'),
      DartedArgument(name: 'languages', abbreviation: 'l', isMultiOption: false, defaultValue: 'en', optionsSeparator: ','),
      DartedArgument(name: 'main-language', abbreviation: 'm', isMultiOption: false, defaultValue: 'en'),
    ],
    flags: [
      DartedFlag(name: 'generate-json', abbreviation: 'j', canBeNegated: false, appliedByDefault: true),
    ],
    callback: (args, flags) async => await replaceCallback(args, flags),
  ),
];
