import 'package:flutter/material.dart';
import 'constants/app_colors.dart';
import 'constants/app_text_styles.dart';
import 'theme/app_theme.dart';
import 'data/dummy_data.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'service/token_service.dart';
import 'repositories/auth_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const SplashScreen(),
    );
  }
}

/// SplashScreen: cek token untuk auto-login
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
    final tokenService = TokenService();
    final token = await tokenService.getToken();

    if (!mounted) return;

    if (token != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const MainScreen(isLoggedIn: true),
        ),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
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

  const MainScreen({super.key, this.isLoggedIn = false});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return DefaultTabController(
          length: 4,
          child: Column(
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.tabInactiveBackground,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const TabBar(
                    tabs: [
                      Tab(text: "Home"),
                      Tab(text: "Academy"),
                      Tab(text: "Profile"),
                      Tab(text: "Packages"),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: TabBarView(
                  children: [
                    const HomeScreen(cards: dummyCards),
                    const Center(
                      child: Text(
                        'Hello World - Academy',
                        style: AppTextStyles.bodyPlaceholder,
                      ),
                    ),
                    const Center(
                      child: Text(
                        'Hello World - Profile',
                        style: AppTextStyles.bodyPlaceholder,
                      ),
                    ),
                    const Center(
                      child: Text(
                        'Hello World - Packages',
                        style: AppTextStyles.bodyPlaceholder,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      case 1:
        return const Center(
          child: Text('Berita Screen', style: AppTextStyles.bodyPlaceholder),
        );
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
        title: const Text('RicoCapital App'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: widget.isLoggedIn
                ? TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey[900],
                      foregroundColor: AppColors.textPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 0,
                      ),
                    ),
                    onPressed: () async {
                      final authRepository = AuthRepository();
                      await authRepository.logout();

                      if (!mounted) return;

                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) =>
                              const MainScreen(isLoggedIn: false),
                        ),
                        (route) => false,
                      );
                    },
                    child: const Text(
                      'Logout',
                      style: AppTextStyles.buttonBold,
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
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: const Text('Login', style: AppTextStyles.buttonBold),
                  ),
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.background,
          border: Border(
            top: BorderSide(
              color: AppColors.borderColor,
              width: AppColors.borderWidth,
            ),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.white,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, color: AppColors.primary),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.article_outlined, color: AppColors.primary),
              label: 'Berita',
            ),
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
