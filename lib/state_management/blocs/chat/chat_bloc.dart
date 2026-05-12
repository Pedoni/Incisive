import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:incisive/repositories/chat_repository.dart';
import 'package:incisive/source/remote/ai_context_service.dart';
import 'package:incisive/state_management/blocs/base/base_bloc.dart';

part 'chat_bloc_event.dart';

class ChatBloc extends BaseBloc {
  final ChatRepository chatRepository;
  final AiContextService aiContextService;

  ChatBloc({
    required this.chatRepository,
    required this.aiContextService,
  }) : super(Initial()) {
    on<SendChatMessageEvent>(_sendMessage);
  }

  void sendMessage(List<Map<String, String>> messages) =>
      add(SendChatMessageEvent(messages: messages));

  FutureOr<void> _sendMessage(
    SendChatMessageEvent event,
    Emitter<BaseState> emitter,
  ) async {
    emitter(Loading());
    try {
      final systemPrompt = await aiContextService.buildSystemPrompt();
      // ignore: avoid_print
      // print('=== SYSTEM PROMPT ===\n$systemPrompt');
      final fullPayload = [
        {'role': 'system', 'content': systemPrompt},
        ...event.messages,
      ];
      final reply = await chatRepository.sendMessage(fullPayload);
      emitter(Success(reply));
    } catch (e) {
      emitter(Error(e.toString()));
    }
  }
}
