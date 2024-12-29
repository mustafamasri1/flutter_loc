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

    // Iterate through the keys to remove similar ones.
    Map<String, String> refinedMapToWrite = {};
    for (var mEntry in redefinedMap.entries) {
      MapEntry<String, String> mappedEntry = MapEntry(
          '"' + cleanContent(mEntry.value.trim()).replaceAll('"', "'") + '"',
          lang == mainLang
              ? ('"' + cleanContent(mEntry.key.trim()) + '"')
                  .replaceAll('\n', '\\n')
              : '""');
      if (!refinedMapToWrite.containsKey(mappedEntry.key)) {
        refinedMapToWrite.addEntries([mappedEntry]);
      }
    }

    // Write the file...
    await langFile.writeAsString(refinedMapToWrite.toString());
  });
}
