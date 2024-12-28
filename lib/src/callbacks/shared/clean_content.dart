/// Clean the string content of quotes.
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
      cleanedContent = content.substring(quoteType.length, content.length - quoteType.length);
    }
  }
  // Step 4: Trim and check for empty content
  return cleanedContent.trim();
}
