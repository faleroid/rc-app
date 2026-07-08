import 'package:flutter/material.dart';
import '../constants/app_colors.dart'; // Sesuaikan path jika perlu
import 'home_screen.dart';               // Pastikan path ke home_page.dart benar
import 'package.dart';            // Pastikan path ke package_page.dart benar

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // 0 untuk Home, 1 untuk Package
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // Sesuaikan dengan warna background aplikasimu

      // ─── INDEXED STACK ──────────────────────────────────────────
      // Menjaga state setiap halaman agar tidak hancur saat pindah tab.
      // Inilah kunci agar tombol onNavigateToPackage bisa ditekan berkali-kali.
      body: IndexedStack(
        index: _currentIndex,
        children: [
          // Index 0: Home Page
          HomePage(
            onNavigateToPackage: () {
              // Mengubah tab ke halaman Package (Index 1)
              setState(() {
                _currentIndex = 1;
              });
            },
          ),

          // Index 1: Package Page
          PackagePage(
            onNavigateToPricing: () {
              // Jika nanti kamu butuh navigasi khusus di dalam PackagePage
              // bisa ditambahkan di sini.
            },
          ),
        ],
      ),

      // ─── BOTTOM NAVIGATION BAR ──────────────────────────────────
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: AppColors.cardBorder, // Batas garis tipis di atas menu
              width: 1.0,
            ),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: AppColors.cardDark,
          selectedItemColor: AppColors.webRed,
          unselectedItemColor: AppColors.textWhite54,
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            // Pindah tab saat icon menu di bawah ditekan
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet),
              label: 'Package',
            ),
          ],
        ),
      ),
    );
  }
}