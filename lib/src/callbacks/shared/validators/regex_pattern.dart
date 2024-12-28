import 'package:darted_cli/console_helper.dart';
import '../../../helpers/error_helper.dart';

void validateRegexPatterns(List<String?>? patterns) {
  if (patterns == null) return;
  for (final pattern in patterns) {
    if (pattern == null) continue;
    try {
      RegExp(pattern); // Attempt to create a RegExp object
    } catch (e) {
      ErrorHelper.print('Invalid RegExp pattern: $pattern. Error: $e');
      ConsoleHelper.exit(1);
    }
  }
}
