// lib/models/course_model.dart

class ModuleMiniModel {
  final int id;
  final int courseId;
  final int durationMinutes;
  final String title;
  final String? thumbnailUrl;
  final String? videoUrl;

  ModuleMiniModel({
    required this.id,
    required this.courseId,
    required this.durationMinutes,
    required this.title,
    this.thumbnailUrl,
    this.videoUrl,
  });

  /// Real Video Thumbnail (YouTube HQ Thumbnail atau thumbnail kustom dari API)
  String get realThumbnailUrl {
    if (thumbnailUrl != null && thumbnailUrl!.trim().isNotEmpty) {
      return thumbnailUrl!.trim();
    }
    if (videoUrl != null && videoUrl!.trim().isNotEmpty) {
      final regExp = RegExp(
        r'(?:youtube\.com\/(?:[^\/]+\/.+\/|(?:v|e(?:mbed)?)\/|.*[?&]v=)|youtu\.be\/|youtube\.com\/shorts\/)([^"&?\/ ]{11})',
      );
      final match = regExp.firstMatch(videoUrl!.trim());
      if (match != null && match.group(1) != null) {
        return 'https://img.youtube.com/vi/${match.group(1)}/hqdefault.jpg';
      }
    }
    return '';
  }

  factory ModuleMiniModel.fromJson(Map<String, dynamic> json) {
    return ModuleMiniModel(
      id: json['id'] ?? 0,
      courseId: json['course_id'] ?? 0,
      durationMinutes: json['duration_minutes'] ?? 0,
      title: json['title'] ?? 'Modul ${json['id']}',
      thumbnailUrl: json['thumbnail'] ?? json['thumbnail_url'],
      videoUrl: json['video_url'] ?? json['youtube_embed_url'],
    );
  }
}

class CourseModel {
  final int id;
  final String title;
  final String slug;
  final List<ModuleMiniModel> modules;

  CourseModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.modules,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    var modulesList = json['modules'] as List? ?? [];
    List<ModuleMiniModel> parsedModules =
        modulesList.map((m) => ModuleMiniModel.fromJson(m)).toList();

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
