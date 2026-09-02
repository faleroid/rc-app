import 'package:dio/dio.dart';
import '../models/announcement_model.dart';
import '../services/api_service.dart';
import '../services/cache_service.dart';

class AnnouncementRepository {
  final ApiService _apiService = ApiService();
  final CacheService _cache = CacheService();

  Future<AnnouncementListResponse> fetchAnnouncements({
    String? category,
    String? search,
    int page = 1,
    int perPage = 15,
    bool forceRefresh = false,
  }) async {
    final cacheKey = 'announcements_${category ?? 'all'}_${search ?? ''}_${page}_$perPage';

    if (!forceRefresh) {
      final cached = _cache.get<AnnouncementListResponse>(cacheKey);
      if (cached != null) return cached;
    }

    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'per_page': perPage,
      };

      if (category != null && category.isNotEmpty && category != 'all') {
        queryParams['category'] = category;
      }

      if (search != null && search.trim().isNotEmpty) {
        queryParams['search'] = search.trim();
      }

      final response = await _apiService.dio.get(
        '/announcements',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final result = AnnouncementListResponse.fromJson(response.data);
        _cache.set(cacheKey, result);
        return result;
      } else {
        throw Exception('Gagal memuat pengumuman');
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Terjadi kesalahan jaringan saat memuat pengumuman',
      );
    }
  }

  Future<Map<String, dynamic>> toggleLike(int announcementId) async {
    try {
      final response = await _apiService.dio.post(
        '/announcements/$announcementId/like',
      );

      if (response.statusCode == 200) {
        // Invalidate announcement caches since like state changed
        _cache.invalidateByPrefix('announcements_');

        final data = response.data['data'] as Map<String, dynamic>? ?? {};
        return {
          'is_liked': data['is_liked'] ?? false,
          'likes_count': data['likes_count'] ?? 0,
        };
      } else {
        throw Exception('Gagal memperbarui like');
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Terjadi kesalahan jaringan saat like pengumuman',
      );
    }
  }
}
