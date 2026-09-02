import 'package:dio/dio.dart';
import '../models/profile_model.dart';
import '../services/api_service.dart';
import '../services/cache_service.dart';

class AppException implements Exception {
  final String message;
  AppException(this.message);

  @override
  String toString() => message;
}

class ProfileRepository {
  final ApiService _apiService = ApiService();
  final CacheService _cache = CacheService();

  Future<ProfileResponse> getProfile({bool forceRefresh = false}) async {
    const cacheKey = 'profile';

    if (!forceRefresh) {
      final cached = _cache.get<ProfileResponse>(cacheKey);
      if (cached != null) return cached;
    }

    try {
      final response = await _apiService.dio.get('/profile');

      if (response.statusCode == 200) {
        final result = ProfileResponse.fromJson(response.data);
        _cache.set(cacheKey, result);
        return result;
      } else {
        throw AppException('Failed to load profile');
      }
    } on DioException catch (e) {
      throw AppException(
        e.response?.data['message'] ?? 'Failed to load profile',
      );
    }
  }

  Future<bool> updateUsername(String newName) async {
    try {
      final response = await _apiService.dio.patch(
        '/profile/username',
        data: {'name': newName},
      );
      if (response.statusCode == 200) {
        _cache.invalidate('profile'); // Invalidate profile cache after update
      }
      return response.statusCode == 200;
    } on DioException catch (e) {
      throw AppException(e.response?.data['message'] ?? 'Gagal mengubah nama');
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
      throw AppException(
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
      throw AppException(
        e.response?.data['message'] ?? 'Gagal mengubah password',
      );
    }
  }
}
