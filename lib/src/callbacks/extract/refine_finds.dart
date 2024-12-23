import '../../models/loc_match.model.dart';

/// Refine the finds.
Future<Map<String, List<LocMatch>>> refineFinds(
    Map<String, List<LocMatch>> inputFinds) async {
  Map<String, List<LocMatch>> outputFinds = inputFinds;
  await Future.forEach(inputFinds.entries, (inputEntry) async {
    //S2 -- Per-line enhancements
    await Future.forEach(outputFinds.entries, (findEntry) async {
      List<LocMatch> matches = findEntry.value;

      //1. Remove imports & exports
      matches = matches
        ..removeWhere((matchItem) =>
            (matchItem.lineContent.trim().startsWith('import') ||
                matchItem.lineContent.trim().startsWith('export')));

      //2. Remove One-line comments
      matches = matches
        ..removeWhere(
            (matchItem) => (matchItem.lineContent.trim().startsWith('//')));

      //S2 -- Per-position enhancements
      await Future.forEach(matches, (matchValue) async {
        Map<int, String> m = matchValue.matchesInLine;
        m = Map.fromEntries(m.entries.toList()
          ..removeWhere((e) {
            //1.Remove strings followed by tr()
            bool isFollowedByTr =
                matchValue.lineContent.length > ((e.key) + e.value.length) &&
                    matchValue.lineContent
                        .substring(e.key + e.value.length)
                        .startsWith(r'.tr()');

            return isFollowedByTr;
          }));
        matches[matches.indexOf(matchValue)] =
            matchValue.copyWith(matchesInLine: m);
      });

      outputFinds[findEntry.key] = matches
        ..removeWhere((mm) => mm.matchesInLine.isEmpty);
    });
  });
  return outputFinds;
}
