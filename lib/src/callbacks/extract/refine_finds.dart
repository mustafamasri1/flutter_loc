import 'package:flutter_loc/src/models/loc_match.model.dart';

Future refineFinds(Map<String, List<LocMatch>> inputFinds) async {
  Map<String, List<LocMatch>> _outputFinds;

  //1.Remove imports
  await Future.forEach(inputFinds.entries, (entries) async {
    List<(int, String)> listedValues = [];
    listedValues = d.value..removeWhere((item) => item.$2.startsWith('import'));
    newFinds.addEntries([MapEntry(d.key, listedValues)]);
  });
}

// Basic Refinements on the hard-coded strings extracted
List<Future<Map<String, List<LocMatch>>> Function(Map<String, List<LocMatch>> input)> _refinements = [
  // Removing imports
  (data) async {
    Map<String, List<(int, String)>> newFinds = {};
    //
    await Future.forEach(data.entries, (d) async {
      List<(int, String)> listedValues = [];
      listedValues = d.value..removeWhere((item) => item.$2.startsWith('import'));
      newFinds.addEntries([MapEntry(d.key, listedValues)]);
    });
    //
    return newFinds;
  },
  // Not followed by .tr()
  (data) async {
    Map<String, List<(int, String)>> newFinds = {};
    //
    await Future.forEach(data.entries, (d) async {
      List<(int, String)> listedValues = [];
      listedValues = d.value
        ..removeWhere((item) {
          String stringFromLine = "${RegExp('["\'](.*?)["\']').hasMatch(item.$2) ? RegExp('["\'](.*?)["\']').firstMatch(item.$2)?.group(0) : 'N/A'}";
          return item.$2.contains("'$stringFromLine'.tr()") || item.$2.contains('"$stringFromLine".tr()');
        });
      newFinds.addEntries([MapEntry(d.key, listedValues)]);
    });
    //
    return newFinds;
  },
  // Making sure only with spaces
  // (data) async {
  //   Map<String, List<(int, String)>> newFinds = {};
  //   //
  //   await Future.forEach(data.entries, (d) async {
  //     List<(int, String)> listedValues = [];
  //     listedValues = d.value
  //       ..removeWhere((item) {
  //         String stringFromLine = "${RegExp('["\'](.*?)["\']').hasMatch(item.$2) ? RegExp('["\'](.*?)["\']').firstMatch(item.$2)?.group(0) : 'N/A'}";
  //         return !stringFromLine.contains(' ');
  //       });
  //     newFinds.addEntries([MapEntry(d.key, listedValues)]);
  //   });
  //   //
  //   return newFinds;
  // },
];
