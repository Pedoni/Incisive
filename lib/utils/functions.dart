String toSqlDate(DateTime d) =>
    "${d.year.toString().padLeft(4, '0')}-"
    "${d.month.toString().padLeft(2, '0')}-"
    "${d.day.toString().padLeft(2, '0')}";

DateTime startOfDay(DateTime date) => DateTime(date.year, date.month, date.day);

DateTime startOfNextDay(DateTime date) => DateTime(date.year, date.month, date.day).add(const Duration(days: 1));
