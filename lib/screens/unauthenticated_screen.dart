// lib/screens/unauthenticated_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_colors.dart';
import '../constants/app_font_sizes.dart';
import '../widgets/cta_button.dart';

class UnauthenticatedScreen extends StatelessWidget {
  final String? message;

  const UnauthenticatedScreen({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    final displayMessage = 'Yuk, masuk ke akunmu untuk melanjutkan!';
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Content
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Glowing Icon Container
                    Container(
                      padding: const EdgeInsets.all(24),
                      child: const Icon(
                        Icons.lock_person_rounded,
                        color: AppColors.webRed,
                        size: 80,
                      ),
                    ),

                    // Title
                    const Text(
                      'Ups, kamu belum punya akses!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: AppFontSizes.xl,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),

                    // Subtitle / Message
                    Text(
                      displayMessage,
                      style: const TextStyle(
                        color: AppColors.textWhite70,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 36),

                    // Primary Button: Login
                    AppPrimaryButton(
                      label: 'Masuk Sekarang',
                      backgroundColor: AppColors.webRed,
                      onTap: () {
                        context.go('/login');
                      },
                    ),
                    const SizedBox(height: 16),

                    // Secondary Button: Back to Main
                    OutlinedButton(
                      onPressed: () {
                        context.go('/main');
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white24),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Kembali ke Beranda',
                        style: TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
