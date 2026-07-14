
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

// ================================================================
// FILE: main.dart
// DESKRIPSI: Titik masuk utama aplikasi RicoCapital.
//
// ALUR APLIKASI:
//   1. main() → MyApp → SplashScreen
//   2. SplashScreen cek token (auto-login)
//      - Ada token  → MainScreen(isLoggedIn: true)
//      - Tidak ada  → LoginScreen
//   3. MainScreen mengelola seluruh navigasi:
//      - Tab atas  : Home | Academy | Profile | Packages
//      - Bottom Nav: Beranda | Berita | Modul
//      - Gradient background dinamis sesuai tab aktif
//
// DEPENDENCIES:
//   constants/app_colors.dart    → semua warna aplikasi
//   constants/app_text_styles.dart → semua style teks
//   theme/app_theme.dart         → tema global MaterialApp
//   data/dummy_data.dart         → data dummy untuk development
//   screens/home_screen.dart     → halaman beranda utama
//   screens/login_screen.dart    → halaman login
//   service/token_service.dart   → cek/simpan/hapus token auth
//   repositories/auth_repository.dart → logika login/logout ke API
//   widgets/auto_scroll_ticker.dart   → widget scroll otomatis
// ================================================================

import 'dart:ui'; // Untuk PointerDeviceKind (deteksi jenis input perangkat)


// ================================================================
// FUNGSI MAIN
// Fungsi pertama yang dipanggil saat aplikasi dijalankan.
// Langsung menjalankan MyApp sebagai widget root.
// ================================================================
void main() {
  runApp(const MyApp());
}

// ================================================================
// CLASS: MyCustomScrollBehavior
//
// FUNGSI: Memperluas perilaku scroll default Flutter agar mendukung
//         berbagai jenis perangkat input, tidak hanya touchscreen.
//
// MENGAPA DIBUTUHKAN:
//   Secara default, Flutter hanya mengizinkan drag/scroll via sentuhan.
//   Kelas ini menambahkan dukungan mouse & trackpad, sehingga aplikasi
//   tetap bisa di-scroll saat dijalankan di:
//   - Emulator Android/iOS di laptop (via mouse)
//   - Flutter Web
//   - Flutter Desktop
// ================================================================
class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,    // Sentuhan jari di layar HP/tablet
    PointerDeviceKind.mouse,    // Klik dan seret dengan mouse
    PointerDeviceKind.trackpad, // Geser dengan trackpad laptop
  };
}

// ================================================================
// CLASS: MyApp
//
// FUNGSI: Widget root aplikasi. Semua konfigurasi global didefinisikan
//         di sini dan akan berlaku di seluruh halaman aplikasi.
//
// TANGGUNG JAWAB:
//   - Mengatur tema visual global (warna, font, style) via AppTheme.darkTheme
//   - Mengaktifkan scroll multi-device via MyCustomScrollBehavior
//   - Menentukan halaman pertama yang ditampilkan → SplashScreen
//   - Menyembunyikan banner "DEBUG" di pojok kanan atas
//
// CATATAN: Widget ini StatelessWidget karena tidak punya state yang
//          berubah — konfigurasinya statis di seluruh siklus hidup app.
// ================================================================
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

