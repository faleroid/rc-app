import '../services/api_service.dart';

class NavigationItemModel {
  final int id;
  final String title;
  final String slug;
  final int sortOrder;
  final String description;
  final String? videoUrl;
  final String? thumbnailUrl;

  NavigationItemModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.sortOrder,
    this.description = '',
    this.videoUrl,
    this.thumbnailUrl,
  });

  /// Real Video Thumbnail (YouTube HQ Thumbnail atau thumbnail kustom dari API)
  String get realThumbnailUrl {
    // 1. Cek jika API mengirimkan thumbnail_url kustom
    if (thumbnailUrl != null && thumbnailUrl!.trim().isNotEmpty) {
      return thumbnailUrl!.trim();
    }

    // 2. Cek jika video_url adalah tautan YouTube dan ekstrak thumbnail aslinya
    if (videoUrl != null && videoUrl!.trim().isNotEmpty) {
      final url = videoUrl!.trim();
      final regExp = RegExp(
        r'(?:youtube\.com\/(?:[^\/]+\/.+\/|(?:v|e(?:mbed)?)\/|.*[?&]v=)|youtu\.be\/|youtube\.com\/shorts\/)([^"&?\/ ]{11})',
      );
      final match = regExp.firstMatch(url);
      if (match != null && match.group(1) != null) {
        return 'https://img.youtube.com/vi/${match.group(1)}/hqdefault.jpg';
      }
    }

    return '';
  }

  factory NavigationItemModel.fromJson(Map<String, dynamic> json) {
    return NavigationItemModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      title: json['title']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      sortOrder: json['sort_order'] is int
          ? json['sort_order']
          : int.tryParse(json['sort_order']?.toString() ?? '0') ?? 0,
      description: json['description']?.toString() ?? '',
      videoUrl: json['video_url']?.toString(),
      thumbnailUrl:
          json['thumbnail_url']?.toString() ?? json['thumbnail']?.toString(),
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
      current: json['current'] is int
          ? json['current']
          : int.tryParse(json['current']?.toString() ?? '1') ?? 1,
      total: json['total'] is int
          ? json['total']
          : int.tryParse(json['total']?.toString() ?? '1') ?? 1,
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
  final String? videoPlaybackUrl;
  final String? thumbnailUrl;
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
    this.videoPlaybackUrl,
    this.thumbnailUrl,
    required this.createdAt,
    required this.formattedFileSize,
  });

  /// Priority getter untuk URL streaming video (Cloudflare R2 / Direct MP4)
  String? get videoStreamUrl {
    String? raw;
    if (videoPlaybackUrl != null && videoPlaybackUrl!.trim().isNotEmpty) {
      raw = videoPlaybackUrl!.trim();
    } else if (fileUrl != null && fileUrl!.trim().isNotEmpty) {
      raw = fileUrl!.trim();
    } else if (videoUrl != null && videoUrl!.trim().isNotEmpty) {
      final url = videoUrl!.trim();
      final isYouTube = url.contains('youtube.com') || url.contains('youtu.be');
      if (!isYouTube) {
        raw = url;
      }
    }

    if (raw == null) return null;
    return resolveMediaUrl(raw);
  }

  /// Real Video Thumbnail
  String get realThumbnailUrl {
    if (thumbnailUrl != null && thumbnailUrl!.trim().isNotEmpty) {
      return thumbnailUrl!.trim();
    }

    if (videoUrl != null && videoUrl!.trim().isNotEmpty) {
      final url = videoUrl!.trim();
      final regExp = RegExp(
        r'(?:youtube\.com\/(?:[^\/]+\/.+\/|(?:v|e(?:mbed)?)\/|.*[?&]v=)|youtu\.be\/|youtube\.com\/shorts\/)([^"&?\/ ]{11})',
      );
      final match = regExp.firstMatch(url);
      if (match != null && match.group(1) != null) {
        return 'https://img.youtube.com/vi/${match.group(1)}/hqdefault.jpg';
      }
    }

    return '';
  }

  /// Helper untuk meresolve localhost URL menjadi host IP tempat API server berjalan
  static String resolveMediaUrl(String url) {
    final trimmed = url.trim();
    if (trimmed.isEmpty) return trimmed;

    if (trimmed.startsWith('http://localhost') ||
        trimmed.startsWith('http://127.0.0.1')) {
      try {
        final baseApi = ApiService().dio.options.baseUrl;
        final Uri? apiUri = Uri.tryParse(baseApi);
        if (apiUri != null && apiUri.host.isNotEmpty) {
          final String targetHost =
              apiUri.port != 0 && apiUri.port != 80 && apiUri.port != 443
                  ? '${apiUri.host}:${apiUri.port}'
                  : apiUri.host;
          return trimmed.replaceFirst(
            RegExp(r'http://(localhost|127\.0\.0\.1)(:\d+)?'),
            'http://$targetHost',
          );
        }
      } catch (e) {
        // Fallback
      }
    }

    return trimmed;
  }

  factory ModuleDetailModel.fromJson(Map<String, dynamic> json) {
    return ModuleDetailModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      courseId: json['course_id'] is int
          ? json['course_id']
          : int.tryParse(json['course_id']?.toString() ?? '0') ?? 0,
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      formattedDuration: json['formatted_duration']?.toString() ?? '',
      fileUrl: json['file_url']?.toString(),
      videoUrl: json['video_url']?.toString(),
      videoPlaybackUrl: json['video_playback_url']?.toString(),
      thumbnailUrl:
          json['thumbnail_url']?.toString() ?? json['thumbnail']?.toString(),
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
    final data =
        json['data'] is Map<String, dynamic> ? json['data'] : <String, dynamic>{};
    return ModuleDetailResponse(
      success: json['success'] == true,
      module: ModuleDetailModel.fromJson(
        data['module'] is Map<String, dynamic>
            ? data['module']
            : <String, dynamic>{},
      ),
      navigation: NavigationModel.fromJson(
        data['navigation'] is Map<String, dynamic>
            ? data['navigation']
            : <String, dynamic>{},
      ),
    );
  }
}
