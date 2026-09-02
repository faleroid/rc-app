import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_colors.dart';
import '../constants/app_font_sizes.dart';

class TermsOfUseScreen extends StatelessWidget {
  const TermsOfUseScreen({super.key});

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
          'Ketentuan Penggunaan',
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
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
                            Icons.description_outlined,
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
                                'Ketentuan Penggunaan',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: AppFontSizes.xl,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Pembaruan Terakhir: 17 Agustus 2026',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: AppFontSizes.xs,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Selamat datang di Ricocapital. Dokumen Ketentuan Penggunaan ("Ketentuan") ini mengatur akses dan penggunaan Anda terhadap situs web, aplikasi, serta seluruh layanan digital yang disediakan oleh Ricocapital, termasuk layanan edukasi cryptocurrency, teknologi blockchain, sistem keanggotaan (membership), dan integrasi kecerdasan buatan (AI) yang kami tawarkan.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: AppFontSizes.sm,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Dengan mendaftar, mengakses, atau menggunakan layanan Ricocapital, Anda menyetujui untuk terikat secara hukum oleh Ketentuan ini. Jika Anda tidak menyetujui sebagian atau seluruh Ketentuan ini, Anda tidak diperkenankan untuk menggunakan layanan kami.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: AppFontSizes.sm,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 1. Definisi dan Lingkup Layanan
              _buildSectionCard(
                sectionTitle: '1. Definisi dan Lingkup Layanan',
                sectionIcon: Icons.menu_book_outlined,
                children: const [
                  _TermsPoint(
                    title: 'Ricocapital',
                    description:
                        'Platform penyedia layanan edukasi digital yang berfokus pada ekosistem cryptocurrency dan blockchain.',
                  ),
                  _TermsPoint(
                    title: 'Layanan',
                    description:
                        'Meliputi akses ke modul pembelajaran (teks, video, dan interaktif), fitur membership premium, serta asisten virtual atau chatbot AI yang dirancang untuk membantu navigasi dan analisis data kripto secara otomatis.',
                  ),
                  _TermsPoint(
                    title: 'Pengguna',
                    description:
                        'Setiap individu atau entitas yang mengakses layanan Ricocapital, baik sebagai tamu maupun anggota terdaftar (member).',
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 2. Pendaftaran dan Keamanan Akun
              _buildSectionCard(
                sectionTitle: '2. Pendaftaran dan Keamanan Akun',
                sectionIcon: Icons.manage_accounts_outlined,
                introText:
                    'Untuk mengakses fitur-fitur khusus seperti modul premium dan chatbot AI, Pengguna diwajibkan untuk membuat akun dan mungkin mendaftar dalam program membership. Pengguna setuju untuk:',
                children: const [
                  _TermsBulletPoint(
                    text:
                        'Memberikan informasi yang akurat, terkini, dan lengkap saat proses pendaftaran.',
                  ),
                  _TermsBulletPoint(
                    text:
                        'Menjaga kerahasiaan kata sandi dan kredensial login akun.',
                  ),
                  _TermsBulletPoint(
                    text:
                        'Menanggung seluruh tanggung jawab atas segala aktivitas yang terjadi di bawah akun Pengguna.',
                  ),
                  _TermsBulletPoint(
                    text:
                        'Segera memberi tahu tim dukungan Ricocapital jika terjadi penggunaan akun secara tidak sah. Penggunaan satu akun oleh lebih dari satu orang secara bersamaan (account sharing) sangat dilarang dan dapat mengakibatkan penangguhan akun.',
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 3. Keanggotaan (Membership) dan Pembayaran
              _buildSectionCard(
                sectionTitle: '3. Keanggotaan (Membership) dan Pembayaran',
                sectionIcon: Icons.card_membership_outlined,
                introText:
                    'Akses ke materi tingkat lanjut dan benefit eksklusif diberikan berdasarkan tingkatan membership yang dipilih oleh Pengguna. Ketentuan pembayaran adalah sebagai berikut:',
                children: const [
                  _TermsBulletPoint(
                    text:
                        'Biaya berlangganan ditagihkan sesuai dengan siklus yang dipilih (misalnya, bulanan atau tahunan) dan dibayarkan di muka.',
                  ),
                  _TermsBulletPoint(
                    text:
                        'Semua transaksi bersifat final. Kecuali diwajibkan oleh hukum yang berlaku, biaya yang telah dibayarkan untuk produk digital atau langganan tidak dapat dikembalikan (non-refundable).',
                  ),
                  _TermsBulletPoint(
                    text:
                        'Ricocapital berhak untuk mengubah struktur harga dan manfaat membership dengan memberikan pemberitahuan sebelumnya kepada Pengguna.',
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 4. Penafian Risiko Finansial (Disclaimer) - Highlighted
              _buildRiskDisclaimerCard(),
              const SizedBox(height: 20),

              // 5. Penggunaan Chatbot AI dan Teknologi Interaktif
              _buildSectionCard(
                sectionTitle:
                    '5. Penggunaan Chatbot AI dan Teknologi Interaktif',
                sectionIcon: Icons.smart_toy_outlined,
                introText:
                    'Platform kami dilengkapi dengan inovasi chatbot AI untuk membantu Pengguna menjawab pertanyaan seputar materi kripto. Pengguna memahami bahwa:',
                children: const [
                  _TermsBulletPoint(
                    text:
                        'Saran atau analisis yang diberikan oleh chatbot dihasilkan melalui algoritma berdasarkan data historis dan tidak menjamin akurasi pergerakan pasar di masa depan.',
                  ),
                  _TermsBulletPoint(
                    text:
                        'Pengguna dilarang melakukan rekayasa balik (reverse engineering), manipulasi, atau memberikan perintah yang bertujuan merusak sistem AI Ricocapital.',
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 6. Hak Kekayaan Intelektual
              _buildSectionCard(
                sectionTitle: '6. Hak Kekayaan Intelektual',
                sectionIcon: Icons.copyright_outlined,
                children: const [
                  _TermsParagraph(
                    text:
                        'Seluruh materi yang terdapat di dalam aplikasi Ricocapital, termasuk namun tidak terbatas pada teks, grafik, logo, video, antarmuka pengguna, algoritma perangkat lunak, dan materi kurikulum adalah milik eksklusif Ricocapital dan dilindungi oleh undang-undang hak cipta dan kekayaan intelektual Indonesia.',
                  ),
                  SizedBox(height: 12),
                  _TermsParagraph(
                    text:
                        'Pengguna dilarang keras untuk menyalin, mendistribusikan, memodifikasi, menjual ulang, atau mempublikasikan materi premium kepada pihak ketiga, baik untuk tujuan komersial maupun non-komersial tanpa izin tertulis dari Ricocapital.',
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 7. Pembatasan Tanggung Jawab
              _buildSectionCard(
                sectionTitle: '7. Pembatasan Tanggung Jawab',
                sectionIcon: Icons.gavel_outlined,
                introText:
                    'Sejauh diizinkan oleh hukum, Ricocapital tidak bertanggung jawab atas kerugian langsung, tidak langsung, insidental, atau konsekuensial yang timbul dari:',
                children: const [
                  _TermsBulletPoint(
                    text:
                        'Penggunaan atau ketidakmampuan menggunakan layanan atau aplikasi.',
                  ),
                  _TermsBulletPoint(
                    text:
                        'Kerugian finansial akibat keputusan perdagangan atau investasi yang diambil setelah mengakses materi atau berinteraksi dengan AI kami.',
                  ),
                  _TermsBulletPoint(
                    text:
                        'Akses tidak sah ke dalam server yang mengakibatkan kebocoran data pribadi (meskipun kami telah menerapkan standar keamanan terbaik).',
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 8. Penghentian Layanan
              _buildSectionCard(
                sectionTitle: '8. Penghentian Layanan',
                sectionIcon: Icons.block_outlined,
                children: const [
                  _TermsParagraph(
                    text:
                        'Ricocapital berhak secara sepihak untuk membatasi, menangguhkan, atau menghentikan akses akun Anda kapan saja tanpa pemberitahuan sebelumnya jika kami menemukan indikasi pelanggaran terhadap Ketentuan Penggunaan ini, termasuk aktivitas pembajakan konten atau penipuan.',
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 9. Hukum yang Berlaku
              _buildSectionCard(
                sectionTitle: '9. Hukum yang Berlaku',
                sectionIcon: Icons.account_balance_outlined,
                children: const [
                  _TermsParagraph(
                    text:
                        'Ketentuan Penggunaan ini tunduk pada dan ditafsirkan berdasarkan hukum Negara Kesatuan Republik Indonesia. Segala perselisihan yang timbul dari penggunaan layanan ini akan diselesaikan secara musyawarah untuk mufakat, atau melalui yurisdiksi pengadilan yang berwenang di Indonesia.',
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
                        '© 2026 Ricocapital. Seluruh Hak Cipta Dilindungi Undang-Undang.',
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
    String? introText,
    required List<Widget> children,
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
          if (introText != null) ...[
            Text(
              introText,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: AppFontSizes.sm,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 14),
          ],
          ...children,
        ],
      ),
    );
  }

  Widget _buildRiskDisclaimerCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.amber.withValues(alpha: 0.6),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.amberAccent,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  '4. Penafian Risiko Finansial (Disclaimer)',
                  style: TextStyle(
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.webRed.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: AppColors.webRed.withValues(alpha: 0.5),
              ),
            ),
            child: const Text(
              'PERINGATAN RISIKO TINGGI',
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: AppFontSizes.xs,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Seluruh konten yang disediakan oleh Ricocapital, termasuk modul pembelajaran, analisis pasar, dan respons yang dihasilkan oleh fitur Chatbot AI, murni bertujuan untuk EDUKASI dan INFORMASI.',
            style: TextStyle(
              color: Colors.white,
              fontSize: AppFontSizes.sm,
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Kami BUKAN penasihat keuangan, pialang, atau perencana investasi berlisensi. Informasi yang kami sediakan tidak boleh ditafsirkan sebagai ajakan, rekomendasi, atau nasihat investasi mutlak untuk membeli, menjual, atau menahan aset kripto apa pun. Pasar cryptocurrency sangat fluktuatif dan berisiko tinggi. Anda bertanggung jawab penuh atas segala keputusan investasi yang Anda buat.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: AppFontSizes.sm,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _TermsPoint extends StatelessWidget {
  final String title;
  final String description;

  const _TermsPoint({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
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
                    text: '$title: ',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text: description),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TermsBulletPoint extends StatelessWidget {
  final String text;

  const _TermsBulletPoint({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: AppFontSizes.sm,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TermsParagraph extends StatelessWidget {
  final String text;

  const _TermsParagraph({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white70,
        fontSize: AppFontSizes.sm,
        height: 1.5,
      ),
    );
  }
}
