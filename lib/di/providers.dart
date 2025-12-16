part of 'dependency_injector.dart';

final List<SingleChildWidget> _providers = [
  Provider<LoginService>(
    create: (context) => LoginService(),
  ),
  Provider<DiaryService>(
    create: (context) => DiaryService(),
  ),
  Provider<UserService>(
    create: (context) => UserService(),
  ),
];
