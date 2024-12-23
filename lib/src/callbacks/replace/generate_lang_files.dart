import 'package:darted_cli/io_helper.dart';

Future<void> generateLangFiles(String path, Map<String, String> redefinedMap,
    List<String> langs, String mainLang) async {
  //Create the directory
  Directory d = await IOHelper.directory.create("$path/l10n");

  // Loop through the required languages.
  await Future.forEach(langs, (lang) async {
    // Create the files
    File langFile = await IOHelper.file.create("${d.path}/$lang.json");

    // Write the data to the files...
    await langFile.writeAsString(redefinedMap
        .map((k, v) => MapEntry(cleanContent(v.trim()),
            lang == mainLang ? cleanContent(k.trim()) : '""'))
        .toString());
  });
}

String cleanContent(String content) {
  String cleanedContent = content;
  // Return true if the content itself is empty.
  if (content.isEmpty) return "";

  // Step 1: Identify quote type (single, double, or triple)
  String? quoteType = RegExp(r'''^(['"]{1,3})''').firstMatch(content)?.group(1);

  if (quoteType != null) {
    // Ensure the content has matching opening and closing quotes
    if (content.length >= quoteType.length * 2 && content.endsWith(quoteType)) {
      // Step 3: Remove only the matching quotes
      cleanedContent = content.substring(
          quoteType.length, content.length - quoteType.length);
    }
  }
  // Step 4: Trim and check for empty content
  return '"${cleanedContent.trim()}"';
}
