import '../../constants.dart';
import '../../models/loc_match.model.dart';

String stringifyFinds(
  Map<String, List<LocMatch>> finds,
  bool populatePlaceholders,
) {
  return finds.entries
      .map((entry) => entry.value.isNotEmpty
          ? "${fileStartDelimeter(entry.key)}\n$pathToMatchesDelimeter\n${entry.value.map((matchValue) => "${matchesToMatchesDelimeter(matchValue.linePosition.toString())}\n${matchValue.matchesInLine.entries.toList().map((mEntry) => "(${mEntry.key}) ${mEntry.value} $contentDelimeter ${populatePlaceholders ? craftPlaceholder(mEntry.value) : '""'} $lineEndDelimeter\n").toList().join('+_+').replaceAll('+_+', '')}").toList().reduceIfNotEmpty((a, b) => "$a\n$b") ?? []}"
          : '')
      .toList()
      .map((item) => "$item\n$pathToMatchesDelimeter\n$fileEndDelimeter\n\n")
      .toList()
      .join('+_+')
      .replaceAll('+_+', '');
}

String craftPlaceholder(String originalText) => originalText.toLowerCase().replaceAll(' ', '_');

extension ListExtension<E> on List<E>? {
  E? reduceIfNotEmpty(E Function(E a, E b) condition) {
    return this == null || this!.isEmpty ? null : this!.reduce((aa, bb) => condition(aa, bb));
  }
}
