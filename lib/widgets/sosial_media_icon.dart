// ================================================================
// FILE: widgets/social_media_icon.dart
//
// FUNGSI: Widget ikon dengan efek cahaya (glow) berwarna di
//         sekitar kotak. Mendukung penampilan Ikon bawaan maupun
//         Gambar dari URL (logoUrl).
//
// DIGUNAKAN DI: home_page.dart → section footer "IKUTI KAMI DI SOCIAL MEDIA"
//               atau section "SPONSOR".
// ================================================================

import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/margin.dart';
import 'sponsor_chip.dart'; // Import SponsorItem from sponsor_chip.dart

// ----------------------------------------------------------------
// CLASS: SocialMediaIcon
// ----------------------------------------------------------------
class SocialMediaIcon extends StatelessWidget {
  /// Ikon yang ditampilkan jika [logoUrl] null, atau jika gambar URL gagal dimuat.
  final IconData icon;

  /// URL gambar/logo (opsional). Jika diisi, akan menggantikan ikon.
  final String? logoUrl;

  /// Warna utama efek glow dan border (contoh: Colors.pinkAccent).
  final Color glowColor;

  /// Teks label di bawah ikon (nama platform/sponsor).
  final String label;

  /// Callback opsional saat kotak ditekan.
  final VoidCallback? onTap;

  const SocialMediaIcon({
    super.key,
    required this.icon,
    required this.glowColor,
    required this.label,
    this.logoUrl,
    this.onTap,
  });

  // Contoh data statis untuk grid (Bisa dihapus jika diambil dari API/State)
  static const List<SponsorItem> gridSponsors = [
    SponsorItem(name: 'Binance Labs', logoUrl: 'https://example.com/binance.png'),
    SponsorItem(name: 'Bloomberg'),
    SponsorItem(name: 'Bybit'),
    SponsorItem(name: 'CoinMarketCap'),
    SponsorItem(name: 'LunarCrush'),
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Null berarti tidak ada aksi saat tap
      child: Column(
        mainAxisSize: MainAxisSize.min, // Kolom menyesuaikan konten
        children: [
          // ── KOTAK IKON / LOGO DENGAN GLOW ──────────────────────────
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.cardDark, // Background kotak
              borderRadius: BorderRadius.circular(AppRadius.md),

              // Border tipis berwarna sesuai glowColor
              border: Border.all(
                color: glowColor.withValues(alpha: 0.3),
              ),

              // Efek cahaya (glow) di luar kotak
              boxShadow: [
                BoxShadow(
                  color: glowColor.withValues(alpha: 0.15), // Warna cahaya
                  blurRadius: 8,    // Seberapa lebar cahaya menyebar
                  spreadRadius: 1,  // Seberapa jauh dari kotak
                ),
              ],
            ),

            // Logika render: Jika logoUrl ada, render gambar. Jika null/error, render Icon.
            child: logoUrl != null && logoUrl!.isNotEmpty
                ? ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: Image.network(
                logoUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback jika URL gambar rusak atau gagal dimuat
                  return Icon(
                    icon,
                    color: AppColors.textWhite,
                    size: 22,
                  );
                },
              ),
            )
                : Icon(
              icon,
              color: AppColors.textWhite, // Ikon selalu putih
              size: 22,
            ),
          ),

          const SizedBox(height: AppSpacing.xs),

          // ── LABEL TEKS ────────────────────────────────────────
          SizedBox(
            width: 60, // Membatasi lebar teks agar rapi jika labelnya panjang
            child: Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis, // Memotong teks dengan "..." jika kepanjangan
              style: const TextStyle(
                color: AppColors.textWhite54,
                fontSize: 9, // Sangat kecil, hanya sebagai keterangan
              ),
            ),
          ),
        ],
      ),
    );
  }
}