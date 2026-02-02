import 'package:incisive/mappers/dto/comment_dto.dart';
import 'package:incisive/models/comment_model.dart';
import 'package:pine/utils/dto_mapper.dart';

class CommentMapper extends DTOMapper<CommentDTO, CommentModel> {
  @override
  CommentModel fromDTO(CommentDTO dto) {
    return CommentModel(
      id: dto.id,
      postId: dto.postId,
      content: dto.content,
      createdAt: DateTime.parse(dto.createdAt),
      approved: dto.approved,
      upvotes: dto.upvotes,
      downvotes: dto.downvotes,
      myVote: dto.myVote,
      viewerUserId: dto.viewerUserId,
      author: CommentAuthorModel(
        id: dto.author.id,
        avatarAsset: dto.author.avatarAsset,
        level: dto.author.level,
      ),
    );
  }

  @override
  CommentDTO toDTO(CommentModel model) {
    throw UnimplementedError();
  }
}
