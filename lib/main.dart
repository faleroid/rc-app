import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'constants/app_colors.dart';
import 'constants/app_text_styles.dart';
import 'constants/app_font_sizes.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/news_screen.dart';
import 'screens/academy_page.dart';
import 'screens/about_page.dart';
import 'screens/course_list_screen.dart';
import 'screens/package.dart';
import 'screens/chat_bot_screen.dart';
import 'services/token_service.dart';
import 'services/announcement_tracker_service.dart';
import 'repositories/profile_repository.dart';
import 'router/app_router.dart';
import 'constants/assets.dart';

import 'dart:ui'; // For PointerDeviceKind
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  runApp(const MyApp());
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch, // Touch screen
    PointerDeviceKind.mouse, // Mouse drag
    PointerDeviceKind.trackpad, // Trackpad
  };
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: appRouter,
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    final tokenService = TokenService(); // Token service instance
    final token = await tokenService.getToken(); // Retrieve token from storage

    if (!mounted) return;

    if (token != null && token.isNotEmpty) {
      try {
        final profileRepo = ProfileRepository();
        final res = await profileRepo.getProfile();
        if (res.data != null) {
          if (!mounted) return;
          context.go('/main', extra: {'isLoggedIn': true});
          return;
        }
      } catch (_) {
        await tokenService.deleteToken();
      }
    }

    if (!mounted) return;
    context.go('/main', extra: {'isLoggedIn': false});
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
    );
  }
}

class MainScreen extends StatefulWidget {
  final bool isLoggedIn;
  final int initialIndex;
  final int initialTabIndex;

  const MainScreen({
    super.key,
    this.isLoggedIn = false,
    this.initialIndex = 0,
    this.initialTabIndex = 0,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  String _userName = 'Profile';
  bool _isActive = false;
  bool _isLoggedIn = false;
  late TabController _tabController;
  final TokenService _tokenService = TokenService();

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _isLoggedIn = widget.isLoggedIn;

    _tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );

    // Listen to real-time auth state changes (login / logout)
    _tokenService.authNotifier.addListener(_onAuthStateChanged);
    _verifyAuthStatus();
  }

