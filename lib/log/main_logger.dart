import 'package:flutter/material.dart';
import 'package:incisive/log/app_logger.dart';
import 'package:logger/logger.dart';

class MainLogger {
  static late AppLogger _logger;

  static void init(AppLogger logger) {
    _logger = logger;
  }

  static void logFlutterError(FlutterErrorDetails errorDetails) {
    _logger.logError(errorDetails.exception, errorDetails.stack);
    FlutterError.dumpErrorToConsole(errorDetails);
  }

  static void logError(Object error, StackTrace? stackTrace) {
    _logger.logError(error, stackTrace);
    Logger().e(
      error.toString(),
      error: error,
      stackTrace: stackTrace,
      time: DateTime.now(),
    );
  }

  static void logInfo(String message, {bool onlyConsole = false}) {
    if (!onlyConsole) {
      _logger.log(message);
    }
    Logger().i(message, time: DateTime.now());
  }
}
