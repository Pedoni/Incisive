import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:incisive/models/post_model.dart';
import 'package:incisive/navigation/args/social_post_detail_args.dart';
import 'package:incisive/ui/pages/social_post_detail_page.dart';
import 'package:incisive/utils/functions.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class SocialPostItem extends StatelessWidget {
  final PostModel post;

  const SocialPostItem({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    final time = TimeOfDay.fromDateTime(post.datetime.toLocal());

    return GestureDetector(
      onTap:
          () => context.push(
            SocialPostDetailPage.routeName,
            extra: SocialPostDetailArgs(post: post),
          ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
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
            Row(
              children: [
                Text(
                  '${time.hour.toString().padLeft(2, '0')}:'
                  '${time.minute.toString().padLeft(2, '0')}',
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
                            content: Image.asset("assets/images/${post.author?.avatarAsset}"),
                          ),
                    );
                  },
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: getUserBackgroundColor(post.author!.level),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/${post.author?.avatarAsset}',
                        width: 32,
                        height: 32,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) {
                          return const Icon(Icons.person, size: 16);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Text(
              post.title,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),

            Text(
              post.content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Nunito Sans',
                fontSize: 16,
                height: 1.45,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 15),
            Row(
              children: [
                if (post.author?.id == Supabase.instance.client.auth.currentUser?.id) ...[
                  const Icon(
                    Icons.person_2_sharp,
                    size: 15,
                  ),
                ],
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      size: 18,
                      color: Colors.black45,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      post.approvedCommentsCount.toString(),
                      style: const TextStyle(
                        fontFamily: 'Nunito Sans',
                        fontSize: 16,
                        color: Colors.black45,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
