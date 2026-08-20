import 'package:go_router/go_router.dart';
import '../main.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/payment_checkout_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/change_password_screen.dart';
import '../screens/verify_password_screen.dart';
import '../screens/update_username_screen.dart';
import '../screens/news_screen.dart';
import '../screens/module_detail_screen.dart';
import '../screens/chat_bot_screen.dart';
import '../screens/unauthenticated_screen.dart';
import '../screens/payment_webview_screen.dart';
import '../screens/privacy_policy_screen.dart';
import '../models/payment_model.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/chat',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        return ChatBotScreen(
          courseId: extra['courseId'] as int?,
          moduleId: extra['moduleId'] as int?,
          courseTitle: extra['courseTitle'] as String?,
          moduleTitle: extra['moduleTitle'] as String?,
        );
      },
    ),
    GoRoute(
      path: '/unauthenticated',
      builder: (context, state) {
        final message = state.extra as String?;
        return UnauthenticatedScreen(message: message);
      },
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) {
        final initialPackageId = state.extra as int?;
        return RegisterScreen(initialPackageId: initialPackageId);
      },
    ),
    GoRoute(
      path: '/checkout',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        final package = extra['package'] as MembershipPackageModel;
        final userName = extra['userName'] as String? ?? 'Member';
        final userEmail = extra['userEmail'] as String? ?? '-';
        final userPhone = extra['userPhone'] as String? ?? '-';

        return PaymentCheckoutScreen(
          package: package,
          userName: userName,
          userEmail: userEmail,
          userPhone: userPhone,
        );
      },
    ),
    GoRoute(
      path: '/payment-webview',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return PaymentWebviewScreen(
          redirectUrl: extra['redirectUrl'],
          paymentId: extra['paymentId'],
        );
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
        GoRoute(
          path: 'privacy-policy',
          builder: (context, state) => const PrivacyPolicyScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/privacy-policy',
      builder: (context, state) => const PrivacyPolicyScreen(),
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
