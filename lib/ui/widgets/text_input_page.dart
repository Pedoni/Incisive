import 'package:flutter/material.dart';
import 'package:incisive/ui/widgets/speech_dialog.dart';
import 'package:incisive/utils/incisive_colors.dart';

class TextInputPage extends StatelessWidget {
  final String title;
  final String headerLabel;
  final String speechHint;
  final TextEditingController controller;
  final int maxLength;
  final int minLength;
  final String hintText;
  final bool isLoading;
  final VoidCallback onConfirm;
  final Widget? extraField;

  const TextInputPage({
    super.key,
    required this.title,
    required this.headerLabel,
    required this.speechHint,
    required this.controller,
    required this.maxLength,
    required this.minLength,
    required this.hintText,
    required this.isLoading,
    required this.onConfirm,
    this.extraField,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: IncisiveColors.primary,
          ),
        ),
        backgroundColor: IncisiveColors.background,
        foregroundColor: IncisiveColors.primary,
        elevation: 0,
      ),
      backgroundColor: IncisiveColors.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  headerLabel,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 112, 66, 16),
                    fontFamily: 'Nunito Sans',
                    fontSize: 16,
                  ),
                ),
                _MicButton(
                  hint: speechHint,
                  onResult: (result) {
                    controller.text += (controller.text.isNotEmpty ? ' ' : '') + result;
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            if (extraField != null) ...[
              extraField!,
              const SizedBox(height: 20),
            ],

            Expanded(
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                maxLength: maxLength,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: hintText,
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.black26),
                  ),
                ),
                style: const TextStyle(
                  fontSize: 18,
                  fontFamily: 'Nunito Sans',
                  height: 1.4,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Bottone Conferma
            Center(
              child: _ConfirmButton(
                controller: controller,
                minLength: minLength,
                isLoading: isLoading,
                onConfirm: onConfirm,
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _MicButton extends StatelessWidget {
  final String hint;
  final ValueChanged<String> onResult;

  const _MicButton({required this.hint, required this.onResult});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final result = await showDialog<String>(
          context: context,
          builder: (_) => SpeechDialog(description: hint),
        );
        if (result != null && result.isNotEmpty) {
          onResult(result);
        }
      },
      child: const Icon(
        Icons.mic,
        color: Color.fromARGB(255, 112, 66, 16),
      ),
    );
  }
}

class _ConfirmButton extends StatelessWidget {
  final TextEditingController controller;
  final int minLength;
  final bool isLoading;
  final VoidCallback onConfirm;

  const _ConfirmButton({
    required this.controller,
    required this.minLength,
    required this.isLoading,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final isShort = controller.text.length < minLength;
    final disabled = isShort || isLoading;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: IncisiveColors.primary,
        foregroundColor: Colors.white,
        disabledBackgroundColor: const Color.fromARGB(255, 184, 181, 181),
        fixedSize: Size.fromWidth(MediaQuery.sizeOf(context).width * 0.4),
      ),
      onPressed: disabled ? null : onConfirm,
      child:
          isLoading
              ? const SizedBox(
                height: 25,
                width: 25,
                child: CircularProgressIndicator(color: Colors.white),
              )
              : const Text('Conferma'),
    );
  }
}
