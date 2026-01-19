import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import 'app_logger.dart';

class WebLogger implements AppLogger {
  final List<String> _buffer = [];

  @override
  void log(String message) {
    final line = '${DateTime.now()}: $message';
    _buffer.add(line);
    debugPrint(line);
  }

  @override
  void logError(Object error, StackTrace? stackTrace) {
    log('Error: $error\nStackTrace: $stackTrace');
  }

  @override
  Future<void> downloadLog(BuildContext context) async {
    final content = _buffer.join('\n');

    await FilePicker.platform.saveFile(
      fileName: 'log-web.txt',
      bytes: Uint8List.fromList(content.codeUnits),
    );
  }

  @override
  Future<void> clearLogs() async {
    _buffer.clear();
  }
}
