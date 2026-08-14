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
            final err = snapshot.error.toString();
            if (err.contains('403') ||
                err.contains('Akses ditolak') ||
                err.contains('tidak aktif') ||
                err.contains('Unauthorized')) {
              return _buildLockedView(context);
            }
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

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: courses.map((course) {
                if (course.modules.isEmpty) return const SizedBox.shrink();

                return Column(
                  children: [
                    _buildCourseSection(course),
                    const SizedBox(height: 24),
                  ],
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  // Build one course section with its module cards
  Widget _buildCourseSection(CourseModel course) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Course title as section header
        Text(
          course.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),

        // Module cards horizontal list
        SizedBox(
          height: 160,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: course.modules.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
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

        // "See all" button if modules > 2
        if (course.modules.length > 2) ...[
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton(
              onPressed: () {
                // TODO: Navigate to course detail
                // context.push('/courses/${course.slug}');
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Lihat semua',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ],
    );
  }

  // Build locked view for inactive or guest users
  Widget _buildLockedView(BuildContext context) {
    return Center(
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
              'Akses Modul Terkunci',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              'Keanggotaan Anda saat ini belum aktif. Silakan pilih dan bayar paket keanggotaan untuk membuka seluruh modul & materi pembelajaran eksklusif RicoCapital.',
              style: TextStyle(
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
    );
  }
}
