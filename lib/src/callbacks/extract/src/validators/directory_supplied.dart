import 'package:darted_cli/console_helper.dart';
import '../../../../helpers/error_helper.dart';

/// Validate if the directory argument was supplied.
void validateDirectorySupplied(Map<String, dynamic>? args) {
  if (args == null ||
      !(args.containsKey('directory') || args.containsKey('d'))) {
    ErrorHelper.print(
        "You need to provide the directory to look for hard-coded strings in.");
    ConsoleHelper.exit(1);
  }
}
