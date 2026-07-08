import 'package:go_router/go_router.dart';
import '../main.dart';
import '../screens/login_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/change_password_screen.dart';
import '../screens/verify_password_screen.dart';
import '../screens/update_username_screen.dart';
import '../screens/news_screen.dart';
import '../screens/detail_news_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/main',
      builder: (context, state) {
        final extraData = state.extra as Map<String, dynamic>? ?? {};
        final isLoggedIn = extraData['isLoggedIn'] as bool? ?? false;
        final initialIndex = extraData['index'] as int? ?? 0;
        final initialTabIndex = extraData['tabIndex'] as int? ?? 0;
        return MainScreen(isLoggedIn: isLoggedIn, initialIndex: initialIndex, initialTabIndex: initialTabIndex);
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
    GoRoute(
      path: '/news',
      builder: (context, state) => const NewsScreen(),
      routes: [
        // Rute anak (anak dari /news, jadinya /news/judul-berita-abc)
        GoRoute(
          path: ':slug',
          builder: (context, state) {
            // Mengambil parameter slug dari URL/Alamat rute
            final slug = state.pathParameters['slug'] ?? '';
            return DetailNewsScreen(slug: slug);
          },
        ),
      ],
    ),
  ],
);
