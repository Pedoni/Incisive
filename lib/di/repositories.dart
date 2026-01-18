part of 'dependency_injector.dart';

final List<RepositoryProvider> _repositories = [
  RepositoryProvider<LoginRepository>(
    create: ((context) => LoginRepository(loginService: context.read())),
  ),
  RepositoryProvider<DiaryRepository>(
    create:
        ((context) => DiaryRepository(
          diaryService: context.read(),
          diaryMapper: context.read(),
        )),
  ),
  RepositoryProvider<UserRepository>(
    create:
        ((context) => UserRepository(
          userService: context.read(),
          userMapper: context.read(),
        )),
  ),
  RepositoryProvider<GratitudeRepository>(
    create:
        ((context) => GratitudeRepository(
          gratitudeService: context.read(),
          gratitudeMapper: context.read(),
        )),
  ),
  RepositoryProvider<BreathingRepository>(
    create: ((context) => BreathingRepository(breathingService: context.read())),
  ),
  RepositoryProvider<SocialRepository>(
    create:
        ((context) => SocialRepository(
          socialService: context.read(),
          postMapper: context.read(),
          commentMapper: context.read(),
        )),
  ),
];
