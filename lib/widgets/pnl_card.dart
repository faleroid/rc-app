
// ================================================================
// FILE: widgets/pnl_card.dart
//
// FUNGSI: Widget kartu kecil yang menampilkan hasil profit/loss (PnL)
//         dari sebuah posisi trading (pair + persentase keuntungan).
//
// DIGUNAKAN DI: home_page.dart → sub-section "Hasil Profit Member"
//               di dalam ListView horizontal (scrollable kiri-kanan)
//
// CONTOH PENGGUNAAN:
//   PnlCard(
//     pair: "BTC/USDT Long",
//     percentage: "+145.20%",
//     color: Colors.greenAccent,
//   )
// ================================================================

import 'package:flutter/material.dart';
import '../constants/font.dart';
import '../constants/margin.dart';
import '../constants/app_colors.dart';

// ----------------------------------------------------------------
// CLASS: PnlCard
// StatelessWidget karena hanya menampilkan data statis dari parameter.
// ----------------------------------------------------------------
class PnlCard extends StatelessWidget {
  /// Nama pasangan trading, contoh: "BTC/USDT Long", "ETH/USDT Short"
  final String pair;

  /// Persentase profit/loss, contoh: "+145.20%", "-12.50%"
  final String percentage;

  /// Warna teks persentase.
  /// Umumnya: Colors.greenAccent untuk profit, Colors.redAccent untuk loss
  final Color color;

  const PnlCard({
    super.key,
    required this.pair,
    required this.percentage,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150, // Lebar tetap agar kartu seragam dalam ListView horizontal

      // Margin kanan memisahkan setiap kartu
      margin: const EdgeInsets.only(right: AppSpacing.md),

      padding: const EdgeInsets.all(AppSpacing.md),

      decoration: BoxDecoration(
        color: AppColors.cardDark,                     // Background gelap
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.cardBorder), // Border tipis
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center, // Konten di tengah vertikal
        children: [

          // ── NAMA PAIR ──────────────────────────────────────────
          // Ukuran kecil, warna redup — sebagai label/subtitle
          Text(
            pair,
            style: const TextStyle(
              color: AppColors.textWhite70,
              fontSize: AppFontSizes.xs,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: AppSpacing.xs),

          // ── PERSENTASE PROFIT/LOSS ─────────────────────────────
          // Ukuran besar, warna mencolok sesuai parameter [color]
          Text(
            percentage,
            style: TextStyle(
              color: color,               // Warna dinamis dari parameter
              fontSize: AppFontSizes.lg,  // Besar agar mudah dibaca
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
