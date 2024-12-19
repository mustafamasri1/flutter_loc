import 'package:darted_cli/console_helper.dart';
import '../../../helpers/error_helper.dart';

void validateDirectorySupplied(Map<String, dynamic>? args) {
  if (args == null || (!args.containsKey('directory') || !args.containsKey('d'))) {
    ErrorHelper.print("You need to provide the name of the template and it's description through the 'template.yaml' file.");
    ConsoleHelper.exit(1);
  }
}
