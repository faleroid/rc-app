import 'package:dio/dio.dart';
import '../models/news_model.dart';
import '../services/api_service.dart';

class NewsRepository {
  final ApiService _apiService = ApiService();

  Future<NewsPaginatedResponse> fetchNews({
    String? search,
    int page = 1,
  }) async {
    try {
      final response = await _apiService.dio.get(
        '/news',
        queryParameters: {
          'page': page,
          if (search != null && search.isNotEmpty) 'search': search,
        },
      );

      if (response.statusCode == 200) {
        return NewsPaginatedResponse.fromJson(response.data);
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
