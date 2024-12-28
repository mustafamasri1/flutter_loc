import 'package:darted_cli/console_helper.dart';
import 'package:darted_cli/io_helper.dart';

import '../../../../helpers/error_helper.dart';

/// Validate the working directory pathes in the config file supplied.
Future<void> validateConfigFilePathes(Map<String, dynamic> extractedData) async {
  // Get the available working pathes in the Yaml file.
  List<String> workingFiles = [
    extractedData['extraction']['custom_refinement_logic_file'],
  ];

  List<String> workingDirs = [
    extractedData['extraction']['working_directory'],
    // extractedData['extraction']['generation_directory'],
  ];

  // Validate the working dirs exist.
  await Future.forEach(workingDirs, (d) async {
    // print('Check dir: ${wd.path}/${d}');
    if (!await IOHelper.directory.exists("$d")) {
      ErrorHelper.print("Invalid directory path '$d', Make sure it exists.");
      ConsoleHelper.exit(1);
    }
  });

  // Validate the working files exist.
  await Future.forEach(workingFiles, (f) async {
    // print('Check file: ${wd.path}/${f}');
    if (!await IOHelper.file.exists("$f")) {
      ErrorHelper.print("Invalid file path '$f', Make sure it exists.");
      ConsoleHelper.exit(1);
    }
  });
}
