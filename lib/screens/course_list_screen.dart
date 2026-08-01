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
}
