import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';
import '../constants/app_font_sizes.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  static const String _waUrl = 'https://wa.me/6281330581505';

  Future<void> _launchWhatsApp(BuildContext context) async {
    final uri = Uri.parse(_waUrl);
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tidak dapat membuka WhatsApp. Silakan coba lagi.'),
            backgroundColor: AppColors.webRed,
          ),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal menghubungkan ke WhatsApp.'),
            backgroundColor: AppColors.webRed,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        centerTitle: true,
        title: const Text(
          'Pusat Bantuan',
          style: TextStyle(
            color: Colors.white,
            fontSize: AppFontSizes.lg,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.25),
                      AppColors.cardDark,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.4),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.5),
                        ),
                      ),
                      child: const Icon(
                        Icons.headset_mic_outlined,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pusat Bantuan',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: AppFontSizes.xl,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Tim Customer Support Ricocapital siap membantu menjawab pertanyaan dan menyelesaikan kendala Anda.',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: AppFontSizes.xs,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // WhatsApp Support Action Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.cardDark,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF25D366).withValues(alpha: 0.4),
                    width: 1.2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF25D366,
                            ).withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.chat_outlined,
                            color: Color(0xFF25D366),
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Layanan Bantuan WhatsApp',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: AppFontSizes.md,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Respon cepat melalui pesan langsung',
                                style: TextStyle(
                                  color: Colors.white60,
                                  fontSize: AppFontSizes.xs,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(color: Colors.white12, height: 1),
                    const SizedBox(height: 16),

                    // Open WhatsApp Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        icon: const Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        label: const Text(
                          'Hubungi via WhatsApp',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: AppFontSizes.sm,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF25D366),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () => _launchWhatsApp(context),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // FAQ Section
              const Text(
                'Pertanyaan yang Sering Diajukan (FAQ)',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: AppFontSizes.md,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              _buildFaqItem(
                question: 'Bagaimana cara mengakses modul pembelajaran?',
                answer:
                    'Masuk ke menu Academy di navigasi bawah, pilih materi pembelajaran yang diinginkan, dan buka modul. Untuk modul tingkat lanjut, pastikan akun Anda memiliki status membership aktif.',
              ),
              _buildFaqItem(
                question: 'Bagaimana cara mengaktifkan membership premium?',
                answer:
                    'Buka menu Package, pilih paket langganan yang sesuai dengan kebutuhan Anda, lalu selesaikan pembayaran menggunakan metode pembayaran yang tersedia melalui Midtrans.',
              ),
              _buildFaqItem(
                question: 'Bagaimana cara menggunakan fitur AI Chatbot?',
                answer:
                    'Tekan ikon Chat AI untuk membuka asisten virtual cerdas Ricocapital. Anda dapat menanyakan topik edukasi kripto, analisis terminologi pasar, atau ringkasan modul.',
              ),
              _buildFaqItem(
                question:
                    'Bagaimana jika pembayaran berhasil tetapi membership belum aktif?',
                answer:
                    'Silakan hubungi customer support kami melalui WhatsApp dengan menyertakan bukti pembayaran (invoice / receipt) dan alamat email akun terdaftar Anda agar dapat segera kami bantu verifikasi.',
              ),
              const SizedBox(height: 24),

              // Security notice
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardDark.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white12),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.shield_outlined,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'PENTING: Tim resmi Ricocapital tidak akan pernah menanyakan kata sandi (password) atau kunci rahasia akun Anda kepada siapapun.',
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: AppFontSizes.xs,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFaqItem({required String question, required String answer}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Theme(
        data: ThemeData(
          dividerColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          childrenPadding: const EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 16,
          ),
          iconColor: AppColors.primaryLight,
          collapsedIconColor: Colors.white70,
          title: Text(
            question,
            style: const TextStyle(
              color: Colors.white,
              fontSize: AppFontSizes.sm,
              fontWeight: FontWeight.w600,
            ),
          ),
          children: [
            const Divider(color: Colors.white10, height: 1),
            const SizedBox(height: 12),
            Text(
              answer,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: AppFontSizes.xs,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
