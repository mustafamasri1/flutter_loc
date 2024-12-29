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
        Uri.file(customLogicPath),
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
