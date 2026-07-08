import 'package:flutter/material.dart';
import '../constants/font.dart';
import '../constants/margin.dart';
import '../constants/app_colors.dart';
import '../widgets/pricing_card.dart';

class PackagePage extends StatelessWidget {
  final VoidCallback? onNavigateToPricing;
  const PackagePage({
    super.key,
    this.onNavigateToPricing,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.xl,
        ),
        child: Column(
          children: [
            const Text(
              "Pilih Paket Yang Tepat Untuk Anda",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textWhite,
                fontSize: AppFontSizes.xl2,
                fontFamily: AppFonts.display,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            const Text(
              "Bergabunglah dengan ribuan trader sukses dan mulai perjalanan trading crypto Anda hari ini",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textWhite70,
                fontSize: AppFontSizes.sm,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Container(
              width: 80,
              height: 3,
              decoration: BoxDecoration(
                color: AppColors.webRed,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            const SizedBox(height: AppSpacing.xl2),

            // Ethereum Card
            PricingCard(
              name: "Ethereum",
              price: "Rp 200.000",
              originalPrice: "Rp 350.000",
              discountLabel: "Hemat 43%",
              period: "bulan",
              description:
              "Mulai perjalanan investasimu dengan fleksibel, bayar bulanan & langsung nikmati semua benefit eksklusif.",
              benefits: const [
                "Sinyal Spot & Future (Winrate 85%)",
                "Fast News Update",
                "Private Module Access",
                "Monthly Zoom Class",
                "Direct Consultation with Experienced Mentors",
                "Trade Plan & Money Management Strategies",
              ],
              disabledBenefits: const [
                "One on One Future Mentoring Sessions",
              ],
              btnLabel: "Pilih Ethereum",
              gradient: const LinearGradient(
                colors: [AppColors.webOrangeStart, AppColors.webOrangeEnd],
              ),
              onTap: () {
                // TODO: Proses pemilihan paket Ethereum
              },
            ),

            const SizedBox(height: AppSpacing.xl),

            // Bitcoin Card
            PricingCard(
              name: "Bitcoin",
              price: "Rp 2.000.000",
              originalPrice: "Rp 3.500.000",
              discountLabel: "Hemat 43%",
              period: "tahun",
              description:
              "Belajar lebih serius & hemat dengan akses setahun penuh untuk semua kelas dan komunitas premium.",
              benefits: const [
                "Sinyal Spot & Future (Winrate 85%)",
                "Fast News Update",
                "Private Module Access",
                "Monthly Zoom Class",
                "Direct Consultation with Experienced Mentors",
                "Trade Plan & Money Management Strategies",
                "One on One Future Mentoring Sessions",
              ],
              disabledBenefits: const [],
              btnLabel: "Pilih Bitcoin",
              gradient: const LinearGradient(
                colors: [AppColors.webOrangeStart, AppColors.webOrangeEnd],
              ),
              onTap: () {
                // TODO: Proses pemilihan paket Bitcoin
              },
            ),
          ],
        ),
      ),
    );
  }
}
