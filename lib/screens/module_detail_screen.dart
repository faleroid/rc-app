// lib/screens/module_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/module_detail_model.dart';
import '../repositories/course_repository.dart';
import '../constants/app_colors.dart';
import '../widgets/module_video_player.dart';

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
              child: Text(
                snapshot.error.toString(),
                style: const TextStyle(color: Colors.white),
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
