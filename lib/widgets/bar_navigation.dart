import 'package:flutter/material.dart';
import '../constants/strings.dart';
import '../constants/app_colors.dart';
import '../constants/margin.dart';
import '../constants/font.dart';
import '../constants/assets.dart';

// ─────────────────────────────────────────────────────────────
// 3. TAB NAVIGATION BAR (Home | Academy | Profile | Package)
// ─────────────────────────────────────────────────────────────
class AppTabBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTabChanged;

  const AppTabBar({
    super.key,
    this.currentIndex = 0,
    this.onTabChanged,
  });

  static const List<String> _tabs = [
    AppStrings.navHome,
    AppStrings.navAcademy,
    AppStrings.navProfile,
    AppStrings.navPackage,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      padding: const EdgeInsets.all(AppSpacing.xs - 1),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: Row(
        children: List.generate(_tabs.length, (i) {
          final isActive = i == currentIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTabChanged?.call(i),
              child: AnimatedContainer(
                duration: AppDurations.fast,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs + 2),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.tabActive : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                alignment: Alignment.center,
                child: Text(
                  _tabs[i],
                  style: TextStyle(
                    color: isActive
                        ? AppColors.textWhite
                        : AppColors.textWhite54,
                    fontSize: AppFontSizes.sm,
                    fontFamily: AppFonts.primary,
                    fontWeight:
                    isActive ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}