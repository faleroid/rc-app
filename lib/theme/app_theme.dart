import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/font.dart';
import '../constants/margin.dart';
// App Theme for RicoCapital App
class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      fontFamily: AppFonts.primary,
      scaffoldBackgroundColor: AppColors.bgGradientBottom,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.accentPurple,
        surface: AppColors.cardDark,
        error: AppColors.primaryLight,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontFamily: AppFonts.primary,
          color: AppColors.textWhite,
          fontSize: AppFontSizes.md,
          fontWeight: FontWeight.w600,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          textStyle: const TextStyle(
            fontFamily: AppFonts.primary,
            fontWeight: FontWeight.bold,
            fontSize: AppFontSizes.md,
          ),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: AppFonts.display,
          color: AppColors.textWhite,
          fontSize: AppFontSizes.xl3,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          fontFamily: AppFonts.primary,
          color: AppColors.textWhite,
          fontSize: AppFontSizes.xl,
          fontWeight: FontWeight.bold,
        ),
        bodyMedium: TextStyle(
          fontFamily: AppFonts.primary,
          color: AppColors.textWhite70,
          fontSize: AppFontSizes.base,
        ),
        labelSmall: TextStyle(
          fontFamily: AppFonts.primary,
          color: AppColors.textWhite54,
          fontSize: AppFontSizes.sm,
        ),
      ),
      dividerColor: AppColors.divider,
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.bottomNavBg,
        selectedItemColor: AppColors.bottomNavActive,
        unselectedItemColor: AppColors.bottomNavInactive,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(
          fontFamily: AppFonts.primary,
          fontSize: AppFontSizes.xs,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: AppFonts.primary,
          fontSize: AppFontSizes.xs,
        ),
      ),
    );
  }
}