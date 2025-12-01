import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:incisive/state_management/blocs/diary_page_bloc/diary_page_bloc.dart';
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
          "Daily gratitude",
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

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Color.fromARGB(255, 141, 90, 35),

        child: Icon(Icons.chat, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Container(
        decoration: BoxDecoration(color: const Color(0xFFFFF8E8)),
        child: SafeArea(
          child: Container(
            height: double.infinity,
            decoration: BoxDecoration(color: const Color(0xFFFFF8E8)),
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
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

                const Divider(height: 32),

                Expanded(
                  child: ListView(
                    children: [
                      BlocBuilder<DiaryPageBloc, DiaryPageState>(
                        builder: (context, state) {
                          final text = state is ResultDiaryPageState ? state.text : Constants.mockedDiaryEntry.text;
                          return Skeletonizer(
                            effect: const ShimmerEffect(
                              baseColor: Color.fromARGB(255, 238, 229, 207),
                              highlightColor: Color.fromARGB(255, 217, 204, 173),
                              duration: Duration(seconds: 1),
                            ),
                            enabled: state is! ResultDiaryPageState,
                            child:
                                text.isEmpty
                                    ? Center(child: Text("Nessuna informazione inserita"))
                                    : Text(
                                      text,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        height: 1.4,
                                        fontFamily: "Nunito Sans",
                                      ),
                                    ),
                          );
                        },
                      ),
                    ],
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
