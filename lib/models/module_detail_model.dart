class NavigationItemModel {
  final int id;
  final String title;
  final String slug;
  final int sortOrder;

  NavigationItemModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.sortOrder,
  });

  factory NavigationItemModel.fromJson(Map<String, dynamic> json) {
    return NavigationItemModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      title: json['title']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      sortOrder: json['sort_order'] is int ? json['sort_order'] : int.tryParse(json['sort_order']?.toString() ?? '0') ?? 0,
    );
  }
}

class NavigationModel {
  final NavigationItemModel? previous;
  final NavigationItemModel? next;
  final int current;
  final int total;

  NavigationModel({
    this.previous,
    this.next,
    required this.current,
    required this.total,
  });

  factory NavigationModel.fromJson(Map<String, dynamic> json) {
    return NavigationModel(
      previous: json['previous'] is Map<String, dynamic>
          ? NavigationItemModel.fromJson(json['previous'])
          : null,
      next: json['next'] is Map<String, dynamic>
          ? NavigationItemModel.fromJson(json['next'])
          : null,
      current: json['current'] is int ? json['current'] : int.tryParse(json['current']?.toString() ?? '1') ?? 1,
      total: json['total'] is int ? json['total'] : int.tryParse(json['total']?.toString() ?? '1') ?? 1,
    );
  }
}

class ModuleDetailModel {
  final int id;
  final int courseId;
  final String title;
  final String description;
  final String content;
  final String formattedDuration;
  final String? fileUrl;
  final String? videoUrl;
  final String? youtubeEmbedUrl;
  final String createdAt;
  final String formattedFileSize;

  ModuleDetailModel({
    required this.id,
    required this.courseId,
    required this.title,
    required this.description,
    required this.content,
    required this.formattedDuration,
    this.fileUrl,
    this.videoUrl,
    this.youtubeEmbedUrl,
    required this.createdAt,
    required this.formattedFileSize,
  });

  /// Helper untuk mengekstrak Video ID YouTube dari atribut URL yang tersedia
  String? get youtubeVideoId {
    final candidateUrls = [youtubeEmbedUrl, videoUrl, fileUrl];
    for (final rawUrl in candidateUrls) {
      if (rawUrl == null || rawUrl.trim().isEmpty) continue;
      final url = rawUrl.trim();

      // Matching regex untuk berbagai format URL YouTube (watch, embed, youtu.be, dll)
      final RegExp regExp = RegExp(
        r'(?:https?:\/\/)?(?:www\.)?(?:youtube\.com\/(?:[^\/\n\s]+\/\S+\/|(?:v|e(?:mbed)?)\/|\S*?[?&]v=)|youtu\.be\/)([a-zA-Z0-9_-]{11})',
        caseSensitive: false,
      );
      final match = regExp.firstMatch(url);
      if (match != null && match.group(1) != null) {
        return match.group(1);
      }

      // Jika URL sudah dalam format Raw Video ID 11 karakter
      final cleanId = url.split('&').first.split('?').first;
      if (RegExp(r'^[a-zA-Z0-9_-]{11}$').hasMatch(cleanId)) {
        return cleanId;
      }
    }
    return null;
  }

  factory ModuleDetailModel.fromJson(Map<String, dynamic> json) {
    return ModuleDetailModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      courseId: json['course_id'] is int ? json['course_id'] : int.tryParse(json['course_id']?.toString() ?? '0') ?? 0,
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      formattedDuration: json['formatted_duration']?.toString() ?? '',
      fileUrl: json['file_url']?.toString(),
      videoUrl: json['video_url']?.toString(),
      youtubeEmbedUrl: json['youtube_embed_url']?.toString(),
      createdAt: json['created_at']?.toString() ?? '',
      formattedFileSize: json['formatted_file_size']?.toString() ?? '',
    );
  }
}

class ModuleDetailResponse {
  final bool success;
  final ModuleDetailModel module;
  final NavigationModel navigation;

  ModuleDetailResponse({
    required this.success,
    required this.module,
    required this.navigation,
  });

  factory ModuleDetailResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic> ? json['data'] : <String, dynamic>{};
    return ModuleDetailResponse(
      success: json['success'] == true,
      module: ModuleDetailModel.fromJson(data['module'] is Map<String, dynamic> ? data['module'] : <String, dynamic>{}),
      navigation: NavigationModel.fromJson(data['navigation'] is Map<String, dynamic> ? data['navigation'] : <String, dynamic>{}),
    );
  }
}
