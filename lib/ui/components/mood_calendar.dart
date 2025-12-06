import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MoodCalendar extends StatefulWidget {
  final Map<DateTime, double> moodValues;

  const MoodCalendar({
    super.key,
    required this.moodValues,
  });

  @override
  State<MoodCalendar> createState() => _MoodCalendarState();
}

class _MoodCalendarState extends State<MoodCalendar> {
  late DateTime _focusedMonth;

  @override
  void initState() {
    super.initState();
    _focusedMonth = DateTime.now();
  }

  void _prevMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final days = _generateDays(_focusedMonth);

    return Container(
      decoration: BoxDecoration(color: const Color(0xFFFFF8E8)),
      padding: EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildHeader(),
          const SizedBox(height: 12),
          _buildWeekDaysRow(),
          const SizedBox(height: 6),
          _buildCalendarGrid(days),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final name = DateFormat.yMMMM().format(_focusedMonth);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: _prevMonth,
          icon: const Icon(
            Icons.chevron_left,
            color: Color.fromARGB(255, 141, 90, 35),
          ),
        ),
        Text(
          name,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: "Poppins",
            color: Color.fromARGB(255, 141, 90, 35),
          ),
        ),
        IconButton(
          onPressed: _nextMonth,
          icon: const Icon(
            Icons.chevron_right,
            color: Color.fromARGB(255, 141, 90, 35),
          ),
        ),
      ],
    );
  }

  Widget _buildWeekDaysRow() {
    const days = ["L", "M", "M", "G", "V", "S", "D"];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        for (final day in days)
          Text(
            day,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: "Nunito Sans",
              fontWeight: FontWeight.bold,
            ),
          ),
      ],
    );
  }

  Widget _buildCalendarGrid(List<DateTime> days) {
    return Expanded(
      child: GridView.builder(
        itemCount: days.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemBuilder: (_, index) {
          final day = days[index];
          final inMonth = day.month == _focusedMonth.month;

          final mood = widget.moodValues[DateTime(day.year, day.month, day.day)];

          final color =
              !inMonth
                  ? Colors.grey.withOpacity(0.1) // fuori mese
                  : mood == null
                  ? Colors.grey.withOpacity(0.25) // nessun dato
                  : moodToColor(mood); // colore mood

          return Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(6),
            ),
            alignment: Alignment.center,
            child: Text(
              "${day.day}",
              style: TextStyle(
                color: inMonth ? Colors.black : Colors.grey,
                fontSize: 14,
              ),
            ),
          );
        },
      ),
    );
  }

  List<DateTime> _generateDays(DateTime month) {
    final first = DateTime(month.year, month.month, 1);

    // Allinea la griglia al lunedì
    final start = first.subtract(Duration(days: first.weekday - 1));

    final last = DateTime(month.year, month.month + 1, 0);
    final end = last.add(Duration(days: 7 - last.weekday));

    final days = <DateTime>[];

    for (DateTime d = start; !d.isAfter(end); d = d.add(const Duration(days: 1))) {
      days.add(d);
    }

    return days;
  }
}

Color moodToColor(double v) {
  v = v.clamp(-1.0, 1.0);
  final t = (v + 1) / 2;

  const red = Color(0xFFE53935);
  const yellow = Color(0xFFFFEB3B);
  const green = Color(0xFF43A047);

  return t < 0.5 ? Color.lerp(red, yellow, t * 2)! : Color.lerp(yellow, green, (t - 0.5) * 2)!;
}
