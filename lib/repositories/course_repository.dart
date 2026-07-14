import 'package:dio/dio.dart';
import '../models/course_model.dart';
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
}
