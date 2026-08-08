import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/margin.dart';
import '../constants/font.dart';
// ─────────────────────────────────────────────────────────────
// 7. PRIMARY CTA BUTTON (Oval / Pill)
// ─────────────────────────────────────────────────────────────
class AppPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Gradient? gradient;
  final Color? textColor;
  final double? width;

  const AppPrimaryButton({
    super.key,
    required this.label,
    this.onTap,
    this.backgroundColor,
    this.gradient,
    this.textColor,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onTap == null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl2,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: isDisabled
              ? Colors.grey.shade800
              : (gradient == null ? (backgroundColor ?? AppColors.primary) : null),
          gradient: isDisabled ? null : gradient,
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isDisabled ? Colors.grey : (textColor ?? AppColors.textWhite),
            fontSize: AppFontSizes.md,
            fontFamily: AppFonts.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}