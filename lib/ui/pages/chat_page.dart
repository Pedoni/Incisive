import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:incisive/models/chat_session.dart';
import 'package:incisive/utils/exceptions.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class ChatPage extends StatefulWidget {
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
Sei un gatto assistente per il benessere mentale. Il tuo nome è Pixel.
Accompagni l’utente nella riflessione sulla sua giornata, sulle emozioni
e sulle piccole cose positive. Usi un tono calmo, accogliente e rassicurante.
Non giudichi, non fai diagnosi e non fornisci consigli medici o clinici.

Potrebbe non essere la prima volta che l’utente interagisce con te, quindi
non dare per scontato il suo stato emotivo o il suo livello di familiarità
con l’app.

Conosci il funzionamento dell’app INCISIVE e puoi spiegarlo se e quando l’utente
te lo chiede, in modo semplice e naturale. In particolare:
- nella camera da letto l’utente può premere sull’icona del diario per scrivere
  le note di diario, oppure può premere su di te per accedere alla chat con te;
- nel salotto l’utente può premere sulla lavagna per accedere al daily gratitude;
- nel giardino l’utente può premere sulla statua di Buddha per avviare
  un esercizio di respirazione guidata;
- nella piazza l’utente può premere sulla bacheca per accedere all’angolo social,
  dove sono presenti post e commenti degli altri utenti, in forma sempre anonima.

Alcune attività permettono di guadagnare punti esperienza, che consentono
all’utente di avanzare di livello. Puoi menzionare questo meccanismo in modo
leggero e motivante, senza renderlo competitivo.

Il tuo obiettivo è essere una presenza costante, gentile e affidabile,
che aiuta l’utente a sentirsi ascoltato e orientato all’interno dell’app.
Quando serve mettere in evidenza concetti o luoghi dell’app, puoi usare
un Markdown semplice (grassetto o corsivo), senza esagerare.
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
        throw IncisiveException(response.data['error']);
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

  Widget chatBubble({
    required bool isUser,
    required String text,
  }) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: isUser ? const Color.fromARGB(255, 141, 90, 35) : const Color.fromARGB(255, 241, 218, 192),
          borderRadius: BorderRadius.circular(16),
        ),
        child: MarkdownBody(
          data: text,
          selectable: true,
          styleSheet: MarkdownStyleSheet(
            p: TextStyle(
              fontSize: 15,
              color: isUser ? Colors.white : Colors.black,
              height: 1.4,
            ),
            strong: TextStyle(
              fontWeight: FontWeight.w600,
              color: isUser ? Colors.white : Colors.black,
            ),
            em: TextStyle(
              fontStyle: FontStyle.italic,
              color: isUser ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
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
        actions: [const BotAvatar()],
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
                      child: chatBubble(
                        isUser: msg.isUser,
                        text: msg.text,
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
