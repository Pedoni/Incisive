import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:incisive/models/gratitude_model.dart';
import 'package:incisive/navigation/app_routes.dart';
import 'package:incisive/navigation/args/upsert_gratitude_args.dart';
import 'package:incisive/state_management/blocs/base/base_bloc.dart';
import 'package:incisive/state_management/blocs/gratitude_page/gratitude_page_bloc.dart';
import 'package:incisive/ui/widgets/app_skeletonizer.dart';
import 'package:incisive/ui/widgets/date_timeline_picker.dart';
import 'package:incisive/ui/widgets/empty_widget.dart';
import 'package:incisive/ui/widgets/state_error_view.dart';
import 'package:incisive/utils/constants.dart';
import 'package:incisive/utils/incisive_colors.dart';

class GratitudePage extends StatefulWidget {
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
    context.read<GratitudePageBloc>().getGratitudePage(_selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Text(
          "Gratitude",
          style: TextStyle(
            fontSize: 25,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: IncisiveColors.primary,
          ),
        ),
        foregroundColor: IncisiveColors.primary,
        backgroundColor: IncisiveColors.background,
      ),
      floatingActionButton: BlocBuilder<GratitudePageBloc, BaseState>(
        builder: (context, state) {
          return FloatingActionButton(
            backgroundColor: IncisiveColors.primary,
            onPressed: switch (state) {
              Initial() || Loading() || Error() => null,
              Empty(data: final entry) || Success(data: final entry) => () {
                context.push(
                  AppRoutes.upsertGratitude,
                  extra: UpsertGratitudeArgs(date: _selectedDate, page: entry),
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
        color: IncisiveColors.background,
        child: SafeArea(
          child: SizedBox(
            height: double.infinity,
            child: Padding(
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
                        context.read<GratitudePageBloc>().getGratitudePage(date);
                      }),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Expanded(
                    child: BlocBuilder<GratitudePageBloc, BaseState>(
                      builder: (context, state) {
                        if (state is Empty) {
                          return const EmptyWidget(text: "Nessuna informazione inserita");
                        } else if (state is Error) {
                          return const StateErrorView(message: 'Errore nel caricamento');
                        }

                        final entry = state is Success
                            ? state.data as GratitudeModel
                            : Constants.mockedGratitudeEntry;

                        return SingleChildScrollView(
                          physics: state is Loading
                              ? const NeverScrollableScrollPhysics()
                              : const BouncingScrollPhysics(),
                          child: AppSkeletonizer(
                            enabled: state is Loading || state is Initial,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (state is Success) ...[
                                  const Text(
                                    "Sono grato per...",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.bold,
                                      color: IncisiveColors.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                ],
                                ...entry.list!.map(
                                  (e) => Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 4,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      padding: const EdgeInsets.all(16),
                                      child: Text(
                                        e,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Nunito Sans',
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
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
      ),
    );
  }
}