  @override
  void didUpdateWidget(covariant MainScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialIndex != oldWidget.initialIndex) {
      setState(() {
        _selectedIndex = widget.initialIndex;
      });
    }
    if (widget.initialTabIndex != oldWidget.initialTabIndex) {
      _tabController.animateTo(widget.initialTabIndex);
    }
    _verifyAuthStatus();
  }

  void _onAuthStateChanged() {
    _verifyAuthStatus();
  }

  Future<void> _verifyAuthStatus() async {
    final token = await _tokenService.getToken();

    if (token != null && token.isNotEmpty) {
      if (!mounted) return;
      setState(() {
        _isLoggedIn = true;
      });
      await _fetchProfile();
      AnnouncementTrackerService().checkUnreadAnnouncements();
    } else {
      if (!mounted) return;
      setState(() {
        _isLoggedIn = false;
        _userName = 'Profile';
        _isActive = false;
        if (_selectedIndex > 0) {
          _selectedIndex = 0; // Return to Beranda tab when logged out
        }
      });
    }
  }

  @override
  void dispose() {
    _tokenService.authNotifier.removeListener(_onAuthStateChanged);
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchProfile() async {
    try {
      final repo = ProfileRepository();
      final res = await repo.getProfile();
      if (res.data != null && mounted) {
        setState(() {
          _userName = res.data!.name.split(' ').first;
          _isActive = res.data!.isActive;
        });
      }
    } catch (e) {
      // Pass
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _navigateToacademy() {
    _tabController.animateTo(1);
  }

  void _navigateToPackage() {
    _tabController.animateTo(3);
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      // Bottom Nav: Home
      case 0:
        return Column(
          children: [
            const SizedBox(height: 20),

            // Tab Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                height: 42,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: AppColors.cardDark,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.cardBorder, width: 1),
                ),
                child: TabBar(
                  controller: _tabController,
                  dividerColor: Colors.transparent,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.35),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  labelColor: AppColors.textWhite,
                  unselectedLabelColor: AppColors.textWhite54,
                  labelStyle: const TextStyle(
                    fontSize: AppFontSizes.xs,
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: AppFontSizes.xs,
                    fontWeight: FontWeight.w500,
                  ),
                  splashFactory: NoSplash.splashFactory,
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                  tabs: const [
                    Tab(text: "Home"),
                    Tab(text: "Academy"),
                    Tab(text: "About"),
                    Tab(text: "Packages"),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Tab 0: Home
                  HomePage(onNavigateToPackage: _navigateToPackage),

                  // Tab 1: Academy
                  AcademyPage(onNavigateToPricing: _navigateToPackage),

                  // Tab 2: About
                  AboutPage(
                    onNavigateToAcademy: _navigateToacademy,
                    onNavigateToPackage: _navigateToPackage,
                  ),
                  // Tab 3: Packages
                  const PackagePage(),
                ],
              ),
            ),
          ],
        );
      case 1:
        return const NewsScreen();

      case 2:
        return const CourseListScreen();
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          AppImages.logo,
          width: 50,
          height: 50,
          errorBuilder: (context, error, stackTrace) => Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.currency_bitcoin,
              color: AppColors.textWhite,
              size: 18,
            ),
          ),
        ),
        backgroundColor: AppColors.background,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: _isLoggedIn
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Pengumuman VIP Button with Unread Badge Counter
                      ValueListenableBuilder<int>(
                        valueListenable:
                            AnnouncementTrackerService().unreadCountNotifier,
                        builder: (context, unreadCount, child) {
                          return IconButton(
                            icon: Badge(
                              isLabelVisible: unreadCount > 0,
                              label: Text(
                                unreadCount > 99
                                    ? '99+'
                                    : unreadCount.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              backgroundColor: AppColors.webRed,
                              child: const Icon(
                                Icons.campaign_outlined,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            tooltip: 'Pengumuman VIP',
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            constraints: const BoxConstraints(),
                            onPressed: () async {
                              await context.push('/announcements');
                              AnnouncementTrackerService()
                                  .checkUnreadAnnouncements();
                            },
                          );
                        },
                      ),
                      const SizedBox(width: 12),

                      // Profile Avatar & Name
                      GestureDetector(
                        onTap: () {
                          context.push('/profile');
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 14,
                              child: Icon(
                                Icons.person,
                                color: Color(0xFF3B0764),
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _userName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: AppFontSizes.sm,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.textPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 0,
                      ),
                    ),
                    onPressed: () {
                      context.push('/login');
                    },
                    child: const Text('Login', style: AppTextStyles.buttonBold),
                  ),
          ),
        ],
      ),

      body: _buildBody(),

      floatingActionButton: (_isLoggedIn && _isActive)
          ? FloatingActionButton.extended(
              onPressed: () {
                ChatBotScreen.showModal(context);
              },
              backgroundColor: AppColors.primary,
              icon: const Icon(Icons.smart_toy_rounded, color: Colors.white),
              label: const Text(
                'Tanya AI',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,

      bottomNavigationBar: (_isLoggedIn && _isActive)
          ? Container(
              decoration: const BoxDecoration(
                color: AppColors.background, // Dark background
                border: Border(
                  top: BorderSide(
                    color: AppColors.borderColor, // Top border
                    width: AppColors.borderWidth,
                  ),
                ),
              ),
              child: BottomNavigationBar(
                backgroundColor:
                    Colors.transparent, // Transparent to use container background
                elevation: 0, // Remove shadow
                type: BottomNavigationBarType.fixed,
                currentIndex: _selectedIndex,
                selectedItemColor: AppColors.primary,
                unselectedItemColor: Colors.white,
                onTap: _onItemTapped, // Handle tap

                items: const [
                  // Home
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined, color: AppColors.primary),
                    label: 'Beranda',
                  ),

                  // News
                  BottomNavigationBarItem(
                    icon: Icon(Icons.article_outlined, color: AppColors.primary),
                    label: 'Berita',
                  ),

                  // Module
                  BottomNavigationBarItem(
                    icon: Icon(Icons.menu_book_outlined, color: AppColors.primary),
                    label: 'Modul',
                  ),
                ],
              ),
            )
          : null,
    );
  }
}
