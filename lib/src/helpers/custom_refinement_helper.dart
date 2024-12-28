import 'dart:isolate';
export 'dart:isolate' show SendPort, ReceivePort;

class CustomRefinementHelper {
  static void entry(
      SendPort sendPort,
      bool Function(String filePath, String lineContent, String matchedString)
          callback) {
    final SendPort port = sendPort;
    final receivePort = ReceivePort();
    port.send(receivePort.sendPort);

    receivePort.listen((message) {
      if (message is Map<String, dynamic>) {
        final filePath = message['filePath'] as String;
        final lineContent = message['lineContent'] as String;
        final matchedString = message['matchedString'] as String;

        // Do the callback.
        final bool shouldExtract =
            callback(filePath, lineContent, matchedString);
        port.send(shouldExtract);
      }
    });
  }
}
