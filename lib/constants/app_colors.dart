import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // Mencegah instansiasi

  // Colors
  static const Color primary = Colors.red;
  static const Color background = Colors.black12;
  static const Color cardDark = Color.fromARGB(255, 30, 30, 30);

  // Text
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.grey;

  // Border
  static const Color borderColor = Colors.grey;
  static const double borderWidth = 0.5;

  // Tab Bar
  static Color tabInactiveBackground = Colors.white.withOpacity(0.08);
  static const Color tabActiveBackground = Colors.red;
  static const Color tabLabelActive = Colors.white;
  static const Color tabLabelInactive = Colors.grey;

  // Overlay / Filter
  static Color gridCardBorder = Colors.grey.withOpacity(0.2);
  static Color imageOverlay = Colors.black.withOpacity(0.5);

  // Others
  static const Color transparent = Colors.transparent;
}
