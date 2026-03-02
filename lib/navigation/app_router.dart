import 'package:go_router/go_router.dart';
import 'package:incisive/models/post_model.dart';
import 'package:incisive/navigation/app_routes.dart';
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
import 'package:incisive/ui/pages/monthly_report_page.dart';
import 'package:incisive/ui/pages/pending_comments_page.dart';
import 'package:incisive/ui/pages/register_page.dart';
import 'package:incisive/ui/pages/social_page.dart';
import 'package:incisive/ui/pages/social_post_detail_page.dart';
import 'package:incisive/ui/pages/shop_page.dart';
import 'package:incisive/ui/pages/user_profile_page.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

GoRouter createRouter(AuthNotifier notifier) => GoRouter(
  refreshListenable: notifier,
  initialLocation: AppRoutes.login,

  redirect: (context, state) {
    final session = Supabase.instance.client.auth.currentSession;
    final location = state.uri.path;

    final isLoggingIn = location == AppRoutes.login;
    final isRegistering = location == AppRoutes.register;

    if (session == null && !isLoggingIn && !isRegistering) {
      return AppRoutes.login;
    }

    if (session != null && isLoggingIn) {
      return HomePage.routeName;
    }

    return null;
  },

  routes: [
    GoRoute(
      path: AppRoutes.login,
      builder: (_, _) => const LoginPage(),
    ),

    GoRoute(
      path: AppRoutes.register,
      builder: (_, _) => const RegisterPage(),
    ),

    GoRoute(
      path: HomePage.routeName,
      builder: (_, _) => const HomePage(),
    ),

    GoRoute(
      path: AppRoutes.diary,
      builder: (_, _) => const DiaryPage(),
    ),

    GoRoute(
      path: AppRoutes.gratitude,
      builder: (_, _) => const GratitudePage(),
    ),

    GoRoute(
      path: AppRoutes.chat,
      builder: (_, _) => const ChatPage(),
    ),

    GoRoute(
      path: AppRoutes.breathing,
      builder: (_, _) => const BreathingPage(),
    ),

    GoRoute(
      path: AppRoutes.social,
      builder: (_, _) => const SocialPage(),
    ),

    GoRoute(
      path: AppRoutes.addPost,
      builder: (_, _) => const AddPostPage(),
    ),

    GoRoute(
      path: AppRoutes.userProfile,
      builder: (_, _) => const UserProfilePage(),
    ),

    GoRoute(
      path: AppRoutes.shop,
      builder: (_, _) => const ShopPage(),
    ),

    GoRoute(
      path: AppRoutes.monthlyReport,
      builder: (_, _) => const MonthlyReportPage(),
    ),

    GoRoute(
      path: AppRoutes.upsertDiary,
      builder: (context, state) {
        final args = state.extra! as UpsertDiaryArgs;
        return UpsertDiaryPage(
          date: args.date,
          existingEntry: args.entry,
        );
      },
    ),

    GoRoute(
      path: AppRoutes.addComment,
      builder: (context, state) {
        final post = state.extra! as PostModel;
        return AddCommentPage(post: post);
      },
    ),

    GoRoute(
      path: AppRoutes.upsertGratitude,
      builder: (context, state) {
        final args = state.extra! as UpsertGratitudeArgs;
        return GratitudeUpsertPage(
          date: args.date,
          existingEntry: args.page,
        );
      },
    ),

    GoRoute(
      path: AppRoutes.socialPostDetail,
      builder: (context, state) {
        final args = state.extra! as SocialPostDetailArgs;
        return SocialPostDetailPage(post: args.post);
      },
    ),

    GoRoute(
      path: AppRoutes.pendingComments,
      builder: (context, state) {
        final args = state.extra! as SocialPostDetailArgs;
        return PendingCommentsPage(post: args.post);
      },
    ),
  ],
);
