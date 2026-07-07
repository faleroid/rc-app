import 'package:dio/dio.dart';
import '../services/api_service.dart';
import '../models/auth_model.dart';
import '../services/token_service.dart';

class AuthRepository {
  final ApiService _apiService = ApiService();

  Future<AuthResponse> login(String email, String password) async {
    try {
      final response = await _apiService.dio.post(
        '/login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AuthResponse.fromJson(response.data);
      } else {
        return AuthResponse(
          success: false,
          message: response.data['message'] ?? 'Login gagal',
        );
      }
    } on DioException catch (e) {
      print('DioException caught: ${e.toString()}');

      final data = e.response?.data;
      final errorMessage = (data is Map<String, dynamic>)
          ? (data['message'] ?? 'Terjadi kesalahan jaringan')
          : 'Terjadi kesalahan jaringan (${e.type.name})';

      return AuthResponse(success: false, message: errorMessage);
    }
  }

  Future<void> logout() async {
    try {
      await _apiService.dio.post('/logout');
    } catch (e) {
      print('API Logout gagal/error: $e');
    } finally {
      final tokenService = TokenService();
      await tokenService.deleteToken();
    }
  }
}
