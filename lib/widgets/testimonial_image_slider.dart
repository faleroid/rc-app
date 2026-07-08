// ================================================================
// FILE: widgets/testimonial_image_slider.dart
//
// FUNGSI: Slider gambar horizontal yang dapat di-scroll dengan efek
//         "snap ke tengah" dan efek "magnify" (memperbesar gambar
//         yang berada di posisi tengah viewport).
//
// FITUR:
//   - Gambar di tengah viewport otomatis diperbesar (scale max)
//   - Gambar di pinggir mengecil proporsional (scale min)
//   - Saat scroll berhenti, otomatis snap ke item terdekat
//   - Border merah menyala (glow) pada gambar yang aktif di tengah
//   - Mendukung error state (gambar gagal muat → icon placeholder)
//
// DIGUNAKAN DI: home_page.dart → section "Testimonials"
//
// CONTOH PENGGUNAAN:
//   TestimonialImageSlider(
//     imageUrls: ['https://...', 'https://...'],
//   )
// ================================================================

import 'package:flutter/material.dart';
import '../constants/durasi.dart';
import '../constants/margin.dart';
import '../constants/app_colors.dart';
// ----------------------------------------------------------------
// CLASS: TestimonialImageSlider (dipublikasikan — bukan private lagi)
//
// Sebelumnya bernama _TestimonialImageSlider (private) di home_page.dart.
// Sekarang dipublikasikan agar bisa dipakai di halaman lain.
// ----------------------------------------------------------------
class TestimonialImageSlider extends StatefulWidget {
  /// Daftar URL gambar testimonial yang akan ditampilkan di slider.
  /// Minimal 1 item. Jika kosong, widget menampilkan SizedBox kosong.
  final List<String> imageUrls;

  const TestimonialImageSlider({
    super.key,
    required this.imageUrls,
  });

  @override
  State<TestimonialImageSlider> createState() =>
      _TestimonialImageSliderState();
}

class _TestimonialImageSliderState extends State<TestimonialImageSlider> {
  // ── SCROLL CONTROLLER ─────────────────────────────────────────
  // Digunakan untuk:
  //   1. Membaca posisi scroll saat ini (untuk hitung scale per item)
  //   2. Melakukan animasi snap ke item terdekat
  late final ScrollController _scrollController;

  // ── KONSTANTA DIMENSI & SKALA ─────────────────────────────────
  // Dipisah sebagai konstanta agar mudah diubah tanpa cari satu per satu

  /// Lebar setiap item gambar dalam pixel
  static const double _itemWidth = 150.0;

  /// Jarak horizontal antar item
  static const double _itemSpacing = 12.0;

  /// Tinggi total widget slider
  static const double _sliderHeight = 200.0;

  /// Skala maksimum — gambar di tengah diperbesar hingga 118%
  static const double _maxScale = 1.18;

  /// Skala minimum — gambar di pinggir dikecilkan hingga 85%
  static const double _minScale = 0.85;

