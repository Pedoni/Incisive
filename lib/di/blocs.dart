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
  BlocProvider<MoodTrackerBloc>(
    create: (context) => MoodTrackerBloc(diaryRepository: context.read()),
  ),
  BlocProvider<ProfileBloc>(
    create: (context) => ProfileBloc(userRepository: context.read()),
  ),
  BlocProvider<GratitudePageBloc>(
    create: (context) => GratitudePageBloc(gratitudeRepository: context.read()),
  ),
  BlocProvider<GratitudeUpsertBloc>(
    create: (context) => GratitudeUpsertBloc(gratitudeRepository: context.read()),
  ),
  BlocProvider<BreathingBloc>(
    create: (context) => BreathingBloc(breathingRepository: context.read()),
  ),
  BlocProvider<SocialBloc>(
    create: (context) => SocialBloc(socialRepository: context.read()),
  ),
  BlocProvider<CreatePostBloc>(
    create: (context) => CreatePostBloc(socialRepository: context.read()),
  ),
  BlocProvider<SocialCommentBloc>(
    create: (context) => SocialCommentBloc(socialRepository: context.read()),
  ),
  BlocProvider<CommentPostBloc>(
    create: (context) => CommentPostBloc(socialRepository: context.read()),
  ),
  BlocProvider<AvatarBloc>(
    create: (context) => AvatarBloc(userRepository: context.read()),
  ),
  BlocProvider<PurchaseBloc>(
    create: (context) => PurchaseBloc(userRepository: context.read()),
  ),
  BlocProvider<UserMonthlyStatsBloc>(
    create: (context) => UserMonthlyStatsBloc(monthlyStatsRepository: context.read()),
  ),
  BlocProvider<GlobalMonthlyStatsBloc>(
    create: (context) => GlobalMonthlyStatsBloc(monthlyStatsRepository: context.read()),
  ),
  BlocProvider<ChatBloc>(
    create: (context) => ChatBloc(
      chatRepository: context.read(),
      aiContextService: AiContextService(aiService: AiService()),
    ),
  ),
];
