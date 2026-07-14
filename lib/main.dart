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
import 'screens/package.dart';
import 'services/token_service.dart';
import 'repositories/profile_repository.dart';
import 'router/app_router.dart';
import 'constants/assets.dart';

import 'dart:ui'; // For PointerDeviceKind

void main() {
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
    _checkLoginStatus(); // Check login status on startup
  }

  void _checkLoginStatus() async {
    final tokenService = TokenService(); // Token service instance
    final token = await tokenService.getToken(); // Retrieve token from storage

    if (!mounted) return;

    if (token != null) {
      context.go('/main', extra: {'isLoggedIn': true});
    } else {
      context.go('/login');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const MainScreen(isLoggedIn: true),
        ),
      );
    }
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
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;

    _tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );

    if (widget.isLoggedIn) {
      _fetchProfile();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchProfile() async {
    try {
      final repo = ProfileRepository();
      final res = await repo.getProfile();
      if (res.data != null) {
        setState(() {
          _userName = res.data!.name.split(' ').first;
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
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.borderColor, width: 0.5),
                ),
                child: TabBar(
                  controller: _tabController,
                  dividerColor: Colors.transparent,
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
        return const Center(
          child: Text('Modul Screen', style: AppTextStyles.bodyPlaceholder),
        );
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
            child: widget.isLoggedIn
                ? GestureDetector(
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
                      context.go('/login');
                    },
                    child: const Text('Login', style: AppTextStyles.buttonBold),
                  ),
          ),
        ],
      ),

      body: _buildBody(),

      bottomNavigationBar: Container(
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
          backgroundColor: Colors.transparent, // Transparent to use container background
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
      ),
    );
  }
}
