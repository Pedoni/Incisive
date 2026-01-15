import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:incisive/models/social_post_model.dart';
import 'package:incisive/state_management/blocs/base/base_bloc.dart';
import 'package:incisive/state_management/blocs/social/social_bloc.dart';
import 'package:incisive/ui/pages/add_post_page.dart';
import 'package:incisive/ui/widgets/social_post_item.dart';
import 'package:incisive/utils/constants.dart';
import 'package:lottie/lottie.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SocialPage extends StatefulWidget {
  static const routeName = '/socialPage';

  const SocialPage({super.key});

  @override
  State<SocialPage> createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();

    context.read<SocialBloc>().getDailyPosts(_selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E8),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 141, 90, 35),

        onPressed:
            () => Navigator.pushNamed(
              context,
              AddPostPage.routeName,
              arguments: [_selectedDate, null],
            ),
        child: Icon(Icons.add, color: Colors.white),
      ),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Text(
          "Bacheca",
          style: TextStyle(
            fontSize: 25,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 141, 90, 35),
          ),
        ),
        foregroundColor: const Color.fromARGB(255, 141, 90, 35),
        backgroundColor: const Color(0xFFFFF8E8),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Center(
                child: EasyDateTimeLinePicker(
                  focusedDate: _selectedDate,
                  firstDate: DateTime(2000, 1, 1),
                  lastDate: DateTime(2030, 12, 31),
                  timelineOptions: const TimelineOptions(height: 90),
                  locale: Localizations.localeOf(context),
                  onDateChange: (date) {
                    setState(() => _selectedDate = date);
                    context.read<SocialBloc>().add(GetDailySocialPostsEvent(date));
                  },
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: BlocBuilder<SocialBloc, BaseState>(
                  builder: (context, state) {
                    if (state is Loading || state is Initial) {
                      final list = List.generate(10, (index) => Constants.mockedPostItem);
                      return Skeletonizer(
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 10,
                          itemBuilder: (context, index) => SocialPostItem(post: list[index]),
                        ),
                      );
                    }

                    if (state is Error) {
                      return Center(
                        child: Text(
                          "Errore nel caricamento",
                          style: TextStyle(
                            fontFamily: 'Nunito Sans',
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                      );
                    }

                    if (state is Empty) {
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
                            const SizedBox(height: 24),
                            const Text(
                              "Nessuno ha condiviso nulla oggi",
                              style: TextStyle(
                                fontFamily: 'Nunito Sans',
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    if (state is Success<List<SocialPostModel>>) {
                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: state.data.length,
                        itemBuilder: (context, index) {
                          return SocialPostItem(post: state.data[index]);
                        },
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
