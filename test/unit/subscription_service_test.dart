import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../helpers/mock_repositories.dart';
import '../helpers/test_fixtures.dart';

class SubscriptionService {
  final MockSubscriptionRepository subscriptionRepository;
  final MockPaymentRepository paymentRepository;

  SubscriptionService({
    required this.subscriptionRepository,
    required this.paymentRepository,
  });

  Future<Map<String, dynamic>?> getActiveSubscription(Map<String, dynamic> userFixture) async {
    final sub = userFixture['subscription'];
    if (sub != null && sub['status'] == 'active') {
      return sub;
    }
    return null;
  }

  bool isSubscribed(Map<String, dynamic>? subscriptionData) {
    if (subscriptionData == null) return false;
    return subscriptionData['status'] == 'active' && (subscriptionData['days_remaining'] ?? 0) > 0;
  }

  bool canUpgrade(int currentPackageId) {
    // Tiers: 1 = Starter, 2 = Pro, 3 = VIP Ultimate (Highest)
    return currentPackageId < 3;
  }

  Future<Map<String, dynamic>> upgradePackage(int newPackageId) async {
    if (newPackageId <= 0) {
      throw Exception('Package ID tidak valid');
    }
    final response = await paymentRepository.createPayment(newPackageId);
    return {
      'payment_id': response.paymentId,
      'snap_token': response.snapToken,
      'redirect_url': response.redirectUrl,
    };
  }
}

void main() {
  group('2. SUBSCRIPTION SERVICE UNIT TESTS (Arrange-Act-Assert)', () {
    late MockSubscriptionRepository mockSubscriptionRepository;
    late MockPaymentRepository mockPaymentRepository;
    late SubscriptionService subscriptionService;

    setUp(() {
      mockSubscriptionRepository = MockSubscriptionRepository();
      mockPaymentRepository = MockPaymentRepository();
      subscriptionService = SubscriptionService(
        subscriptionRepository: mockSubscriptionRepository,
        paymentRepository: mockPaymentRepository,
      );
    });

    test('getActiveSubscription() → return data paket aktif jika ada', () async {
      // Arrange
      final userFixture = fakeUserSubscribed();

      // Act
      final activeSub = await subscriptionService.getActiveSubscription(userFixture);

      // Assert
      expect(activeSub, isNotNull);
      expect(activeSub!['status'], equals('active'));
      expect(activeSub['package']['name'], equals('Pro Plan'));
    });

    test('getActiveSubscription() saat tidak ada paket aktif → return null [Negative]', () async {
      // Arrange
      final userFixture = fakeUserExpired();

      // Act
      final activeSub = await subscriptionService.getActiveSubscription(userFixture);

      // Assert
      expect(activeSub, isNull);
    });

    test('isSubscribed() → return true jika paket aktif, false jika tidak', () {
      // Arrange
      final activeFixture = fakeUserSubscribed()['subscription'];
      final expiredFixture = fakeUserExpired()['subscription'];

      // Act
      final isSubActive = subscriptionService.isSubscribed(activeFixture);
      final isSubExpired = subscriptionService.isSubscribed(expiredFixture);

      // Assert
      expect(isSubActive, isTrue);
      expect(isSubExpired, isFalse);
    });

    test('canUpgrade() → return true hanya jika paket saat ini bukan paket tertinggi', () {
      // Arrange
      const starterId = 1;
      const proId = 2;
      const vipUltimateId = 3;

      // Act
      final canUpgradeStarter = subscriptionService.canUpgrade(starterId);
      final canUpgradePro = subscriptionService.canUpgrade(proId);
      final canUpgradeVIP = subscriptionService.canUpgrade(vipUltimateId);

      // Assert
      expect(canUpgradeStarter, isTrue);
      expect(canUpgradePro, isTrue);
      expect(canUpgradeVIP, isFalse); // Highest tier cannot upgrade
    });

    test('upgradePackage() → kirim request ke API dengan paket_id baru', () async {
      // Arrange
      const newPackageId = 3; // Upgrade to VIP Ultimate

      // Act
      final result = await subscriptionService.upgradePackage(newPackageId);

      // Assert
      expect(result['payment_id'], equals(101));
      expect(result['snap_token'], isNotEmpty);
      expect(result['redirect_url'], contains('sandbox.midtrans.com'));
    });
  });
}
