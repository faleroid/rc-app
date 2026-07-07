import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
// ─────────────────────────────────────────────────────────────
// 1. GRADIENT BACKGROUND WRAPPER
// ─────────────────────────────────────────────────────────────
class AppGradientBackground extends StatelessWidget {
  final Widget child;
  final VoidCallback? onLoginTap;
  final List<Color>? colors;

  const AppGradientBackground({
    super.key,
    required this.child,
    this.colors,
    this.onLoginTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors ?? [
            AppColors.bgGradientTop,
            AppColors.bgGradientMid,
            AppColors.bgGradientBottom,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      child: child,
    );
  }
}