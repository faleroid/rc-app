import 'package:dio/dio.dart';
import '../services/api_service.dart';
import '../models/payment_model.dart';

class PaymentRepository {
  final ApiService _apiService = ApiService();

  /// Mengambil daftar paket membership yang tersedia
  Future<Map<String, dynamic>> getMembershipUpgradeInfo() async {
    try {
      final response = await _apiService.dio.get('/membership/upgrade');
      if (response.data['success'] == true) {
        final List packagesRaw = response.data['data']['packages'] ?? [];
        final List<MembershipPackageModel> packages = 
            packagesRaw.map((json) => MembershipPackageModel.fromJson(json)).toList();
        
        CurrentMembershipModel? currentMembership;
        if (response.data['data']['currentMembership'] != null) {
          currentMembership = CurrentMembershipModel.fromJson(response.data['data']['currentMembership']);
        }

        return {
          'packages': packages,
          'currentMembership': currentMembership,
        };
      }
      throw Exception(response.data['message'] ?? 'Gagal mengambil data membership');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Terjadi kesalahan jaringan');
    }
  }

  /// Membuat transaksi pembayaran baru untuk mendapatkan Snap Token
  Future<PaymentStoreResponse> createPayment(int packageId) async {
    try {
      final response = await _apiService.dio.post(
        '/payment/$packageId/store',
        data: {'payment_method': 'snap'}, // Kita gunakan Snap secara default
      );
      
      if (response.data['success'] == true) {
        return PaymentStoreResponse.fromJson(response.data['data']);
      }
      throw Exception(response.data['message'] ?? 'Gagal membuat pembayaran');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal memproses transaksi');
    }
  }

  /// Mengecek status pembayaran terakhir
  Future<Map<String, dynamic>> checkPaymentStatus(int paymentId) async {
    try {
      final response = await _apiService.dio.get('/payment/$paymentId/check-status');
      if (response.data['success'] == true) {
        return response.data['data'];
      }
      throw Exception(response.data['message'] ?? 'Gagal verifikasi status');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal sinkronisasi status');
    }
  }
}
