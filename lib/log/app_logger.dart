import 'package:flutter/material.dart';

abstract class AppLogger {
  void log(String message);
  void logError(Object error, StackTrace? stackTrace);
  Future<void> downloadLog(BuildContext context);
  Future<void> clearLogs();
}
