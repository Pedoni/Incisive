import 'package:incisive/mappers/dto/post_dto.dart';
import 'package:incisive/models/social_post_model.dart';
import 'package:pine/utils/dto_mapper.dart';

class PostMapper extends DTOMapper<PostDTO, SocialPostModel> {
  @override
  SocialPostModel fromDTO(PostDTO dto) {
    return SocialPostModel(
      id: dto.id,
      content: dto.content,
      authorId: dto.authorId,
      datetime: DateTime.parse(dto.datetime),
      title: dto.title,
      approvedCommentsCount: dto.approvedCommentsCount,
    );
  }

  @override
  PostDTO toDTO(SocialPostModel model) {
    throw UnimplementedError();
  }
}
