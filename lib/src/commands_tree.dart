import 'package:darted_cli/console_helper.dart';
import 'package:darted_cli/darted_cli.dart';
import 'package:darted_cli/io_helper.dart';
import 'package:flutter_loc/flutter_loc.dart';

//
List<DartedCommand> commandsTree = [
  //S1 - Test
  DartedCommand(
    name: 'test',
    helperDescription: "Test.",
    arguments: [
      // DartedArgument(name: 'command', abbreviation: 'c', isMultiOption: false, defaultValue: 'lib'),
    ],
    callback: (args, flags) async {
      Map<String, List<(int, String)>> res = await IOHelper.file.search('.', RegExp('coco'));
      ConsoleHelper.write(res.toString());
      ConsoleHelper.exit(1);
    },
  ),
  //S1 - Extract
  DartedCommand(
    name: 'extract',
    helperDescription: "Extract potential hard-coded strings.",
    arguments: [
      DartedArgument(name: 'directory', abbreviation: 'd', isMultiOption: false, defaultValue: 'lib'),
    ],
    callback: (args, flags) async => await execCallback(args, flags),
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
