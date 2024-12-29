import 'package:darted_cli/console_helper.dart';
import 'package:darted_cli/io_helper.dart';

import '../../../helpers/error_helper.dart';

/// Validate the working directory pathes in the config file supplied.
Future<void> validateConfigFilePathes(Map<String, dynamic> extractedData,
    {List<String>? filesToCheck, List<String>? dirsToCheck}) async {
  // Get the available working pathes in the Yaml file.
  List<String> workingFiles = filesToCheck ?? [];

  List<String> workingDirs = dirsToCheck ?? [];

  if (dirsToCheck == null || dirsToCheck.isEmpty) return;
  // Validate the working dirs exist.
  await Future.forEach(workingDirs, (d) async {
    if (!await IOHelper.directory.exists("$d")) {
      ErrorHelper.print("Invalid directory path '$d', Make sure it exists.");
      ConsoleHelper.exit(1);
    }
  });

  if (filesToCheck == null || filesToCheck.isEmpty) return;
  // Validate the working files exist.
  await Future.forEach(workingFiles, (f) async {
    if (!await IOHelper.file.exists("$f")) {
      ErrorHelper.print("Invalid file path '$f', Make sure it exists.");
      ConsoleHelper.exit(1);
    }
  });
}
