part of 'dependency_injector.dart';

final List<SingleChildWidget> _mappers = [
  Provider<DTOMapper<DiaryDTO, DiaryModel>>(
    create: (_) => DiaryMapper(),
  ),
  Provider<DTOMapper<GratitudeDTO, GratitudePageModel>>(
    create: (_) => GratitudeMapper(),
  ),
  Provider<DTOMapper<PostDTO, SocialPostModel>>(
    create: (_) => PostMapper(),
  ),
];
