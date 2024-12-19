import 'package:darted_cli/darted_cli.dart';
import 'package:flutter_loc/flutter_loc.dart';

void main(List<String> input) => dartedEntry(
      input: input,
      commandsTree: commandsTree,
      customEntryHelper: (commandsTree) => defaultEntryHelper(commandsTree),
      customHelpResponse: (command) => commandsUsagePrinter(command),
    );
