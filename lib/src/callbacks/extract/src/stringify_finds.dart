import '../../../constants.dart';
import '../../../models/loc_match.model.dart';
import '../../shared/clean_content.dart';
import '../../shared/clear_path_trails.dart';
import '../../shared/list_extension.dart';

/// Turn the refined finds into a stringified version with special pattern.
String stringifyFinds(
  Map<String, List<LocMatch>> finds,
  bool populatePlaceholders, {
  int? generatedKeyMaxValue,
  String? generatedKeyPrefix,
  String? generatedKeySuffix,
  String? generatedKeySeparator,
}) {
  return finds.entries
      .map((entry) => entry.value.isNotEmpty
          ? "${fileStartDelimeter(entry.key.clearPathTrails.replaceAll(' ', '%20')).clearPathTrails}\n$pathToMatchesDelimeter\n${entry.value.map((matchValue) => "${matchesToMatchesDelimeter(matchValue.linePosition.toString())}\n${matchValue.matchesInLine.entries.toList().map((mEntry) => "(${mEntry.key}) ${mEntry.value} $contentDelimeter ${populatePlaceholders ? _craftPlaceholder(mEntry.value, generatedKeyMaxValue, generatedKeyPrefix, generatedKeySuffix, generatedKeySeparator) : '""'} $lineEndDelimeter\n").toList().join('+_+').replaceAll('+_+', '')}").toList().reduceIfNotEmpty((a, b) => "$a\n$b") ?? []}"
          : '')
      .toList()
      .map((item) => item.isEmpty
          ? ''
          : "$item\n$pathToMatchesDelimeter\n$fileEndDelimeter\n\n")
      .toList()
      .join('+_+')
      .replaceAll('+_+', '');
}

/// Create a placeholder for the original text.
String _craftPlaceholder(String originalText, int? generatedKeyMaxValue,
    String? prefix, String? suffix, String? separator) {
  if (originalText.split(' ').length > (generatedKeyMaxValue ?? 4)) {
    return '""';
  }
  return '"' +
      (prefix ?? '') +
      cleanContent(originalText)
          .toLowerCase()
          .replaceAll('\n', ' ')
          .replaceAll('"', "'")
          .replaceAll(' ', separator ?? '_') +
      (suffix ?? '') +
      '"';
}
