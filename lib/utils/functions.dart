import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String toSqlDate(DateTime d) =>
    "${d.year.toString().padLeft(4, '0')}-"
    "${d.month.toString().padLeft(2, '0')}-"
    "${d.day.toString().padLeft(2, '0')}";

String formatDateItalian(DateTime date) {
  final formatter = DateFormat('d MMMM y', 'it_IT');
  return formatter.format(date);
}

DateTime startOfDayUtc(DateTime date) => DateTime.utc(date.year, date.month, date.day);

DateTime startOfNextDayUtc(DateTime date) => startOfDayUtc(date).add(const Duration(days: 1));

typedef JsonObject = Map<String, dynamic>;

typedef JsonArray = List<JsonObject>;

String formatDateTime(DateTime dateTime) {
  final day = dateTime.day.toString().padLeft(2, '0');
  final month = dateTime.month.toString().padLeft(2, '0');
  final year = dateTime.year;

  final hour = dateTime.hour.toString().padLeft(2, '0');
  final minute = dateTime.minute.toString().padLeft(2, '0');

  return "$day/$month/$year, $hour:$minute";
}

Color getUserBackgroundColor(int userLevel) {
  return switch (userLevel) {
    >= 100 => const Color.fromARGB(255, 224, 191, 0),
    >= 75 => const Color.fromARGB(255, 185, 185, 185),
    >= 50 => const Color.fromARGB(255, 184, 115, 51),
    >= 20 => Colors.red,
    >= 10 => Colors.green,
    >= 5 => Colors.blue,
    _ => const Color.fromARGB(255, 217, 216, 216),
  };
}
