# TODO List Integrasi Payment & Membership (Flutter - Rico Capital)

Dokumen ini berisi panduan langkah demi langkah secara rinci untuk mengintegrasikan aplikasi Flutter (`rc-app`) dengan Laravel Backend (`ricocapital`) untuk fitur autentikasi, pemilihan paket membership, dan pembayaran via Midtrans Snap.

---

## 📌 Phase 1: Konfigurasi Environment & Network Base Service

- [ ] **1.1 Sesuaikan Base URL di `lib/services/api_service.dart`**
  - Pastikan IP target menunjuk ke alamat backend Laravel yang aktif:
    - Android Emulator: `http://10.0.2.2:8000/api`
    - iOS Simulator: `http://127.0.0.1:8000/api`
    - HP Fisik / Wi-Fi: `http://<IP_LAPTOP_ANDA>:8000/api` (contoh: `http://192.168.1.7:8000/api`)
  - Pastikan Header `Accept: application/json` dan `Authorization: Bearer <TOKEN>` sudah terpasang dengan benar pada Interceptor Dio.

---

## 📦 Phase 2: Pembuatan Model Data (`lib/models/`)

- [ ] **2.1 Buat File `lib/models/payment_model.dart`**
  Model ini digunakan untuk mengolah data respons dari endpoint backend:
  - `MembershipPackageModel`: Parsing data paket (`id`, `name`, `description`, `price`, `formatted_price`, `duration`, `benefits`).
  - `PaymentStoreResponse`: Parsing respons checkout (`payment_id`, `snap_token`, `redirect_url`).
  - `PaymentStatusResponse`: Parsing hasil cek status (`payment_id`, `status`, `user`, `membership_package`).

  *Contoh Struktur Code:*
  ```dart
  class MembershipPackageModel {
    final int id;
    final String name;
    final String description;
    final double price;
    final String formattedPrice;
    final String duration;
    final List<String> benefits;

    MembershipPackageModel({
      required this.id,
      required this.name,
      required this.description,
      required this.price,
      required this.formattedPrice,
      required this.duration,
      required this.benefits,
    });

    factory MembershipPackageModel.fromJson(Map<String, dynamic> json) {
      return MembershipPackageModel(
        id: json['id'],
        name: json['name'] ?? '',
        description: json['description'] ?? '',
        price: (json['price'] as num).toDouble(),
        formattedPrice: json['formatted_price'] ?? '',
        duration: json['duration'] ?? '',
        benefits: List<String>.from(json['benefits'] ?? []),
      );
    }
  }

  class PaymentStoreResponse {
    final int paymentId;
    final String snapToken;
    final String redirectUrl;

    PaymentStoreResponse({
      required this.paymentId,
      required this.snapToken,
      required this.redirectUrl,
    });

    factory PaymentStoreResponse.fromJson(Map<String, dynamic> json) {
      return PaymentStoreResponse(
        paymentId: json['payment_id'],
        snapToken: json['snap_token'] ?? '',
        redirectUrl: json['redirect_url'] ?? '',
      );
    }
  }
  ```

---

## 🛠️ Phase 3: Pembuatan Payment Repository (`lib/repositories/`)

- [ ] **3.1 Buat File `lib/repositories/payment_repository.dart`**
  Repository ini menghubungkan Flutter dengan endpoint API Backend Laravel:
  - `getPackages()` ➔ Memanggil `GET /membership/upgrade`
  - `createPayment(int packageId, String paymentMethod)` ➔ Memanggil `POST /payment/{packageId}/store`
  - `checkStatus(int paymentId)` ➔ Memanggil `GET /payment/{paymentId}/check-status`

  *Contoh Struktur Code:*
  ```dart
  import 'package:dio/dio.dart';
  import '../services/api_service.dart';
  import '../models/payment_model.dart';

  class PaymentRepository {
    final ApiService _apiService = ApiService();

    // 1. Ambil daftar paket membership
    Future<List<MembershipPackageModel>> getPackages() async {
      try {
        final response = await _apiService.dio.get('/membership/upgrade');
        if (response.statusCode == 200) {
          final List data = response.data['packages'] ?? [];
          return data.map((json) => MembershipPackageModel.fromJson(json)).toList();
        }
        return [];
      } on DioException catch (e) {
        throw Exception(e.response?.data['message'] ?? 'Gagal mengambil paket');
      }
    }

    // 2. Buat pembayaran Midtrans Snap
    Future<PaymentStoreResponse> createPayment(int packageId, String paymentMethod) async {
      try {
        final response = await _apiService.dio.post(
          '/payment/$packageId/store',
          data: {'payment_method': paymentMethod},
        );
        return PaymentStoreResponse.fromJson(response.data);
      } on DioException catch (e) {
        throw Exception(e.response?.data['message'] ?? 'Gagal memproses pembayaran');
      }
    }

    // 3. Cek & sinkronkan status pembayaran
    Future<Map<String, dynamic>> checkStatus(int paymentId) async {
      try {
        final response = await _apiService.dio.get('/payment/$paymentId/check-status');
        return response.data;
      } on DioException catch (e) {
        throw Exception(e.response?.data['message'] ?? 'Gagal memverifikasi status');
      }
    }
  }
  ```

