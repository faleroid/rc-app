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

  Future<bool> updateUsername(String newName) async {
    try {
      final response = await _apiService.dio.patch(
        '/profile/username',
        data: {'name': newName},
      );
      return response.statusCode == 200;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal mengubah nama');
    }
  }

  Future<bool> verifyPassword(String currentPassword) async {
    try {
      final response = await _apiService.dio.post(
        '/profile/verify-password',
        data: {'current_password': currentPassword},
      );
      return response.statusCode == 200;
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Password salah atau terjadi kesalahan',
      );
    }
  }

  Future<bool> updatePassword(
    String currentPassword,
    String newPassword,
    String newPasswordConfirmation,
  ) async {
    try {
      final response = await _apiService.dio.patch(
        '/profile/password',
        data: {
          'current_password': currentPassword,
          'password': newPassword,
          'password_confirmation': newPasswordConfirmation,
        },
      );
      return response.statusCode == 200;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal mengubah password');
    }
  }
}
