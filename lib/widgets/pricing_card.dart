// ================================================================
// FILE: widgets/pricing_card.dart
//
// FUNGSI: Widget kartu paket harga (pricing) yang menampilkan:
//   - Nama paket + badge diskon
//   - Deskripsi singkat paket
//   - Harga (coret harga asli, tampilkan harga promo)
//   - Daftar benefit yang TERSEDIA (ikon centang hijau)
//   - Daftar benefit yang TIDAK TERSEDIA (ikon silang abu + coretan)
//   - Tombol CTA untuk memilih paket
//
// DIGUNAKAN DI: home_page.dart → section "Pricing"
//
// CONTOH PENGGUNAAN:
//   PricingCard(
//     name: "Ethereum",
//     price: "Rp 200.000",
//     originalPrice: "Rp 350.000",
//     discountLabel: "Hemat 43%",
//     period: "bulan",
//     description: "Mulai perjalanan...",
//     benefits: ["Sinyal Spot & Future", "Fast News Update"],
//     disabledBenefits: ["One on One Mentoring"],
//     btnLabel: "Pilih Ethereum",
//     gradient: LinearGradient(colors: [Colors.orange, Colors.red]),
//     onTap: () { /* buka halaman pembayaran */ },
//   )
// ================================================================

import 'package:flutter/material.dart';
import '../constants/font.dart';
import '../constants/margin.dart';
import '../constants/app_colors.dart';
import '../widgets/cta_button.dart';

// ----------------------------------------------------------------
// CLASS: PricingCard
// StatelessWidget — semua data diterima dari parameter, tidak ada
// state internal yang berubah.
// ----------------------------------------------------------------
class PricingCard extends StatelessWidget {
  /// Nama paket. Contoh: "Ethereum", "Bitcoin"
  final String name;

  /// Harga promo yang ditampilkan besar. Contoh: "Rp 200.000"
  final String price;

  /// Harga asli (sebelum diskon) — ditampilkan dengan garis coret.
  /// Contoh: "Rp 350.000"
  final String originalPrice;

  /// Label badge diskon di kanan judul. Contoh: "Hemat 43%"
  final String discountLabel;

  /// Satuan periode harga. Contoh: "bulan", "tahun"
  final String period;

  /// Deskripsi singkat paket (1-2 kalimat)
  final String description;

  /// Daftar fitur/benefit yang TERMASUK dalam paket ini.
  /// Ditampilkan dengan ikon centang hijau (✓)
  final List<String> benefits;

  /// Daftar fitur/benefit yang TIDAK TERMASUK dalam paket ini.
  /// Ditampilkan dengan ikon silang abu (✗) dan teks bergaris coret.
  final List<String> disabledBenefits;

  /// Teks tombol CTA di bagian bawah kartu. Contoh: "Pilih Ethereum"
  final String btnLabel;

  /// Gradient warna untuk tombol CTA.
  /// Contoh: LinearGradient(colors: [Colors.orange, Colors.deepOrange])
  final Gradient? gradient;

  /// Callback saat tombol CTA ditekan. Null = tombol tidak aktif.
  final VoidCallback? onTap;