// ================================================================
// CLASS: SplashScreen
//
// FUNGSI: Layar loading sementara yang ditampilkan saat aplikasi
//         pertama kali dibuka. Tugasnya adalah memeriksa apakah
//         pengguna sudah login sebelumnya (ada token tersimpan).
//
// ALUR KERJA:
//   1. Tampilkan loading spinner (CircularProgressIndicator)
//   2. Panggil TokenService untuk baca token dari local storage
//   3. Jika token ADA  → langsung ke MainScreen (sudah login)
//   4. Jika token TIDAK ADA → ke LoginScreen (harus login dulu)
//
// MENGAPA StatefulWidget:
//   Karena perlu menjalankan kode async di initState() untuk
//   mengecek token sebelum navigasi dilakukan.
// ================================================================
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // ── LIFECYCLE ────────────────────────────────────────────────

  /// Dipanggil otomatis oleh Flutter saat widget pertama kali dibuat.
  /// Langsung trigger pengecekan status login.
  @override
  void initState() {
    super.initState();
    // _checkLoginStatus(); // Mulai cek token segera setelah widget muncul
  }

  // ── METHODS ──────────────────────────────────────────────────

  /// Mengecek apakah pengguna sudah pernah login dengan membaca
  /// token yang tersimpan di local storage perangkat.
  ///
  /// - Menggunakan TokenService untuk operasi storage yang aman.
  /// - Navigasi dilakukan dengan pushReplacement agar SplashScreen
  ///   tidak bisa di-back oleh pengguna setelah berpindah halaman.
  /// - Pengecekan `mounted` mencegah error jika widget sudah
  ///   dihancurkan sebelum operasi async selesai.
  void _checkLoginStatus() async {
    final tokenService = TokenService(); // Inisialisasi layanan token
    final token = await tokenService.getToken(); // Baca token dari storage

    // Guard: Pastikan widget masih aktif sebelum navigasi
    // (Mencegah error "setState called after dispose")
    if (!mounted) return;

    if (token != null) {
      context.go('/main', extra: {'isLoggedIn': true});
    } else {
      context.go('/login');
      // ── TOKEN DITEMUKAN → Pengguna sudah pernah login ──────
      // Langsung masuk ke MainScreen tanpa perlu login lagi.
      // isLoggedIn: true → AppBar akan tampilkan tombol "Logout"
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const MainScreen(isLoggedIn: true),
        ),
      );
    }
  }
  // ── BUILD ─────────────────────────────────────────────────────

  /// Tampilan saat SplashScreen aktif: hanya loading spinner di tengah.
  /// Warna spinner mengikuti warna primary dari AppColors.
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        // Spinner putar tanda sedang memproses (cek token)
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }
}

// ================================================================
// CLASS: MainScreen
//
// FUNGSI: Kerangka utama aplikasi setelah pengguna berhasil
//         terautentikasi. Mengelola seluruh navigasi dan tampilan
//         konten berdasarkan tab dan bottom nav yang dipilih.
//
// STRUKTUR LAYAR:
//   ┌─────────────────────────────────┐
//   │  AppBar (Logo + Login/Logout)   │  ← Selalu terlihat
//   ├─────────────────────────────────┤
//   │  Tab Bar (Home|Academy|Profile  │  ← Hanya di bottom index 0
//   │           |Packages)            │
//   ├─────────────────────────────────┤
//   │                                 │
//   │     Konten Halaman Aktif        │  ← Berubah sesuai tab
//   │                                 │
//   ├─────────────────────────────────┤
//   │  Bottom Nav (Beranda|Berita     │  ← Selalu terlihat
//   │              |Modul)            │
//   └─────────────────────────────────┘
//
// STATE YANG DIKELOLA:
//   _selectedIndex      → item bottom nav aktif (0=Beranda, 1=Berita, 2=Modul)
//   _tabIndex           → tab aktif di atas (0=Home, 1=Academy, 2=Profile, 3=Packages)
//   _bottomNavIndex     → sinkron dengan _selectedIndex untuk bottom nav widget
//   _scrollToPricingOnHome → flag auto-scroll ke section Pricing di HomePage
//
// PARAMETER:
//   isLoggedIn → diterima dari SplashScreen/LoginScreen, menentukan
//                apakah AppBar tampilkan tombol "Login" atau "Logout"
// ================================================================
class MainScreen extends StatefulWidget {
  /// Status autentikasi pengguna.
  /// true  → tampilkan tombol "Logout" di AppBar
  /// false → tampilkan tombol "Login" di AppBar
  final bool isLoggedIn;
  final int initialIndex;
  final int initialTabIndex;

