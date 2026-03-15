part of 'chat_bloc.dart';

class SendChatMessageEvent extends BaseEvent {
  final List<Map<String, String>> messages;

  const SendChatMessageEvent({required this.messages});

  @override
  List<Object> get props => [messages];
}
