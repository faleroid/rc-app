import 'package:flutter/material.dart';
import '../constants/margin.dart';
import '../constants/strings.dart';
import '../constants/app_colors.dart';
import '../constants/font.dart';
/// ============================================================
/// ABOUT PAGE — Halaman "Tentang Kami" RicoCapital
/// Layout disesuaikan dari ricocapital.id/about
/// Sections: Hero, Expert Team, Vision & Mission,
///           Our Dedication, Stats, CTA
/// ============================================================

/// Data model for team members
class _TeamMember {
  final String name;
  final String position;
  final String imageUrl;

  const _TeamMember({
    required this.name,
    required this.position,
    required this.imageUrl,
  });
}

class AboutPage extends StatelessWidget {
  final VoidCallback? onNavigateToAcademy;
  final VoidCallback? onNavigateToPackage;

  const AboutPage({
    super.key,
    this.onNavigateToAcademy,
    this.onNavigateToPackage,
  });

  // ── TEAM DATA ─────────────────────────────────────────────
  static const List<_TeamMember> _teamMembers = [
    _TeamMember(
      name: 'A Rico Yoananda Rahardja',
      position: 'Founder & Chief Executive Officer',
      imageUrl: 'https://www.ricocapital.id/images/profile/rico.png',
    ),
    _TeamMember(
      name: 'Renggo Harya Pandora',
      position: 'Chief Technology Officer',
      imageUrl: 'https://www.ricocapital.id/images/profile/renggo.png',
    ),
    _TeamMember(
      name: 'Achmad Nadif Zain',
      position: 'Chief Creative Officer',
      imageUrl: 'https://www.ricocapital.id/images/profile/nadif.png',
    ),
    _TeamMember(
      name: 'Gregat Filhaq Sejati',
      position: 'Chief Financial Officer',
      imageUrl: 'https://www.ricocapital.id/images/profile/gregat.png',
    ),
    _TeamMember(
      name: 'Nugrahhadi Al Khawarizmi',
      position: 'Front-end Developer',
      imageUrl: 'https://www.ricocapital.id/images/profile/hadi.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        // ─── SECTION 1: HERO ─────────────────────────────────
        _buildHeroSection(),

        const SizedBox(height: AppSpacing.xl2),

        // ─── SECTION 2: EXPERT TEAM ──────────────────────────
        _buildTeamSection(),

        const SizedBox(height: AppSpacing.xl3),

        // ─── SECTION 3: VISION & MISSION ─────────────────────
        _buildVisionMissionSection(),

        const SizedBox(height: AppSpacing.xl3),

        // ─── SECTION 4: OUR DEDICATION ───────────────────────
        _buildDedicationSection(),

        const SizedBox(height: AppSpacing.xl3),

        // ─── SECTION 5: CTA ──────────────────────────────────
        _buildCtaSection(),

        const SizedBox(height: AppSpacing.xl3),
      ],
    );
  }

  // ================================================================
  // SECTION BUILDERS
  // ================================================================

  /// HERO — "About Ricocapital" + subtitle
  Widget _buildHeroSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.xl2),
          // Title: "RicoCapital"
          const Text(
            AppStrings.appName,
            style: TextStyle(
              color: AppColors.textWhite,
              fontSize: AppFontSizes.xl4,
              fontFamily: AppFonts.display,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          // Gradient accent: "Education and Private Venture"
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryLight],
            ).createShader(bounds),
            child: const Text(
              'Education and Private Venture',
              style: TextStyle(
                color: Colors.white,
                fontSize: AppFontSizes.lg,
                fontFamily: AppFonts.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          // Subtitle paragraph
          const Text(
            AppStrings.aboutSubtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textWhite70,
              fontSize: AppFontSizes.base,
              fontFamily: AppFonts.primary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  /// EXPERT TEAM — Grid of team member cards
  Widget _buildTeamSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        children: [
          // Section title
          const Text(
            'Meet Our Expert Team',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textWhite,
              fontSize: AppFontSizes.xl2,
              fontFamily: AppFonts.display,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          // Gradient underline
          Container(
            height: 3,
            width: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryLight],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Top row: 3 team cards
          Row(
            children: List.generate(3, (i) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: i == 0 ? 0 : AppSpacing.xs,
                    right: i == 2 ? 0 : AppSpacing.xs,
                  ),
                  child: _buildTeamCard(_teamMembers[i]),
                ),
              );
            }),
          ),
          const SizedBox(height: AppSpacing.sm),

          // Bottom row: 2 team cards
          Row(
            children: List.generate(2, (i) {
              final idx = i + 3;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: i == 0 ? 0 : AppSpacing.xs,
                    right: i == 1 ? 0 : AppSpacing.xs,
                  ),
                  child: _buildTeamCard(_teamMembers[idx]),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  /// Vision & Mission cards side-by-side
  Widget _buildVisionMissionSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        children: [
          // Section title
          const Text(
            'Vision & Mission',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textWhite,
              fontSize: AppFontSizes.xl2,
              fontFamily: AppFonts.display,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          // Gradient underline
          Container(
            height: 3,
            width: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryLight],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // ─── VISION CARD ────────────────────────────────────
          _buildGlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, AppColors.primaryLight],
                        ),
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child: const Icon(Icons.visibility,
                          color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    const Text(
                      'Visi',
                      style: TextStyle(
                        color: AppColors.textWhite,
                        fontSize: AppFontSizes.xl,
                        fontFamily: AppFonts.display,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                const Text(
                  AppStrings.aboutVisionBody,
                  style: TextStyle(
                    color: AppColors.textWhite70,
                    fontSize: AppFontSizes.sm,
                    fontFamily: AppFonts.primary,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // ─── MISSION CARD ───────────────────────────────────
          _buildGlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, AppColors.primaryLight],
                        ),
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child: const Icon(Icons.flag,
                          color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    const Text(
                      'Misi',
                      style: TextStyle(
                        color: AppColors.textWhite,
                        fontSize: AppFontSizes.xl,
                        fontFamily: AppFonts.display,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                ...AppStrings.aboutMissionItems.map(
                      (item) => Padding(
                    padding:
                    const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding:
                          EdgeInsets.only(top: 4, right: AppSpacing.sm),
                          child: Icon(Icons.check_circle,
                              color: AppColors.primary, size: 16),
                        ),
                        Expanded(
                          child: Text(
                            item,
                            style: const TextStyle(
                              color: AppColors.textWhite70,
                              fontSize: AppFontSizes.sm,
                              fontFamily: AppFonts.primary,
                              height: 1.5,
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
        ],
      ),
    );
  }

  /// OUR DEDICATION — 3 cards + stats grid
  Widget _buildDedicationSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        children: [
          // Section title
          const Text(
            'Our Dedication',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textWhite,
              fontSize: AppFontSizes.xl2,
              fontFamily: AppFonts.display,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          // Gradient underline
          Container(
            height: 3,
            width: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryLight],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          const Text(
            'Komitmen kami untuk memajukan pendidikan\ncrypto dan blockchain di Indonesia',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textWhite54,
              fontSize: AppFontSizes.sm,
              fontFamily: AppFonts.primary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // ─── DEDICATION CARDS ───────────────────────────────
          _buildDedicationCard(
            icon: Icons.school,
            title: AppStrings.dedicationEduTitle,
            body: AppStrings.dedicationEduBody,
            gradientColors: [AppColors.primary, AppColors.primaryLight],
          ),
          const SizedBox(height: AppSpacing.md),
          _buildDedicationCard(
            icon: Icons.group,
            title: AppStrings.dedicationComTitle,
            body: AppStrings.dedicationComBody,
            gradientColors: [
              const Color(0xFF64748B),
              const Color(0xFF475569),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _buildDedicationCard(
            icon: Icons.lightbulb,
            title: AppStrings.dedicationInoTitle,
            body: AppStrings.dedicationInoBody,
            gradientColors: [
              const Color(0xFFF43F5E),
              AppColors.primary,
            ],
          ),

          const SizedBox(height: AppSpacing.xl2),

          // ─── STATS GRID ─────────────────────────────────────
          Row(
            children: [
              _buildStatItem(
                AppStrings.statActiveUsers,
                AppStrings.statActiveUsersLbl,
                AppColors.primary,
              ),
              _buildStatItem(
                AppStrings.statCommunity,
                AppStrings.statCommunityLbl,
                const Color(0xFFFB7185),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              _buildStatItem(
                AppStrings.statSuccessRate,
                AppStrings.statSuccessRateLbl,
                const Color(0xFF94A3B8),
              ),
              _buildStatItem(
                AppStrings.statSupport,
                AppStrings.statSupportLbl,
                const Color(0xFFFCA5A5),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// CTA section — "Ready to Join Our Community?"
  Widget _buildCtaSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.1),
            width: 1,
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary.withValues(alpha: 0.15),
              const Color(0xFFF43F5E).withValues(alpha: 0.15),
              const Color(0xFF64748B).withValues(alpha: 0.15),
            ],
          ),
        ),
        child: Column(
          children: [
            // Title
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'Ready to Join Our\n',
                    style: TextStyle(
                      color: AppColors.textWhite,
                      fontSize: AppFontSizes.xl2,
                      fontFamily: AppFonts.display,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  TextSpan(
                    text: 'Community?',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: AppFontSizes.xl2,
                      fontFamily: AppFonts.display,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            // Body
            const Text(
              'Bergabunglah dengan ribuan trader sukses dan\nmulai perjalanan crypto Anda bersama\nRicocapital',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textWhite70,
                fontSize: AppFontSizes.sm,
                fontFamily: AppFonts.primary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            // Buttons
            SizedBox(
              width: double.infinity,
              child: GestureDetector(
                onTap: onNavigateToPackage,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.md,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, Color(0xFFF43F5E)],
                    ),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: const Text(
                    AppStrings.btnStartLearning,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textWhite,
                      fontSize: AppFontSizes.md,
                      fontFamily: AppFonts.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              width: double.infinity,
              child: GestureDetector(
                onTap: onNavigateToAcademy,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.md,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primary, width: 2),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: const Text(
                    AppStrings.btnViewCurriculum,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: AppFontSizes.md,
                      fontFamily: AppFonts.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================================================================
  // HELPER WIDGETS
  // ================================================================

  /// Team member card — shows image, name, position
  Widget _buildTeamCard(_TeamMember member) {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: AppColors.cardBorder,
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            Image.network(
              member.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // Fallback: gradient + initials
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.primary.withValues(alpha: 0.6),
                        AppColors.cardDark,
                      ],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      _getInitials(member.name),
                      style: const TextStyle(
                        color: AppColors.textWhite,
                        fontSize: AppFontSizes.xl2,
                        fontFamily: AppFonts.display,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
            // Gradient overlay at bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.85),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      member.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textWhite,
                        fontSize: AppFontSizes.xs,
                        fontFamily: AppFonts.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      member.position,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textWhite54,
                        fontSize: 8,
                        fontFamily: AppFonts.primary,
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

  /// Glass-morphism styled card container
  Widget _buildGlassCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.25),
          width: 1,
        ),
      ),
      child: child,
    );
  }

  /// Dedication feature card
  Widget _buildDedicationCard({
    required IconData icon,
    required String title,
    required String body,
    required List<Color> gradientColors,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(
          color: gradientColors.first.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Icon circle
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradientColors),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: AppSpacing.md),
          // Title
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textWhite,
              fontSize: AppFontSizes.lg,
              fontFamily: AppFonts.display,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          // Body
          Text(
            body,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textWhite54,
              fontSize: AppFontSizes.sm,
              fontFamily: AppFonts.primary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  /// Stats item widget
  Widget _buildStatItem(String value, String label, Color valueColor) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: AppFontSizes.xl4,
              fontFamily: AppFonts.display,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textWhite54,
              fontSize: AppFontSizes.sm,
              fontFamily: AppFonts.primary,
            ),
          ),
        ],
      ),
    );
  }

  /// Get initials from a full name
  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}';
    }
    return parts[0][0];
  }
}
