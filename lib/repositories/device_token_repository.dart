import '../services/api_service.dart';

class DeviceTokenRepository {
  final ApiService _apiService = ApiService();

  /// Register or update FCM device token on backend
  Future<bool> registerToken(String token, {String platform = 'android'}) async {
    try {
      final response = await _apiService.dio.post(
        '/device-token',
        data: {
          'token': token,
          'platform': platform,
        },
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (_) {
      return false;
    }
  }

  /// Remove device token on logout
  Future<bool> removeToken(String token) async {
    try {
      final response = await _apiService.dio.delete(
        '/device-token',
        data: {
          'token': token,
        },
      );
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