  // ── LIFECYCLE ─────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    // Daftarkan listener → setiap kali scroll bergerak, panggil _onScroll
    _scrollController.addListener(_onScroll);
  }

  /// Dipanggil setiap frame saat scroll bergerak.
  /// Memanggil setState() agar skala gambar diperbarui secara real-time.
  void _onScroll() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    // Hapus listener sebelum dispose untuk mencegah memory leak
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  // ── SNAP TO CENTER ────────────────────────────────────────────

  /// Dipanggil ketika scroll berhenti (ScrollEndNotification).
  /// Menghitung item terdekat dari posisi scroll saat ini,
  /// lalu animasi scroll ke posisi tengah item tersebut.
  ///
  /// Rumus:
  ///   totalItemWidth = itemWidth + itemSpacing
  ///   nearestIndex   = round(currentOffset / totalItemWidth)
  ///   targetOffset   = nearestIndex * totalItemWidth
  void _snapToCenter() {
    if (!_scrollController.hasClients) return;

    final offset = _scrollController.offset;
    final totalItemWidth = _itemWidth + _itemSpacing;

    // Pembulatan offset ke index item terdekat
    final nearestIndex = (offset / totalItemWidth).round();
    final targetOffset = nearestIndex * totalItemWidth;

    // Animasi halus menuju posisi yang tepat
    _scrollController.animateTo(
      targetOffset,
      duration: AppDurations.normal,   // Durasi dari app_constants
      curve: Curves.easeOutCubic,      // Kurva melambat di akhir
    );
  }

  // ── SKALA BERDASARKAN POSISI ──────────────────────────────────

  /// Menghitung skala (zoom) untuk item di [index] berdasarkan
  /// seberapa jauh posisi item dari pusat viewport.
  ///
  /// Logika:
  ///   - Item di pusat viewport → skala = _maxScale (1.18)
  ///   - Item di tepi viewport  → skala = _minScale (0.85)
  ///   - Item di antaranya      → interpolasi linear
  ///
  /// Jika scroll controller belum punya klien (pertama kali render),
  /// item pertama (index 0) diberi skala max sebagai default.
  double _getScaleForIndex(int index) {
    if (!_scrollController.hasClients) {
      // Sebelum scroll tersedia, item pertama jadi "aktif"
      return index == 0 ? _maxScale : _minScale;
    }

    final viewportWidth = _scrollController.position.viewportDimension;
    final scrollOffset = _scrollController.offset;
    final totalItemWidth = _itemWidth + _itemSpacing;

    // Posisi tengah item ini dalam koordinat scroll
    final itemCenter = (index * totalItemWidth) + (_itemWidth / 2);

    // Posisi tengah area yang terlihat (viewport)
    final viewportCenter = scrollOffset + (viewportWidth / 2);

    // Jarak absolut item dari tengah viewport
    final distance = (itemCenter - viewportCenter).abs();

    // Normalisasi jarak ke rentang 0.0 (tengah) hingga 1.0 (tepi)
    final maxDistance = viewportWidth / 2;
    final normalizedDist = (distance / maxDistance).clamp(0.0, 1.0);

    // Interpolasi: semakin jauh → semakin kecil
    return _maxScale - (normalizedDist * (_maxScale - _minScale));
  }

  // ── BUILD ─────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    // Jika tidak ada gambar, tampilkan ruang kosong sesuai tinggi slider
    if (widget.imageUrls.isEmpty) {
      return const SizedBox(height: _sliderHeight);
    }

    return SizedBox(
      height: _sliderHeight,

      // NotificationListener menangkap event scroll selesai
      // untuk memicu fungsi snap ke tengah
      child: NotificationListener<ScrollEndNotification>(
        onNotification: (notification) {
          _snapToCenter(); // Snap saat jari diangkat / momentum habis
          return true;     // true = event sudah ditangani, tidak bubble up
        },

        child: ListView.builder(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,   // Scroll ke kiri/kanan
          physics: const BouncingScrollPhysics(), // Efek bouncing di ujung
          itemCount: widget.imageUrls.length,

          // Padding kiri-kanan agar item pertama & terakhir bisa ke tengah
          // Rumus: (lebarLayar - lebarItem) / 2
          padding: EdgeInsets.symmetric(
            horizontal:
            (MediaQuery.of(context).size.width - _itemWidth) / 2,
          ),

          itemBuilder: (context, index) {
            final scale = _getScaleForIndex(index); // Hitung skala item ini
            final url = widget.imageUrls[index];
            final isActive = scale > 1.0; // Aktif jika lebih besar dari normal

            return Padding(
              padding: const EdgeInsets.only(right: _itemSpacing),
              child: Center(
                child: AnimatedScale(
                  scale: scale, // Skala berubah smooth saat scroll
                  duration: const Duration(milliseconds: 150),
                  curve: Curves.easeOut,
                  child: Container(
                    width: _itemWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.md),

                      // Border merah menyala untuk item aktif (di tengah)
                      // Border abu untuk item tidak aktif
                      border: Border.all(
                        color: isActive
                            ? AppColors.webRed.withValues(alpha: 0.5)
                            : AppColors.cardBorder,
                        width: isActive ? 2.0 : 1.0,
                      ),

                      // Efek glow merah di sekitar gambar aktif
                      boxShadow: isActive
                          ? [
                        BoxShadow(
                          color: AppColors.webRed.withValues(alpha: 0.15),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ]
                          : null, // Tidak ada shadow untuk item tidak aktif
                    ),

                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      child: Image.network(
                        url,
                        fit: BoxFit.cover,
                        // Fallback jika gambar gagal dimuat
                        errorBuilder: (context, error, stackTrace) =>
                            Container(
                              color: AppColors.cardBorder,
                              child: const Icon(
                                Icons.image_not_supported,
                                color: AppColors.textWhite30,
                              ),
                            ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}