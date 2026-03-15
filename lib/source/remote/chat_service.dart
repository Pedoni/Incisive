import 'dart:convert';
import 'package:incisive/source/remote/base_service.dart';
import 'package:incisive/utils/exceptions.dart';

class ChatService extends BaseService {
  Future<String> sendMessage(List<Map<String, String>> messages) async {
    return await guard("Send chat message", () async {
      final response = await supabase.functions.invoke(
        'chat',
        body: jsonEncode({'messages': messages}),
      );

      final data = response.data;

      if (data['error'] != null) {
        throw IncisiveException(data['error']);
      }

      return data['reply'] as String;
    });
  }
}
