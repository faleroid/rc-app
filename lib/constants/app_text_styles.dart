import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_font_sizes.dart';

class AppTextStyles {
  AppTextStyles._(); // Mencegah instansiasi

  // === Heading ===
  static const TextStyle heading = TextStyle(
    color: AppColors.textPrimary,
    fontSize: AppFontSizes.xxl,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle headingAccent = TextStyle(
    color: AppColors.primary,
    fontSize: AppFontSizes.xxl,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle title = TextStyle(
    color: AppColors.textPrimary,
    fontSize: AppFontSizes.xxl,
    fontWeight: FontWeight.w600,
  );

  // === AppBar ===
  static const TextStyle appBarTitle = TextStyle(
    color: AppColors.textPrimary,
    fontSize: AppFontSizes.xl,
  );

  // === Body ===
  static const TextStyle bodyWhite = TextStyle(
    color: AppColors.textPrimary,
    fontSize: AppFontSizes.sm,
    height: 1.4,
  );

  static const TextStyle bodyPlaceholder = TextStyle(
    color: AppColors.textPrimary,
    fontSize: AppFontSizes.xl,
  );

  // === Card ===
  static const TextStyle cardTitle = TextStyle(
    color: AppColors.textPrimary,
    fontWeight: FontWeight.bold,
    fontSize: AppFontSizes.cardTitle,
    shadows: [
      Shadow(blurRadius: 4.0, color: Colors.black54, offset: Offset(1.0, 1.0)),
    ],
  );

  static const TextStyle cardIndex = TextStyle(
    color: AppColors.textPrimary,
    fontWeight: FontWeight.bold,
    fontSize: AppFontSizes.xs,
  );

  // === Button ===
  static const TextStyle buttonBold = TextStyle(fontWeight: FontWeight.bold);

  // === Tab ===
  static const TextStyle tabActive = TextStyle(fontWeight: FontWeight.bold);

  static const TextStyle tabInactive = TextStyle(fontWeight: FontWeight.normal);
}
