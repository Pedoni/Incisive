import 'package:flutter/material.dart';
import 'package:incisive/log/file_logger.dart';
import 'package:logger/logger.dart';

class MainLogger {
  static void logFlutterError(FlutterErrorDetails errorDetails) async {
    FileLogger.logError(errorDetails.exception, errorDetails.stack);
    FlutterError.dumpErrorToConsole(errorDetails);
  }

  static void logError(Object error, StackTrace? stackTrace) async {
    FileLogger.logError(error, stackTrace);
    Logger().e(error.toString(), error: error, stackTrace: stackTrace, time: DateTime.now());
  }

  static void logInfo(String message, {bool? onlyConsole}) async {
    if (!(onlyConsole ?? false)) FileLogger.log(message);
    Logger().i(message, time: DateTime.now());
  }
}
