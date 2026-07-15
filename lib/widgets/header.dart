import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/margin.dart';
import '../constants/assets.dart';
import '../constants/font.dart';
import '../constants/strings.dart';

class AppHeader extends StatelessWidget {
  final VoidCallback? onLoginTap;

  const AppHeader({super.key, this.onLoginTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          // Logo
          Image.asset(
            AppImages.logo,
            width: 30,
            height: 30,
            errorBuilder: (context, error, stackTrace) => Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.currency_bitcoin,
                color: AppColors.textWhite,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          // App name
          const Text(
            AppStrings.appName,
            style: TextStyle(
              color: AppColors.textWhite70,
              fontSize: AppFontSizes.md,
              fontFamily: AppFonts.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          // Login Button
          GestureDetector(
            onTap: onLoginTap,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.base,
                vertical: AppSpacing.xs + 2,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: const Text(
                AppStrings.btnLogin,
                style: TextStyle(
                  color: AppColors.textWhite,
                  fontSize: AppFontSizes.sm,
                  fontFamily: AppFonts.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
