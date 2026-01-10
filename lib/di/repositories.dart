part of 'dependency_injector.dart';

final List<RepositoryProvider> _repositories = [
  RepositoryProvider<LoginRepository>(
    create: ((context) => LoginRepository(loginService: context.read())),
  ),
  RepositoryProvider<DiaryRepository>(
    create: ((context) => DiaryRepository(diaryService: context.read())),
  ),
  RepositoryProvider<UserRepository>(
    create: ((context) => UserRepository(userService: context.read())),
  ),
  RepositoryProvider<GratitudeRepository>(
    create: ((context) => GratitudeRepository(gratitudeService: context.read())),
  ),
  RepositoryProvider<BreathingRepository>(
    create: ((context) => BreathingRepository(breathingService: context.read())),
  ),
  RepositoryProvider<SocialRepository>(
    create: ((context) => SocialRepository(socialService: context.read())),
  ),
];
