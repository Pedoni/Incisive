import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:incisive/models/diary_model.dart';
import 'package:incisive/state_management/blocs/diary_page_bloc/diary_page_bloc.dart';

class UpsertDiaryPage extends StatefulWidget {
  static const routeName = '/upsertDiaryPage';

  final DateTime date;
  final DiaryEntry? existingEntry;

  const UpsertDiaryPage({
    super.key,
    required this.date,
    this.existingEntry,
  });

  @override
  State<UpsertDiaryPage> createState() => _UpsertDiaryPageState();
}

class _UpsertDiaryPageState extends State<UpsertDiaryPage> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.existingEntry?.text ?? "");
  }

  void _save() {}

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingEntry != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? "Modifica nota" : "Nuova nota",
          style: const TextStyle(
            fontSize: 22,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: Color.fromARGB(255, 141, 90, 35),
          ),
        ),
        backgroundColor: const Color(0xFFFFF8E8),
        foregroundColor: Color.fromARGB(255, 141, 90, 35),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.check, size: 28),
            onPressed: _save,
          ),
        ],
      ),
      backgroundColor: const Color(0xFFFFF8E8),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Scrivi qui i tuoi pensieri",
              style: TextStyle(
                color: Colors.black54,
                fontFamily: 'Nunito Sans',
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 6),
            Expanded(
              child: TextField(
                controller: _controller,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                expands: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Inserisci il tuo testo...",
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.black26),
                  ),
                ),
                style: const TextStyle(
                  fontSize: 18,
                  fontFamily: "Nunito Sans",
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
