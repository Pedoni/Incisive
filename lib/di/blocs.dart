part of 'dependency_injector.dart';

final List<BlocProvider> _blocs = [
  BlocProvider<LoginBloc>(
    create:
        (context) => LoginBloc(
          loginRepository: context.read(),
        ),
  ),
];
