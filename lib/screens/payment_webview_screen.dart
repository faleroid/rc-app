import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:go_router/go_router.dart';
import '../repositories/payment_repository.dart';
import '../constants/app_colors.dart';
import '../constants/margin.dart';

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
      ..setBackgroundColor(AppColors.background)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) => setState(() => _isLoading = true),
          onPageFinished: (url) => setState(() => _isLoading = false),
          onNavigationRequest: (NavigationRequest request) {
            final url = request.url;
            // Deteksi endpoint sukses/selesai dari Midtrans atau Backend
            if (url.contains('/finish') || url.contains('/check-status')) {
              _handlePaymentResult(true, "Pembayaran Berhasil!");
              return NavigationDecision.prevent;
            }
            
            if (url.contains('/unfinish')) {
              _handlePaymentResult(false, "Pembayaran Belum Selesai");
              return NavigationDecision.prevent;
            }

            if (url.contains('/error')) {
              _handlePaymentResult(false, "Terjadi Kesalahan Pembayaran");
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.redirectUrl));
  }

  Future<void> _handlePaymentResult(bool isSuccess, String message) async {
    if (!mounted) return;
    
    if (!isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.orange),
      );
    }
    
    context.pop(isSuccess); // Tutup dengan membawa status keberhasilan
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.cardDark,
        title: const Text('Pembayaran VIP'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(false), // User menutup manual (exit)
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(color: AppColors.webRed),
            ),
        ],
      ),
    );
  }
}