  const MainScreen({super.key, this.isLoggedIn = false, this.initialIndex = 0, this.initialTabIndex = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  // ── STATE VARIABLES ──────────────────────────────────────────

  /// Index item yang aktif di BottomNavigationBar.
  /// 0 = Beranda (menampilkan tab system)
  /// 1 = Berita
  /// 2 = Modul
  int _selectedIndex = 0;
  String _userName = 'Profile';

  /// TabController eksplisit — memungkinkan navigasi programatik
  /// ke tab mana pun, berulang kali tanpa masalah.
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

  // ── HELPER METHODS ────────────────────────────────────────────

  /// Dipanggil saat user menekan item di BottomNavigationBar.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  /// Navigasi ke tab Academy (index 1).
  /// Menggunakan animateTo() yang selalu bisa dipanggil berulang.
  void _navigateToacademy() {
    _tabController.animateTo(1);
  }

  /// Navigasi ke tab Package (index 3).
  /// Menggunakan animateTo() yang selalu bisa dipanggil berulang.
  void _navigateToPackage() {
    _tabController.animateTo(3);
  }

  // ── TAB CONTENT BUILDER ───────────────────────────────────────

  Widget _buildBody() {
    switch (_selectedIndex) {

    // ── BOTTOM NAV 0: BERANDA ─────────────────────────────
      case 0:
        return Column(
          children: [

            const SizedBox(height: 20),

            // ── TAB BAR ───────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.tabInactiveBackground,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: "Home"),     // index 0
                    Tab(text: "Academy"),  // index 1
                    Tab(text: "About"),    // index 2
                    Tab(text: "Packages"), // index 3
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            // ── TAB CONTENT (TabBarView) ──────────────────
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [

                  // ── TAB 0: HOME ──────────────────────────
                  HomePage(
                    onNavigateToPackage: _navigateToPackage,
                  ),

                  // ── TAB 1: ACADEMY ───────────────────────
                  AcademyPage(
                    onNavigateToPricing: _navigateToPackage,
                  ),

                  // ── TAB 2: ABOUT ────────────────────────
                  AboutPage(
                    onNavigateToAcademy: _navigateToacademy,
                    onNavigateToPackage: _navigateToPackage,
                  ),
                  // ── TAB 3: PACKAGES ──────────────────────
                  const PackagePage(),

                ],
              ),
            ),
          ],
        );

    // ── BOTTOM NAV 1: BERITA ──────────────────────────────
    // Placeholder untuk halaman Berita.
    // TODO: Buat BeritaScreen() dan ganti widget ini
      case 1:
        return const NewsScreen();

      case 2:
        return const Center(
          child: Text(
            'Modul Screen',
            style: AppTextStyles.bodyPlaceholder,
          ),
        );

    // ── DEFAULT (fallback) ────────────────────────────────
    // Jika _selectedIndex tidak cocok dengan case manapun,
    // tampilkan widget kosong (tidak seharusnya terjadi).
      default:
        return const SizedBox.shrink();
    }
  }

  // ── BUILD ─────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ── APP BAR ────────────────────────────────────────────
      // Header di paling atas dengan judul app dan tombol Login/Logout.
      // Tombol yang ditampilkan bergantung pada widget.isLoggedIn.
      appBar: AppBar(
        title: const Text('RicoCapital App'), // Judul di AppBar

        // ── TOMBOL AKSI DI KANAN APPBAR ─────────────────────
        // actions adalah daftar widget di sisi kanan AppBar.
        // Hanya ada satu widget di sini: tombol Login atau Logout.
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),

            // ── KONDISI: SUDAH LOGIN atau BELUM? ────────────
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

            // ── SUDAH LOGIN → Tampilkan tombol LOGOUT ────
          ),
          )
        ],
      ),

      // ── BODY ───────────────────────────────────────────────
      // Konten utama yang berubah sesuai _selectedIndex.
      // _buildBody() menentukan widget mana yang ditampilkan.
      body: _buildBody(),

      // ── BOTTOM NAVIGATION BAR ──────────────────────────────
      // Navigasi bawah dengan 3 item: Beranda | Berita | Modul.
      // Dibungkus Container untuk menambahkan border atas dan
      // warna background kustom.
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.background, // Background sesuai tema gelap
          border: Border(
            top: BorderSide(
              color: AppColors.borderColor, // Garis tipis di atas bottom nav
              width: AppColors.borderWidth, // Ketebalan garis (dari AppColors)
            ),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent, // Transparan → pakai warna Container
          elevation: 0,                         // Hapus shadow bawaan Flutter
          type: BottomNavigationBarType.fixed,  // Lebar item tetap (tidak menyusut)
          currentIndex: _selectedIndex,          // Item yang sedang aktif
          selectedItemColor: AppColors.primary,  // Warna item aktif (merah)
          unselectedItemColor: Colors.white,     // Warna item non-aktif (putih)
          onTap: _onItemTapped,                  // Callback saat item ditekan

          items: const [
            // ── ITEM 0: BERANDA ───────────────────────────
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, color: AppColors.primary),
              label: 'Beranda',
            ),

            // ── ITEM 1: BERITA ────────────────────────────
            BottomNavigationBarItem(
              icon: Icon(Icons.article_outlined, color: AppColors.primary),
              label: 'Berita',
            ),

            // ── ITEM 2: MODUL ─────────────────────────────
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