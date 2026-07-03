import 'package:flutter/material.dart';
import 'constants/app_colors.dart';
import 'constants/app_text_styles.dart';
import 'theme/app_theme.dart';
import 'data/dummy_data.dart';
import 'screens/home_screen.dart';

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
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

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
            child: TextButton(
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
                print('Login tapped');
              },
              child: const Text('Login', style: AppTextStyles.buttonBold),
            ),
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A1A),
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
