// lib/screens/course_list_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/course_model.dart';
import '../repositories/course_repository.dart';
import '../widgets/module_card.dart';
import '../constants/app_colors.dart';

class CourseListScreen extends StatefulWidget {
  const CourseListScreen({super.key});

  @override
  State<CourseListScreen> createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  final CourseRepository _repository = CourseRepository();
  late Future<CourseListResponse> _coursesFuture;

  @override
  void initState() {
    super.initState();
    _coursesFuture = _repository.fetchCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: FutureBuilder<CourseListResponse>(
        future: _coursesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.courses.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada data tersedia.',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final courses = snapshot.data!.courses;

          // Cari modul terbaru (ID terbesar) dari seluruh course untuk featured header
          CourseModel? featuredCourse;
          ModuleMiniModel? latestModule;

          for (final course in courses) {
            for (final module in course.modules) {
              if (latestModule == null || module.id > latestModule.id) {
                latestModule = module;
                featuredCourse = course;
              }
            }
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Modul Video Terbaru (Full Width Tanpa Padding)
                if (featuredCourse != null && latestModule != null)
                  _buildFeaturedHeader(featuredCourse, latestModule),

                // Daftar Section Course (Dengan Padding)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: courses.map((course) {
                      if (course.modules.isEmpty)
                        return const SizedBox.shrink();

                      return _buildCourseSection(course);
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Header Modul Terbaru Full Width Mentok Layar
  Widget _buildFeaturedHeader(CourseModel course, ModuleMiniModel module) {
    final thumbnailUrl =
        module.thumbnailUrl ??
        'https://picsum.photos/seed/${module.id + 15}/800/450';

    return GestureDetector(
      onTap: () {
        context.push('/courses/${course.id}/modules/${module.id}');
      },
      child: SizedBox(
        width: double.infinity,
        height: 240,
        child: Stack(
          children: [
            // Background Thumbnail Image
            Positioned.fill(
              child: Image.network(
                thumbnailUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: AppColors.cardDark,
                  child: const Center(
                    child: Icon(
                      Icons.video_library,
                      size: 48,
                      color: Colors.white54,
                    ),
                  ),
                ),
              ),
            ),

            // Gradient Overlay untuk kontras teks
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.01),
                      Colors.black.withValues(alpha: 0.6),
                      Colors.black.withValues(alpha: 0.85),
                    ],
                    stops: const [0.0, 0.45, 1.0],
                  ),
                ),
              ),
            ),

            // Text Info & Tombol "Tonton Sekarang"
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Tag / Nama Course
                  Text(
                    course.title.toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.primaryLight,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Judul Modul Video
                  Text(
                    module.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),

                  // Tombol "Tonton Sekarang" & Durasi
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 9,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Tonton Sekarang',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (module.durationMinutes > 0) ...[
                        const SizedBox(width: 14),
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              color: Colors.white70,
                              size: 15,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '${module.durationMinutes} menit',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build satu section course beserta list modul horizontal
  Widget _buildCourseSection(CourseModel course) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Course Title Header
        Text(
          course.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),

        // Horizontal Module Cards List
        SizedBox(
          height: 160,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: course.modules.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final module = course.modules[index];

              return SizedBox(
                width: 160,
                child: ModuleCard(
                  title: module.title,
                  thumbnailUrl:
                      module.thumbnailUrl ??
                      'https://picsum.photos/seed/${module.id + 15}/400/300',
                  onTap: () {
                    context.push('/courses/${course.id}/modules/${module.id}');
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
