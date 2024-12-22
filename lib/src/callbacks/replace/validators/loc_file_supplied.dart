import 'package:darted_cli/console_helper.dart';
import 'package:darted_cli/io_helper.dart';
import '../../../helpers/error_helper.dart';

Future<void> validateLocFileSupplied(File file) async {
  if (!await IOHelper.file.exists(file.path)) {
    ErrorHelper.print("The flutter_loc file path is invalid. Make sure you provided a correct path.");
    ConsoleHelper.exit(1);
  }
}
