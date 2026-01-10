import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:incisive/state_management/blocs/create_post/create_post_bloc.dart';
import 'package:incisive/state_management/blocs/social/social_bloc.dart';
import 'package:incisive/ui/widgets/error_dialog.dart';
import 'package:incisive/ui/widgets/insert_confirm_dialog.dart';
import 'package:incisive/ui/widgets/speech_dialog.dart';
import 'package:incisive/utils/functions.dart';

class AddPostPage extends StatefulWidget {
  static const routeName = '/upsertDiaryPage';

  const AddPostPage({
    super.key,
  });

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late CreatePostBloc _createPostBloc;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _titleController.addListener(() => setState(() {}));
    _contentController = TextEditingController();
    _contentController.addListener(() => setState(() {}));
    _createPostBloc = context.read<CreatePostBloc>();
  }

  void _save() => _createPostBloc.createPost(_titleController.text, _contentController.text);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Crea post",
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
      body: BlocListener<CreatePostBloc, CreatePostState>(
        listener: (context, state) {
          if (state is ResultCreatePostState) {
            context.read<SocialBloc>().getDailyPosts(DateTime.now());
            Navigator.pop(context);

            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => InsertConfirmDialog(isEdit: false),
            );
          } else if (state is ErrorCreatePostState) {
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
                    formatDateItalian(DateTime.now()),
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
                        builder: (_) => SpeechDialog(description: "Racconta quello che ti senti..."),
                      );

                      if (result != null && result.isNotEmpty) {
                        setState(() {
                          _contentController.text += (_contentController.text.isNotEmpty ? " " : "") + result;
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
              TextField(
                controller: _titleController,
                keyboardType: TextInputType.text,
                maxLines: 1,
                maxLength: 50,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Inserisci il titolo...",

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.black26),
                  ),
                ),
                style: const TextStyle(
                  fontSize: 18,
                  fontFamily: "Nunito Sans",
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: TextField(
                  controller: _contentController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  maxLength: 2000,
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
                child: BlocBuilder<CreatePostBloc, CreatePostState>(
                  builder: (context, state) {
                    final screenWidth = MediaQuery.sizeOf(context).width;
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 141, 90, 35),
                        foregroundColor: Colors.white,
                        disabledBackgroundColor:
                            _titleController.text.length < 5 || _contentController.text.length < 20
                                ? const Color.fromARGB(255, 184, 181, 181)
                                : Color.fromARGB(255, 141, 90, 35),
                        fixedSize: Size.fromWidth(screenWidth * 0.4),
                      ),
                      onPressed:
                          _titleController.text.length < 5 || _contentController.text.length < 20 || state is TryCreatePostState
                              ? null
                              : _save,
                      child:
                          state is TryCreatePostState
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
