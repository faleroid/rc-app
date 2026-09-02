import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_colors.dart';
import '../constants/app_font_sizes.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
          'Kebijakan Privasi',
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
                        Icons.shield_outlined,
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
                            'Kebijakan Privasi',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: AppFontSizes.xl,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Komitmen Ricocapital.id dalam menjaga privasi, aset, dan keamanan data Anda.',
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

              // Section A
              _buildSectionCard(
                sectionTitle: 'A. Kerahasiaan Aset & Informasi Sensitif',
                sectionIcon: Icons.lock_outline,
                items: const [
                  _PolicyPoint(
                    number: 1,
                    title: 'Lingkup Aset Dilindungi',
                    description:
                        'Seluruh aset yang mencakup informasi tertulis, dokumen terlampir, data finansial, strategi, maupun informasi tidak tertulis yang dikategorikan sensitif wajib dijaga kerahasiaannya secara mutlak oleh sistem dan tim Ricocapital.id',
                  ),
                  _PolicyPoint(
                    number: 2,
                    title: 'Larangan Publikasi Pihak Ketiga',
                    description:
                        'Segala bentuk aset sensitif, data internal, dan kekayaan intelektual perusahaan atau pengguna dilarang keras untuk disebarluaskan, diperjualbelikan, atau dipublikasikan ke media manapun tanpa izin tertulis',
                  ),
                  _PolicyPoint(
                    number: 3,
                    title: 'Akses Terbatas (Privileged Access)',
                    description:
                        'Pengelolaan dan peninjauan data/aset sensitif hanya dapat diakses oleh personel berwenang dari tim internal Ricocapital.id yang terikat dengan perjanjian kerahasiaan (Non-Disclosure Agreement / NDA) yang ketat.',
                  ),
                  _PolicyPoint(
                    number: 4,
                    title: 'Proteksi Data Terlampir',
                    description:
                        'Dokumen digital, file, atau lampiran yang diunggah pengguna ke dalam sistem akan dienkripsi secara end-to-end guna mencegah intersepsi atau kebocoran data.',
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Section B
              _buildSectionCard(
                sectionTitle: 'B. Keamanan Data Pengguna & Membership',
                sectionIcon: Icons.admin_panel_settings_outlined,
                items: const [
                  _PolicyPoint(
                    number: 1,
                    title: 'Pengumpulan Data yang Relevan',
                    description:
                        'Ricocapital.id hanya mengumpulkan data pribadi dan membership yang esensial untuk keperluan verifikasi identitas, pengelolaan akun, dan peningkatan layanan platform.',
                  ),
                  _PolicyPoint(
                    number: 2,
                    title: 'Keamanan Infrastruktur Sistem',
                    description:
                        'Manajemen data member dilindungi menggunakan sistem keamanan siber berlapis, termasuk enkripsi basis data, protokol enkripsi transfer data (SSL/TLS), serta audit keamanan berkala oleh tim internal.',
                  ),
                  _PolicyPoint(
                    number: 3,
                    title: 'Kendali Akun Pengguna',
                    description:
                        'Pengguna memiliki hak penuh atas akun membership mereka, termasuk hak untuk meminta pembaruan data atau penghapusan informasi sesuai dengan prosedur operasional standar (SOP) keamanan platform',
                  ),
                  _PolicyPoint(
                    number: 4,
                    title: 'Komitmen Jaminan Keamanan Tim',
                    description:
                        'Tim Ricocapital.id berkomitmen penuh untuk bertanggung jawab secara hukum dan operasional atas keutuhan, kerahasiaan, dan keamanan seluruh data yang dipercayakan oleh pengguna di dalam aplikasi maupun media pendukung lainnya.',
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Footer info
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardDark.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white12),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.verified_user_outlined,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Kebijakan ini berlaku untuk seluruh pengguna dan anggota platform Ricocapital.id.',
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: AppFontSizes.xs,
                          height: 1.3,
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

  Widget _buildSectionCard({
    required String sectionTitle,
    required IconData sectionIcon,
    required List<_PolicyPoint> items,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title Header
          Row(
            children: [
              Icon(sectionIcon, color: AppColors.primary, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  sectionTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: AppFontSizes.md,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(color: Colors.white12, height: 1),
          const SizedBox(height: 14),

          // Policy points
          ...items.map((item) => _buildPointRow(item)),
        ],
      ),
    );
  }

  Widget _buildPointRow(_PolicyPoint item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.5),
                width: 1,
              ),
            ),
            child: Text(
              '${item.number}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: AppFontSizes.xs,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: AppFontSizes.sm,
                  height: 1.5,
                ),
                children: [
                  TextSpan(
                    text: '${item.title}: ',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text: item.description),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PolicyPoint {
  final int number;
  final String title;
  final String description;

  const _PolicyPoint({
    required this.number,
    required this.title,
    required this.description,
  });
}
