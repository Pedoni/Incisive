import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:incisive/state_management/blocs/base/base_bloc.dart';
import 'package:incisive/state_management/blocs/create_post/create_post_bloc.dart';
import 'package:incisive/state_management/blocs/social/social_bloc.dart';
import 'package:incisive/ui/widgets/error_dialog.dart';
import 'package:incisive/ui/widgets/insert_confirm_dialog.dart';
import 'package:incisive/ui/widgets/text_input_page.dart';
import 'package:incisive/utils/enums.dart';
import 'package:incisive/utils/functions.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({super.key});

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.addListener(() => setState(() {}));
    _contentController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _save() => context.read<CreatePostBloc>().createPost(_titleController.text, _contentController.text);

  bool get _canSave => _titleController.text.length >= 5 && _contentController.text.length >= 20;

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreatePostBloc, BaseState>(
      listener: (context, state) {
        if (state is Success) {
          context.read<SocialBloc>().getDailyPosts(DateTime.now());
          if (context.canPop()) context.pop();
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => InsertConfirmDialog(type: PostType.gdInsert),
          );
        } else if (state is Error) {
          showDialog(
            context: context,
            builder:
                (_) => ErrorDialog(
                  title: "Errore",
                  text: state.errorString ?? 'Errore sconosciuto.',
                ),
          );
        }
      },
      child: BlocBuilder<CreatePostBloc, BaseState>(
        builder: (context, state) {
          return TextInputPage(
            title: "Crea post",
            headerLabel: formatDateItalian(DateTime.now()),
            speechHint: "Racconta quello che ti senti...",
            controller: _contentController,
            maxLength: 2000,
            minLength: 20,
            hintText: "Inserisci il tuo testo...",
            isLoading: state is Loading,
            onConfirm: _canSave ? _save : () {},
            extraField: TextField(
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
          );
        },
      ),
    );
  }
}
