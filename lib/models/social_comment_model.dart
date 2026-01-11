class SocialCommentModel {
  final String id;
  final String postId;
  final String authorId;
  final String content;
  final DateTime createdAt;
  final bool approved;
  final int upvotes;
  final int downvotes;

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
  });

  /// Helper: chi guarda è l’autore del commento?
  bool get isMine => authorId == viewerUserId;

  /// Helper: chi guarda è l’autore del post?
  bool isPostAuthor(String postAuthorId) => viewerUserId == postAuthorId;

  factory SocialCommentModel.fromMap(
    Map<String, dynamic> map, {
    required String viewerUserId,
  }) {
    return SocialCommentModel(
      id: map['id'] as String,
      postId: map['post_id'] as String,
      authorId: map['author_id'] as String,
      content: map['content'] as String,
      createdAt: DateTime.parse(map['created_at']),
      approved: map['approved'] as bool,
      upvotes: map['upvotes'] as int,
      downvotes: map['downvotes'] as int,
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
