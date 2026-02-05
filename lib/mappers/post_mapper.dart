import 'package:incisive/mappers/dto/post_dto.dart';
import 'package:incisive/models/post_author_model.dart';
import 'package:incisive/models/post_model.dart';
import 'package:pine/utils/dto_mapper.dart';

class PostMapper extends DTOMapper<PostDTO, PostModel> {
  @override
  PostModel fromDTO(PostDTO dto) {
    return PostModel(
      id: dto.id,
      content: dto.content,
      datetime: DateTime.parse(dto.datetime),
      title: dto.title,
      approvedCommentsCount: dto.approvedCommentsCount,
      visible: dto.visible,
      author: PostAuthorModel(
        id: dto.author.id,
        firstName: dto.author.firstName,
        lastName: dto.author.lastName,
        avatarAsset: dto.author.avatarAsset,
        level: dto.author.level,
      ),
    );
  }

  @override
  PostDTO toDTO(PostModel model) {
    throw UnimplementedError();
  }
}
