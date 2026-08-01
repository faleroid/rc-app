import 'package:dio/dio.dart';
import '../models/course_model.dart';
import '../models/module_detail_model.dart';
import '../services/api_service.dart';

class CourseRepository {
  final ApiService _apiService = ApiService();

  Future<CourseListResponse> fetchCourses() async {
    try {
      final response = await _apiService.dio.get('/courses');

      if (response.statusCode == 200) {
        return CourseListResponse.fromJson(response.data);
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
