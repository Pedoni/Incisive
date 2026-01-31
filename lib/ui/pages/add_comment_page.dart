import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:incisive/models/post_model.dart';
import 'package:incisive/state_management/blocs/base/base_bloc.dart';
import 'package:incisive/state_management/blocs/comment_post/comment_post_bloc.dart';
import 'package:incisive/ui/widgets/error_dialog.dart';
import 'package:incisive/ui/widgets/insert_confirm_dialog.dart';
import 'package:incisive/ui/widgets/speech_dialog.dart';
import 'package:incisive/utils/enums.dart';

class AddCommentPage extends StatefulWidget {
  static const routeName = '/addCommentPage';

  final PostModel post;

  const AddCommentPage({
    super.key,
    required this.post,
  });

  @override
  State<AddCommentPage> createState() => _AddCommentPageState();
}

class _AddCommentPageState extends State<AddCommentPage> {
  late TextEditingController _controller;
  late CommentPostBloc _commentPostBloc;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(() => setState(() {}));
    _commentPostBloc = context.read<CommentPostBloc>();
  }

  void _save() => _commentPostBloc.commentPost(
    widget.post.id,
    _controller.text.trim(),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          "Scrivi commento",
          style: TextStyle(
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
      body: BlocListener<CommentPostBloc, BaseState>(
        listener: (context, state) {
          if (state is Success) {
            context.pop();
            showDialog(
              context: context,
              builder: (context) => InsertConfirmDialog(type: PostType.comment),
            );
          } else if (state is Error) {
            showDialog(
              context: context,
              builder:
                  (context) => ErrorDialog(
                    title: "Errore",
                    text: state.errorString ?? 'Errore sconosciuto.',
                  ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HEADER + MIC
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Scrivi il tuo commento",
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
                        builder:
                            (_) => const SpeechDialog(
                              description: "Detta il tuo commento...",
                            ),
                      );

                      if (result != null && result.isNotEmpty) {
                        setState(() {
                          _controller.text += (_controller.text.isNotEmpty ? " " : "") + result;
                        });
                      }
                    },
                    child: const Icon(
                      Icons.mic,
                      color: Color.fromARGB(255, 112, 66, 16),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// TEXT FIELD
              Expanded(
                child: TextField(
                  controller: _controller,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  maxLength: 500,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Inserisci il tuo commento...",
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

              const SizedBox(height: 20),

              /// CONFIRM BUTTON
              Center(
                child: BlocBuilder<CommentPostBloc, BaseState>(
                  builder: (context, state) {
                    final screenWidth = MediaQuery.sizeOf(context).width;

                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 141, 90, 35),
                        foregroundColor: Colors.white,
                        disabledBackgroundColor:
                            _controller.text.length < 5 ? const Color.fromARGB(255, 184, 181, 181) : const Color.fromARGB(255, 141, 90, 35),
                        fixedSize: Size.fromWidth(screenWidth * 0.4),
                      ),
                      onPressed: _controller.text.length < 5 || state is Loading ? null : _save,
                      child:
                          state is Loading
                              ? const SizedBox(
                                height: 25,
                                width: 25,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                              : const Text("Conferma"),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