  const PricingCard({
    super.key,
    required this.name,
    required this.price,
    required this.originalPrice,
    this.discountLabel = "Hemat 43%",
    required this.period,
    required this.description,
    required this.benefits,
    required this.disabledBenefits,
    required this.btnLabel,
    this.gradient,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Lebar penuh area parent
      padding: const EdgeInsets.all(AppSpacing.xl),

      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.cardBorder, width: 1.5),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── BARIS 1: NAMA PAKET + BADGE DISKON ──────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              // Nama paket (besar & bold)
              Text(
                name,
                style: const TextStyle(
                  color: AppColors.textWhite,
                  fontSize: AppFontSizes.xl2,
                  fontFamily: AppFonts.display,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // Badge diskon di kanan (merah tipis)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.webRed.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  border: Border.all(
                    color: AppColors.webRed.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  discountLabel,
                  style: const TextStyle(
                    color: AppColors.webRed,
                    fontSize: AppFontSizes.xs,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // ── DESKRIPSI PAKET ───────────────────────────────────
          Text(
            description,
            style: const TextStyle(
              color: AppColors.textWhite70,
              fontSize: AppFontSizes.sm,
              height: 1.4, // Jarak baris agar mudah dibaca
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // ── HARGA PROMO ───────────────────────────────────────
          // Menampilkan harga besar + satuan periode kecil di sebelahnya
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price,
                style: const TextStyle(
                  color: AppColors.textWhite,
                  fontSize: AppFontSizes.xl3 - 2, // Besar tapi tidak terlalu
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              // Satuan: "/bulan" atau "/tahun"
              Text(
                "/$period",
                style: const TextStyle(
                  color: AppColors.textWhite54,
                  fontSize: AppFontSizes.sm,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.xs),

          // ── HARGA ASLI (CORET) ────────────────────────────────
          // Ditampilkan lebih redup dengan garis coret (strikethrough)
          Text(
            originalPrice,
            style: const TextStyle(
              color: AppColors.textWhite30,
              fontSize: AppFontSizes.sm,
              decoration: TextDecoration.lineThrough, // Garis coret
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Garis pemisah antara harga dan daftar benefit
          const Divider(color: AppColors.divider, height: 1),

          const SizedBox(height: AppSpacing.xl),

          // ── DAFTAR BENEFIT TERSEDIA ───────────────────────────
          // Setiap item dari [benefits] ditampilkan dengan ikon centang hijau
          ...benefits.map((benefit) => _BenefitRow(
            text: benefit,
            isEnabled: true, // Tersedia → centang hijau, teks normal
          )),

          // ── DAFTAR BENEFIT TIDAK TERSEDIA ────────────────────
          // Setiap item dari [disabledBenefits] ditampilkan dengan
          // ikon silang abu dan teks bergaris coret
          ...disabledBenefits.map((benefit) => _BenefitRow(
            text: benefit,
            isEnabled: false, // Tidak tersedia → silang abu, teks coret
          )),

          const SizedBox(height: AppSpacing.xl),

          // ── TOMBOL CTA ────────────────────────────────────────
          // Lebar penuh dengan gradient warna dari parameter
          Center(
            child: AppPrimaryButton(
              label: btnLabel,
              width: double.infinity,
              gradient: gradient,
              textColor: Colors.black, // Teks gelap agar kontras dengan gradient cerah
              onTap: onTap,
            ),
          ),
        ],
      ),
    );
  }
}

// ----------------------------------------------------------------
// PRIVATE CLASS: _BenefitRow
//
// FUNGSI: Satu baris item benefit di dalam PricingCard.
//   - isEnabled = true  → ikon centang hijau, teks putih normal
//   - isEnabled = false → ikon silang abu, teks coret & redup
//
// Dipisah sebagai class sendiri agar kode PricingCard lebih bersih
// dan tidak berulang (DRY — Don't Repeat Yourself).
// Private (prefix _) karena hanya dipakai di file ini.
// ----------------------------------------------------------------
class _BenefitRow extends StatelessWidget {
  final String text;
  final bool isEnabled;

  const _BenefitRow({
    required this.text,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── IKON STATUS ─────────────────────────────────────
          Icon(
            isEnabled ? Icons.check_circle : Icons.cancel,
            color: isEnabled ? Colors.greenAccent : Colors.grey,
            size: 18,
          ),

          const SizedBox(width: AppSpacing.sm),

          // ── TEKS BENEFIT ────────────────────────────────────
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                // Teks putih jika tersedia, sangat redup jika tidak
                color: isEnabled
                    ? AppColors.textWhite
                    : AppColors.textWhite30,
                fontSize: AppFontSizes.sm,
                // Garis coret untuk yang tidak tersedia
                decoration: isEnabled
                    ? TextDecoration.none
                    : TextDecoration.lineThrough,
              ),
            ),
          ),
        ],
      ),
    );
  }
}