import 'package:dio/dio.dart';
import '../models/course_model.dart';
import '../models/module_detail_model.dart';
import '../services/api_service.dart';
import '../services/cache_service.dart';

class CourseRepository {
  final ApiService _apiService = ApiService();
  final CacheService _cache = CacheService();

  Future<CourseListResponse> fetchCourses({
    bool forceRefresh = false,
  }) async {
    const cacheKey = 'courses';

    if (!forceRefresh) {
      final cached = _cache.get<CourseListResponse>(cacheKey);
      if (cached != null) return cached;
    }

    try {
      final response = await _apiService.dio.get('/courses');

      if (response.statusCode == 200) {
        final result = CourseListResponse.fromJson(response.data);
        _cache.set(cacheKey, result);
        return result;
      } else {
        throw Exception('Gagal memuat daftar modul');
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Terjadi kesalahan jaringan',
      );
    }
  }

  Future<ModuleDetailResponse> fetchModuleDetail(
    int courseId,
    int moduleId,
  ) async {
    try {
      // Menembak endpoint: /api/courses/1/modules/1
      final response = await _apiService.dio.get(
        '/courses/$courseId/modules/$moduleId',
      );

      if (response.statusCode == 200) {
        return ModuleDetailResponse.fromJson(response.data);
      } else {
        throw Exception('Gagal memuat detail modul');
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Terjadi kesalahan jaringan',
      );
    }
  }
}
