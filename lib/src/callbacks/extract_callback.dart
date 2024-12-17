import 'package:darted_cli/console_helper.dart';
import 'package:darted_cli/io_helper.dart';

Future execCallback(Map<String, dynamic>? args, Map<String, bool>? flags) async {
  // Define the directory to look in...
  Directory directory = Directory(args?['directory'] ?? args?['d'] ?? 'lib');

  // Change into that directory
  await IOHelper.directory.change(directory.path);

  // Get the new pwd
  String wd = IOHelper.directory.getCurrent();

  // Find all the hardcoded strings...
  Map<String, List<(int, String)>> finds = {};
  await ConsoleHelper.loadWithTask(
    task: 'Searching files for hardcoded strings...',
    process: () => IOHelper.file.search(
      wd,
      // RegExp('["\'](.*?)["\']'),
      RegExp(r"""(?<!\$)(?<!\{)((['"]){1,3})(.*?)(?<!\\)\2""", dotAll: true),
      excluded: [RegExp('commands_tree.dart'), RegExp('flutter_loc.txt')],
    ).then((v) => finds = v),
  );

  // Refinements on the search results...
  await ConsoleHelper.loadWithTask(
    task: 'Doing refinements on the extracted lines...',
    process: () async {
      await Future.forEach(refinements, (r) async {
        finds = await r(finds);
      });
      return finds;
    },
  );

  // Combine the refined data into a string...
  String hardcodedStrings = finds.entries
          .map((map) => map.value.isNotEmpty
              ? "##PATH\n(file://${map.key})\n#\n${map.value.map((e) => "[${e.$1}] ${RegExp('["\'](.*?)["\']').hasMatch(e.$2) ? RegExp('["\'](.*?)["\']').firstMatch(e.$2)?.group(0) : 'N/A'} => '';").toList().reduceIfNotEmpty((aa, bb) => "$aa\n$bb") ?? []}"
              : '')
          .toList()
          .reduceIfNotEmpty(
            (p1, p2) => p1.trim().isEmpty
                ? '\n\n$p2'
                : p2.trim().isEmpty
                    ? "$p1\n"
                    : "$p1\n#\n#!PATH\n\n$p2",
          ) ??
      '';

  // Export the refined data to an external file...
  File outputFile = File('flutter_loc.txt');
  await ConsoleHelper.loadWithTask(
    task: 'Generating flutter_loc file...',
    process: () => outputFile.writeAsString(hardcodedStrings),
  );
}

List<Future<Map<String, List<(int, String)>>> Function(Map<String, List<(int, String)>> data)> refinements = [
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

extension ListExtension<E> on List<E>? {
  E? reduceIfNotEmpty(E Function(E a, E b) condition) {
    return this == null || this!.isEmpty ? null : this!.reduce((aa, bb) => condition(aa, bb));
  }
}
