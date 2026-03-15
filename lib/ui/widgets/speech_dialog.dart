import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:incisive/utils/incisive_colors.dart';
import 'package:lottie/lottie.dart';
import 'package:speech_to_text/speech_recognition_error.dart' as stte;
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechDialog extends StatefulWidget {
  final String description;

  const SpeechDialog({
    required this.description,
    super.key,
  });

  @override
  State<SpeechDialog> createState() => _SpeechDialogState();
}

class _SpeechDialogState extends State<SpeechDialog> {
  late final stt.SpeechToText _speech;

  bool _isListening = false;
  String _recognizedText = '';
  bool _hasStarted = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_hasStarted) {
      _hasStarted = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startListening();
      });
    }
  }

  Future<void> _startListening() async {
    final available = await _speech.initialize(
      onStatus: _onStatus,
      onError: _onError,
    );

    if (!available) return;

    setState(() => _isListening = true);

    await _speech.listen(
      localeId: 'it_IT',
      listenOptions: stt.SpeechListenOptions(listenMode: stt.ListenMode.confirmation),
      onResult: (result) {
        setState(() {
          _recognizedText = result.recognizedWords;
        });
      },
    );
  }

  Future<void> _stopListening() async {
    if (_isListening) {
      await _speech.stop();
      setState(() => _isListening = false);
    }
  }

  void _onStatus(String status) {
    if (status == 'done' || status == 'notListening') {
      _stopListening();
    }
  }

  void _onError(stte.SpeechRecognitionError error) {
    _stopListening();
  }

  @override
  void dispose() {
    _speech.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      contentPadding: const EdgeInsets.fromLTRB(24, 10, 24, 24),
      backgroundColor: Colors.white,

      title: Row(
        children: [
          Icon(
            Icons.mic,
            color: IncisiveColors.primary,
            size: 28,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              widget.description,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Color.fromARGB(255, 60, 60, 60),
              ),
            ),
          ),
        ],
      ),

      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset(
            'assets/animations/speech_recognition.json',
            width: 110,
            height: 110,
            repeat: _isListening,
          ),
          const SizedBox(height: 16),
          Text(
            _recognizedText.isEmpty ? 'Ti sto ascoltando...' : _recognizedText,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              color: Color.fromARGB(255, 80, 80, 80),
            ),
          ),
        ],
      ),

      actionsPadding: const EdgeInsets.only(bottom: 12, right: 12),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            foregroundColor: IncisiveColors.primary,
            backgroundColor: const Color.fromARGB(255, 244, 223, 200),
          ),
          child: const Text(
            'Annulla',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          onPressed: () async {
            await _stopListening();
            if (context.mounted && context.canPop()) {
              context.pop();
            }
          },
        ),

        TextButton(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            foregroundColor: Colors.white,
            backgroundColor: IncisiveColors.primary,
          ),
          child: const Text(
            'Ok',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          onPressed: () async {
            await _stopListening();
            if (context.mounted) {
              if (context.canPop()) {
                context.pop(_recognizedText);
              }
            }
          },
        ),
      ],
    );
  }
}
