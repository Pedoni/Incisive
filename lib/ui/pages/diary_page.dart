import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:incisive/state_management/blocs/diary_page_bloc/diary_page_bloc.dart';
import 'package:incisive/ui/widgets/mood_gauge.dart';
import 'package:incisive/utils/constants.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DiaryPage extends StatefulWidget {
  const DiaryPage({super.key});

  static const routeName = '/diaryPage';

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
      ),

      floatingActionButton: BlocBuilder<DiaryPageBloc, DiaryPageState>(
        builder: (context, state) {
          return FloatingActionButton(
            backgroundColor: Color.fromARGB(255, 141, 90, 35),
            onPressed: switch (state) {
              InitDiaryPageState() || TryDiaryPageState() || ErrorDiaryPageState() => null,
              EmptyDiaryPageState() => () {},
              ResultDiaryPageState(text: final text) => () {},
            },
            child: switch (state) {
              InitDiaryPageState() || TryDiaryPageState() || ErrorDiaryPageState() => null,
              EmptyDiaryPageState() => Icon(Icons.add, color: Colors.white),
              ResultDiaryPageState(text: final text) => Icon(Icons.edit, color: Colors.white),
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
                SizedBox(height: 30),
                Divider(
                  height: 0,
                  thickness: 1,
                  color: Colors.grey,
                ),

                Expanded(
                  child: BlocBuilder<DiaryPageBloc, DiaryPageState>(
                    builder: (context, state) {
                      if (state is EmptyDiaryPageState) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 42,
                                color: Colors.black54,
                              ),
                              SizedBox(height: 10),
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
                      }
                      final text = state is ResultDiaryPageState ? state.text : Constants.mockedDiaryEntry.text;
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
                              switch (state) {
                                ErrorDiaryPageState() => Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.error),
                                      SizedBox(height: 5),
                                      Text(
                                        "Errore nel caricamento",
                                        style: TextStyle(fontFamily: 'Nunito Sans'),
                                      ),
                                    ],
                                  ),
                                ),
                                EmptyDiaryPageState() => Center(child: Text("Nessuna informazione inserita")),
                                _ => Column(
                                  children: [
                                    if (state is ResultDiaryPageState) MoodGauge(mood: 0),
                                    Text(
                                      text,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        height: 1.4,
                                        fontFamily: "Nunito Sans",
                                      ),
                                    ),
                                  ],
                                ),
                              },
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
