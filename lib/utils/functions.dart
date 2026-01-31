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
