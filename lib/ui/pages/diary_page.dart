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

  bool _emotionsOpen = false;
  bool _areasOpen = false;

  // Mappa icone emozioni (scegli quelle che vuoi)
  IconData _emotionIcon(String e) {
    switch (e.toLowerCase()) {
      case 'gioia':
        return Icons.sentiment_very_satisfied;
      case 'serenità':
        return Icons.self_improvement;
      case 'gratitudine':
        return Icons.favorite;
      case 'calma':
        return Icons.spa;
      case 'soddisfazione':
        return Icons.emoji_events;
      case 'tristezza':
        return Icons.sentiment_dissatisfied;
      case 'ansia':
        return Icons.psychology;
      case 'rabbia':
        return Icons.local_fire_department;
      case 'frustrazione':
        return Icons.report_problem;
      case 'paura':
        return Icons.warning_amber;
      default:
        return Icons.circle;
    }
  }

  bool _isPositiveEmotion(String e) {
    const pos = {'gioia', 'serenità', 'gratitudine', 'calma', 'soddisfazione'};
    return pos.contains(e.toLowerCase());
  }

  Widget _pill({
    required IconData icon,
    required Color bg,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Nunito Sans',
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _wrapPills({
    required List<Widget> children,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: children,
      ),
    );
  }

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
                  child: BlocConsumer<DiaryPageBloc, DiaryPageState>(
                    listener: (context, state) {
                      if (state is ResultDiaryPageState || state is EmptyDiaryPageState) {
                        setState(() {
                          _areasOpen = false;
                          _emotionsOpen = false;
                        });
                      }
                    },
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
                      final emotions = entry.emotions;
                      final gratitudeAreas = entry.gratitudeAreas;
                      final nonGratitudeAreas = entry.nonGratitudeAreas;

                      const green = Color(0xFF2E7D32);
                      const red = Color(0xFFC62828);

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
                              Theme(
                                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                                child: ExpansionTile(
                                  tilePadding: const EdgeInsets.symmetric(horizontal: 0),
                                  childrenPadding: const EdgeInsets.only(bottom: 6),
                                  onExpansionChanged: (open) {
                                    setState(() => _emotionsOpen = open);
                                  },
                                  title: const Text(
                                    "Emozioni",
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  trailing: AnimatedRotation(
                                    turns: _emotionsOpen ? 0.5 : 0.0, // 180°
                                    duration: const Duration(milliseconds: 200),
                                    child: const Icon(Icons.expand_more),
                                  ),
                                  children: [
                                    if (emotions.isEmpty)
                                      const SizedBox(height: 4)
                                    else
                                      _wrapPills(
                                        children:
                                            emotions.map((e) {
                                              final isPos = _isPositiveEmotion(e);
                                              return _pill(
                                                icon: _emotionIcon(e),
                                                bg: isPos ? green : red,
                                                label: e,
                                              );
                                            }).toList(),
                                      ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 6),
                              Theme(
                                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                                child: ExpansionTile(
                                  tilePadding: const EdgeInsets.symmetric(horizontal: 0),
                                  childrenPadding: const EdgeInsets.only(bottom: 6),
                                  title: const Text(
                                    "Aree della vita",
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  onExpansionChanged: (open) {
                                    setState(() => _areasOpen = open);
                                  },

                                  trailing: AnimatedRotation(
                                    turns: _areasOpen ? 0.5 : 0.0,
                                    duration: const Duration(milliseconds: 200),
                                    child: const Icon(Icons.expand_more),
                                  ),

                                  children: [
                                    if (gratitudeAreas.isEmpty && nonGratitudeAreas.isEmpty)
                                      const SizedBox(height: 4)
                                    else
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          if (gratitudeAreas.isNotEmpty) ...[
                                            const Padding(
                                              padding: EdgeInsets.only(left: 4, top: 6),
                                              child: Text(
                                                "Gratitudini",
                                                style: TextStyle(
                                                  fontFamily: 'Nunito Sans',
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                            ),
                                            _wrapPills(
                                              children:
                                                  gratitudeAreas
                                                      .map(
                                                        (a) => _pill(
                                                          icon: Icons.thumb_up,
                                                          bg: green,
                                                          label: a,
                                                        ),
                                                      )
                                                      .toList(),
                                            ),
                                          ],
                                          if (nonGratitudeAreas.isNotEmpty) ...[
                                            const Padding(
                                              padding: EdgeInsets.only(left: 4, top: 6),
                                              child: Text(
                                                "Difficoltà",
                                                style: TextStyle(
                                                  fontFamily: 'Nunito Sans',
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                            ),
                                            _wrapPills(
                                              children:
                                                  nonGratitudeAreas
                                                      .map(
                                                        (a) => _pill(
                                                          icon: Icons.thumb_down,
                                                          bg: red,
                                                          label: a,
                                                        ),
                                                      )
                                                      .toList(),
                                            ),
                                          ],
                                        ],
                                      ),
                                  ],
                                ),
                              ),
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
