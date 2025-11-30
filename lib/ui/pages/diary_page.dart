import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:incisive/models/diary_model.dart';
import 'package:incisive/utils/constants.dart';
import 'package:intl/intl.dart';

class DiaryPage extends StatefulWidget {
  const DiaryPage({super.key});

  static const routeName = '/diaryPage';

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  late DateTime _selectedDate;

  DateTime getDateForIndex(int index) {
    return DateTime.now().add(Duration(days: index));
  }

  DiaryEntry getEntryForIndex(int index) {
    final date = getDateForIndex(index);
    final text =
        "Pensieri del giorno\n\n"
        "Questa è una pagina di diario di esempio.\n"
        "La data attuale è:\n\n"
        "${DateFormat('dd/MM/yyyy').format(date)}\n\n"
        "Puoi aggiungere contenuti personalizzati qui.";
    return DiaryEntry(date, text);
  }

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final entry = Constants.mockedDiaryEntry;
    return Scaffold(
      backgroundColor: Colors.brown.shade100,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Color.fromARGB(255, 141, 90, 35),

        child: Icon(Icons.chat, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Material(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(color: const Color(0xFFFFF8E8)),
          child: SafeArea(
            child: Container(
              height: double.infinity,
              decoration: BoxDecoration(color: const Color(0xFFFFF8E8)),
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Daily gratitude",
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 141, 90, 35),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: EasyDateTimeLinePicker(
                        focusedDate: _selectedDate,
                        firstDate: DateTime(2000, 1, 1),
                        lastDate: DateTime(2030, 12, 31),
                        timelineOptions: TimelineOptions(height: 100),
                        locale: Localizations.localeOf(context),
                        onDateChange: (date) => setState(() => _selectedDate = date),
                      ),
                    ),

                    const Divider(height: 32),

                    Text(
                      entry.text,
                      style: const TextStyle(
                        fontSize: 18,
                        height: 1.4,
                        fontFamily: "Nunito Sans",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
