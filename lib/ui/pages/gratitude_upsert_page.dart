import 'package:flutter/material.dart';

class GratitudeUpsertPage extends StatefulWidget {
  static const routeName = '/upsertGratitudePage';

  const GratitudeUpsertPage({super.key});

  @override
  State<GratitudeUpsertPage> createState() => _GratitudeUpsertPageState();
}

class _GratitudeUpsertPageState extends State<GratitudeUpsertPage> {
  final List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
    _addController();
    _addController();
    _addController();
  }

  void _addController() {
    _controllers.add(TextEditingController());
  }

  int get _filledGratitudes => _controllers.where((c) => c.text.trim().isNotEmpty).length;

  void _onTextChanged() {
    final allFilled = _controllers.every((c) => c.text.trim().isNotEmpty);

    if (allFilled) {
      setState(() {
        _addController();
      });
    } else {
      setState(() {});
    }
  }

  void _onConfirm() {
    final gratitudes = _controllers.map((c) => c.text.trim()).where((text) => text.isNotEmpty).toList();

    // QUI puoi salvarle (Supabase, bloc, ecc.)
    Navigator.of(context).pop(gratitudes);
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = false; // TODO: cambiare e rendere dinamico

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? "Modifica pagina" : "Nuova pagina",
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
      ),
      backgroundColor: const Color(0xFFFFF8E8),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: _controllers.length,
                itemBuilder: (context, index) {
                  final isExtra = index >= 3;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: GratitudeField(
                      controller: _controllers[index],
                      isExtra: isExtra,
                      onChanged: _onTextChanged,
                    ),
                  );
                },
              ),
            ),

            // BOTTONE CONFERMA
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _filledGratitudes >= 3 ? _onConfirm : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 141, 90, 35),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: const Color.fromARGB(255, 184, 181, 181),

                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Conferma',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GratitudeField extends StatelessWidget {
  final TextEditingController controller;
  final bool isExtra;
  final VoidCallback onChanged;

  const GratitudeField({
    super.key,
    required this.controller,
    required this.isExtra,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: isExtra ? Colors.brown.withOpacity(0.5) : Colors.brown,
          width: 1.4,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        controller: controller,
        onChanged: (_) => onChanged(),
        maxLines: null,
        textInputAction: TextInputAction.newline,
        decoration: InputDecoration(
          hintText: isExtra ? 'Aggiungi un’altra gratitudine…' : 'Sono grato per…',
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }
}
