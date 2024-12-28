import 'package:darted_cli/io_helper.dart';
import '../shared/clean_content.dart';

/// Generate the specified lang files and include the keys supplied.
Future<void> generateLangFiles(String path, Map<String, String> redefinedMap, List<String> langs, String mainLang) async {
  //Create the directory
  Directory d = await IOHelper.directory.create("$path/l10n");

  // Loop through the required languages.
  await Future.forEach(langs, (lang) async {
    // Create the files
    File langFile = await IOHelper.file.create("${d.path}/$lang.json");

    // Write the data to the files...
    await langFile.writeAsString(redefinedMap.map((k, v) => MapEntry(cleanContent(v.trim()), lang == mainLang ? cleanContent(k.trim()) : '""')).toString());
  });
}
