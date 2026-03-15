import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:incisive/repositories/chat_repository.dart';
import 'package:incisive/state_management/blocs/base/base_bloc.dart';

part 'chat_bloc_event.dart';

class ChatBloc extends BaseBloc {
  final ChatRepository chatRepository;

  ChatBloc({required this.chatRepository}) : super(Initial()) {
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
      final reply = await chatRepository.sendMessage(event.messages);
      emitter(Success(reply));
    } catch (e) {
      emitter(Error(e.toString()));
    }
  }
}
