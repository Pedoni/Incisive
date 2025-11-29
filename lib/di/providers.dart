part of 'dependency_injector.dart';

final List<SingleChildWidget> _providers = [
  Provider<LoginService>(
    create: (context) => LoginService(),
  ),
];
