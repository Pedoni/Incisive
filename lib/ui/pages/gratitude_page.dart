import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:incisive/state_management/blocs/gratitude_page/gratitude_page_bloc.dart';
import 'package:incisive/ui/pages/gratitude_upsert_page.dart';
import 'package:incisive/utils/constants.dart';
import 'package:lottie/lottie.dart';

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
    context.read<GratitudePageBloc>().getGratitudePage(_selectedDate);
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

      floatingActionButton: BlocBuilder<GratitudePageBloc, GratitudePageState>(
        builder: (context, state) {
          return FloatingActionButton(
            backgroundColor: Color.fromARGB(255, 141, 90, 35),
            onPressed: switch (state) {
              InitialGratitudeState() || LoadingGratitudeState() || ErrorGratitudeState() => null,
              EmptyGratitudeState() => () {
                Navigator.pushNamed(
                  context,
                  GratitudeUpsertPage.routeName,
                  arguments: [null],
                );
              },
              ResultGratitudeState(entry: final entry) => () {
                Navigator.pushNamed(
                  context,
                  GratitudeUpsertPage.routeName,
                  arguments: [entry],
                );
              },
            },
            child: switch (state) {
              InitialGratitudeState() || LoadingGratitudeState() || ErrorGratitudeState() => null,
              EmptyGratitudeState() => Icon(Icons.add, color: Colors.white),
              ResultGratitudeState(entry: final entry) => Icon(Icons.edit, color: Colors.white),
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
                          context.read<GratitudePageBloc>().getGratitudePage(date);
                        }),
                  ),
                ),
                SizedBox(height: 30),

                Expanded(
                  child: BlocBuilder<GratitudePageBloc, GratitudePageState>(
                    builder: (context, state) {
                      if (state is EmptyGratitudeState) {
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
                      } else if (state is ErrorGratitudeState) {
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
                      final entry = state is ResultGratitudeState ? state.entry : Constants.mockedGratitudeEntry;
                      return SingleChildScrollView(
                        physics: state is LoadingGratitudeState ? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics(),
                        child: Skeletonizer(
                          effect: const ShimmerEffect(
                            baseColor: Color.fromARGB(255, 238, 229, 207),
                            highlightColor: Color.fromARGB(255, 217, 204, 173),
                            duration: Duration(seconds: 1),
                          ),
                          enabled: state is LoadingGratitudeState || state is InitialGratitudeState,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (state is ResultGratitudeState) ...[
                                Text(
                                  "Sono grato per...",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 141, 90, 35),
                                  ),
                                ),
                                SizedBox(height: 16),
                              ],
                              ...(entry.list
                                  .map(
                                    (e) => Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(12),
                                          boxShadow: [
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
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Nunito Sans',
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList()),
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
