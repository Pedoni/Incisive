import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:incisive/repositories/diary_repository.dart';
import 'package:incisive/state_management/blocs/base/base_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

part 'upsert_page_event.dart';

class UpsertPageBloc extends BaseBloc {
  final DiaryRepository diaryRepository;

  UpsertPageBloc({
    required this.diaryRepository,
  }) : super(Initial()) {
    on<TryUpsertPageEvent>(_upsertPage);
  }

  void upsertPage(DateTime dateTime, String text) => add(
        TryUpsertPageEvent(dateTime: dateTime, text: text),
      );

  FutureOr<void> _upsertPage(
    TryUpsertPageEvent event,
    Emitter<BaseState> emitter,
  ) async {
    emitter(Loading());
    try {
      await diaryRepository.upsertPage(date: event.dateTime, text: event.text);
      emitter(Success<void>(null));

      _triggerMonthlySummary(event.dateTime);
    } catch (e) {
      emitter(Error(e.toString()));
    }
  }

  void _triggerMonthlySummary(DateTime date) async {
    try {
      final token = Supabase.instance.client.auth.currentSession?.accessToken;
      final userId = Supabase.instance.client.auth.currentUser?.id;

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final body = jsonEncode({
        'user_id': userId,
        'year': date.year,
        'month': date.month,
      });

      const baseUrl = 'https://hktlznvzeixqyisnegzr.supabase.co/functions/v1';

      await Future.wait([
        http.post(
          Uri.parse('$baseUrl/generate-monthly-summary'),
          headers: headers,
          body: body,
        // ignore: avoid_print
        ).then((r) => print('[Summary] Status: ${r.statusCode}, Body: ${r.body}')),
        http.post(
          Uri.parse('$baseUrl/generate-notification'),
          headers: headers,
          body: body,
        // ignore: avoid_print
        ).then((r) => print('[Notification] Status: ${r.statusCode}, Body: ${r.body}')),
      ]);

    } catch (e) {
      // ignore: avoid_print
      print('[Background] Errore: $e');
    }
  }
}
