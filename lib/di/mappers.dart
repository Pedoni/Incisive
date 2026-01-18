part of 'dependency_injector.dart';

final List<SingleChildWidget> _mappers = [
  Provider<DTOMapper<DiaryDTO, DiaryModel>>(
    create: (_) => DiaryMapper(),
  ),
  Provider<DTOMapper<GratitudeDTO, GratitudeModel>>(
    create: (_) => GratitudeMapper(),
  ),
  Provider<DTOMapper<PostDTO, PostModel>>(
    create: (_) => PostMapper(),
  ),
  Provider<DTOMapper<CommentDTO, CommentModel>>(
    create: (_) => CommentMapper(),
  ),
  Provider<DTOMapper<UserDTO, UserModel>>(
    create: (_) => UserMapper(),
  ),
];
