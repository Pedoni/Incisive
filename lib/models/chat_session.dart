class ChatSession {
  static final List<ChatMessage> messages = [];
}

class ChatMessage {
  final bool isUser;
  final String text;

  ChatMessage(this.isUser, this.text);

  Map<String, String> toOpenAi() {
    return {
      'role': isUser ? 'user' : 'assistant',
      'content': text,
    };
  }
}
