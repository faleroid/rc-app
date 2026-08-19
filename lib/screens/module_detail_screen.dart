// lib/screens/module_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/module_detail_model.dart';
import '../repositories/course_repository.dart';
import '../constants/app_colors.dart';
import '../widgets/module_video_player.dart';
import 'chat_bot_screen.dart';

class ModuleDetailScreen extends StatefulWidget {
  final int courseId;
  final int moduleId;

  const ModuleDetailScreen({
    super.key,
    required this.courseId,
    required this.moduleId,
  });

  @override
  State<ModuleDetailScreen> createState() => _ModuleDetailScreenState();
}

class _ModuleDetailScreenState extends State<ModuleDetailScreen> {
  final CourseRepository _repository = CourseRepository();
  late Future<ModuleDetailResponse> _moduleFuture;

  @override
  void initState() {
    super.initState();
    _moduleFuture = _repository.fetchModuleDetail(
      widget.courseId,
      widget.moduleId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ModuleDetailResponse>(
      future: _moduleFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.primary),
                onPressed: () => context.pop(),
              ),
              title: const Text(
                'Memuat Modul...',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              centerTitle: true,
              backgroundColor: AppColors.background,
              elevation: 0,
            ),
            body: const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        } else if (snapshot.hasError) {
          final err = snapshot.error.toString();
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.primary),
                onPressed: () => context.pop(),
              ),
              backgroundColor: AppColors.background,
              elevation: 0,
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.lock_outline_rounded,
                        size: 56,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.webRed.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.webRed.withValues(alpha: 0.5)),
                      ),
                      child: const Text(
                        'KHUSUS MEMBER AKTIF',
                        style: TextStyle(
                          color: AppColors.webRed,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Detail Modul Terkunci',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      err.contains('403') || err.contains('Akses ditolak') || err.contains('tidak aktif')
                          ? 'Keanggotaan Anda belum aktif. Silakan pilih dan bayar paket keanggotaan untuk membuka modul ini.'
                          : err,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 4,
                      ),
                      onPressed: () {
                        context.push('/register');
                      },
                      icon: const Icon(Icons.workspace_premium, size: 20),
                      label: const Text(
                        'Pilih Paket Keanggotaan',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.primary),
                onPressed: () => context.pop(),
              ),
              backgroundColor: AppColors.background,
              elevation: 0,
            ),
            body: const Center(
              child: Text(
                'Data tidak ditemukan',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        }

        final module = snapshot.data!.module;
        final nav = snapshot.data!.navigation;

        return Scaffold(
          backgroundColor: AppColors.background,
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              ChatBotScreen.showModal(
                context,
                courseId: widget.courseId,
                moduleId: widget.moduleId,
                moduleTitle: module.title,
              );
            },
            backgroundColor: AppColors.primary,
            icon: const Icon(Icons.smart_toy_rounded, color: Colors.white),
            label: const Text(
              'Tanya AI',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.primary),
              onPressed: () => context.pop(),
            ),
            title: Text(
              'Modul ${nav.current} dari ${nav.total}',
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
            centerTitle: true,
            backgroundColor: AppColors.background,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Video Player Banner (Cloudflare R2 MP4 Streaming)
                ModuleVideoPlayer(
                  videoUrl: module.videoStreamUrl,
                  fallbackImageUrl: module.fileUrl,
                ),

                // Content Details
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        module.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Description
                      if (module.description.isNotEmpty) ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.1),
                            ),
                          ),
                          child: Text(
                            module.description,
                            style: const TextStyle(
                              color: AppColors.textWhite70,
                              fontSize: 12,
                              height: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],

                      const Divider(
                        color: Color.fromARGB(255, 80, 80, 80),
                        thickness: 0.5,
                      ),
                      const SizedBox(height: 12),

                      // Video Lainnya Section
                      const Text(
                        'Modul Lainnya',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Render Previous/Next as "Other Videos"
                      if (nav.previous != null) _buildVideoItem(nav.previous!),
                      if (nav.next != null) _buildVideoItem(nav.next!),

                      // Jika tidak ada navigasi, tampilkan pesan kosong
                      if (nav.previous == null && nav.next == null)
                        Center(
                          child: Text(
                            'Belum ada modul lain yang tersedia di kursus ini.',
                            style: TextStyle(
                              color: AppColors.textWhite54,
                              fontSize: 12,
                            ),
                          ),
                        ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildVideoItem(NavigationItemModel item) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        context.pushReplacement(
          '/courses/${widget.courseId}/modules/${item.id}',
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        height: 90,
        child: Row(
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                'https://picsum.photos/seed/${item.id + 20}/200/150',
                width: 140,
                height: 90,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 140,
                  height: 90,
                  color: AppColors.cardDark,
                  child: const Icon(Icons.image, color: Colors.white54),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.description.isNotEmpty
                        ? item.description
                        : 'Modul ${item.sortOrder}',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textWhite54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
