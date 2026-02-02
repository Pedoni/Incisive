import 'package:go_router/go_router.dart';
import 'package:incisive/models/post_model.dart';
import 'package:incisive/navigation/args/social_post_detail_args.dart';
import 'package:incisive/navigation/args/upsert_diary_args.dart';
import 'package:incisive/navigation/args/upsert_gratitude_args.dart';
import 'package:incisive/navigation/auth_notifier.dart';
import 'package:incisive/ui/pages/add_comment_page.dart';
import 'package:incisive/ui/pages/add_post_page.dart';
import 'package:incisive/ui/pages/breathing_page.dart';
import 'package:incisive/ui/pages/chat_page.dart';
import 'package:incisive/ui/pages/diary_page.dart';
import 'package:incisive/ui/pages/diary_upsert_page.dart';
import 'package:incisive/ui/pages/gratitude_page.dart';
import 'package:incisive/ui/pages/gratitude_upsert_page.dart';
import 'package:incisive/ui/pages/home_page.dart';
import 'package:incisive/ui/pages/login_page.dart';
import 'package:incisive/ui/pages/mood_calendar_page.dart';
import 'package:incisive/ui/pages/pending_comments_page.dart';
import 'package:incisive/ui/pages/register_page.dart';
import 'package:incisive/ui/pages/social_page.dart';
import 'package:incisive/ui/pages/social_post_detail_page.dart';
import 'package:incisive/ui/pages/store_page.dart';
import 'package:incisive/ui/pages/user_profile_page.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

GoRouter createRouter(AuthNotifier notifier) => GoRouter(
  refreshListenable: notifier,
  initialLocation: LoginPage.routeName,

  redirect: (context, state) {
    final session = Supabase.instance.client.auth.currentSession;
    final location = state.uri.path;

    final isLoggingIn = location == LoginPage.routeName;
    final isRegistering = location == RegisterPage.routeName;

    if (session == null && !isLoggingIn && !isRegistering) {
      return LoginPage.routeName;
    }

    if (session != null && isLoggingIn) {
      return HomePage.routeName;
    }

    return null;
  },

  routes: [
    GoRoute(
      path: LoginPage.routeName,
      builder: (_, _) => const LoginPage(),
    ),

    GoRoute(
      path: RegisterPage.routeName,
      builder: (_, _) => const RegisterPage(),
    ),

    GoRoute(
      path: HomePage.routeName,
      builder: (_, _) => const HomePage(),
    ),

    GoRoute(
      path: DiaryPage.routeName,
      builder: (_, _) => const DiaryPage(),
    ),

    GoRoute(
      path: MoodCalendarPage.routeName,
      builder: (_, _) => const MoodCalendarPage(),
    ),

    GoRoute(
      path: GratitudePage.routeName,
      builder: (_, _) => const GratitudePage(),
    ),

    GoRoute(
      path: ChatPage.routeName,
      builder: (_, _) => const ChatPage(),
    ),

    GoRoute(
      path: BreathingPage.routeName,
      builder: (_, _) => const BreathingPage(),
    ),

    GoRoute(
      path: SocialPage.routeName,
      builder: (_, _) => const SocialPage(),
    ),

    GoRoute(
      path: AddPostPage.routeName,
      builder: (_, _) => const AddPostPage(),
    ),

    GoRoute(
      path: UserProfilePage.routeName,
      builder: (_, _) => const UserProfilePage(),
    ),

    GoRoute(
      path: StorePage.routeName,
      builder: (_, _) => const StorePage(),
    ),

    GoRoute(
      path: UpsertDiaryPage.routeName,
      builder: (context, state) {
        final args = state.extra! as UpsertDiaryArgs;
        return UpsertDiaryPage(
          date: args.date,
          existingEntry: args.entry,
        );
      },
    ),

    GoRoute(
      path: AddCommentPage.routeName,
      builder: (context, state) {
        final post = state.extra! as PostModel;
        return AddCommentPage(post: post);
      },
    ),

    GoRoute(
      path: GratitudeUpsertPage.routeName,
      builder: (context, state) {
        final args = state.extra! as UpsertGratitudeArgs;
        return GratitudeUpsertPage(
          date: args.date,
          existingEntry: args.page,
        );
      },
    ),

    GoRoute(
      path: SocialPostDetailPage.routeName,
      builder: (context, state) {
        final args = state.extra! as SocialPostDetailArgs;
        return SocialPostDetailPage(post: args.post);
      },
    ),

    GoRoute(
      path: PendingCommentsPage.routeName,
      builder: (context, state) {
        final args = state.extra! as SocialPostDetailArgs;
        return PendingCommentsPage(post: args.post);
      },
    ),
  ],
);
