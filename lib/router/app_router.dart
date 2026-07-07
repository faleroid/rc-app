import 'package:go_router/go_router.dart';
import '../main.dart';
import '../screens/login_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/change_password_screen.dart';
import '../screens/verify_password_screen.dart';
import '../screens/update_username_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/main',
      builder: (context, state) {
        final isLoggedIn = state.extra as bool? ?? false;
        return MainScreen(isLoggedIn: isLoggedIn);
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
        // Menangkap nama saat ini yang dilempar dari halaman Profile
        final currentName = state.extra as String? ?? '';
        return UpdateUsernameScreen(currentName: currentName);
      },
    ),
  ],
);
