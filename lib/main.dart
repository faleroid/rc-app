
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'constants/app_colors.dart';
import 'constants/app_text_styles.dart';
import 'constants/app_font_sizes.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/news_screen.dart';
import 'screens/academy_page.dart';
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
    _checkLoginStatus(); // Mulai cek token segera setelah widget muncul
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

  const MainScreen({super.key, this.isLoggedIn = false, this.initialIndex = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // ── STATE VARIABLES ──────────────────────────────────────────

  /// Index item yang aktif di BottomNavigationBar.
  /// 0 = Beranda (menampilkan tab system)
  /// 1 = Berita
  /// 2 = Modul
  int _selectedIndex = 0;
  String _userName = 'Profile';

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    if (widget.isLoggedIn) {
      _fetchProfile();
    }
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

  /// Index tab aktif di TabBar bagian atas (hanya muncul di Beranda).
  /// 0 = Home | 1 = Academy | 2 = Profile | 3 = Packages
  int _tabIndex = 0;

  /// Sinkron dengan _selectedIndex, digunakan khusus untuk
  /// AppBottomNavBar widget yang membutuhkan parameter terpisah.
  int _bottomNavIndex = 0;

  /// Flag khusus untuk memicu auto-scroll ke section Pricing
  /// di dalam HomePage. Direset ke false setelah scroll selesai
  /// agar tidak scroll ulang saat tab dibuka kembali.
  bool _scrollToPricingOnHome = false;

  // ── HELPER METHODS ────────────────────────────────────────────

  /// Dipanggil saat user menekan item di BottomNavigationBar.
  /// Memperbarui _selectedIndex → Flutter rebuild → tampilan berubah.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  /// Navigasi paksa ke tab Home (index 0) sekaligus mengaktifkan
  /// flag _scrollToPricingOnHome agar HomePage auto-scroll ke bagian Pricing.
  ///
  /// Dipanggil dari dalam halaman Academy via callback onNavigateToPricing,
  /// misalnya saat user menekan tombol "Lihat Paket" di halaman Academy.
  void _navigateToHomeAndScroll() {
    setState(() {
      _tabIndex = 0;                 // Pindah ke tab Home
      _scrollToPricingOnHome = true; // Aktifkan flag → HomePage akan auto-scroll
    });
  }

  /// Menentukan warna gradient background berdasarkan tab yang aktif.
  ///
  /// Setiap tab memiliki nuansa warna berbeda untuk memberi pengalaman
  /// visual yang khas per halaman:
  ///   - Tab Profile (index 2) → Gradient ungu (warna brand profil)
  ///   - Tab lainnya           → Gradient hitam/gelap (warna utama web)
  ///
  /// Return: List<Color> berisi 3 warna untuk LinearGradient (atas→tengah→bawah)
  List<Color> _getGradientColors() {
    if (_tabIndex == 2) {
      // ── PROFILE TAB → Gradient ungu khas halaman profil ────
      return const [
        AppColors.profileGradientTop,    // Ungu tua di atas
        AppColors.profileGradientMid,    // Ungu sedang di tengah
        AppColors.profileGradientBottom, // Ungu sangat gelap di bawah
      ];
    } else {
      // ── HOME / ACADEMY / PACKAGES → Gradient hitam web ─────
      return const [
        AppColors.webGradientTop,    // Hitam gelap di atas
        AppColors.webGradientMid,    // Hitam pekat di tengah
        AppColors.webGradientBottom, // Hampir hitam total di bawah
      ];
    }
  }

  // ── TAB CONTENT BUILDER ───────────────────────────────────────

  /// Membangun dan mengembalikan widget konten utama berdasarkan
  /// item bottom nav (_selectedIndex) yang sedang aktif.
  ///
  /// - Case 0 (Beranda): Menampilkan sistem tab 4-halaman dengan
  ///   DefaultTabController. Tab bar di atas, konten di bawah.
  /// - Case 1 (Berita): Placeholder teks — halaman belum dibuat.
  /// - Case 2 (Modul): Placeholder teks — halaman belum dibuat.
  Widget _buildBody() {
    switch (_selectedIndex) {

    // ── BOTTOM NAV 0: BERANDA ─────────────────────────────
    // Menampilkan sistem tab 4 halaman:
    // Home | Academy | Profile | Packages
      case 0:
        return DefaultTabController(
          length: 4, // Jumlah tab yang tersedia
          child: Column(
            children: [

              const SizedBox(height: 20), // Jarak dari AppBar ke tab bar

              // ── TAB BAR ───────────────────────────────────
              // Container pembungkus tab bar dengan style
              // rounded (sudut melengkung) dan background gelap.
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  height: 40, // Tinggi tab bar
                  decoration: BoxDecoration(
                    color: AppColors.tabInactiveBackground, // Warna bg tab bar
                    borderRadius: BorderRadius.circular(20), // Sudut membulat
                  ),
                  child: const TabBar(
                    // Daftar tab yang ditampilkan
                    tabs: [
                      Tab(text: "Home"),     // index 0
                      Tab(text: "Academy"),  // index 1
                      Tab(text: "Profile"),  // index 2
                      Tab(text: "Packages"), // index 3
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10), // Jarak antara tab bar dan konten

              // ── TAB CONTENT (TabBarView) ──────────────────
              // Setiap child di sini sesuai urutan Tab di atas.
              // Expanded agar konten mengisi sisa ruang layar.
              Expanded(
                child: TabBarView(
                  children: [

                    // ── TAB 0: HOME ──────────────────────────
                    // HomeScreen menerima data kartu dari dummyCards.
                    // dummyCards didefinisikan di data/dummy_data.dart.
                    HomePage(
                      scrollToPricing: _scrollToPricingOnHome,
                      onScrollCompleted: () {
                        setState(() {
                          _scrollToPricingOnHome = false; // Reset flag setelah scroll
                        });
                      },
                    ),

                    // ── TAB 1: ACADEMY ───────────────────────
                    // Placeholder sementara.
                    // TODO: Ganti dengan AcademyScreen() yang sebenarnya
                    AcademyPage(
                      onNavigateToPricing: _navigateToHomeAndScroll,
                    ),

                    // ── TAB 2: PROFILE ───────────────────────
                    // Placeholder sementara.
                    // TODO: Ganti dengan ProfileScreen() yang sebenarnya
                    const Center(
                      child: Text(
                        'Hello World - Profile',
                        style: AppTextStyles.bodyPlaceholder,
                      ),
                    ),

                    // ── TAB 3: PACKAGES ──────────────────────
                    // Placeholder sementara.
                    // TODO: Ganti dengan PackagesScreen() yang sebenarnya
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