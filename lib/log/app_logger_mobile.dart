import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';

import 'app_logger.dart';

class MobileFileLogger implements AppLogger {
  Future<Directory> get _logsDir async {
    final directory = await getApplicationDocumentsDirectory();
    final dir = Directory('${directory.path}/logs');
    if (!dir.existsSync()) dir.createSync();
    return dir;
  }

  Future<String> get _logFilePath async {
    final date = DateFormat('dd-MM-yyyy').format(DateTime.now());
    final dir = await _logsDir;
    return '${dir.path}/log-mapp-$date.txt';
  }

  @override
  void log(String message) async {
    final filePath = await _logFilePath;
    File(filePath).writeAsStringSync(
      '${DateTime.now()}: $message\n',
      mode: FileMode.append,
    );
  }

  @override
  void logError(Object error, StackTrace? stackTrace) {
    log('Error: $error\nStackTrace: $stackTrace');
  }

  @override
  Future<void> downloadLog(BuildContext context) async {
    final filePath = await _logFilePath;
    final file = File(filePath);
    if (!await file.exists()) return;

    await FilePicker.platform.saveFile(
      fileName: path.basename(filePath),
      bytes: await file.readAsBytes(),
    );
  }

  @override
  Future<void> clearLogs() async {
    final dir = await _logsDir;
    for (final f in dir.listSync()) {
      if (f is File) f.deleteSync();
    }
  }
}
