import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../helpers/mock_repositories.dart';

class MidtransPaymentService {
  final MockPaymentRepository paymentRepository;
  bool isSubscribed = false;

  MidtransPaymentService({required this.paymentRepository});

  Future<String> createTransaction(int? packageId, String? paymentMethod) async {
    if (packageId == null || paymentMethod == null || paymentMethod.isEmpty) {
      throw FormatException('Data transaksi tidak lengkap');
    }
    final response = await paymentRepository.createPayment(packageId);
    return response.snapToken;
  }

  Map<String, dynamic> handlePaymentStatus(String status) {
    switch (status) {
      case 'settlement':
      case 'paid':
      case 'success':
        isSubscribed = true;
        return {
          'isSubscribed': true,
          'message': 'Pembayaran berhasil! Akses VIP Anda telah aktif.',
          'ui_state': 'SUCCESS',
        };
      case 'pending':
        isSubscribed = false;
        return {
          'isSubscribed': false,
          'message': 'Menunggu pembayaran selesai.',
          'ui_state': 'PENDING_UI',
        };
      case 'expire':
        isSubscribed = false;
        return {
          'isSubscribed': false,
          'message': 'Waktu pembayaran telah habis (Expired).',
          'ui_state': 'EXPIRED_UI',
        };
      case 'cancel':
      case 'deny':
        isSubscribed = false;
        return {
          'isSubscribed': false,
          'message': 'Pembayaran dibatalkan.',
          'ui_state': 'CANCEL_UI',
        };
      default:
        isSubscribed = false;
        return {
          'isSubscribed': false,
          'message': 'Status pembayaran tidak diketahui.',
          'ui_state': 'UNKNOWN_UI',
        };
    }
  }
}

void main() {
  group('3. MIDTRANS PAYMENT SERVICE UNIT TESTS (Arrange-Act-Assert)', () {
    late MockPaymentRepository mockPaymentRepository;
    late MidtransPaymentService paymentService;

    setUp(() {
      mockPaymentRepository = MockPaymentRepository();
      paymentService = MidtransPaymentService(paymentRepository: mockPaymentRepository);
    });

    test('createTransaction() → return snap_token dari API Laravel', () async {
      // Arrange
      const packageId = 2;
      const paymentMethod = 'bca_va';

      // Act
      final snapToken = await paymentService.createTransaction(packageId, paymentMethod);

      // Assert
      expect(snapToken, equals('snap_token_sandbox_test_xyz123'));
    });

    test('createTransaction() dengan data tidak lengkap → throw error [Negative]', () async {
      // Arrange
      int? packageId;
      String? paymentMethod = '';

      // Act & Assert
      expect(
        () => paymentService.createTransaction(packageId, paymentMethod),
        throwsA(isA<FormatException>().having((e) => e.message, 'message', contains('tidak lengkap'))),
      );
    });

    test('penanganan status settlement → set isSubscribed = true', () {
      // Arrange
      const status = 'settlement';

      // Act
      final result = paymentService.handlePaymentStatus(status);

      // Assert
      expect(paymentService.isSubscribed, isTrue);
      expect(result['isSubscribed'], isTrue);
      expect(result['ui_state'], equals('SUCCESS'));
    });

    test('penanganan status pending → tampilkan UI pending, belum aktifkan akses', () {
      // Arrange
      const status = 'pending';

      // Act
      final result = paymentService.handlePaymentStatus(status);

      // Assert
      expect(paymentService.isSubscribed, isFalse);
      expect(result['isSubscribed'], isFalse);
      expect(result['ui_state'], equals('PENDING_UI'));
    });

    test('penanganan status expire → tampilkan pesan expired, tidak aktifkan akses', () {
      // Arrange
      const status = 'expire';

      // Act
      final result = paymentService.handlePaymentStatus(status);

      // Assert
      expect(paymentService.isSubscribed, isFalse);
      expect(result['isSubscribed'], isFalse);
      expect(result['ui_state'], equals('EXPIRED_UI'));
      expect(result['message'], contains('Expired'));
    });

    test('penanganan status cancel → tampilkan pesan cancel, tidak aktifkan akses', () {
      // Arrange
      const status = 'cancel';

      // Act
      final result = paymentService.handlePaymentStatus(status);

      // Assert
      expect(paymentService.isSubscribed, isFalse);
      expect(result['isSubscribed'], isFalse);
      expect(result['ui_state'], equals('CANCEL_UI'));
      expect(result['message'], contains('dibatalkan'));
    });
  });
}
