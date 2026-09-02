import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/auth_model.dart';
import '../models/profile_model.dart';
import '../repositories/profile_repository.dart';
import '../repositories/auth_repository.dart';
import '../services/announcement_tracker_service.dart';
import '../constants/app_colors.dart';
import '../constants/app_font_sizes.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileRepository _repository = ProfileRepository();
  late Future<ProfileResponse> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _repository.getProfile();
    AnnouncementTrackerService().checkUnreadAnnouncements();
  }

  Future<void> _refresh() async {
    setState(() {
      _profileFuture = _repository.getProfile();
    });
    AnnouncementTrackerService().checkUnreadAnnouncements();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white, fontSize: AppFontSizes.lg),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        color: AppColors.primary,
        backgroundColor: AppColors.background,
        child: FutureBuilder<ProfileResponse>(
          future: _profileFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            } else if (snapshot.hasError) {
              final errStr = snapshot.error.toString();
              final isUnauth =
                  errStr.toLowerCase().contains('unauthenticated') ||
                  errStr.contains('401') ||
                  errStr.contains('403');

              if (isUnauth) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  try {
                    context.go(
                      '/unauthenticated',
                      extra:
                          'Sesi profil Anda telah berakhir. Silakan login kembali.',
                    );
                  } catch (_) {}
                });
              }

              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.lock_person_rounded,
                        color: AppColors.webRed,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        isUnauth ? 'Sesi Anda Telah Berakhir' : errStr,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.webRed,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          context.go('/unauthenticated');
                        },
                        child: const Text(
                          'Masuk Sekarang',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasData && snapshot.data!.data != null) {
              final user = snapshot.data!.data!;

              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileHeader(user),
                    const SizedBox(height: 24),
                    _buildPremiumCard(user),
                    const SizedBox(height: 24),
                    const Text(
                      'Bergabung dengan Komunitas',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildCommunitySection(),
                    const SizedBox(height: 24),
                    const Text(
                      'Lainnya',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildOtherMenu(),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(
                            color: AppColors.primary,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          final authRepository = AuthRepository();
                          await authRepository.logout();

                          if (!context.mounted) return;

                          context.go('/main', extra: {'isLoggedIn': false});
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.logout, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Keluar Akun',
                              style: TextStyle(
                                fontSize: AppFontSizes.xs,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Center(
                      child: Column(
                        children: [
                          Text(
                            'Ricocapital',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: AppFontSizes.xs,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Version : 1.0.5',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: AppFontSizes.xs,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              );
            }
            return const Center(
              child: Text(
                'Tidak ada data',
                style: TextStyle(color: Colors.white),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileHeader(UserModel user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                user.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: AppFontSizes.xxxl,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () async {
                final result = await context.push<String>(
                  '/update-username',
                  extra: user.name,
                );
                if (result != null && mounted) {
                  setState(() {
                    _profileFuture = _repository.getProfile();
                  });
                }
              },
              child: const Icon(Icons.edit, color: Colors.white70, size: 20),
            ),
            const SizedBox(width: 12),
            if (user.role.toLowerCase() == 'vip')
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'VIP',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: AppFontSizes.xs,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.phone_android,
                  color: Colors.white70,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  user.phoneNumber ?? '-',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: AppFontSizes.sm,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  color: Colors.white70,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  user.domicile ?? '-',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: AppFontSizes.sm,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPremiumCard(UserModel user) {
    String expiredText = 'Kamu belum berlangganan paket apapun.';
    if (user.membershipExpiresAt != null) {
      expiredText =
          'Paket berlangganan kamu aktif hingga ${DateFormat('dd MMMM yyyy').format(user.membershipExpiresAt!)}';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(26, 169, 0, 0),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Member VIP',
            style: TextStyle(
              color: Colors.white,
              fontSize: AppFontSizes.xxl,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            expiredText,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: AppFontSizes.xs,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchExternalUrl(String url) async {
    final uri = Uri.parse(url);
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tidak dapat membuka $url'),
            backgroundColor: AppColors.webRed,
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal membuka tautan komunitas.'),
            backgroundColor: AppColors.webRed,
          ),
        );
      }
    }
  }

  Widget _buildCommunitySection() {
    return Row(
      children: [
        Expanded(
          child: _buildCommunityCard(
            title: 'Discord',
            icon: Icons.discord,
            brandColor: const Color(0xFF5865F2),
            onTap: () => _launchExternalUrl('https://discord.gg/Az32k28bq'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildCommunityCard(
            title: 'WhatsApp',
            icon: Icons.chat_bubble,
            brandColor: const Color(0xFF25D366),
            onTap: () => _launchExternalUrl('https://wa.me/6281330581505'),
          ),
        ),
      ],
    );
  }

  Widget _buildCommunityCard({
    required String title,
    required IconData icon,
    required Color brandColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: AppColors.cardDark,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: brandColor.withValues(alpha: 0.3),
              width: 1.2,
            ),
          ),
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: brandColor.withValues(alpha: 0.15),
                radius: 25,
                child: Icon(icon, color: brandColor, size: 28),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Gabung Komunitas',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtherMenu() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        children: [
          ValueListenableBuilder<int>(
            valueListenable: AnnouncementTrackerService().unreadCountNotifier,
            builder: (context, unreadCount, child) {
              return _buildListTile(
                'Pengumuman',
                leadingIcon: Icons.notifications_outlined,
                badgeCount: unreadCount,
                onTap: () async {
                  await context.push('/announcements');
                  AnnouncementTrackerService().checkUnreadAnnouncements();
                },
              );
            },
          ),
          _buildDivider(),
          _buildListTile(
            'Password',
            leadingIcon: Icons.lock_outline,
            onTap: () {
              context.push('/profile/verify-password');
            },
          ),
          _buildDivider(),
          _buildListTile(
            'Pusat Bantuan',
            leadingIcon: Icons.help_outline,
            onTap: () {
              context.push('/profile/help-center');
            },
          ),
          _buildDivider(),
          _buildListTile(
            'Syarat & Ketentuan',
            leadingIcon: Icons.description_outlined,
            onTap: () {
              context.push('/profile/terms-of-use');
            },
          ),
          _buildDivider(),
          _buildListTile(
            'Kebijakan Privasi',
            leadingIcon: Icons.security_outlined,
            onTap: () {
              context.push('/profile/privacy-policy');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(
    String title, {
    required IconData leadingIcon,
    int badgeCount = 0,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(leadingIcon, color: Colors.white70),
      title: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: AppFontSizes.sm,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (badgeCount > 0) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.webRed,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                badgeCount > 99 ? '99+' : badgeCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.white54),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return const Divider(
      color: Colors.white24,
      height: 1,
      indent: 16,
      endIndent: 16,
    );
  }
}
