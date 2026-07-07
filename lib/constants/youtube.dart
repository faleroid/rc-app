
// ─── YOUTUBE VIDEO CONFIG ────────────────────────────────────
/// Konfigurasi video YouTube untuk section testimonial.
/// Ganti videoId dengan ID video YouTube yang diinginkan.
class AppYouTube {
  AppYouTube._();

  /// ID Video YouTube (bagian setelah "v=" di URL).
  /// Contoh: URL https://www.youtube.com/watch?v=dQw4w9WgXcQ → ID: dQw4w9WgXcQ
  static const String testimonialVideoId = 'uCqy9_j5iFc&t=6s';
}

// ─── DATA TESTIMONIAL IMAGES ─────────────────────────────────
/// Daftar gambar testimonial untuk slider di section "KATA MEREKA".
/// Tambahkan URL gambar baru ke dalam list ini untuk menambah item slider.
/// Format: URL langsung ke file gambar (JPG/PNG).
class AppTestimonials {
  AppTestimonials._();

  static const List<String> imageUrls = [
    // ── Tambahkan gambar testimonial baru di sini ──
    'https://ricocapital.id/images/testimoni/testi6.jpg',
    'https://ricocapital.id/images/testimoni/testi2.jpg',
    'https://ricocapital.id/images/testimoni/testi1.jpg',
    'https://ricocapital.id/images/testimoni/testi5.jpg',
    // ── Contoh: 'https://ricocapital.id/images/testimoni/testi_baru.jpg', ──
  ];
}