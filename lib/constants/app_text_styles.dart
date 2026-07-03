import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._(); // Mencegah instansiasi

  // === Heading ===
  static const TextStyle heading = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle headingAccent = TextStyle(
    color: AppColors.primary,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  // === AppBar ===
  static const TextStyle appBarTitle = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 18,
  );

  // === Body ===
  static const TextStyle bodyWhite = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 14,
    height: 1.4,
  );

  static const TextStyle bodyPlaceholder = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 18,
  );

  // === Card ===
  static const TextStyle cardTitle = TextStyle(
    color: AppColors.textPrimary,
    fontWeight: FontWeight.bold,
    fontSize: 13,
    shadows: [
      Shadow(
        blurRadius: 4.0,
        color: Colors.black54,
        offset: Offset(1.0, 1.0),
      ),
    ],
  );

  static const TextStyle cardIndex = TextStyle(
    color: AppColors.textPrimary,
    fontWeight: FontWeight.bold,
    fontSize: 12,
  );

  // === Button ===
  static const TextStyle buttonBold = TextStyle(
    fontWeight: FontWeight.bold,
  );

  // === Tab ===
  static const TextStyle tabActive = TextStyle(
    fontWeight: FontWeight.bold,
  );

  static const TextStyle tabInactive = TextStyle(
    fontWeight: FontWeight.normal,
  );
}
