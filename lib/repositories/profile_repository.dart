import 'package:dio/dio.dart';
import '../models/profile_model.dart';
import '../services/api_service.dart';

class ProfileRepository {
  final ApiService _apiService = ApiService();

  Future<ProfileResponse> getProfile() async {
    try {
      final response = await _apiService.dio.get('/profile');

      if (response.statusCode == 200) {
        return ProfileResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load profile');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to load profile');
    }
  }
}
