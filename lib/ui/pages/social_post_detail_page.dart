import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:incisive/models/social_post_model.dart';
import 'package:incisive/models/social_comment_model.dart';
import 'package:incisive/state_management/blocs/social_comment/social_comment_bloc.dart';
import 'package:incisive/ui/pages/pending_comments_page.dart';
import 'package:incisive/ui/widgets/empty_widget.dart';
import 'package:incisive/ui/widgets/social_post_item.dart';
import 'package:incisive/utils/constants.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class SocialPostDetailPage extends StatefulWidget {
  static const routeName = '/socialPostDetail';

  final SocialPostModel post;

  const SocialPostDetailPage({
    super.key,
    required this.post,
  });

  @override
  State<SocialPostDetailPage> createState() => _SocialPostDetailPageState();
}

class _SocialPostDetailPageState extends State<SocialPostDetailPage> {
  final TextEditingController _commentController = TextEditingController();
  late final String? viewerUserId;
  late final bool isAuthor;

  @override
  void initState() {
    super.initState();
    context.read<SocialCommentBloc>().getComments(widget.post.id);
    isAuthor = widget.post.authorId == Supabase.instance.client.auth.currentUser?.id;
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E8),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFFFF8E8),
        foregroundColor: const Color.fromARGB(255, 141, 90, 35),
        title: const Text(
          "Post",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          if (widget.post.authorId == Supabase.instance.client.auth.currentUser!.id)
            IconButton(
              icon: const Icon(Icons.mark_email_unread_outlined),
              tooltip: "Commenti in attesa",
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  PendingCommentsPage.routeName,
                  arguments: widget.post,
                );
              },
            ),
        ],
      ),

      body: SafeArea(
        child: BlocConsumer<SocialCommentBloc, SocialCommentState>(
          listener: (context, state) {
            if (state is ErrorSocialCommentState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            final comments = state is ResultSocialCommentState ? state.comments : <SocialCommentModel>[];

            return Column(
              children: [
                /// POST
                _PostHeader(post: widget.post),

                const Divider(height: 1),

                /// COMMENTI
                Expanded(
                  child: _CommentsList(
                    state: state,
                    comments: comments.where((c) => c.approved).toList(),
                    postAuthorId: widget.post.authorId,
                    postId: widget.post.id,
                  ),
                ),

                if (!isAuthor)
                  _CommentInput(
                    post: widget.post,
                    controller: _commentController,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _PostHeader extends StatelessWidget {
  final SocialPostModel post;

  const _PostHeader({required this.post});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            post.title,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            post.content,
            style: const TextStyle(
              fontFamily: 'Nunito Sans',
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _CommentsList extends StatelessWidget {
  final SocialCommentState state;
  final List<SocialCommentModel> comments;
  final String postAuthorId;
  final String postId;

  const _CommentsList({
    required this.state,
    required this.comments,
    required this.postAuthorId,
    required this.postId,
  });

  @override
  Widget build(BuildContext context) {
    if (state is LoadingSocialCommentState || state is InitSocialCommentState) {
      final list = List.generate(10, (index) => Constants.mockedPostItem);
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        child: Skeletonizer(
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 10,
            itemBuilder: (context, index) => SocialPostItem(post: list[index]),
          ),
        ),
      );
    }

    if (state is EmptySocialCommentState || (state is ResultSocialCommentState && comments.where((c) => c.approved).isEmpty)) {
      return EmptyWidget(text: "Nessun commento in attesa");
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: comments.length,
      itemBuilder: (_, i) {
        final comment = comments[i];

        return _CommentItem(
          comment: comment,
          isPostAuthor: postAuthorId == comment.viewerUserId,
          postId: postId,
        );
      },
    );
  }
}

class _CommentItem extends StatelessWidget {
  final SocialCommentModel comment;
  final bool isPostAuthor;
  final String postId;

  const _CommentItem({
    required this.comment,
    required this.isPostAuthor,
    required this.postId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: comment.approved ? Colors.white : Colors.orange.shade50,
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
          const SizedBox(height: 8),

          if (!comment.approved && isPostAuthor)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  context.read<SocialCommentBloc>().approveComment(
                    postId,
                    comment.id,
                  );
                },
                child: const Text("Approva"),
              ),
            ),

          if (comment.approved)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.thumb_up_alt_outlined, size: 18),
                  onPressed: () {
                    context.read<SocialCommentBloc>().voteComment(
                      comment.id,
                      postId,
                      true,
                    );
                  },
                ),
                Text(comment.upvotes.toString()),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.thumb_down_alt_outlined, size: 18),
                  onPressed: () {
                    context.read<SocialCommentBloc>().voteComment(
                      comment.id,
                      postId,
                      false,
                    );
                  },
                ),
                Text(comment.downvotes.toString()),
              ],
            ),
        ],
      ),
    );
  }
}

class _CommentInput extends StatelessWidget {
  final SocialPostModel post;
  final TextEditingController controller;

  const _CommentInput({
    required this.post,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              maxLines: null,
              decoration: InputDecoration(
                hintText: "Scrivi un commento...",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              if (controller.text.trim().isEmpty) return;

              context.read<SocialCommentBloc>().createComment(
                post.id,
                controller.text.trim(),
              );

              controller.clear();
            },
          ),
        ],
      ),
    );
  }
}
