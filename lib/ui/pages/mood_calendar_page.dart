import 'package:flutter/material.dart';
import 'package:incisive/ui/components/mood_calendar.dart';

class MoodCalendarPage extends StatelessWidget {
  static const routeName = '/moodCalendarPage';

  const MoodCalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(
          "Mood tracker",
          style: TextStyle(
            fontSize: 25,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 141, 90, 35),
          ),
        ),
        foregroundColor: Color.fromARGB(255, 141, 90, 35),
        backgroundColor: const Color(0xFFFFF8E8),
      ),
      body: MoodCalendar(
        moodValues: {
          DateTime(2025, 12, 1): -1,
          DateTime(2025, 12, 2): -0.6,
          DateTime(2025, 12, 3): 0,
          DateTime(2025, 12, 4): 0.7,
          DateTime(2025, 12, 5): 1.0,
        },
      ),
    );
  }
}
