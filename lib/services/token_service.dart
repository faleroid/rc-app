import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenService {
  static final TokenService _instance = TokenService._internal();
  factory TokenService() => _instance;
  TokenService._internal();

  final _storage = const FlutterSecureStorage();
  final String _tokenKey = 'auth_token';

  String? _cachedToken;
  bool _isInitialized = false;

  final ValueNotifier<bool> authNotifier = ValueNotifier<bool>(false);

  Future<void> saveToken(String token) async {
    _cachedToken = token;
    _isInitialized = true;
    authNotifier.value = true;
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    if (_isInitialized) {
      return _cachedToken;
    }
    _cachedToken = await _storage.read(key: _tokenKey);
    _isInitialized = true;
    final hasToken = _cachedToken != null && _cachedToken!.isNotEmpty;
    if (authNotifier.value != hasToken) {
      authNotifier.value = hasToken;
    }
    return _cachedToken;
  }

  Future<void> deleteToken() async {
    _cachedToken = null;
    _isInitialized = true;
    authNotifier.value = false;
    await _storage.delete(key: _tokenKey);
  }
}
