import 'package:incisive/repositories/base_repository.dart';
import 'package:incisive/source/remote/chat_service.dart';

class ChatRepository extends BaseRepository {
  final ChatService chatService;

  ChatRepository({required this.chatService});

  Future<String> sendMessage(List<Map<String, String>> messages) async {
    return await guard(
      'Send chat message',
      () => chatService.sendMessage(messages),
    );
  }
}
