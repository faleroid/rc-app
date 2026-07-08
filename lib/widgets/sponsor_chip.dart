// ================================================================
// FILE: widgets/sponsor_chip.dart
//
// FUNGSI: Widget chip yang menampilkan logo atau nama sponsor/partner
//         di section "Supported By" pada halaman Home.
//
// LOGIKA TAMPILAN:
//   - Jika SponsorItem memiliki [logoUrl] → tampilkan gambar logo
//   - Jika gambar gagal dimuat (error)    → tampilkan teks nama sponsor
//   - Jika [logoUrl] null                 → langsung tampilkan teks nama
//
// DIGUNAKAN DI: home_page.dart → section "Supported By"
//               Disusun dalam pola "brick-wall" (2-2-1 atau 3-2)
//               sesuai lebar layar menggunakan LayoutBuilder.
//
// CONTOH PENGGUNAAN:
//   SponsorChip(
//     sponsor: SponsorItem(name: "Binance", logoUrl: "https://..."),
//   )
// ================================================================

import 'package:flutter/material.dart';
import '../constants/margin.dart';
import '../constants/app_colors.dart';
import '../constants/font.dart';

// ----------------------------------------------------------------
// CLASS: SponsorItem
// Model data sederhana untuk menyimpan informasi satu sponsor.
// Dipisah di sini agar mudah digunakan bersama SponsorChip.
// ----------------------------------------------------------------
class SponsorItem {
  /// Nama sponsor/partner, ditampilkan jika logo tidak tersedia.
  /// Contoh: "Binance", "OKX", "Bybit"
  final String name;

  /// URL gambar logo sponsor. Nullable — boleh null jika tidak ada logo.
  final String? logoUrl;

  const SponsorItem({
    required this.name,
    this.logoUrl,
  });
}

// ----------------------------------------------------------------
// CLASS: SponsorChip
// StatelessWidget karena hanya menampilkan data statis.
// ----------------------------------------------------------------
class SponsorChip extends StatelessWidget {
  /// Data sponsor yang akan ditampilkan (nama + opsional logo URL)
  final SponsorItem sponsor;

  const SponsorChip({
    super.key,
    required this.sponsor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Padding dalam chip — di sekitar logo/teks
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),

      decoration: BoxDecoration(
        // Background sangat transparan agar tidak dominan
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08), // Border sangat tipis
        ),
      ),

      // ── KONTEN: LOGO atau TEKS ──────────────────────────────
      child: sponsor.logoUrl != null
          ? Image.network(
        sponsor.logoUrl!,
        height: 24,          // Tinggi logo seragam
        fit: BoxFit.contain, // Tidak crop, logo tampil utuh
        // Fallback: jika logo gagal dimuat, tampilkan teks nama
        errorBuilder: (context, error, stackTrace) => Text(
          sponsor.name,
          style: const TextStyle(
            color: AppColors.textWhite70,
            fontSize: AppFontSizes.sm,
            fontWeight: FontWeight.w600,
          ),
        ),
      )
      // Jika logoUrl null sejak awal → langsung tampilkan teks
          : Text(
        sponsor.name,
        style: const TextStyle(
          color: AppColors.textWhite70,
          fontSize: AppFontSizes.sm,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}