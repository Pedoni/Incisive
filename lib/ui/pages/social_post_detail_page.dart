import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:incisive/models/post_model.dart';
import 'package:incisive/models/comment_model.dart';
import 'package:incisive/navigation/args/social_post_detail_args.dart';
import 'package:incisive/state_management/blocs/base/base_bloc.dart';
import 'package:incisive/state_management/blocs/social_comment/social_comment_bloc.dart';
import 'package:incisive/ui/pages/add_comment_page.dart';
import 'package:incisive/ui/pages/pending_comments_page.dart';
import 'package:incisive/ui/widgets/empty_widget.dart';
import 'package:incisive/ui/widgets/social_post_item.dart';
import 'package:incisive/utils/constants.dart';
import 'package:incisive/utils/functions.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class SocialPostDetailPage extends StatefulWidget {
  static const routeName = '/socialPostDetail';

  final PostModel post;

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
    isAuthor = widget.post.author!.id == Supabase.instance.client.auth.currentUser?.id;
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
        scrolledUnderElevation: 0,
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
          if (widget.post.author!.id == Supabase.instance.client.auth.currentUser!.id)
            IconButton(
              icon: const Icon(Icons.mark_email_unread_outlined),
              tooltip: "Commenti in attesa",
              onPressed: () {
                context.push(
                  PendingCommentsPage.routeName,
                  extra: SocialPostDetailArgs(post: widget.post),
                );
              },
            ),
        ],
      ),
      floatingActionButton:
          !isAuthor
              ? FloatingActionButton(
                backgroundColor: const Color.fromARGB(255, 141, 90, 35),
                foregroundColor: Colors.white,
                child: const Icon(Icons.add_comment),
                onPressed: () {
                  context.push(
                    AddCommentPage.routeName,
                    extra: widget.post,
                  );
                },
              )
              : null,
      body: SafeArea(
        child: BlocBuilder<SocialCommentBloc, BaseState>(
          builder: (context, state) {
            final comments = state is Success<List<CommentModel>> ? state.data : <CommentModel>[];

            return Column(
              children: [
                /// POST
                _PostHeader(post: widget.post),

                const Divider(height: 1),

                /// COMMENTI
                Expanded(
                  child: _CommentsList(
                    state: state,
                    comments: comments.where((c) => c.approved).toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt)),
                    postAuthorId: widget.post.author!.id,
                    postId: widget.post.id,
                  ),
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
  final PostModel post;

  const _PostHeader({required this.post});

  @override
  Widget build(BuildContext context) {
    final author = post.author;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ROW: AVATAR + TITOLO
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: getUserBackgroundColor(author!.level),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/${author.avatarAsset}',
                    width: 44,
                    height: 44,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) {
                      return const Icon(Icons.person, size: 22);
                    },
                  ),
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Text(
                  post.title,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          /// CONTENUTO
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
  final BaseState state;
  final List<CommentModel> comments;
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
    if (state is Loading || state is Initial) {
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

    if (state is Empty || (state is Success && comments.where((c) => c.approved).isEmpty)) {
      return EmptyWidget(text: "Ancora nessun commento");
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
  final CommentModel comment;
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
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            formatDateTime(comment.createdAt),
            style: const TextStyle(
              fontFamily: 'Nunito Sans',
              fontSize: 12,
              color: Colors.black45,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            comment.content,
            style: const TextStyle(
              fontFamily: 'Nunito Sans',
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 8),

          if (comment.approved)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(
                    comment.myVote == null || comment.myVote == false ? Icons.thumb_up_alt_outlined : Icons.thumb_up_alt,
                    size: 18,
                  ),
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
                  icon: Icon(
                    comment.myVote == null || comment.myVote == true ? Icons.thumb_down_alt_outlined : Icons.thumb_down_alt,
                    size: 18,
                  ),
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
