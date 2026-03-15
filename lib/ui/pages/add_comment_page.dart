import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:incisive/models/post_model.dart';
import 'package:incisive/state_management/blocs/base/base_bloc.dart';
import 'package:incisive/state_management/blocs/comment_post/comment_post_bloc.dart';
import 'package:incisive/ui/widgets/error_dialog.dart';
import 'package:incisive/ui/widgets/insert_confirm_dialog.dart';
import 'package:incisive/ui/widgets/text_input_page.dart';
import 'package:incisive/utils/enums.dart';

class AddCommentPage extends StatefulWidget {
  final PostModel post;

  const AddCommentPage({super.key, required this.post});

  @override
  State<AddCommentPage> createState() => _AddCommentPageState();
}

class _AddCommentPageState extends State<AddCommentPage> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() => context.read<CommentPostBloc>().commentPost(widget.post.id, _controller.text.trim());

  @override
  Widget build(BuildContext context) {
    return BlocListener<CommentPostBloc, BaseState>(
      listener: (context, state) {
        if (state is Success) {
          context.pop();
          showDialog(
            context: context,
            builder: (_) => InsertConfirmDialog(type: PostType.comment),
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
      child: BlocBuilder<CommentPostBloc, BaseState>(
        builder: (context, state) {
          return TextInputPage(
            title: "Scrivi commento",
            headerLabel: "Scrivi il tuo commento",
            speechHint: "Detta il tuo commento...",
            controller: _controller,
            maxLength: 500,
            minLength: 5,
            hintText: "Inserisci il tuo commento...",
            isLoading: state is Loading,
            onConfirm: _save,
          );
        },
      ),
    );
  }
}
