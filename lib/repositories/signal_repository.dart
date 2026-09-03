import 'package:dio/dio.dart';
import '../models/signal_model.dart';
import '../services/api_service.dart';
import '../services/cache_service.dart';

class SignalRepository {
  final ApiService _apiService = ApiService();
  final CacheService _cache = CacheService();

  Future<SignalListResponse> fetchSignals({
    String status = 'active',
    String type = 'all',
    String? search,
    int page = 1,
    int perPage = 12,
    bool forceRefresh = false,
  }) async {
    final cacheKey = 'signals_${status}_${type}_${search ?? ''}_${page}_$perPage';

    if (!forceRefresh) {
      final cached = _cache.get<SignalListResponse>(cacheKey);
      if (cached != null) return cached;
    }

    try {
      final queryParams = <String, dynamic>{
        'status': status,
        'page': page,
        'per_page': perPage,
      };

      if (type.isNotEmpty && type != 'all') {
        queryParams['type'] = type;
      }

      if (search != null && search.trim().isNotEmpty) {
        queryParams['search'] = search.trim();
      }

      final response = await _apiService.dio.get(
        '/signals',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final result = SignalListResponse.fromJson(response.data);
        _cache.set(cacheKey, result);
        return result;
      } else {
        throw Exception('Gagal memuat sinyal trading');
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ??
            'Terjadi kesalahan jaringan saat memuat sinyal trading',
      );
    }
  }

  Future<SignalModel> fetchSignalDetail(int id) async {
    try {
      final response = await _apiService.dio.get('/signals/$id');

      if (response.statusCode == 200) {
        final data = response.data['data'] as Map<String, dynamic>;
        return SignalModel.fromJson(data);
      } else {
        throw Exception('Gagal memuat detail sinyal');
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ??
            'Terjadi kesalahan jaringan saat memuat detail sinyal',
      );
    }
  }

  Future<List<SignalMonthlyRecapModel>> fetchMonthlyRecap({
    bool forceRefresh = false,
  }) async {
    const cacheKey = 'signals_monthly_recap';

    if (!forceRefresh) {
      final cached = _cache.get<List<SignalMonthlyRecapModel>>(cacheKey);
      if (cached != null) return cached;
    }

    try {
      final response = await _apiService.dio.get('/signals/recap');

      if (response.statusCode == 200) {
        final data = response.data['data'] as List<dynamic>? ?? [];
        final result =
            data.map((e) => SignalMonthlyRecapModel.fromJson(e)).toList();
        _cache.set(cacheKey, result);
        return result;
      } else {
        throw Exception('Gagal memuat rekap bulanan sinyal');
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ??
            'Terjadi kesalahan jaringan saat memuat rekap bulanan sinyal',
      );
    }
  }

  Future<SignalModel> createSignal({
    required String pair,
    required String type, // 'Futures' or 'Spot'
    required String side, // 'LONG' or 'SHORT'
    String? leverage,
    required List<String> entryTargets,
    required List<String> tpTargets,
    String? stopLoss,
    String? notes,
  }) async {
    try {
      final payload = <String, dynamic>{
        'pair': pair,
        'type': type,
        'side': side,
        'entry_targets': entryTargets,
        'tp_targets': tpTargets,
      };

      if (leverage != null && leverage.isNotEmpty) {
        payload['leverage'] = leverage;
      }
      if (stopLoss != null && stopLoss.isNotEmpty) {
        payload['stop_loss'] = stopLoss;
      }
      if (notes != null && notes.isNotEmpty) {
        payload['notes'] = notes;
      }

      final response = await _apiService.dio.post(
        '/signals',
        data: payload,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Invalidate signal caches so newly added signal appears immediately
        _cache.invalidateByPrefix('signals_');

        final data = response.data['data'] as Map<String, dynamic>;
        return SignalModel.fromJson(data);
      } else {
        throw Exception(response.data['message'] ?? 'Gagal membuat sinyal');
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ??
            'Terjadi kesalahan jaringan saat membuat sinyal',
      );
    }
  }
}
