part of 'dependency_injector.dart';

final List<BlocProvider> _blocs = [
  BlocProvider<LoginBloc>(
    create: (context) => LoginBloc(loginRepository: context.read()),
  ),
  BlocProvider<RegisterBloc>(
    create: (context) => RegisterBloc(loginRepository: context.read()),
  ),
  BlocProvider<DiaryPageBloc>(
    create: (context) => DiaryPageBloc(diaryRepository: context.read()),
  ),
  BlocProvider<UpsertPageBloc>(
    create: (context) => UpsertPageBloc(diaryRepository: context.read()),
  ),
];
