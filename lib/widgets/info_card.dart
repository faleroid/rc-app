import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/strings.dart';
import '../constants/margin.dart';
import '../constants/font.dart';
// ─────────────────────────────────────────────────────────────
// 6. SIGNAL / INFO CARD (Merah)
// ─────────────────────────────────────────────────────────────
class SignalCard extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;

  const SignalCard({
    super.key,
    this.text = AppStrings.signalText1,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.cardSignal,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ikon notifikasi / sinyal
            Container(
              width: 20,
              height: 20,
              margin: const EdgeInsets.only(
                  right: AppSpacing.sm, top: AppSpacing.xs / 2),
              decoration: const BoxDecoration(
                color: AppColors.textWhite,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  '!',
                  style: TextStyle(
                    color: AppColors.cardSignal,
                    fontSize: AppFontSizes.sm,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // Teks sinyal
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  color: AppColors.textWhite,
                  fontSize: AppFontSizes.sm,
                  fontFamily: AppFonts.primary,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}