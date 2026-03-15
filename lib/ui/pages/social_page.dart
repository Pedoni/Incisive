import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:incisive/models/post_model.dart';
import 'package:incisive/navigation/app_routes.dart';
import 'package:incisive/state_management/blocs/base/base_bloc.dart';
import 'package:incisive/state_management/blocs/social/social_bloc.dart';
import 'package:incisive/ui/widgets/date_timeline_picker.dart';
import 'package:incisive/ui/widgets/empty_widget.dart';
import 'package:incisive/ui/widgets/social_post_item.dart';
import 'package:incisive/ui/widgets/state_error_view.dart';
import 'package:incisive/utils/constants.dart';
import 'package:incisive/utils/incisive_colors.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SocialPage extends StatefulWidget {
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
      backgroundColor: IncisiveColors.background,
      floatingActionButton: FloatingActionButton(
        backgroundColor: IncisiveColors.primary,
        onPressed: () => context.push(AppRoutes.addPost),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Text(
          "Bacheca",
          style: TextStyle(
            fontSize: 25,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: IncisiveColors.primary,
          ),
        ),
        foregroundColor: IncisiveColors.primary,
        backgroundColor: IncisiveColors.background,
        actions: [
          IconButton(
            onPressed: () => context.push(AppRoutes.monthlyReport),
            icon: const Icon(Icons.track_changes),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Center(
                child: DateTimelinePicker(
                  focusedDate: _selectedDate,
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
                      return const StateErrorView(message: 'Errore nel caricamento');
                    }

                    if (state is Empty) {
                      return const EmptyWidget(text: "Nessuno ha condiviso nulla oggi");
                    }

                    if (state is Success<List<PostModel>>) {
                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: state.data.length,
                        itemBuilder: (context, index) => SocialPostItem(post: state.data[index]),
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}