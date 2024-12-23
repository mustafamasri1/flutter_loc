import 'dart:convert';

// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

class LocMatch {
  int linePosition;
  String lineContent;
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

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'linePosition': linePosition,
      'lineContent': lineContent,
      'matchesInLine': matchesInLine,
    };
  }

  factory LocMatch.fromMap(Map<String, dynamic> map) {
    return LocMatch(
      linePosition: map['linePosition'] as int,
      lineContent: map['lineContent'] as String,
      matchesInLine:
          Map<int, String>.from(map['matchesInLine'] as Map<int, String>),
    );
  }

  String toJson() => json.encode(toMap());

  factory LocMatch.fromJson(String source) =>
      LocMatch.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'LocMatch(linePosition: $linePosition, lineContent: $lineContent, matchesInLine: $matchesInLine)';

  @override
  bool operator ==(covariant LocMatch other) {
    if (identical(this, other)) return true;
    final mapEquals = const DeepCollectionEquality().equals;

    return other.linePosition == linePosition &&
        other.lineContent == lineContent &&
        mapEquals(other.matchesInLine, matchesInLine);
  }

  @override
  int get hashCode =>
      linePosition.hashCode ^ lineContent.hashCode ^ matchesInLine.hashCode;
}
