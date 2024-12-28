import 'package:darted_cli/console_helper.dart';
import 'package:darted_cli/io_helper.dart';

import '../../helpers/error_helper.dart';

Future<void> generateOutput(String stringifiedFinds, String outputDirectory, bool isOverwrite) async {
  File outputFile = File("$outputDirectory${Platform.pathSeparator}flutter_loc.txt");
  if (!await IOHelper.file.exists(outputFile.path) || isOverwrite) {
    // Generate the output directory if doesn't exist.
    if (!await IOHelper.directory.exists(outputDirectory)) {
      await IOHelper.directory.create(outputDirectory);
    }
    await outputFile.writeAsString(stringifiedFinds);
  } else {
    // Throw an error that the file already exists.
    ErrorHelper.print("The file already exists in the supplied directory. Either change the output directory or use the '--overwrite | -ow' flag");
    ConsoleHelper.exit(1);
  }
}
