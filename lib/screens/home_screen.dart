import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../constants/margin.dart';
import '../constants/font.dart';
import '../constants/app_colors.dart';
import '../constants/youtube.dart';
import '../constants/durasi.dart';
import '../constants/ticker.dart';
import '../constants/sponsor.dart';
import '../constants/strings.dart';
import '../widgets/cta_button.dart';
import '../widgets/auto_scroll_ticker.dart';

/// ============================================================
/// HOME PAGE — Halaman utama RicoCapital sesuai referensi tampilan
/// Mengikuti style www.ricocapital.id (Black/Red/Yellow-Orange)
/// ============================================================
class HomePage extends StatefulWidget {
  final VoidCallback? onNavigateToPackage;

  const HomePage({
    super.key,
    this.onNavigateToPackage,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ─── YouTube Controller ──────────────────────────────────────
  late final YoutubePlayerController _ytController;

  @override
  void initState() {
    super.initState();

    // Initialize YouTube inline player
    _ytController = YoutubePlayerController.fromVideoId(
      videoId: AppYouTube.testimonialVideoId,
      autoPlay: false,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        mute: false,
        playsInline: true,
        origin: 'https://www.youtube-nocookie.com',
      ),
    );
  }

  @override
  void dispose() {
    _ytController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ─── BLURRY GLOWING BLOB BACKGROUND LAYER ────────────────
        Positioned.fill(
          child: IgnorePointer(
            child: Stack(
              children: [
                // Top-Left red glow
                Positioned(
                  top: -100,
                  left: -150,
                  child: Container(
                    width: 350,
                    height: 350,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.webRed.withValues(alpha: 0.12),
                          AppColors.webRed.withValues(alpha: 0.04),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                // Middle-Right purple/blue glow
                Positioned(
                  top: 500,
                  right: -150,
                  child: Container(
                    width: 400,
                    height: 400,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.deepPurpleAccent.withValues(alpha: 0.08),
                          Colors.blueAccent.withValues(alpha: 0.03),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                // Lower-Left red glow
                Positioned(
                  bottom: 400,
                  left: -150,
                  child: Container(
                    width: 450,
                    height: 450,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.webRed.withValues(alpha: 0.08),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ─── HERO SECTION ──────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.xl,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: AppSpacing.md),
                    RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: AppFontSizes.xl4 - 4,
                          fontFamily: AppFonts.display,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                        children: [
                          TextSpan(
                            text: "Trade Like a Pro\nWith ",
                            style: TextStyle(color: AppColors.textWhite),
                          ),
                          TextSpan(
                            text: "Ricocapital",
                            style: TextStyle(color: AppColors.webRed),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.base),
                    const Text(
                      "Join With 300+ Users And 700+ Community",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textWhite70,
                        fontSize: AppFontSizes.md,
                        fontFamily: AppFonts.primary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    AppPrimaryButton(
                      label: "JOIN US",
                      backgroundColor: AppColors.webRed,
                      onTap: widget.onNavigateToPackage,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // ─── ABOUT / INTRODUCTION SECTION ──────────────────
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.xl,
                ),
                child: Column(
                  children: [
                    const Text(
                      "Ricocapital",
                      style: TextStyle(
                        color: AppColors.textWhite,
                        fontSize: AppFontSizes.xl2,
                        fontFamily: AppFonts.display,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    const Text(
                      "Education And Private Venture",
                      style: TextStyle(
                        color: AppColors.webRed,
                        fontSize: AppFontSizes.md,
                        fontFamily: AppFonts.display,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.base),
                    const Text(
                      "Ricocapital hadir sebagai platform edukasi cryptocurrency dan blockchain yang lahir dari bertahun-tahun pengalaman komunitas akan cryptocurrency. Platform ini berkomitmen untuk memberikan pembelajaran mendalam, mulai dari pemahaman dasar hingga strategi trading yang terukur dan teruji secara profesional.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textWhite70,
                        fontSize: AppFontSizes.base,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl2),
                    Column(
                      children: [
                        const Text(
                          "Edukasi Crypto Eksklusif, Untuk Mereka yang Siap Profit Konsisten",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.textWhite,
                            fontSize: AppFontSizes.md,
                            fontFamily: AppFonts.display,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Container(
                          width: 80,
                          height: 3,
                          decoration: BoxDecoration(
                            color: AppColors.webRed,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // ─── FEATURES CARDS LIST ───────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                ),
                child: Column(
                  children: const [
                    WebFeatureCard(
                      badgeText: "Updated Monthly",
                      badgeColor: Colors.purpleAccent,
                      title: "Modul Ebook",
                      imageUrl: "https://www.ricocapital.id/Module.png",
                      description:
                      "Belajar crypto dari nol hingga mampu mengelola portofolio dengan eBooks praktis yang bisa diakses kapan saja. Modul diperbarui tiap bulan berdasarkan riset langsung dari pakar, sehingga materi selalu relevan dengan perkembangan terbaru dari cryptocurrency dan blockchain.",
                    ),
                    WebFeatureCard(
                      badgeText: "85% Win Rate",
                      badgeColor: Colors.greenAccent,
                      title: "Sinyal Harian",
                      imageUrl: "https://www.ricocapital.id/Signal.png",
                      description:
                      "Ricocapital menghadirkan riset pasar dan sinyal trading untuk membantu kalian yang ingin langsung merasakan peluang profit di market crypto. Dengan historis winrate di atas 85% setiap bulannya, sinyal ini dirancang untuk membimbing kalian meraih profit yang konsisten dan terukur.",
                    ),
                    WebFeatureCard(
                      badgeText: "Live Updates",
                      badgeColor: Colors.cyanAccent,
                      title: "Research & Berita Harian",
                      imageUrl:
                      "https://www.ricocapital.id/Research%20Berita%20Harian.png",
                      description:
                      "Ricocapital menyajikan riset mendalam mengenai perkembangan industri crypto, dilengkapi dengan berita A1 yang selalu terupdate seputar cryptocurrency dan blockchain. Semua informasi disusun secara informatif, akurat, dan berbasis riset para ahli, sehingga kamu selalu selangkah lebih maju dalam memahami tren dan peluang di dunia digital aset.",
                    ),
                    WebFeatureCard(
                      badgeText: "24/7 Support",
                      badgeColor: Colors.lightGreenAccent,
                      title: "Kelas & Konsultasi Private",
                      imageUrl:
                      "https://www.ricocapital.id/Kelas%20&%20Konsultasi%20Private.png",
                      description:
                      "Kami menyediakan sesi mentoring eksklusif 1-on-1 bersama para ahli, dirancang khusus untuk mendampingi perjalanan belajar sesuai kebutuhan dan level pemahamanmu. Selain itu, tersedia layanan konsultasi private 24/7 yang memungkinkan kamu mendapatkan arahan langsung kapan saja. Dengan pendekatan personal.",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // ─── MIDDLE HERO / CTA ─────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.xl2,
                ),
                child: Column(
                  children: [
                    const Text(
                      "Mulai dan Hasilkan 100 Juta Pertama Dari Cryptocurrency",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textWhite,
                        fontSize: AppFontSizes.xl,
                        fontFamily: AppFonts.display,
                        fontWeight: FontWeight.bold,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    AppPrimaryButton(
                      label: "TAKE ACTION",
                      backgroundColor: AppColors.webRed,
                      onTap: widget.onNavigateToPackage,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // ─── TESTIMONIALS SECTION ──────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.xl,
                ),
                child: Column(
                  children: [
                    // Video Testimonial Title Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.base,
                        vertical: AppSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.cyan.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                        border: Border.all(
                          color: Colors.cyan.withValues(alpha: 0.3),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.play_circle_fill,
                              color: Colors.cyan, size: 20),
                          SizedBox(width: AppSpacing.xs),
                          Text(
                            "KATA MEREKA YANG SUDAH BERGABUNG",
                            style: TextStyle(
                              color: Colors.cyan,
                              fontSize: AppFontSizes.xs - 1,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // ─── YOUTUBE INLINE VIDEO PLAYER ──────────────────
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: YoutubePlayer(
                          controller: _ytController,
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xl2),

                    // ─── CENTER-SNAP IMAGE SLIDER WITH MAGNIFY ────────
                    _TestimonialImageSlider(
                      imageUrls: AppTestimonials.imageUrls,
                    ),

                    const SizedBox(height: AppSpacing.xl2),

                    // Profit Member Subsection
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Hasil Profit Member",
                        style: TextStyle(
                          color: AppColors.textWhite,
                          fontSize: AppFontSizes.md,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    SizedBox(
                      height: 100,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        children: [
                          _buildPnlCard(
                              "BTC/USDT Long", "+145.20%", Colors.greenAccent),
                          _buildPnlCard(
                              "ETH/USDT Short", "+92.45%", Colors.greenAccent),
                          _buildPnlCard(
                              "SOL/USDT Long", "+210.80%", Colors.greenAccent),
                          _buildPnlCard(
                              "LINK/USDT Long", "+65.15%", Colors.greenAccent),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // ─── DISCORD EXCLUSIVE SECTION ─────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.xl,
                ),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppColors.cardDark,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    border: Border.all(color: AppColors.cardBorder, width: 1.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.deepPurpleAccent.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                          border: Border.all(
                            color: Colors.deepPurpleAccent
                                .withValues(alpha: 0.3),
                          ),
                        ),
                        child: const Text(
                          "Discord Exclusive",
                          style: TextStyle(
                            color: Colors.deepPurpleAccent,
                            fontSize: AppFontSizes.xs,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.base),

                      const Text(
                        "AKSES KE INFORMASI DARI PARA FOUNDER",
                        style: TextStyle(
                          color: AppColors.textWhite,
                          fontSize: AppFontSizes.md,
                          fontFamily: AppFonts.display,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      const Text(
                        "MENGENAI KONDISI MARKET SECARA REAL-TIME.",
                        style: TextStyle(
                          color: AppColors.webRed,
                          fontSize: AppFontSizes.md,
                          fontFamily: AppFonts.display,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: AppSpacing.xl),

                      // Discord Exclusive Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        child: Image.network(
                          'https://www.ricocapital.id/images/CTA-home.jpeg',
                          width: double.infinity,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                height: 200,
                                color: AppColors.cardDark,
                                child: const Center(
                                  child: Icon(
                                    Icons.image_not_supported,
                                    color: AppColors.textWhite30,
                                    size: 40,
                                  ),
                                ),
                              ),
                        ),
                      ),

                      const SizedBox(height: AppSpacing.xl),

                      Center(
                        child: AppPrimaryButton(
                          label: "Daftar Sekarang",
                          gradient: const LinearGradient(
                            colors: [Color(0xFFE53E3E), Color(0xFFC53030)],
                          ),
                          onTap:widget.onNavigateToPackage,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // ─── BELAJAR TRADING SECTION ─────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.xl,
                ),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      child: Text(
                        "BELAJAR TRADING FUTURE DAN CRYPTO BERSAMA RICOCAPITAL",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textWhite,
                          fontSize: AppFontSizes.lg,
                          fontFamily: AppFonts.display,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                          height: 1.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Container(
                      width: 80,
                      height: 3,
                      decoration: BoxDecoration(
                        color: AppColors.webRed,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl2),

                    // Auto-Scroll Ticker (seamless infinite loop)
                    AutoScrollTicker(
                      height: 180,
                      scrollSpeed: 35,
                      itemSpacing: AppSpacing.md,
                      children: AppTickerImages.tradingTicker.map((url) {
                        return Container(
                          width: 320, // 16:9 aspect ratio (320x180)
                          height: 180,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            border: Border.all(color: AppColors.cardBorder),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            child: Image.network(
                              url,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: AppColors.cardDark,
                                child: const Center(
                                  child: Icon(Icons.image_not_supported,
                                      color: AppColors.textWhite30, size: 32),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // ─── SUPPORTED BY ───────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.xl,
                ),
                child: Column(
                  children: [
                    const Text(
                      "SUPPORTED BY",
                      style: TextStyle(
                        color: AppColors.textWhite54,
                        fontSize: AppFontSizes.sm - 1,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // ─── Part 1: Static Brick-Wall Grid (2-2-1 Formation) ──────────────
                    Builder(
                      builder: (context) {
                        final sponsors = AppSponsors.gridSponsors;

                        return Column(
                          children: [
                            // Row 1: 2 logos
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (sponsors.isNotEmpty)
                                  _buildSponsorChip(sponsors[0]),
                                const SizedBox(width: AppSpacing.md),
                                if (sponsors.length > 1)
                                  _buildSponsorChip(sponsors[1]),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.md),
                            // Row 2: 2 logos
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (sponsors.length > 2)
                                  _buildSponsorChip(sponsors[2]),
                                const SizedBox(width: AppSpacing.md),
                                if (sponsors.length > 3)
                                  _buildSponsorChip(sponsors[3]),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.md),
                            // Row 3: 1 logo centered
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (sponsors.length > 4)
                                  _buildSponsorChip(sponsors[4]),
                              ],
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: AppSpacing.xl2),

                    // ─── Part 2: Dynamic Auto-Scroll Ticker ──────────
                    AutoScrollTicker(
                      height: 60,
                      scrollSpeed: 25,
                      itemSpacing: AppSpacing.base,
                      children: AppTickerImages.supportedByTicker.map((url) {
                        return Container(
                          width: 120,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.03),
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.08),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                            child: Image.network(
                              url,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => const Center(
                                child: Icon(Icons.business,
                                    color: AppColors.textWhite30, size: 24),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // ─── FOOTER & IKUTI KAMI ───────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.xl,
                ),
                child: Column(
                  children: [
                    const Divider(color: AppColors.divider),
                    const SizedBox(height: AppSpacing.xl),

                    Text(
                      AppStrings.appName.toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.textWhite,
                        fontSize: AppFontSizes.lg,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    const Text(
                      "Platform edukasi cryptocurrency dan blockchain terpercaya untuk membantu Anda meraih profit konsisten di dunia digital aset.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textWhite54,
                        fontSize: AppFontSizes.sm,
                      ),
                    ),

                    const SizedBox(height: AppSpacing.base),

                    // Trusted Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                        border: Border.all(
                          color: Colors.green.withValues(alpha: 0.2),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle_outline,
                              color: Colors.green, size: 16),
                          SizedBox(width: AppSpacing.xs),
                          Text(
                            "Trusted by 300+ Users & 700+ Community",
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: AppFontSizes.xs - 1,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xl2),

                    const Text(
                      "IKUTI KAMI DI SOCIAL MEDIA",
                      style: TextStyle(
                        color: AppColors.textWhite,
                        fontSize: AppFontSizes.md,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.base),

                    // Glowing Social Icons
                    Wrap(
                      spacing: AppSpacing.md,
                      children: [
                        _buildSocialMediaIcon(
                          icon: Icons.camera_alt_outlined,
                          glowColor: Colors.pinkAccent,
                          label: "Instagram",
                        ),
                        _buildSocialMediaIcon(
                          icon: Icons.music_note,
                          glowColor: Colors.tealAccent,
                          label: "TikTok",
                        ),
                        _buildSocialMediaIcon(
                          icon: Icons.chat_bubble_outline,
                          glowColor: Colors.greenAccent,
                          label: "WhatsApp",
                        ),
                        _buildSocialMediaIcon(
                          icon: Icons.discord,
                          glowColor: Colors.indigoAccent,
                          label: "Discord",
                        ),
                        _buildSocialMediaIcon(
                          icon: Icons.play_circle_outline,
                          glowColor: Colors.redAccent,
                          label: "YouTube",
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSpacing.xl2),

                    const Text(
                      "Email: ricocapitalcoid@gmail.com",
                      style: TextStyle(
                        color: AppColors.textWhite54,
                        fontSize: AppFontSizes.sm,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    const Text(
                      "Support: 24/7 Available",
                      style: TextStyle(
                        color: AppColors.textWhite54,
                        fontSize: AppFontSizes.sm,
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xl3),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPnlCard(String pair, String percentage, Color color) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            pair,
            style: const TextStyle(
              color: AppColors.textWhite70,
              fontSize: AppFontSizes.xs,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            percentage,
            style: TextStyle(
              color: color,
              fontSize: AppFontSizes.lg,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSponsorChip(SponsorItem sponsor) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: sponsor.logoUrl != null
          ? Image.network(
        sponsor.logoUrl!,
        height: 24,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => Text(
          sponsor.name,
          style: const TextStyle(
            color: AppColors.textWhite70,
            fontSize: AppFontSizes.sm,
            fontWeight: FontWeight.w600,
          ),
        ),
      )
          : Text(
        sponsor.name,
        style: const TextStyle(
          color: AppColors.textWhite70,
          fontSize: AppFontSizes.sm,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSocialMediaIcon({
    required IconData icon,
    required Color glowColor,
    required String label,
  }) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.cardDark,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: glowColor.withValues(alpha: 0.3)),
            boxShadow: [
              BoxShadow(
                color: glowColor.withValues(alpha: 0.15),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Icon(icon, color: AppColors.textWhite, size: 22),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textWhite54,
            fontSize: 9,
          ),
        ),
      ],
    );
  }
}

/// ─── WEB FEATURE CARD ───────────────────────────────────────────
class WebFeatureCard extends StatelessWidget {
  final String badgeText;
  final Color badgeColor;
  final String title;
  final String description;
  final String imageUrl;

  const WebFeatureCard({
    super.key,
    required this.badgeText,
    required this.badgeColor,
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: AppColors.cardBorder,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppRadius.lg),
            ),
            child: AspectRatio(
              aspectRatio: 1.8,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppColors.cardBorder,
                    child: const Center(
                      child: Icon(
                        Icons.broken_image,
                        color: AppColors.textWhite30,
                        size: 40,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    border: Border.all(
                      color: badgeColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: badgeColor,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        badgeText,
                        style: TextStyle(
                          color: badgeColor,
                          fontSize: AppFontSizes.xs - 1,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.base),

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

                // Description
                Text(
                  description,
                  style: const TextStyle(
                    color: AppColors.textWhite70,
                    fontSize: AppFontSizes.sm,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ─── TESTIMONIAL IMAGE SLIDER ─────────────────────────────────────
/// Center-snapping horizontal slider with magnify/highlight effect
/// on the center image. Uses ListView.builder for scalability.
class _TestimonialImageSlider extends StatefulWidget {
  final List<String> imageUrls;

  const _TestimonialImageSlider({required this.imageUrls});

  @override
  State<_TestimonialImageSlider> createState() =>
      _TestimonialImageSliderState();
}

class _TestimonialImageSliderState extends State<_TestimonialImageSlider> {
  late final ScrollController _scrollController;
  static const double _itemWidth = 150.0;
  static const double _itemSpacing = 12.0;
  static const double _sliderHeight = 200.0;
  static const double _maxScale = 1.18;
  static const double _minScale = 0.85;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    // Trigger rebuild to update scale animations
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  /// Snap to the nearest item center when scroll ends
  void _snapToCenter() {
    if (!_scrollController.hasClients) return;

    final offset = _scrollController.offset;
    final totalItemWidth = _itemWidth + _itemSpacing;
    final nearestIndex = (offset / totalItemWidth).round();
    final targetOffset = nearestIndex * totalItemWidth;

    _scrollController.animateTo(
      targetOffset,
      duration: AppDurations.normal,
      curve: Curves.easeOutCubic,
    );
  }

  double _getScaleForIndex(int index) {
    if (!_scrollController.hasClients) {
      return index == 0 ? _maxScale : _minScale;
    }

    final viewportWidth = _scrollController.position.viewportDimension;
    final scrollOffset = _scrollController.offset;
    final totalItemWidth = _itemWidth + _itemSpacing;

    // Center of the item
    final itemCenter = (index * totalItemWidth) + (_itemWidth / 2);
    // Center of the viewport
    final viewportCenter = scrollOffset + (viewportWidth / 2);

    // Distance from center (normalized 0..1)
    final distance = (itemCenter - viewportCenter).abs();
    final maxDistance = viewportWidth / 2;
    final normalizedDist = (distance / maxDistance).clamp(0.0, 1.0);

    return _maxScale - (normalizedDist * (_maxScale - _minScale));
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imageUrls.isEmpty) {
      return const SizedBox(height: _sliderHeight);
    }

    return SizedBox(
      height: _sliderHeight,
      child: NotificationListener<ScrollEndNotification>(
        onNotification: (notification) {
          _snapToCenter();
          return true;
        },
        child: ListView.builder(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: widget.imageUrls.length,
          padding: EdgeInsets.symmetric(
            horizontal: (MediaQuery.of(context).size.width - _itemWidth) / 2,
          ),
          itemBuilder: (context, index) {
            final scale = _getScaleForIndex(index);
            final url = widget.imageUrls[index];

            return Padding(
              padding: const EdgeInsets.only(right: _itemSpacing),
              child: Center(
                child: AnimatedScale(
                  scale: scale,
                  duration: const Duration(milliseconds: 150),
                  curve: Curves.easeOut,
                  child: Container(
                    width: _itemWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(
                        color: scale > 1.0
                            ? AppColors.webRed.withValues(alpha: 0.5)
                            : AppColors.cardBorder,
                        width: scale > 1.0 ? 2.0 : 1.0,
                      ),
                      boxShadow: scale > 1.0
                          ? [
                        BoxShadow(
                          color: AppColors.webRed.withValues(alpha: 0.15),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ]
                          : null,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      child: Image.network(
                        url,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: AppColors.cardBorder,
                          child: const Icon(
                            Icons.image_not_supported,
                            color: AppColors.textWhite30,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
