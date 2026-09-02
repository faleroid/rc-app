import 'package:dio/dio.dart';
import '../models/ebook_model.dart';
import '../services/api_service.dart';
import '../services/cache_service.dart';

class EbookRepository {
  final ApiService _apiService = ApiService();
  final CacheService _cache = CacheService();

  Future<EbookListResponse> fetchEbooks({
    String category = 'all',
    String? search,
    int page = 1,
    int perPage = 12,
    bool forceRefresh = false,
  }) async {
    final cacheKey = 'ebooks_${category}_${search ?? ''}_${page}_$perPage';

    if (!forceRefresh) {
      final cached = _cache.get<EbookListResponse>(cacheKey);
      if (cached != null) return cached;
    }

    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'per_page': perPage,
      };

      if (category.isNotEmpty && category != 'all') {
        queryParams['category'] = category;
      }

      if (search != null && search.trim().isNotEmpty) {
        queryParams['search'] = search.trim();
      }

      final response = await _apiService.dio.get(
        '/ebooks',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final result = EbookListResponse.fromJson(response.data);
        _cache.set(cacheKey, result);
        return result;
      } else {
        throw Exception('Gagal memuat e-book');
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ??
            'Terjadi kesalahan jaringan saat memuat e-book',
      );
    }
  }

  Future<EbookDetailResponse> fetchEbookDetail(String slug) async {
    try {
      final response = await _apiService.dio.get('/ebooks/$slug');

      if (response.statusCode == 200) {
        return EbookDetailResponse.fromJson(response.data);
      } else {
        throw Exception('Gagal memuat detail e-book');
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ??
            'Terjadi kesalahan jaringan saat memuat detail e-book',
      );
    }
  }

  Future<String> fetchEbookReadUrl(String slug) async {
    try {
      final response = await _apiService.dio.get('/ebooks/$slug/read');

      if (response.statusCode == 200) {
        final data = response.data['data'] as Map<String, dynamic>? ?? {};
        final readerUrl = data['reader_pdf_url']?.toString();
        if (readerUrl != null && readerUrl.isNotEmpty) {
          return readerUrl;
        }
        throw Exception('URL reader PDF tidak tersedia');
      } else {
        throw Exception('Gagal mendapatkan akses pembaca e-book');
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ??
            'Terjadi kesalahan jaringan saat mengakses pembaca e-book',
      );
    }
  }
}
