/// Test Fixtures & Helper Functions for RicoCapital Apps Testing
library;

/// Kredensial Midtrans Sandbox untuk Testing Manual/Otomatis
final Map<String, dynamic> midtransSandboxCredentials = {
  'gopay': {
    'phone_number': '+62 081 2345 678',
    'status': 'sandbox_flow',
    'description': 'Simulasi scan QRIS / Deeplink GoPay Sandbox',
  },
  'bca_va': {
    'bank': 'BCA',
    'va_code_generator': 'Auto-generated Snap VA Number',
    'simulator_url': 'https://simulator.sandbox.midtrans.com/bca/va/index',
  },
  'credit_card': {
    'success_card': '4811 1111 1111 1114',
    'failure_card': '4911 1111 1111 1113',
    'cvv': '123',
    'expiry': '12/28',
    '3ds_otp': '112233',
  },
  'ovo': {
    'phone_number': '+62 081 2345 678',
    'status': 'sandbox_flow',
  },
  'dana': {
    'status': 'sandbox_flow',
    'simulator_url': 'https://simulator.sandbox.midtrans.com',
  },
};

/// Fake User Data Logged In (Sanctum Token Valid)
Map<String, dynamic> fakeUserLoggedIn() {
  return {
    'user': {
      'id': 100,
      'name': 'Budi Trader',
      'email': 'budi.trader@ricocapital.id',
      'role': 'user',
      'email_verified_at': '2026-01-01T00:00:00.000000Z',
    },
    'token': 'sanctum_token_valid_eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
    'is_logged_in': true,
  };
}

/// Fake User Data Subscribed (Subscription VIP Aktif)
Map<String, dynamic> fakeUserSubscribed() {
  return {
    'user': {
      'id': 101,
      'name': 'Siti VIP Trader',
      'email': 'siti.vip@ricocapital.id',
      'role': 'vip_user',
    },
    'token': 'sanctum_token_vip_active_789xyz...',
    'is_logged_in': true,
    'subscription': {
      'status': 'active',
      'package': {
        'id': 2,
        'name': 'Pro Plan',
        'price': 199000.0,
      },
      'starts_at': '2026-08-01T00:00:00.000000Z',
      'expires_at': '2026-09-01T00:00:00.000000Z',
      'days_remaining': 24,
    },
  };
}

/// Fake User Data Expired (Subscription VIP Kadaluarsa)
Map<String, dynamic> fakeUserExpired() {
  return {
    'user': {
      'id': 102,
      'name': 'Andi Expired Trader',
      'email': 'andi.expired@ricocapital.id',
      'role': 'user',
    },
    'token': 'sanctum_token_expired_abc123...',
    'is_logged_in': true,
    'subscription': {
      'status': 'expired',
      'package': {
        'id': 1,
        'name': 'Starter Plan',
        'price': 99000.0,
      },
      'starts_at': '2026-06-01T00:00:00.000000Z',
      'expires_at': '2026-07-01T00:00:00.000000Z',
      'days_remaining': 0,
    },
  };
}

/// Fake Transaction List dengan Berbagai Status (Settlement, Pending, Expired, Failed)
List<Map<String, dynamic>> fakeTransactionList() {
  return [
    {
      'id': 1001,
      'order_id': 'RC-ORD-2026080101',
      'package_name': 'Pro Plan',
      'amount': 199000,
      'payment_method': 'Bank Transfer (BCA)',
      'status': 'settlement', // Paid & Verified
      'created_at': '2026-08-01 10:30:00',
    },
    {
      'id': 1002,
      'order_id': 'RC-ORD-2026080502',
      'package_name': 'VIP Ultimate',
      'amount': 499000,
      'payment_method': 'GoPay QRIS',
      'status': 'pending', // Menunggu bayar
      'created_at': '2026-08-08 05:45:00',
      'redirect_url': 'https://app.sandbox.midtrans.com/snap/v2/vtweb/snap_token_pending_1002',
    },
    {
      'id': 1003,
      'order_id': 'RC-ORD-2026071503',
      'package_name': 'Starter Plan',
      'amount': 99000,
      'payment_method': 'Credit Card',
      'status': 'expire', // Waktu pembayaran habis
      'created_at': '2026-07-15 14:00:00',
    },
    {
      'id': 1004,
      'order_id': 'RC-ORD-2026071004',
      'package_name': 'Pro Plan',
      'amount': 199000,
      'payment_method': 'OVO',
      'status': 'deny', // Ditolak / Dibatalkan
      'created_at': '2026-07-10 09:15:00',
    },
  ];
}
