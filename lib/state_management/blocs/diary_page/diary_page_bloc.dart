import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:incisive/repositories/diary_repository.dart';
import 'package:incisive/state_management/blocs/base/base_bloc.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

part 'diary_page_event.dart';

class DiaryPageBloc extends BaseBloc {
  final DiaryRepository diaryRepository;

  DiaryPageBloc({required this.diaryRepository}) : super(Initial()) {
    on<TryDiaryPageEvent>(_getPage);
    on<UpdateDiaryPrivacyEvent>(_updatePrivacy);
  }

  void getPage(DateTime dateTime) => add(TryDiaryPageEvent(dateTime: dateTime));

  void updatePrivacy(DateTime date, bool isPrivate) =>
      add(UpdateDiaryPrivacyEvent(date: date, isPrivate: isPrivate));

  FutureOr<void> _getPage(
    TryDiaryPageEvent event,
    Emitter<BaseState> emitter,
  ) async {
    emitter(Loading());
    try {
      final entry = await diaryRepository.getPage(event.dateTime);
      emitter(entry != null ? Success(entry) : Empty());
    } catch (e) {
      emitter(Error(e.toString()));
    }
  }

  FutureOr<void> _updatePrivacy(
    UpdateDiaryPrivacyEvent event,
    Emitter<BaseState> emitter,
  ) async {
    final currentState = state;
    try {
      await diaryRepository.updatePrivacy(
        date: event.date,
        isPrivate: event.isPrivate,
      );

      if (event.isPrivate) {
        final tomorrow = event.date.add(const Duration(days: 1));
        final tomorrowStr = '${tomorrow.year}-${tomorrow.month.toString().padLeft(2, '0')}-${tomorrow.day.toString().padLeft(2, '0')}';
        await Supabase.instance.client
            .from('scheduled_notifications')
            .delete()
            .eq('user_id', Supabase.instance.client.auth.currentUser!.id)
            .eq('scheduled_for', tomorrowStr)
            .eq('is_read', false);

        final token = Supabase.instance.client.auth.currentSession?.accessToken;
        final userId = Supabase.instance.client.auth.currentUser?.id;
        http.post(
          Uri.parse('https://hktlznvzeixqyisnegzr.supabase.co/functions/v1/generate-monthly-summary'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'user_id': userId,
            'year': event.date.year,
            'month': event.date.month,
          }),
        );
      }

      if (currentState is Success) {
        final entry = currentState.data as dynamic;
        emitter(Success(entry.copyWith(isPrivate: event.isPrivate)));
      }
    } catch (e) {
      emitter(Error(e.toString()));
    }
  }
}
