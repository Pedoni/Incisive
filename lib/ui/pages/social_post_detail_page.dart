import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:incisive/models/post_model.dart';
import 'package:incisive/models/comment_model.dart';
import 'package:incisive/navigation/app_routes.dart';
import 'package:incisive/navigation/args/social_post_detail_args.dart';
import 'package:incisive/state_management/blocs/base/base_bloc.dart';
import 'package:incisive/state_management/blocs/social_comment/social_comment_bloc.dart';
import 'package:incisive/ui/widgets/empty_widget.dart';
import 'package:incisive/utils/constants.dart';
import 'package:incisive/utils/functions.dart';
import 'package:incisive/utils/incisive_colors.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class SocialPostDetailPage extends StatefulWidget {
  final PostModel post;

  const SocialPostDetailPage({
    super.key,
    required this.post,
  });

  @override
  State<SocialPostDetailPage> createState() => _SocialPostDetailPageState();
}

class _SocialPostDetailPageState extends State<SocialPostDetailPage> {
  late final bool isAuthor;

  @override
  void initState() {
    super.initState();
    context.read<SocialCommentBloc>().getComments(widget.post.id);
    isAuthor = widget.post.author!.id == Supabase.instance.client.auth.currentUser?.id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: IncisiveColors.background,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: IncisiveColors.background,
        foregroundColor: IncisiveColors.primary,
        title: const Text(
          "Post",
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
        ),
        actions: [
          if (widget.post.author!.id == Supabase.instance.client.auth.currentUser!.id)
            BlocBuilder<SocialCommentBloc, BaseState>(
              builder: (context, state) {
                final isLoading = state is Loading || state is Initial;
                final comments = state is Success<List<CommentModel>> ? state.data : <CommentModel>[];
                final pendingComments = comments.where((c) => !c.approved).toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt));

                return Skeletonizer(
                  enabled: isLoading,
                  child: IconButton(
                    icon: pendingComments.isNotEmpty ? const Icon(Icons.mark_email_unread_outlined) : const Icon(Icons.email_outlined),
                    tooltip: "Commenti in attesa",
                    onPressed: () {
                      context.push(
                        AppRoutes.pendingComments,
                        extra: SocialPostDetailArgs(post: widget.post),
                      );
                    },
                  ),
                );
              },
            ),
        ],
      ),
      floatingActionButton:
          !isAuthor
              ? FloatingActionButton(
                backgroundColor: IncisiveColors.primary,
                foregroundColor: Colors.white,
                child: const Icon(Icons.add_comment),
                onPressed: () {
                  context.push(AppRoutes.addComment, extra: widget.post);
                },
              )
              : null,
      body: SafeArea(
        child: BlocConsumer<SocialCommentBloc, BaseState>(
          listener: (context, state) {
            if (state is Error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorString ?? 'Errore nel caricamento dei commenti.'),
                  backgroundColor: Colors.red.shade700,
                ),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is Loading || state is Initial;
            final isError = state is Error;

            final comments = state is Success<List<CommentModel>> ? state.data : <CommentModel>[];
            final approvedComments = comments.where((c) => c.approved).toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt));

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Skeletonizer(
                    enabled: isLoading,
                    child: _PostHeader(post: widget.post),
                  ),
                ),

                const SliverToBoxAdapter(child: Divider(height: 1)),
                const SliverToBoxAdapter(child: SizedBox(height: 12)),

                if (isLoading)
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Skeletonizer(
                          child: _CommentItem(
                            comment: Constants.mockedCommentItem,
                            isPostAuthor: false,
                            postId: widget.post.id,
                          ),
                        ),
                      ),
                      childCount: 6,
                    ),
                  )
                else if (isError)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          const Icon(Icons.error_outline, size: 48, color: Colors.black38),
                          const SizedBox(height: 12),
                          Text(
                            state.errorString ?? 'Errore nel caricamento dei commenti.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: 'Nunito Sans',
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: IncisiveColors.primary,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () => context.read<SocialCommentBloc>().getComments(widget.post.id),
                            child: const Text('Riprova'),
                          ),
                        ],
                      ),
                    ),
                  )
                else if (approvedComments.isEmpty)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: EmptyWidget(text: "Ancora nessun commento"),
                    ),
                  )
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) {
                        final comment = approvedComments[i];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: _CommentItem(
                            comment: comment,
                            isPostAuthor: widget.post.author!.id == comment.viewerUserId,
                            postId: widget.post.id,
                          ),
                        );
                      },
                      childCount: approvedComments.length,
                    ),
                  ),

                const SliverToBoxAdapter(child: SizedBox(height: 50)),
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
    final author = post.author!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          content: Image.asset("assets/images/${author.avatarAsset}"),
                        ),
                  );
                },
                child: CircleAvatar(
                  radius: 22,
                  backgroundColor: getUserBackgroundColor(author.level),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/${author.avatarAsset}',
                      width: 44,
                      height: 44,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const Icon(Icons.person, size: 22),
                    ),
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
    final author = comment.author;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: comment.approved ? Colors.white : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                formatDateTime(comment.createdAt),
                style: const TextStyle(
                  fontFamily: 'Nunito Sans',
                  fontSize: 12,
                  color: Colors.black45,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          content: Image.asset("assets/images/${author.avatarAsset}"),
                        ),
                  );
                },
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: getUserBackgroundColor(author.level),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/${author.avatarAsset}',
                      width: 32,
                      height: 32,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const Icon(Icons.person, size: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            comment.content,
            style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 15),
          ),
          if (comment.approved) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(
                    comment.myVote == null || comment.myVote == false ? Icons.thumb_up_alt_outlined : Icons.thumb_up_alt,
                    size: 18,
                  ),
                  onPressed: () {
                    context.read<SocialCommentBloc>().voteComment(comment.id, postId, true);
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
                    context.read<SocialCommentBloc>().voteComment(comment.id, postId, false);
                  },
                ),
                Text(comment.downvotes.toString()),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
