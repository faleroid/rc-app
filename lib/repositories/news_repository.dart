import 'package:dio/dio.dart';
import '../models/news_model.dart';
import '../services/api_service.dart';
import '../services/cache_service.dart';

class NewsRepository {
  final ApiService _apiService = ApiService();
  final CacheService _cache = CacheService();

  Future<NewsPaginatedResponse> fetchNews({
    String? search,
    bool forceRefresh = false,
  }) async {
    final cacheKey = 'news_${search ?? ''}';

    if (!forceRefresh) {
      final cached = _cache.get<NewsPaginatedResponse>(cacheKey);
      if (cached != null) return cached;
    }

    try {
      final response = await _apiService.dio.get(
        '/news',
        queryParameters: {
          if (search != null && search.isNotEmpty) 'search': search,
        },
      );

      if (response.statusCode == 200) {
        final result = NewsPaginatedResponse.fromJson(response.data);
        _cache.set(cacheKey, result);
        return result;
      } else {
        throw Exception('Gagal memuat berita');
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Terjadi kesalahan jaringan',
      );
    }
  }
}
