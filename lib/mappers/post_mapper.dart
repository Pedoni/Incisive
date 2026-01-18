import 'package:incisive/mappers/dto/post_dto.dart';
import 'package:incisive/models/post_model.dart';
import 'package:pine/utils/dto_mapper.dart';

class PostMapper extends DTOMapper<PostDTO, PostModel> {
  @override
  PostModel fromDTO(PostDTO dto) {
    return PostModel(
      id: dto.id,
      content: dto.content,
      authorId: dto.authorId,
      datetime: DateTime.parse(dto.datetime),
      title: dto.title,
      approvedCommentsCount: dto.approvedCommentsCount,
    );
  }

  @override
  PostDTO toDTO(PostModel model) {
    throw UnimplementedError();
  }
}
