import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:incisive/state_management/blocs/diary_page_bloc/diary_page_bloc.dart';
import 'package:incisive/state_management/blocs/mood_tracker_bloc/mood_tracker_bloc.dart';
import 'package:incisive/ui/components/lined_paper.dart';
import 'package:incisive/ui/pages/diary_upsert_page.dart';
import 'package:incisive/ui/pages/mood_calendar_page.dart';
import 'package:incisive/utils/constants.dart';
import 'package:lottie/lottie.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DiaryPage extends StatefulWidget {
  static const routeName = '/diaryPage';

  const DiaryPage({super.key});

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
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
          "Diario",
          style: TextStyle(
            fontSize: 25,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 141, 90, 35),
          ),
        ),
        foregroundColor: Color.fromARGB(255, 141, 90, 35),
        backgroundColor: const Color(0xFFFFF8E8),
        actions: [
          IconButton(
            onPressed: () {
              context.read<MoodTrackerBloc>().getMood();
              Navigator.pushNamed(
                context,
                MoodCalendarPage.routeName,
              );
            },
            icon: Icon(Icons.track_changes),
          ),
        ],
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
              ResultDiaryPageState(entry: final _) => Icon(Icons.edit, color: Colors.white),
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
                  child: BlocBuilder<DiaryPageBloc, DiaryPageState>(
                    builder: (context, state) {
                      if (state is EmptyDiaryPageState) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Lottie.asset(
                                "assets/animations/empty_state.json",
                                width: 200,
                                height: 200,
                                repeat: false,
                              ),
                              SizedBox(height: 30),
                              Text(
                                "Nessuna informazione inserita",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Nunito Sans',
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (state is ErrorDiaryPageState) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error,
                                size: 42,
                                color: Colors.black54,
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Errore nel caricamento",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Nunito Sans',
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      final entry = state is ResultDiaryPageState ? state.entry : Constants.mockedDiaryEntry;
                      return SingleChildScrollView(
                        physics: state is TryDiaryPageState ? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics(),
                        child: Skeletonizer(
                          effect: const ShimmerEffect(
                            baseColor: Color.fromARGB(255, 238, 229, 207),
                            highlightColor: Color.fromARGB(255, 217, 204, 173),
                            duration: Duration(seconds: 1),
                          ),
                          enabled: state is TryDiaryPageState || state is InitDiaryPageState,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),
                              LinedPaper(
                                enabled: state is ResultDiaryPageState,
                                text: entry.text,
                                style: const TextStyle(
                                  fontSize: 20,
                                  height: 1.4,
                                  fontFamily: "Nunito Sans",
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
