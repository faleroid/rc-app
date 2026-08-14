import 'package:dio/dio.dart';
import 'token_service.dart';

class ApiService {
  final TokenService _tokenService = TokenService();
  late final Dio _dio;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        // Tip: Gunakan IP laptop Anda jika testing via HP fisik di jaringan Wi-Fi yang sama
        baseUrl: 'http://192.168.18.26:8000/api',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _tokenService.getToken();

          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            await _tokenService.deleteToken();
          }
          return handler.next(e);
        },
      ),
    );
  }

  Dio get dio => _dio;
}
