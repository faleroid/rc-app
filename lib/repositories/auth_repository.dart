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
      final data = e.response?.data;
      final errorMessage = (data is Map<String, dynamic>)
          ? (data['message'] ?? 'Terjadi kesalahan jaringan')
          : 'Terjadi kesalahan jaringan (${e.type.name})';

      return AuthResponse(success: false, message: errorMessage);
    }
  }

  Future<AuthResponse> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String phoneNumber,
    required String domicile,
  }) async {
    try {
      final response = await _apiService.dio.post(
        '/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
          'phone_number': phoneNumber,
          'domicile': domicile,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AuthResponse.fromJson(response.data);
      } else {
        return AuthResponse(
          success: false,
          message: response.data['message'] ?? 'Registrasi gagal',
        );
      }
    } on DioException catch (e) {
      final data = e.response?.data;
      final errorMessage = (data is Map<String, dynamic>)
          ? (data['message'] ?? 'Gagal mendaftar')
          : 'Gagal mendaftar (${e.type.name})';

      return AuthResponse(success: false, message: errorMessage);
    }
  }

  Future<void> logout() async {
    try {
      await _apiService.dio.post('/logout');
    } catch (_) {
      // Pass
    } finally {
      final tokenService = TokenService();
      await tokenService.deleteToken();
    }
  }
}
