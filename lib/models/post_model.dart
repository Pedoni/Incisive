import 'package:incisive/models/post_author_model.dart';

class PostModel {
  final String id;
  final String content;
  final DateTime datetime;
  final String title;
  final int approvedCommentsCount;
  final bool visible;
  final PostAuthorModel? author;

  PostModel({
    required this.id,
    required this.content,
    required this.datetime,
    required this.title,
    required this.approvedCommentsCount,
    required this.visible,
    required this.author,
  });
}
