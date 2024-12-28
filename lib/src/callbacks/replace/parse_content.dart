import '../../constants.dart';
import '../../models/loc_replacement.model.dart';

/// Parse the file content to a list of structured models to replace the matches.
Future<Map<String, List<LocReplacement>>> parseFileContent(String fileData) async {
  final Map<String, List<LocReplacement>> result = {};

  // Extract all file sections using the delimiters
  List<String> matchedSearchFiles =
      RegExp('${fileStartDelimeter('(.*?)')}(.*?)$fileEndDelimeter', dotAll: true).allMatches(fileData).map((match) => match.group(0)).where((s) => s != null).map((ss) => ss!).toList();

  // Loop through the different files
  await Future.forEach(matchedSearchFiles, (searchFile) async {
    // 1. Got the file path
    String? filePath = RegExp(fileStartDelimeter('(.*?)')).allMatches(searchFile).first.group(1);
    if (filePath != null) {
      // Get the matching content block
      String? matchContentBlock = RegExp('${fileStartDelimeter('(.*?)')}\n$pathToMatchesDelimeter\n(.*?)\n$pathToMatchesDelimeter\n$fileEndDelimeter', multiLine: true, dotAll: true)
          .allMatches(searchFile)
          .map((m) => m.group(2))
          .toList()
          .firstOrNull;
      if (matchContentBlock != null) {
        // Get the line blocks from the content block
        List<String> matchedLineNumbers = RegExp(matchesToMatchesDelimeter(r'(\d+?)')).allMatches(matchContentBlock).map((a) => a.group(1)).where((a) => a != null).map((aa) => aa!).toList();
        List<String> matchedLineBlocks = matchContentBlock.split(RegExp(matchesToMatchesDelimeter(r'(\d+?)'))).where((a) => a.isNotEmpty).toList();

        if (matchedLineNumbers.length == matchedLineBlocks.length) {
          List<LocReplacement> replacementsList = [];
          // Loop through the lines in the matchBlock
          await Future.forEach(matchedLineBlocks, (lineBlock) async {
            //2. Got the line number.
            int lineNumber = int.tryParse(matchedLineNumbers[matchedLineBlocks.indexOf(lineBlock)]) ?? -1;

            List<String> positionMatcheBlocks =
                RegExp(r'(\(\d+?\))(.*?)' '$lineEndDelimeter', dotAll: true).allMatches(lineBlock).map((m) => m.group(0)).where((a) => a != null).map((aa) => aa!).toList();

            Map<int, (String, String)> positionsReplacementsMap = {};

            // Loop through each line that represents a position match.
            await Future.forEach(positionMatcheBlocks, (positionMatch) async {
              //3. Got the poition number
              int positionNumber = int.tryParse(RegExp(r'(\(\d+?\))').firstMatch(positionMatch)?.group(1).toString().replaceFirst('(', '').replaceFirst(')', '') ?? '') ?? -1;

              String? s = RegExp(r'(\(\d+?\)) (.*?)' '$lineEndDelimeter', multiLine: true, dotAll: true).firstMatch(positionMatch)?.group(2);

              //4. Got the value to replace
              String whatToReplace = s?.split(contentDelimeter)[0] ?? '';

              //5. Got the value to replace it with.
              String whatToReplaceItWith = s?.split(contentDelimeter)[1] ?? '';
              if (positionNumber != -1 && whatToReplace.isNotEmpty && whatToReplaceItWith.isNotEmpty) {
                positionsReplacementsMap.addEntries([MapEntry(positionNumber, (whatToReplace, whatToReplaceItWith))]);
              }
            });

            if (positionsReplacementsMap.isNotEmpty && lineNumber != -1) {
              replacementsList.add(LocReplacement(linePosition: lineNumber, matchesInLine: positionsReplacementsMap));
            }
          });
          if (replacementsList.isNotEmpty) {
            result.addEntries([MapEntry(filePath, replacementsList)]);
          }
        }
      }
    }
  });
  return result;
}
