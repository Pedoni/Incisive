import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:incisive/models/diary_model.dart';
import 'package:incisive/state_management/blocs/diary_page_bloc/diary_page_bloc.dart';
import 'package:incisive/state_management/blocs/profile_bloc/profile_bloc.dart';
import 'package:incisive/state_management/blocs/upsert_page_bloc/upsert_page_bloc.dart';
import 'package:incisive/ui/widgets/error_dialog.dart';
import 'package:incisive/ui/widgets/insert_confirm_dialog.dart';
import 'package:incisive/ui/widgets/speech_dialog.dart';
import 'package:incisive/utils/enums.dart';

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
  late UpsertPageBloc _upsertPageBloc;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.existingEntry?.text ?? "");
    _controller.addListener(() => setState(() {}));
    _upsertPageBloc = context.read<UpsertPageBloc>();
  }

  void _save() => _upsertPageBloc.upsertPage(widget.date, _controller.text);

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingEntry != null;

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
      body: BlocListener<UpsertPageBloc, UpsertPageState>(
        listener: (context, state) {
          if (state is ResultUpsertPageState) {
            context.read<DiaryPageBloc>().getPage(widget.date);
            Navigator.pop(context);
            if (widget.existingEntry == null) {
              context.read<ProfileBloc>().addPoints(10);
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
          } else if (state is ErrorUpsertPageState) {
            showDialog(
              context: context,
              builder: (context) => ErrorDialog(title: "Errore", text: state.errorString ?? 'Errore sconosciuto.'),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Scrivi qui i tuoi pensieri",
                    style: TextStyle(
                      color: Color.fromARGB(255, 112, 66, 16),
                      fontFamily: 'Nunito Sans',
                      fontSize: 16,
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      final result = await showDialog<String>(
                        context: context,
                        builder: (_) => SpeechDialog(description: "Racconta della tua giornata..."),
                      );

                      if (result != null && result.isNotEmpty) {
                        setState(() {
                          _controller.text += (_controller.text.isNotEmpty ? " " : "") + result;
                        });
                      }
                    },
                    child: Icon(
                      Icons.mic,
                      color: Color.fromARGB(255, 112, 66, 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: TextField(
                  controller: _controller,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  maxLength: 1000,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
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
              SizedBox(height: 20),
              Center(
                child: BlocBuilder<UpsertPageBloc, UpsertPageState>(
                  builder: (context, state) {
                    final screenWidth = MediaQuery.sizeOf(context).width;
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 141, 90, 35),
                        foregroundColor: Colors.white,
                        disabledBackgroundColor:
                            _controller.text.length < 10 ? const Color.fromARGB(255, 184, 181, 181) : Color.fromARGB(255, 141, 90, 35),
                        fixedSize: Size.fromWidth(screenWidth * 0.4),
                      ),
                      onPressed: _controller.text.length < 10 || state is TryUpsertPageState ? null : _save,
                      child:
                          state is TryUpsertPageState
                              ? SizedBox(
                                height: 25,
                                width: 25,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                              : Text("Conferma"),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
