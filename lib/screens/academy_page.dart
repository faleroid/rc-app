import 'package:flutter/material.dart';
import '../constants/margin.dart';
import '../constants/font.dart';
import '../constants/app_colors.dart';
import '../constants/academy_modul.dart';
import '../models/academy_module.dart';

/// ============================================================
/// ACADEMY PAGE — Halaman Kurikulum RicoCapital
/// Menampilkan materi edukasi trading & crypto dalam layout timeline
/// ============================================================
class AcademyPage extends StatelessWidget {
  final VoidCallback? onNavigateToPricing;

  const AcademyPage({
    super.key,
    this.onNavigateToPricing,
  });

  Color _getLevelBgColor(String level) {
    switch (level) {
      case 'Beginner':
        return const Color(0xFFDCFCE7); // green-100
      case 'Intermediate':
        return const Color(0xFFDBEAFE); // blue-100
      case 'Advanced':
        return const Color(0xFFF3E8FF); // purple-100
      case 'Expert':
        return const Color(0xFFFEE2E2); // red-100
      default:
        return const Color(0xFFF3F4F6);
    }
  }

  Color _getLevelTextColor(String level) {
    switch (level) {
      case 'Beginner':
        return const Color(0xFF166534); // green-800
      case 'Intermediate':
        return const Color(0xFF1E40AF); // blue-800
      case 'Advanced':
        return const Color(0xFF6B21A8); // purple-800
      case 'Expert':
        return const Color(0xFF991B1B); // red-800
      default:
        return const Color(0xFF374151);
    }
  }

  Color _getLevelBorderColor(String level) {
    switch (level) {
      case 'Beginner':
        return const Color(0xFFBBF7D0); // green-200
      case 'Intermediate':
        return const Color(0xFFBFDBFE); // blue-200
      case 'Advanced':
        return const Color(0xFFE9D5FF); // purple-200
      case 'Expert':
        return const Color(0xFFFECACA); // red-200
      default:
        return const Color(0xFFE5E7EB);
    }
  }

  @override
  Widget build(BuildContext context) {
    final modules = AppCurriculum.modules;

    return Stack(
      children: [
        // ─── BACKGROUND GLOWING BLOBS ──────────────────────────
        Positioned.fill(
          child: IgnorePointer(
            child: Stack(
              children: [
                Positioned(
                  top: 40,
                  left: -100,
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.blue.withValues(alpha: 0.15),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 100,
                  right: -100,
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.purpleAccent.withValues(alpha: 0.1),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // ─── SCROLLABLE CONTENT ──────────────────────────────────
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: AppSpacing.xl3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: AppSpacing.xl),

              // ─── HEADER BANNER ─────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Column(
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: AppFontSizes.xl3,
                          fontFamily: AppFonts.display,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          const TextSpan(
                            text: "Eduzone ",
                            style: TextStyle(color: AppColors.textWhite),
                          ),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [Color(0xFF60A5FA), Color(0xFFC084FC)], // Blue-400 to Purple-400
                              ).createShader(
                                Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                              ),
                              child: const Text(
                                "RicoCapital",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: AppFontSizes.xl3,
                                  fontFamily: AppFonts.display,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    const Text(
                      "Comprehensive Blockchain & Cryptocurrency Education Program",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textWhite70,
                        fontSize: AppFontSizes.sm + 1,
                        fontFamily: AppFonts.primary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xl3),

              // ─── TIMELINE LIST ─────────────────────────────────────
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: modules.length,
                itemBuilder: (context, index) {
                  final module = modules[index];
                  return _buildTimelineItem(module);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineItem(AcademyModule module) {
    final bool isLocked = module.isLocked;

    // Timeline line keeps the active blue-purple progress styling.
    final lineGradient = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.blueAccent,
        Colors.purpleAccent,
      ],
    );

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ─── LEFT: TIMELINE LINE & BADGE ───────────────────────
          SizedBox(
            width: 72,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                // Vertical Line
                Positioned(
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 3.5,
                    decoration: BoxDecoration(
                      gradient: lineGradient,
                      borderRadius: BorderRadius.circular(2),
                      boxShadow: isLocked
                          ? []
                          : [
                        BoxShadow(
                          color: Colors.blueAccent.withValues(alpha: 0.4),
                          blurRadius: 6,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ),
                // Circular Number Badge
                Positioned(
                  top: 24,
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.textWhite,
                        width: 3.0,
                      ),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        module.id.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: AppFontSizes.base,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ─── RIGHT: CARD CONTENT ───────────────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                right: AppSpacing.lg,
                top: AppSpacing.sm,
                bottom: AppSpacing.lg,
              ),
              child: Stack(
                children: [
                  // Core Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.base + 2),
                    decoration: BoxDecoration(
                      color: AppColors.cardDark.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      border: Border.all(
                        color: isLocked
                            ? AppColors.cardBorder.withValues(alpha: 0.4)
                            : AppColors.cardBorder,
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Badges Row
                        Row(
                          children: [
                            // Level Badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.sm + 2,
                                vertical: AppSpacing.xs,
                              ),
                              decoration: BoxDecoration(
                                color: _getLevelBgColor(module.level),
                                borderRadius: BorderRadius.circular(AppRadius.pill),
                                border: Border.all(
                                  color: _getLevelBorderColor(module.level),
                                ),
                              ),
                              child: Text(
                                module.level,
                                style: TextStyle(
                                  color: _getLevelTextColor(module.level),
                                  fontSize: AppFontSizes.xs + 1,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            // Duration Badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.sm + 2,
                                vertical: AppSpacing.xs,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(AppRadius.pill),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.15),
                                ),
                              ),
                              child: Text(
                                module.duration,
                                style: const TextStyle(
                                  color: AppColors.textWhite70,
                                  fontSize: AppFontSizes.xs + 1,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: AppSpacing.md),

                        // Title
                        Text(
                          module.title,
                          style: const TextStyle(
                            color: AppColors.textWhite,
                            fontSize: AppFontSizes.md + 1,
                            fontFamily: AppFonts.primary,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),

                        const SizedBox(height: AppSpacing.sm),

                        // Description
                        Text(
                          module.description,
                          style: TextStyle(
                            color: AppColors.textWhite70,
                            fontSize: AppFontSizes.sm + 0.5,
                            fontFamily: AppFonts.primary,
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: AppSpacing.md + 2),

                        // Learn More Button
                        GestureDetector(
                          onTap: onNavigateToPricing,
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Learn More",
                                style: TextStyle(
                                  color: AppColors.textWhite,
                                  fontSize: AppFontSizes.sm + 0.5,
                                  fontFamily: AppFonts.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: AppSpacing.xs),
                              Icon(
                                Icons.chevron_right,
                                color: AppColors.textWhite,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
