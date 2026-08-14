import 'package:flutter/material.dart';

// ─── FONT SIZES ──────────────────────────────────────────────
class AppFontSizes {
  AppFontSizes._();

  static const double xs    = 10.0;
  static const double sm    = 12.0;
  static const double base  = 14.0;
  static const double md    = 16.0;
  static const double lg    = 18.0;
  static const double xl    = 20.0;
  static const double xl2   = 24.0;
  static const double xl3   = 28.0;
  static const double xl4   = 32.0;
}

// ─── FONT WEIGHTS ─────────────────────────────────────────────
class AppFontWeights {
  AppFontWeights._();

  static const FontWeight light     = FontWeight.w300;
  static const FontWeight regular   = FontWeight.w400;
  static const FontWeight medium    = FontWeight.w500;
  static const FontWeight semiBold  = FontWeight.w600;
  static const FontWeight bold      = FontWeight.w700;
}

// ─── FONT FAMILY ─────────────────────────────────────────────
class AppFonts {
  AppFonts._();

  /// Ganti nilai ini jika ingin mengganti font seluruh aplikasi.
  /// Pastikan font sudah didaftarkan di pubspec.yaml.
  static const String primary = 'Poppins';   // Font utama
  static const String display = 'Poppins';   // Font heading/display
}