---

## 🌐 Phase 4: Halaman Webview Midtrans (`lib/screens/`)

- [ ] **4.1 Buat File `lib/screens/payment_webview_screen.dart`**
  Halaman ini menggunakan `webview_flutter` untuk membuka `redirectUrl` dari Midtrans Snap.
  - Memantau navigasi URL (`NavigationDelegate`).
  - Menutup Webview saat terdeteksi URL Callback (`/finish`, `/unfinish`, `/error`, atau `/check-status`).
  - Memanggil `checkStatus()` dan menampilkan `AlertDialog` hasil status pembayaran.

  *Contoh Struktur Code:*
  ```dart
  import 'package:flutter/material.dart';
  import 'package:webview_flutter/webview_flutter.dart';
  import 'package:go_router/go_router.dart';
  import '../repositories/payment_repository.dart';

  class PaymentWebviewScreen extends StatefulWidget {
    final String redirectUrl;
    final int paymentId;

    const PaymentWebviewScreen({
      super.key,
      required this.redirectUrl,
      required this.paymentId,
    });

    @override
    State<PaymentWebviewScreen> createState() => _PaymentWebviewScreenState();
  }

  class _PaymentWebviewScreenState extends State<PaymentWebviewScreen> {
    late final WebViewController _controller;
    final PaymentRepository _repository = PaymentRepository();
    bool _isLoading = true;

    @override
    void initState() {
      super.initState();
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageFinished: (url) {
              setState(() => _isLoading = false);
            },
            onNavigationRequest: (NavigationRequest request) {
              final url = request.url;
              // Deteksi URL redirect dari Midtrans / Backend
              if (url.contains('/finish') || url.contains('/check-status')) {
                _handlePaymentFinished();
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
          ),
        )
        ..loadRequest(Uri.parse(widget.redirectUrl));
    }

    Future<void> _handlePaymentFinished() async {
      context.pop(); // Tutup Webview
      
      // Tampilkan indikator loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      try {
        final result = await _repository.checkStatus(widget.paymentId);
        Navigator.pop(context); // Tutup loading

        final status = result['payment']?['status'] ?? 'pending';
        
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(status == 'paid' || status == 'success' ? 'Pembayaran Berhasil 🎉' : 'Status Pembayaran'),
            content: Text(status == 'paid' || status == 'success' 
              ? 'Selamat! Akun VIP Anda telah aktif.' 
              : 'Status pembayaran Anda saat ini: $status'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.go('/main', extra: {'isLoggedIn': true, 'index': 0});
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } catch (e) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: const Text('Pembayaran Midtrans')),
        body: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_isLoading) const Center(child: CircularProgressIndicator()),
          ],
        ),
      );
    }
  }
  ```

---

## 🎨 Phase 5: Integrasi UI Paket Membership (`lib/screens/package.dart`)

- [ ] **5.1 Perbarui `lib/screens/package.dart`**
  - Ubah dari data *hardcoded* (Ethereum & Bitcoin) menjadi data dinamis dari `PaymentRepository.getPackages()`.
  - Pada event `onTap` di `PricingCard`, jalankan fungsi checkout `createPayment()`.
  - Buka `PaymentWebviewScreen` dengan melempar `redirectUrl` & `paymentId`.

---

## 🚦 Phase 6: Pendaftaran Route pada GoRouter (`lib/router/app_router.dart`)

- [ ] **6.1 Daftarkan Route `/payment-webview` di `lib/router/app_router.dart`**
  ```dart
  GoRoute(
    path: '/payment-webview',
    builder: (context, state) {
      final extraData = state.extra as Map<String, dynamic>;
      return PaymentWebviewScreen(
        redirectUrl: extraData['redirectUrl'],
        paymentId: extraData['paymentId'],
      );
    },
  ),
  ```

---

## 🧪 Phase 7: Pengujian Alur Pembayaran (Testing & Verification)

- [ ] **7.1 Uji Coba Transaksi via Midtrans Sandbox**
  1. Login ke aplikasi Flutter.
  2. Buka Tab Paket Membership ➔ Pilih salah satu paket (misal: Pro Plan).
  3. Pastikan Webview Midtrans Snap terbuka dengan sempurna.
  4. Pilih metode pembayaran (misal: Bank Transfer BNI / QRIS / Permata).
  5. Selesaikan pembayaran di Simulator Midtrans Sandbox (`https://simulator.sandbox.midtrans.com`).
  6. Kembali ke aplikasi / klik selesaikan ➔ Pastikan Webview tertutup otomatis dan dialog sukses tampil.
  7. Buka Halaman Profile di aplikasi ➔ Pastikan badge status berubah menjadi **VIP Member** dan masa berlaku terupdate.
