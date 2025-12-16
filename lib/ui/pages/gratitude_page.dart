import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:incisive/state_management/blocs/diary_page_bloc/diary_page_bloc.dart';
import 'package:incisive/ui/pages/diary_upsert_page.dart';
import 'package:skeletonizer/skeletonizer.dart';

class GratitudePage extends StatefulWidget {
  static const routeName = '/gratitudePage';

  const GratitudePage({super.key});

  @override
  State<GratitudePage> createState() => _GratitudePageState();
}

class _GratitudePageState extends State<GratitudePage> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    context.read<DiaryPageBloc>().getPage(_selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(
          "Gratitude",
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

      floatingActionButton: BlocBuilder<DiaryPageBloc, DiaryPageState>(
        builder: (context, state) {
          return FloatingActionButton(
            backgroundColor: Color.fromARGB(255, 141, 90, 35),
            onPressed: switch (state) {
              InitDiaryPageState() || TryDiaryPageState() || ErrorDiaryPageState() => null,
              EmptyDiaryPageState() => () {
                Navigator.pushNamed(
                  context,
                  UpsertDiaryPage.routeName,
                  arguments: [_selectedDate, null],
                );
              },
              ResultDiaryPageState(entry: final entry) => () {
                Navigator.pushNamed(
                  context,
                  UpsertDiaryPage.routeName,
                  arguments: [_selectedDate, entry],
                );
              },
            },
            child: switch (state) {
              InitDiaryPageState() || TryDiaryPageState() || ErrorDiaryPageState() => null,
              EmptyDiaryPageState() => Icon(Icons.add, color: Colors.white),
              ResultDiaryPageState(entry: final entry) => Icon(Icons.edit, color: Colors.white),
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Container(
        decoration: BoxDecoration(color: const Color(0xFFFFF8E8)),
        child: SafeArea(
          child: Container(
            height: double.infinity,
            decoration: BoxDecoration(color: const Color(0xFFFFF8E8)),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: EasyDateTimeLinePicker(
                    focusedDate: _selectedDate,
                    firstDate: DateTime(2000, 1, 1),
                    lastDate: DateTime(2030, 12, 31),
                    timelineOptions: TimelineOptions(height: 90),
                    locale: Localizations.localeOf(context),
                    onDateChange:
                        (date) => setState(() {
                          _selectedDate = date;
                          context.read<DiaryPageBloc>().getPage(date);
                        }),
                  ),
                ),
                SizedBox(height: 20),

                Expanded(
                  child: SizedBox(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
