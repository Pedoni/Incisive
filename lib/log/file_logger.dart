import 'dart:io';

import 'package:flutter/material.dart';
import 'package:incisive/log/main_logger.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';

class FileLogger {
  static Future<Directory> get logsDirPath async {
    final directory = await getApplicationDocumentsDirectory();
    Directory logsDirectory = Directory('${directory.path}/logs');
    if (!logsDirectory.existsSync()) {
      logsDirectory.createSync();
    }
    return logsDirectory;
  }

  static Future<void> removeLogs() async {
    final logDirectory = await logsDirPath;
    List<FileSystemEntity> files = logDirectory.listSync();
    String logFilePath = await getLogFilePath;
    for (var file in files) {
      if (file is File && file.path != logFilePath) {
        file.deleteSync();
        MainLogger.logInfo('Cancellato il file di log ${file.path}', onlyConsole: true);
      }
    }
  }

  static Future<String> get getLogFilePath async {
    final directory = await logsDirPath;
    final date = DateTime.now();
    final dateName = DateFormat('dd-MM-yyyy').format(date);
    return '${directory.path}/log-mapp-$dateName.txt';
  }

  static void log(String message) async {
    final filePath = await getLogFilePath;
    File(filePath).writeAsStringSync('${DateTime.now()}: $message\n', mode: FileMode.append);
  }

  static void logError(Object error, StackTrace? stackTrace) async {
    final errorLog = 'Error: $error\nStackTrace: $stackTrace';
    log(errorLog);
  }

  static Future<void> downloadLog(BuildContext context) async {
    final String filePath = await getLogFilePath;
    final File logFile = File(filePath);
    if (await logFile.exists()) {
      String? selectedDirectory = await FilePicker.platform.saveFile(
        fileName: path.basename(logFile.path),
        bytes: logFile.readAsBytesSync(),
      );
      MainLogger.logInfo('File di log salvato correttamente in $selectedDirectory', onlyConsole: true);
    } else {
      const snackBar = SnackBar(
        content: Text('Nessun log da scaricare!', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      MainLogger.logInfo('File di log non presente', onlyConsole: true);
    }
  }
}
