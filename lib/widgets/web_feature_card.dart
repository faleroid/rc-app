
// ================================================================
// FILE: widgets/web_feature_card.dart
//
// FUNGSI: Widget kartu fitur yang menampilkan gambar (thumbnail),
//         badge status, judul fitur, dan deskripsi singkat.
//
// DIGUNAKAN DI: home_page.dart → section "Features Cards List"
//
// CONTOH PENGGUNAAN:
//   WebFeatureCard(
//     badgeText: "Updated Monthly",
//     badgeColor: Colors.purpleAccent,
//     title: "Modul Ebook",
//     imageUrl: "https://ricocapital.id/Module.png",
//     description: "Belajar crypto dari nol...",
//   )
// ================================================================

import 'package:flutter/material.dart';
import '../constants/font.dart';
import '../constants/margin.dart';
import '../constants/app_colors.dart';

// ----------------------------------------------------------------
// CLASS: WebFeatureCard
// Stateless karena tidak menyimpan state — hanya menampilkan data
// yang diterima dari luar via constructor parameter.
// ----------------------------------------------------------------
class WebFeatureCard extends StatelessWidget {
  /// Teks label di dalam badge (contoh: "Updated Monthly", "85% Win Rate")
  final String badgeText;

  /// Warna badge dan teks badge (contoh: Colors.purpleAccent)
  final Color badgeColor;

  /// Judul utama kartu (contoh: "Modul Ebook", "Sinyal Harian")
  final String title;

  /// Teks deskripsi panjang di bawah judul
  final String description;

  /// URL gambar thumbnail di bagian atas kartu.
  /// Jika gambar gagal dimuat, tampilkan icon placeholder.
  final String imageUrl;

  const WebFeatureCard({
    super.key,
    required this.badgeText,
    required this.badgeColor,
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Margin bawah memisahkan setiap kartu dalam daftar (Column)
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),

      // Dekorasi kartu: background gelap, sudut membulat, border tipis
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: AppColors.cardBorder,
          width: 1.5,
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── BAGIAN 1: THUMBNAIL GAMBAR ───────────────────────
          // ClipRRect memastikan gambar ikut membulat sesuai sudut kartu
          // hanya di bagian atas (top-left & top-right).
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppRadius.lg),
            ),
            child: AspectRatio(
              aspectRatio: 1.8, // Rasio lebar:tinggi gambar (landscape)
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover, // Gambar memenuhi area tanpa distorsi
                // Jika gambar gagal dimuat (no internet / URL salah):
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppColors.cardBorder,
                    child: const Center(
                      child: Icon(
                        Icons.broken_image,         // Icon gambar rusak
                        color: AppColors.textWhite30,
                        size: 40,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // ── BAGIAN 2: KONTEN TEKS (Badge + Judul + Deskripsi) ───
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // ── BADGE STATUS ──────────────────────────────────
                // Pil kecil berwarna untuk menampilkan status/keunggulan fitur.
                // Warna badge (bg, border, teks, dot) mengikuti parameter badgeColor.
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    // Background sangat transparan dari warna badge
                    color: badgeColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    // Border sedikit lebih terlihat
                    border: Border.all(
                      color: badgeColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // Lebar sesuai konten
                    children: [
                      // Titik bulat kecil sebagai bullet/indicator
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: badgeColor,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),

                      // Teks badge
                      Text(
                        badgeText,
                        style: TextStyle(
                          color: badgeColor,
                          fontSize: AppFontSizes.xs - 1, // Sangat kecil
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.base),

                // ── JUDUL KARTU ───────────────────────────────────
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textWhite,
                    fontSize: AppFontSizes.lg,
                    fontFamily: AppFonts.display,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: AppSpacing.sm),

                // ── DESKRIPSI ─────────────────────────────────────
                // height: 1.5 memberi jarak antar baris agar mudah dibaca
                Text(
                  description,
                  style: const TextStyle(
                    color: AppColors.textWhite70,
                    fontSize: AppFontSizes.sm,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
