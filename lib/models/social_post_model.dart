class SocialPostModel {
  final String id;
  final String content;
  final DateTime datetime;
  final String authorId;
  final String title;
  final int approvedCommentsCount;

  SocialPostModel({
    required this.id,
    required this.content,
    required this.datetime,
    required this.authorId,
    required this.title,
    required this.approvedCommentsCount,
  });
}
