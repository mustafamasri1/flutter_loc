import 'package:darted_cli/darted_cli.dart';
import 'package:darted_cli/io_helper.dart';
import 'package:flutter_loc/src/callbacks/extract/find_hardcoded_strings.dart';
import 'package:flutter_loc/src/callbacks/extract/validators/test_extract.dart';
import 'callbacks/callbacks.exports.dart';

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
      await findHardcodedStrings('./testing');
      // Read a Dart file.
      // var dartFile = File('testing/test.dart');
      // var dartCode = dartFile.readAsStringSync();

      // Extract hard-coded strings.
      // var extractor = HardCodedStringExtractor();
      // var hardCodedStrings = extractor.extractHardCodedStrings(dartCode);

      // Print the results.
      // print('Hard-coded strings found:');
      // for (var string in hardCodedStrings) {
      //   print('- "$string"');
      // }
      // Map<String, List<(int, String)>> res = await IOHelper.file.search('.', RegExp('coco'));
      // ConsoleHelper.write(res.toString());
      // ConsoleHelper.exit(1);
    },
  ),
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
