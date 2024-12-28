import 'package:darted_cli/io_helper.dart';
import '../../shared/clean_content.dart';

/// Generate the specified lang files and include the keys supplied.
Future<void> generateLangFiles(String path, Map<String, String> redefinedMap,
    List<String> langs, String mainLang, String fileFormat) async {
  //Create the directory
  Directory d = await IOHelper.directory.create("$path");

  // Loop through the required languages.
  await Future.forEach(langs, (lang) async {
    // Create the files
    File langFile = await IOHelper.file.create("${d.path}/$lang.$fileFormat");

    // Write the data to the files...
    await langFile.writeAsString(redefinedMap
        .map((k, v) => MapEntry(
            '"' + cleanContent(v.trim()).replaceAll('"', "'") + '"',
            lang == mainLang
                ? ('"' + cleanContent(k.trim()) + '"').replaceAll('\n', '\\n')
                : '""'))
        .toString());
  });
}
