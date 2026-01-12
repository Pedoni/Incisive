class SocialCommentModel {
  final String id;
  final String postId;
  final String authorId;
  final String content;
  final DateTime createdAt;
  final bool approved;
  final int upvotes;
  final int downvotes;
  final bool? myVote;

  /// id dell’utente che sta guardando (serve solo lato UI)
  final String viewerUserId;

  SocialCommentModel({
    required this.id,
    required this.postId,
    required this.authorId,
    required this.content,
    required this.createdAt,
    required this.approved,
    required this.upvotes,
    required this.downvotes,
    required this.viewerUserId,
    this.myVote,
  });

  /// Helper: chi guarda è l’autore del commento?
  bool get isMine => authorId == viewerUserId;

  /// Helper: chi guarda è l’autore del post?
  bool isPostAuthor(String postAuthorId) => viewerUserId == postAuthorId;

  factory SocialCommentModel.fromMap(
    Map<String, dynamic> map, {
    required String viewerUserId,
  }) {
    final votes = (map['social_comment_vote'] as List<dynamic>? ?? []);

    int up = 0;
    int down = 0;
    bool? myVote;

    for (final v in votes) {
      final isUpvote = v['is_upvote'] as bool;
      final userId = v['user_id'] as String;

      if (isUpvote) {
        up++;
      } else {
        down++;
      }

      if (userId == viewerUserId) {
        myVote = isUpvote;
      }
    }

    return SocialCommentModel(
      id: map['id'],
      postId: map['post_id'],
      authorId: map['author_id'],
      content: map['content'],
      createdAt: DateTime.parse(map['created_at']),
      approved: map['approved'],
      upvotes: up,
      downvotes: down,
      myVote: myVote,
      viewerUserId: viewerUserId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'post_id': postId,
      'author_id': authorId,
      'content': content,
      'created_at': createdAt.toIso8601String(),
      'approved': approved,
      'upvotes': upvotes,
      'downvotes': downvotes,
    };
  }

  SocialCommentModel copyWith({
    bool? approved,
    int? upvotes,
    int? downvotes,
  }) {
    return SocialCommentModel(
      id: id,
      postId: postId,
      authorId: authorId,
      content: content,
      createdAt: createdAt,
      approved: approved ?? this.approved,
      upvotes: upvotes ?? this.upvotes,
      downvotes: downvotes ?? this.downvotes,
      viewerUserId: viewerUserId,
    );
  }
}
