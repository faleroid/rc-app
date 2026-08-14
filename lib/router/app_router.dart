import 'package:go_router/go_router.dart';
import '../main.dart';
import '../screens/login_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/change_password_screen.dart';
import '../screens/verify_password_screen.dart';
import '../screens/update_username_screen.dart';
import '../screens/news_screen.dart';
import '../screens/module_detail_screen.dart';
import '../screens/unauthenticated_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/unauthenticated',
      builder: (context, state) {
        final message = state.extra as String?;
        return UnauthenticatedScreen(message: message);
      },
    ),
    GoRoute(
      path: '/main',
      builder: (context, state) {
        final extraData = state.extra as Map<String, dynamic>? ?? {};
        final isLoggedIn = extraData['isLoggedIn'] as bool? ?? false;
        final initialIndex = extraData['index'] as int? ?? 0;
        final initialTabIndex = extraData['tabIndex'] as int? ?? 0;
        return MainScreen(
          isLoggedIn: isLoggedIn,
          initialIndex: initialIndex,
          initialTabIndex: initialTabIndex,
        );
      },
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
      routes: [
        GoRoute(
          path: 'verify-password',
          builder: (context, state) => const VerifyPasswordScreen(),
        ),
        GoRoute(
          path: 'change-password',
          builder: (context, state) {
            final currentPassword = state.extra as String? ?? '';
            return ChangePasswordScreen(currentPassword: currentPassword);
          },
        ),
      ],
    ),
    GoRoute(
      path: '/update-username',
      builder: (context, state) {
        final currentName = state.extra as String? ?? '';
        return UpdateUsernameScreen(currentName: currentName);
      },
    ),
    GoRoute(
      path: '/news',
      builder: (context, state) => const NewsScreen(),
    ),
    GoRoute(
      path: '/courses/:courseId/modules/:moduleId',
      builder: (context, state) {
        final courseId = int.parse(state.pathParameters['courseId']!);
        final moduleId = int.parse(state.pathParameters['moduleId']!);

        return ModuleDetailScreen(courseId: courseId, moduleId: moduleId);
      },
    ),
  ],
);
