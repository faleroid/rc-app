import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/font.dart';
// ─────────────────────────────────────────────────────────────
// 8. SECTION TITLE WIDGET
// ─────────────────────────────────────────────────────────────
class SectionTitle extends StatelessWidget {
  final String text;
  final TextAlign align;
  final double? fontSize;

  const SectionTitle({
    super.key,
    required this.text,
    this.align = TextAlign.left,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      style: TextStyle(
        color: AppColors.textWhite,
        fontSize: fontSize ?? AppFontSizes.lg,
        fontFamily: AppFonts.display,
        fontWeight: FontWeight.bold,
        height: 1.4,
      ),
    );
  }
}