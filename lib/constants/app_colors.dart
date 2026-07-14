import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // Prevent instantiation

  // Colors
  static const Color primary = Color.fromARGB(255, 195, 52, 42);
  static const Color background = Color(0xFF1A1A1A);
  static const Color cardDark = Color.fromARGB(255, 30, 30, 30);

  // Text
  static const Color textPrimary = Color(0xBFFFFFFF);
  static const Color textSecondary = Colors.grey;

  // Border
  static const Color borderColor = Color.fromARGB(255, 70, 70, 70);
  static const double borderWidth = 0.5;

  // Tab Bar
  static Color tabInactiveBackground = Colors.black.withValues(alpha: 0.6);
  static const Color tabActiveBackground = primary;
  static const Color tabLabelActive = Colors.white;
  static const Color tabLabelInactive = Colors.grey;

  // Overlay / Filter
  static Color gridCardBorder = Colors.grey.withValues(alpha: 0.2);
  static Color imageOverlay = Colors.black.withValues(alpha: 0.5);

  // Others
  static const Color transparent = Colors.transparent;

  // Background gradient (Default/Profile Purple Theme)
  static const Color profileGradientTop = Color(0xFF5A006A); // Dark purple top
  static const Color profileGradientMid = Color(
    0xFF1F002A,
  ); // Dark purple middle
  static const Color profileGradientBottom = Color(
    0xFF0F0015,
  ); // Near black bottom

  // Background gradient (Web/Home Black Theme)
  static const Color webGradientTop = Color(0xFF000000); // Pure black top
  static const Color webGradientMid = Color(
    0xFF090314,
  ); // Black with purple shadow middle
  static const Color webGradientBottom = Color(0xFF000000); // Pure black bottom

  // Legacy bg colors (transparent for compatibility if needed)
  static const Color bgGradientTop = Color(0x00000000);
  static const Color bgGradientMid = Color(0x00000000);
  static const Color bgGradientBottom = Color(0x00000000);

  // Primary Colors (Web / Home)
  static const Color primaryDark = Color(0xFFB71C1C); // Dark red
  static const Color primaryLight = Color(0xFFFF5252); // Light red / accent
  static const Color webRed = Color(0xFFE53E3E); // Web red accent

  // Accent & Glow Colors
  static const Color accentPurple = Color(0xFF9C27B0); // Purple accent
  static const Color accentGold = Color(0xFFFFD700); // Gold
  static const Color webOrangeStart = Color(0xFFD97706); // Amber 600
  static const Color webOrangeEnd = Color(0xFFEA580C); // Orange 600

  // Text
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textWhite70 = Color(0xB3FFFFFF); // 70% opacity
  static const Color textWhite54 = Color(0x8AFFFFFF); // 54% opacity
  static const Color textWhite30 = Color(0x4DFFFFFF); // 30% opacity
  static const Color textRed = Color(0xFFE53935);

  // Card / Surface Colors
  static const Color cardBorder = Color(0xFF2C164D); // Thin card border
  static const Color cardSignal = Color(0xFFB71C1C); // Red signal background
  static const Color cardModul = Color(0xFF1E1E1E); // Dark module card

  // Tab bar
  static const Color tabActive = Color(0xFFE53935); // Active tab
  static const Color tabInactive = Color(0xFF130922); // Inactive tab

  // Divider
  static const Color divider = Color(0x1FFFFFFF); // White 12%

  // Bottom nav
  static const Color bottomNavBg = Color(0xFF0A0512);
  static const Color bottomNavActive = Color(0xFFFF5252);
  static const Color bottomNavInactive = Color(0x8AFFFFFF);
}
