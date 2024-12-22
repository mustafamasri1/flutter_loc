import 'dart:convert';

// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class LocReplacement {
  int linePosition;
  Map<int, (String whatToReplace, String whatToReplaceItWith)> matchesInLine;
  LocReplacement({
    required this.linePosition,
    required this.matchesInLine,
  });

  LocReplacement copyWith({
    int? linePosition,
    Map<int, (String whatToReplace, String whatToReplaceItWith)>? matchesInLine,
  }) {
    return LocReplacement(
      linePosition: linePosition ?? this.linePosition,
      matchesInLine: matchesInLine ?? this.matchesInLine,
    );
  }

  @override
  String toString() => 'LocReplacement(linePosition: $linePosition, matchesInLine: $matchesInLine)';

  @override
  bool operator ==(covariant LocReplacement other) {
    if (identical(this, other)) return true;
    final mapEquals = const DeepCollectionEquality().equals;

    return other.linePosition == linePosition && mapEquals(other.matchesInLine, matchesInLine);
  }

  @override
  int get hashCode => linePosition.hashCode ^ matchesInLine.hashCode;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'linePosition': linePosition,
      'matchesInLine': matchesInLine,
    };
  }

  factory LocReplacement.fromMap(Map<String, dynamic> map) {
    return LocReplacement(
      linePosition: map['linePosition'] as int,
      matchesInLine: Map<int, (String whatToReplace, String whatToReplaceItWith)>.from(map['matchesInLine'] as Map<int, (String whatToReplace, String whatToReplaceItWith)>),
    );
  }

  String toJson() => json.encode(toMap());

  factory LocReplacement.fromJson(String source) => LocReplacement.fromMap(json.decode(source) as Map<String, dynamic>);
}
