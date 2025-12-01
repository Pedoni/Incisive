part of 'dependency_injector.dart';

final List<RepositoryProvider> _repositories = [
  RepositoryProvider<LoginRepository>(
    create: ((context) => LoginRepository(loginService: context.read())),
  ),
  RepositoryProvider<DiaryRepository>(
    create: ((context) => DiaryRepository(diaryService: context.read())),
  ),
];
