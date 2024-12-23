/// A match model of all the matches in one line.
class LocMatch {
  /// On which line is this match.
  int linePosition;

  /// What is the content of the entire match.
  String lineContent;

  /// Map of the matched content in this line, with it's matching position.
  Map<int, String> matchesInLine;
  LocMatch({
    required this.linePosition,
    required this.lineContent,
    required this.matchesInLine,
  });

  LocMatch copyWith({
    int? linePosition,
    String? lineContent,
    Map<int, String>? matchesInLine,
  }) {
    return LocMatch(
      linePosition: linePosition ?? this.linePosition,
      lineContent: lineContent ?? this.lineContent,
      matchesInLine: matchesInLine ?? this.matchesInLine,
    );
  }

  @override
  String toString() =>
      'LocMatch(linePosition: $linePosition, lineContent: $lineContent, matchesInLine: $matchesInLine)';
}
