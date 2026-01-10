import 'package:flutter/material.dart';
import 'package:incisive/models/social_post_model.dart';

class SocialPostItem extends StatelessWidget {
  final SocialPostModel post;

  const SocialPostItem({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    final time = TimeOfDay.fromDateTime(post.datetime.toLocal());

    return Container(
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
          /// HEADER
          Row(
            children: [
              const Icon(
                Icons.person_outline,
                size: 20,
                color: Colors.black45,
              ),
              const SizedBox(width: 6),
              const Text(
                "Una persona",
                style: TextStyle(
                  fontFamily: 'Nunito Sans',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
              const Spacer(),
              Text(
                '${time.hour.toString().padLeft(2, '0')}:'
                '${time.minute.toString().padLeft(2, '0')}',
                style: const TextStyle(
                  fontFamily: 'Nunito Sans',
                  fontSize: 12,
                  color: Colors.black45,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// TITOLO (se presente)
          if (post.title.trim().isNotEmpty) ...[
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
          ],

          /// CONTENUTO
          Text(
            post.content,
            style: const TextStyle(
              fontFamily: 'Nunito Sans',
              fontSize: 16,
              height: 1.45,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
