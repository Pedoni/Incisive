import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:incisive/models/gratitude_page_model.dart';
import 'package:incisive/state_management/blocs/base/base_bloc.dart';
import 'package:incisive/state_management/blocs/gratitude_page/gratitude_page_bloc.dart';
import 'package:incisive/state_management/blocs/gratitude_upsert/gratitude_upsert_bloc.dart';
import 'package:incisive/state_management/blocs/profile/profile_bloc.dart';
import 'package:incisive/ui/widgets/error_dialog.dart';
import 'package:incisive/ui/widgets/insert_confirm_dialog.dart';
import 'package:incisive/utils/enums.dart';

class GratitudeUpsertPage extends StatefulWidget {
  static const routeName = '/upsertGratitudePage';

  final GratitudePageModel existingEntry;
  final DateTime date;

  const GratitudeUpsertPage({
    super.key,
    required this.existingEntry,
    required this.date,
  });

  @override
  State<GratitudeUpsertPage> createState() => _GratitudeUpsertPageState();
}

class _GratitudeUpsertPageState extends State<GratitudeUpsertPage> {
  final List<TextEditingController> _controllers = [];
  late final bool isEditing;

  @override
  void initState() {
    super.initState();

    isEditing = widget.existingEntry.list!.isNotEmpty;

    if (isEditing) {
      final existing = widget.existingEntry.list!;

      for (final text in existing) {
        _controllers.add(TextEditingController(text: text));
      }

      while (_controllers.length < 3) {
        _addController();
      }
      _addController();
    } else {
      _addController();
      _addController();
      _addController();
    }
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
    context.read<GratitudeUpsertBloc>().upsertGratitude(
      widget.existingEntry.id,
      gratitudes,
    );
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
      body: BlocListener<GratitudeUpsertBloc, BaseState>(
        listener: (context, state) {
          if (state is Success) {
            context.read<GratitudePageBloc>().getGratitudePage(widget.date);
            if (!isEditing) {
              context.read<ProfileBloc>().addPoints(10);
            }
            if (context.canPop()) {
              context.pop();
            }
            showDialog(
              context: context,
              barrierDismissible: false,
              builder:
                  (context) => InsertConfirmDialog(
                    type: isEditing ? PostType.gdEdit : PostType.gdInsert,
                    points: isEditing ? null : 10,
                  ),
            );
          } else if (state is Error) {
            showDialog(
              context: context,
              builder: (context) => ErrorDialog(title: "Errore", text: state.errorString ?? 'Errore sconosciuto.'),
            );
          }
        },
        child: SafeArea(
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
                child: BlocBuilder<GratitudeUpsertBloc, BaseState>(
                  builder: (context, state) {
                    final screenWidth = MediaQuery.sizeOf(context).width;
                    return ElevatedButton(
                      onPressed: _filledGratitudes >= 3 ? _onConfirm : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 141, 90, 35),
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: const Color.fromARGB(255, 184, 181, 181),
                        fixedSize: Size.fromWidth(screenWidth * 0.4),
                      ),
                      child:
                          state is Loading
                              ? SizedBox(
                                height: 25,
                                width: 25,
                                child: CircularProgressIndicator(color: Colors.white),
                              )
                              : Text("Conferma"),
                    );
                  },
                ),
              ),
            ],
          ),
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
          color: isExtra ? Colors.brown.withValues(alpha: 0.5) : Colors.brown,
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
