import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:flutter_application_1/services/token_service.dart';
import 'package:flutter_application_1/repositories/payment_repository.dart';
import 'package:flutter_application_1/models/payment_model.dart';

// Manual Mock Declarations or Mockito annotations for generation

/// Mock Auth Repository to simulate Laravel Sanctum Auth endpoints
class MockAuthRepository extends Mock {
  Future<Map<String, dynamic>> login(String email, String password) async {
    return super.noSuchMethod(
      Invocation.method(#login, [email, password]),
      returnValue: Future.value({
        'token': 'fake_sanctum_token_12345',
        'user': {'id': 1, 'email': email, 'name': 'Trader Test'},
      }),
      returnValueForMissingStub: Future.value({
        'token': 'fake_sanctum_token_12345',
        'user': {'id': 1, 'email': email, 'name': 'Trader Test'},
      }),
    );
  }

  Future<bool> logout() async {
    return super.noSuchMethod(
      Invocation.method(#logout, []),
      returnValue: Future.value(true),
      returnValueForMissingStub: Future.value(true),
    );
  }

  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    return super.noSuchMethod(
      Invocation.method(#register, [name, email, password]),
      returnValue: Future.value({
        'token': 'fake_sanctum_token_register_67890',
        'user': {'id': 2, 'name': name, 'email': email},
      }),
      returnValueForMissingStub: Future.value({
        'token': 'fake_sanctum_token_register_67890',
        'user': {'id': 2, 'name': name, 'email': email},
      }),
    );
  }
}

/// Mock Subscription Repository to simulate package listing & status
class MockSubscriptionRepository extends Mock {
  Future<List<Map<String, dynamic>>> getPackages() async {
    final packages = <Map<String, dynamic>>[
      {
        'id': 1,
        'name': 'Starter Plan',
        'price': 99000.0,
        'formatted_price': 'Rp 99.000',
        'duration': '1 Bulan',
        'description': 'Akses dasar signal & news',
        'benefits': ['Signal Crypto', 'Akses Berita VIP'],
      },
      {
        'id': 2,
        'name': 'Pro Plan',
        'price': 199000.0,
        'formatted_price': 'Rp 199.000',
        'duration': '1 Bulan',
        'description': 'Akses penuh kelas & video edukasi',
        'benefits': ['Semua fitur Starter', 'Video Edukasi Full', 'Private Discord Group'],
      },
      {
        'id': 3,
        'name': 'VIP Ultimate',
        'price': 499000.0,
        'formatted_price': 'Rp 499.000',
        'duration': '1 Bulan',
        'description': 'Fitur paling komplit + 1-on-1 Mentoring',
        'benefits': ['Semua Fitur Pro', '1-on-1 Mentoring', 'Whale Alert Indicator'],
      },
    ];
    return super.noSuchMethod(
      Invocation.method(#getPackages, []),
      returnValue: Future.value(packages),
      returnValueForMissingStub: Future.value(packages),
    );
  }
}

/// Mock Payment Repository to simulate Midtrans Snap Checkout & Status Checking
class MockPaymentRepository extends Mock implements PaymentRepository {
  @override
  Future<Map<String, dynamic>> getMembershipUpgradeInfo() async {
    return super.noSuchMethod(
      Invocation.method(#getMembershipUpgradeInfo, []),
      returnValue: Future.value({
        'packages': [],
        'currentMembership': null,
      }),
      returnValueForMissingStub: Future.value({
        'packages': [],
        'currentMembership': null,
      }),
    );
  }

  @override
  Future<PaymentStoreResponse> createPayment(int packageId) async {
    final response = PaymentStoreResponse(
      paymentId: 101,
      snapToken: 'snap_token_sandbox_test_xyz123',
      redirectUrl: 'https://app.sandbox.midtrans.com/snap/v2/vtweb/snap_token_sandbox_test_xyz123',
      package: {'id': packageId, 'name': 'Pro Plan'},
    );
    return super.noSuchMethod(
      Invocation.method(#createPayment, [packageId]),
      returnValue: Future.value(response),
      returnValueForMissingStub: Future.value(response),
    );
  }

  @override
  Future<Map<String, dynamic>> checkPaymentStatus(int paymentId) async {
    return super.noSuchMethod(
      Invocation.method(#checkPaymentStatus, [paymentId]),
      returnValue: Future.value({
        'payment': {
          'id': paymentId,
          'status': 'success',
          'package_id': 2,
        },
      }),
      returnValueForMissingStub: Future.value({
        'payment': {
          'id': paymentId,
          'status': 'pending',
          'package_id': 2,
        },
      }),
    );
  }
}

/// Mock Token Service to simulate Secure Storage & Bearer tokens
class MockTokenService extends Mock implements TokenService {
  String? _storedToken = 'fake_bearer_token_xyz';

  @override
  Future<String?> getToken() async => _storedToken;

  @override
  Future<void> saveToken(String token) async {
    _storedToken = token;
  }

  @override
  Future<void> deleteToken() async {
    _storedToken = null;
  }
}

/// Mock HTTP / Dio Client
class MockHttpClient extends Mock implements Dio {}
