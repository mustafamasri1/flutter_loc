import 'dart:async';
import 'dart:isolate';

// import 'package:darted_cli/io_helper.dart';

class RefinementIsolate {
  late Isolate _isolate;
  late SendPort _sendPort;
  final ReceivePort _receivePort = ReceivePort();
  final Completer<void> _readyCompleter = Completer<void>();
  final StreamController<bool> _resultsController = StreamController<bool>.broadcast();

  RefinementIsolate(String customLogicPath) {
    _initialize(customLogicPath);
  }

  Future<void> _initialize(String customLogicPath) async {
    final errorPort = ReceivePort();
    try {
      // Spawn the isolate once.
      _isolate = await Isolate.spawnUri(
        Uri(path: customLogicPath),
        [],
        _receivePort.sendPort,
        onError: errorPort.sendPort,
      );

      _receivePort.listen((message) {
        if (message is SendPort) {
          // Save the isolate's send port.
          _sendPort = message;
          _readyCompleter.complete();
        } else if (message is bool) {
          // Forward results to the stream controller.
          _resultsController.add(message);
        }
      });

      errorPort.listen((error) {
        _resultsController.addError(error);
        errorPort.close();
      });

      await _readyCompleter.future; // Wait until the isolate is ready.
    } catch (e) {
      throw Exception("Failed to initialize refinement isolate: $e");
    }
  }

  Future<bool> applyCustomRefinement(
    String filePath,
    String lineContent,
    String matchedString,
  ) async {
    // Wait for the isolate to be ready.
    await _readyCompleter.future;

    // Send data to the isolate and listen for the result.
    _sendPort.send({
      'filePath': filePath,
      'lineContent': lineContent,
      'matchedString': matchedString,
    });

    return _resultsController.stream.first;
  }

  void dispose() {
    _isolate.kill(priority: Isolate.immediate);
    _receivePort.close();
    _resultsController.close();
  }
}

// Future<bool> applyCustomRefinementImpl(
//   String filePath,
//   String lineContent,
//   String matchedString,
//   //
//   String? customLogicPath,
// ) async {
//   print("Doing refinement on: $matchedString");
//   if (customLogicPath == null) {
//     // Default behavior: Extract everything.
//     return true;
//   }

//   final receivePort = ReceivePort();
//   final errorPort = ReceivePort();

//   try {
//     // Spawn the isolate.
//     final isolate = await Isolate.spawnUri(
//       Uri(path: ),
//       [], // Pass the main isolate's SendPort.
//       receivePort.sendPort,
//       onError: errorPort.sendPort,
//     );

//     final resultCompleter = Completer<bool>();

//     // Listen for messages from the spawned isolate.
//     late SendPort isolateSendPort;
//     final subscription = receivePort.listen((message) {
//       if (message is SendPort) {
//         // The spawned isolate sends back its SendPort.
//         isolateSendPort = message;
//         // Send the input data to the isolate.
//         isolateSendPort.send({
//           'filePath': filePath,
//           'lineContent': lineContent,
//           'matchedString': matchedString,
//         });
//       } else if (message is bool) {
//         // The spawned isolate sends back the result.
//         resultCompleter.complete(message);
//       }
//     });

//     errorPort.listen((error) {
//       resultCompleter.completeError(error);
//       isolate.kill(priority: Isolate.immediate);
//     });

//     return await resultCompleter.future.whenComplete(() {
//       subscription.cancel();
//       receivePort.close();
//       errorPort.close();
//     });
//   } catch (e) {
//     // Handle errors in spawning or communication.
//     return Future.error(e);
//   }
// }
