import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class AppTheme {
  AppTheme._(); // Mencegah instansiasi

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        titleTextStyle: AppTextStyles.appBarTitle,
        shape: Border(
          bottom: BorderSide(color: AppColors.borderColor, width: AppColors.borderWidth),
        ),
      ),
      tabBarTheme: TabBarThemeData(
        dividerColor: AppColors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          color: AppColors.tabActiveBackground,
          borderRadius: BorderRadius.circular(20),
        ),
        labelColor: AppColors.tabLabelActive,
        unselectedLabelColor: AppColors.tabLabelInactive,
        labelStyle: AppTextStyles.tabActive,
        unselectedLabelStyle: AppTextStyles.tabInactive,
      ),
      bottomAppBarTheme: const BottomAppBarThemeData(
        elevation: 0,
        color: AppColors.background,
      ),
    );
  }
}
