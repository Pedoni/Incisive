import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:incisive/models/social_comment_model.dart';
import 'package:incisive/models/social_post_model.dart';
import 'package:incisive/state_management/blocs/social_comment/social_comment_bloc.dart';
import 'package:incisive/ui/widgets/empty_widget.dart';
import 'package:lottie/lottie.dart';

class PendingCommentsPage extends StatelessWidget {
  static const routeName = '/pendingComments';

  final SocialPostModel post;

  const PendingCommentsPage({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E8),
      appBar: AppBar(
        title: const Text(
          "Commenti in attesa",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFFFFF8E8),
        foregroundColor: const Color.fromARGB(255, 141, 90, 35),
        elevation: 0,
      ),
      body: BlocBuilder<SocialCommentBloc, SocialCommentState>(
        builder: (context, state) {
          if (state is LoadingSocialCommentState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is EmptySocialCommentState) {
            return EmptyWidget(text: "Nessun commento in attesa");
          }

          if (state is ResultSocialCommentState) {
            final pendingComments = state.comments.where((c) => !c.approved).toList();

            if (pendingComments.isEmpty) {
              return EmptyWidget(text: "Nessun commento in attesa");
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: pendingComments.length,
              itemBuilder: (_, i) {
                final comment = pendingComments[i];
                return _PendingCommentItem(
                  comment: comment,
                  postId: post.id,
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _PendingCommentItem extends StatelessWidget {
  final SocialCommentModel comment;
  final String postId;

  const _PendingCommentItem({
    required this.comment,
    required this.postId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            comment.content,
            style: const TextStyle(
              fontFamily: 'Nunito Sans',
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                icon: const Icon(Icons.close),
                label: const Text("Rifiuta"),
                onPressed: () {
                  context.read<SocialCommentBloc>().rejectComment(comment.id, postId);
                },
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                icon: const Icon(Icons.check),
                label: const Text("Approva"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 141, 90, 35),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  context.read<SocialCommentBloc>().approveComment(comment.id, postId);

                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
