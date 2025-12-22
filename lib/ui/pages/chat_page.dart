import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:incisive/models/chat_session.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class ChatPage extends StatefulWidget {
  static const routeName = '/chatPage';

  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late final List<ChatMessage> _messages;

  bool _isTyping = false;

  static const int _maxContextMessages = 20;

  static const String _systemPrompt = '''
Sei un gatto assistente empatico per il benessere mentale. Il tuo nome è Pixel.
Aiuti l’utente a riflettere sulla sua giornata, sulle emozioni
e sulle piccole cose positive. Non giudichi, non fai diagnosi,
non dai consigli medici. Usi un tono calmo, accogliente e rassicurante.
''';

  void _addInitialBotMessage() {
    _messages.insert(
      0,
      ChatMessage(false, "Hey 🐾"),
    );
  }

  @override
  void initState() {
    super.initState();

    _messages = ChatSession.messages;

    if (_messages.isEmpty) {
      _addInitialBotMessage();
    }
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isTyping) return;

    _controller.clear();

    setState(() {
      _messages.insert(0, ChatMessage(true, text));
      _isTyping = true;
    });

    _scrollToTop();

    try {
      final payloadMessages = _buildConversationPayload(text);
      final supabase = Supabase.instance.client;

      final response = await supabase.functions.invoke(
        'chat',
        body: jsonEncode({
          'messages': payloadMessages,
        }),
      );

      if (response.data['error'] != null) {
        throw Exception(response.data['error']);
      }

      final reply = response.data['reply'];
      setState(() {
        _isTyping = false;
        _messages.insert(0, ChatMessage(false, reply));
      });

      _scrollToTop();
    } catch (_) {
      setState(() => _isTyping = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'C’è stato un problema. Riprova tra poco.',
            ),
          ),
        );
      }
    }
  }

  List<Map<String, String>> _buildConversationPayload(String newMessage) {
    final recentMessages = _messages.length > _maxContextMessages ? _messages.sublist(0, _maxContextMessages) : _messages;

    return [
      {
        'role': 'system',
        'content': _systemPrompt,
      },
      ...recentMessages.reversed.map((m) => m.toOpenAi()),
      {
        'role': 'user',
        'content': newMessage,
      },
    ];
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E8),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(
          "Pixel",
          style: TextStyle(
            fontSize: 25,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 141, 90, 35),
          ),
        ),
        foregroundColor: Color.fromARGB(255, 141, 90, 35),
        backgroundColor: const Color(0xFFFFF8E8),
      ),
      body: SafeArea(
        child: Container(
          height: double.infinity,
          decoration: BoxDecoration(color: const Color(0xFFFFF8E8)),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  controller: _scrollController,
                  padding: const EdgeInsets.all(12),
                  itemCount: _messages.length + (_isTyping ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (_isTyping && index == 0) {
                      return const Padding(
                        padding: EdgeInsets.only(left: 12, top: 4),
                        child: Text(
                          'Sta scrivendo…',
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }

                    final msg = _messages[_isTyping ? index - 1 : index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child:
                          msg.isUser
                              ? BubbleNormal(
                                text: msg.text,
                                isSender: true,
                                color: Color.fromARGB(255, 141, 90, 35),
                                textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              )
                              : Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const BotAvatar(),
                                  Expanded(
                                    child: BubbleNormal(
                                      text: msg.text,
                                      isSender: false,
                                      color: Color.fromARGB(255, 241, 218, 192),

                                      textStyle: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                    );
                  },
                ),
              ),

              _buildInputBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 241, 218, 192),
                borderRadius: BorderRadius.circular(14),
              ),
              child: TextField(
                controller: _controller,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Scrivi qui…',
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 141, 90, 35),
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMessage {
  final bool isUser;
  final String text;

  _ChatMessage._(this.isUser, this.text);

  factory _ChatMessage.user(String text) => _ChatMessage._(true, text);

  factory _ChatMessage.bot(String text) => _ChatMessage._(false, text);

  Map<String, String> toOpenAi() {
    return {
      'role': isUser ? 'user' : 'assistant',
      'content': text,
    };
  }
}

class BotAvatar extends StatelessWidget {
  const BotAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: CircleAvatar(
        radius: 28,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        backgroundImage: const AssetImage(
          'assets/images/cat_thumb.png',
        ),
      ),
    );
  }
}
