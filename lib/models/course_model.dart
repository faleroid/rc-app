// lib/models/course_model.dart

class ModuleMiniModel {
  final int id;
  final int courseId;
  final int durationMinutes;
  final String title;
  final String? thumbnailUrl;

  ModuleMiniModel({
    required this.id,
    required this.courseId,
    required this.durationMinutes,
    required this.title,
    this.thumbnailUrl,
  });

  factory ModuleMiniModel.fromJson(Map<String, dynamic> json) {
    return ModuleMiniModel(
      id: json['id'] ?? 0,
      courseId: json['course_id'] ?? 0,
      durationMinutes: json['duration_minutes'] ?? 0,
      title: json['title'] ?? 'Modul ${json['id']}',
      thumbnailUrl: json['thumbnail'] ?? json['thumbnail_url'],
    );
  }
}

class CourseModel {
  final int id;
  final String title;
  final String slug;
  final List<ModuleMiniModel>
  modules; // Menyimpan daftar modul di dalam course ini

  CourseModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.modules,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    // Mapping array modules ke dalam List<ModuleMiniModel>
    var modulesList = json['modules'] as List? ?? [];
    List<ModuleMiniModel> parsedModules = modulesList
        .map((m) => ModuleMiniModel.fromJson(m))
        .toList();

    return CourseModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      modules: parsedModules,
    );
  }
}

class CourseListResponse {
  final bool success;
  final List<CourseModel> courses;

  CourseListResponse({required this.success, required this.courses});

  factory CourseListResponse.fromJson(Map<String, dynamic> json) {
    final dataObj = json['data'] ?? {};
    final coursesObj = dataObj['courses'] ?? {};
    final listData = coursesObj['data'] as List? ?? [];

    return CourseListResponse(
      success: json['success'] ?? false,
      courses: listData.map((e) => CourseModel.fromJson(e)).toList(),
    );
  }
}
