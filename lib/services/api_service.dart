import 'package:flutter/widgets.dart';
import 'package:dio/dio.dart';
import 'token_service.dart';
import '../router/app_router.dart';

class ApiService {
  final TokenService _tokenService = TokenService();
  late final Dio _dio;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        // baseUrl: 'http://10.0.2.2:8000/api', // emulator
        baseUrl: 'http://10.120.17.123:8000/api', // real device
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
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

          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          final statusCode = e.response?.statusCode;
          if (statusCode == 401 || statusCode == 403) {
            await _tokenService.deleteToken();
            final serverMsg = e.response?.data is Map
                ? e.response?.data['message']?.toString()
                : null;

            WidgetsBinding.instance.addPostFrameCallback((_) {
              try {
                appRouter.go('/unauthenticated', extra: serverMsg);
              } catch (_) {}
            });
          }
          return handler.next(e);
        },
      ),
    );
  }

  Dio get dio => _dio;
}
