import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:incisive/models/diary_model.dart';
import 'package:incisive/navigation/app_routes.dart';
import 'package:incisive/navigation/args/upsert_diary_args.dart';
import 'package:incisive/state_management/blocs/base/base_bloc.dart';
import 'package:incisive/state_management/blocs/diary_page/diary_page_bloc.dart';
import 'package:incisive/ui/components/lined_paper.dart';
import 'package:incisive/ui/widgets/app_skeletonizer.dart';
import 'package:incisive/ui/widgets/date_timeline_picker.dart';
import 'package:incisive/ui/widgets/empty_widget.dart';
import 'package:incisive/ui/widgets/page_detail_appbar.dart';
import 'package:incisive/ui/widgets/state_error_view.dart';
import 'package:incisive/utils/constants.dart';
import 'package:incisive/utils/incisive_colors.dart';

class DiaryPage extends StatefulWidget {
  const DiaryPage({super.key});

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  late DateTime _selectedDate;

  bool _emotionsOpen = false;
  bool _areasOpen = false;

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

  Widget _pill({required IconData icon, required Color bg, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
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

  Widget _wrapPills({required List<Widget> children}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Wrap(spacing: 10, runSpacing: 10, children: children),
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
      appBar: PageDetailAppbar(title: "Diario"),
      floatingActionButton: BlocBuilder<DiaryPageBloc, BaseState>(
        builder: (context, state) {
          return FloatingActionButton(
            backgroundColor: const Color.fromARGB(255, 141, 90, 35),
            onPressed: switch (state) {
              Initial() || Loading() || Error() => null,
              Empty() => () {
                context.push(
                  AppRoutes.upsertDiary,
                  extra: UpsertDiaryArgs(_selectedDate, null),
                );
              },
              Success(data: final entry) => () {
                context.push(
                  AppRoutes.upsertDiary,
                  extra: UpsertDiaryArgs(_selectedDate, entry),
                );
              },
            },
            child: switch (state) {
              Initial() || Loading() || Error() => null,
              Empty() => const Icon(Icons.add, color: Colors.white),
              Success() => const Icon(Icons.edit, color: Colors.white),
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Container(
        decoration: const BoxDecoration(color: Color(0xFFFFF8E8)),
        child: SafeArea(
          child: Container(
            height: double.infinity,
            decoration: const BoxDecoration(color: Color(0xFFFFF8E8)),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: DateTimelinePicker(
                    focusedDate: _selectedDate,
                    onDateChange: (date) => setState(() {
                      _selectedDate = date;
                      context.read<DiaryPageBloc>().getPage(date);
                    }),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: BlocConsumer<DiaryPageBloc, BaseState>(
                    listener: (context, state) {
                      if (state is Success || state is Empty) {
                        setState(() {
                          _areasOpen = false;
                          _emotionsOpen = false;
                        });
                      }
                    },
                    builder: (context, state) {
                      if (state is Empty) {
                        return const EmptyWidget(text: "Nessuna informazione inserita");
                      } else if (state is Error) {
                        return const StateErrorView(message: 'Errore nel caricamento');
                      }

                      final entry = state is Success ? state.data as DiaryModel : Constants.mockedDiaryEntry;
                      final emotions = entry.emotions;
                      final gratitudeAreas = entry.gratitudeAreas;
                      final nonGratitudeAreas = entry.nonGratitudeAreas;

                      const green = Color(0xFF2E7D32);
                      const red = Color(0xFFC62828);

                      return SingleChildScrollView(
                        physics: state is Loading
                            ? const NeverScrollableScrollPhysics()
                            : const BouncingScrollPhysics(),
                        child: AppSkeletonizer(
                          enabled: state is Initial || state is Loading,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Theme(
                                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                                child: ExpansionTile(
                                  tilePadding: const EdgeInsets.symmetric(horizontal: 0),
                                  childrenPadding: const EdgeInsets.only(bottom: 6),
                                  onExpansionChanged: (open) => setState(() => _emotionsOpen = open),
                                  title: const Text(
                                    "Emozioni",
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  trailing: AnimatedRotation(
                                    turns: _emotionsOpen ? 0.5 : 0.0,
                                    duration: const Duration(milliseconds: 200),
                                    child: const Icon(Icons.expand_more),
                                  ),
                                  children: [
                                    if (emotions.isEmpty)
                                      const SizedBox(height: 4)
                                    else
                                      _wrapPills(
                                        children: emotions.map((e) {
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
                                  onExpansionChanged: (open) => setState(() => _areasOpen = open),
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
                                              children: gratitudeAreas
                                                  .map((a) => _pill(icon: Icons.thumb_up, bg: green, label: a))
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
                                              children: nonGratitudeAreas
                                                  .map((a) => _pill(icon: Icons.thumb_down, bg: red, label: a))
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
                                enabled: state is Success,
                                text: entry.text,
                                style: const TextStyle(
                                  fontSize: 20,
                                  height: 1.4,
                                  fontFamily: "Nunito Sans",
                                ),
                              ),
                              if (state is Success) ...[
                                const SizedBox(height: 40),
                                GestureDetector(
                                  onTap: () {
                                    context.read<DiaryPageBloc>().updatePrivacy(
                                          _selectedDate,
                                          !entry.isPrivate,
                                        );
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: entry.isPrivate
                                          ? IncisiveColors.primary.withValues(alpha: 0.12)
                                          : const Color.fromARGB(255, 241, 218, 192),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: entry.isPrivate
                                            ? IncisiveColors.primary
                                            : Colors.transparent,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          entry.isPrivate
                                              ? Icons.lock
                                              : Icons.lock_open_outlined,
                                          size: 20,
                                          color: IncisiveColors.primary,
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                entry.isPrivate
                                                    ? 'Voce privata'
                                                    : 'Condividi con Pixel',
                                                style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                  color: IncisiveColors.primary,
                                                ),
                                              ),
                                              Text(
                                                entry.isPrivate
                                                    ? 'Pixel non leggerà questa pagina'
                                                    : 'Pixel usa questa pagina per conoscerti meglio',
                                                style: const TextStyle(
                                                  fontFamily: 'Nunito Sans',
                                                  fontSize: 11,
                                                  color: Color(0xFF7A6050),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Switch(
                                          value: !entry.isPrivate,
                                          onChanged: (val) {
                                            context
                                                .read<DiaryPageBloc>()
                                                .updatePrivacy(
                                                  _selectedDate,
                                                  !val,
                                                );
                                          },
                                          activeThumbColor: IncisiveColors.primary,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 80),
                              ],
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