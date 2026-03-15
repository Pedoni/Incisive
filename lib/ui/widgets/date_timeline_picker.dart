import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';

class DateTimelinePicker extends StatelessWidget {
  final DateTime focusedDate;
  final ValueChanged<DateTime> onDateChange;

  const DateTimelinePicker({
    super.key,
    required this.focusedDate,
    required this.onDateChange,
  });

  @override
  Widget build(BuildContext context) {
    return EasyDateTimeLinePicker(
      focusedDate: focusedDate,
      firstDate: DateTime(2000, 1, 1),
      lastDate: DateTime(2030, 12, 31),
      timelineOptions: const TimelineOptions(height: 90),
      locale: Localizations.localeOf(context),
      onDateChange: onDateChange,
    );
  }
}
