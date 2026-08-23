import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/font.dart';
import '../constants/margin.dart';
import '../constants/app_colors.dart';
import '../widgets/pricing_card.dart';
import '../repositories/payment_repository.dart';
import '../repositories/auth_repository.dart';
import '../models/payment_model.dart';
import '../services/token_service.dart';

class PackagePage extends StatefulWidget {
  final VoidCallback? onNavigateToPricing;
  const PackagePage({
    super.key,
    this.onNavigateToPricing,
  });

  @override
  State<PackagePage> createState() => _PackagePageState();
}

class _PackagePageState extends State<PackagePage> {
  final PaymentRepository _repository = PaymentRepository();
  final AuthRepository _authRepository = AuthRepository();
  final TokenService _tokenService = TokenService();
  final _storage = const FlutterSecureStorage();
  
  bool _isLoading = true;
  bool _isLoggedIn = false;
  String? _errorMessage;
  
  List<MembershipPackageModel> _packages = [];
  CurrentMembershipModel? _currentMembership;

  // Form Registration
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _domicileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Countdown Logic
  Timer? _countdownTimer;
  Timer? _pollingTimer; // Untuk background polling
  int _secondsRemaining = 0;
  int? _activePaymentId;
  String? _activeRedirectUrl;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    await _checkLoginStatus();
    await _fetchData();
    await _checkPersistedCountdown();
  }

  Future<void> _checkLoginStatus() async {
    final token = await _tokenService.getToken();
    setState(() {
      _isLoggedIn = token != null;
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _pollingTimer?.cancel();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _domicileController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _checkPersistedCountdown() async {
    final endTimeStr = await _storage.read(key: 'payment_countdown_end');
    final paymentIdStr = await _storage.read(key: 'payment_active_id');
    final redirectUrl = await _storage.read(key: 'payment_redirect_url');

    if (endTimeStr != null && paymentIdStr != null && redirectUrl != null) {
      final endTime = DateTime.parse(endTimeStr);
      final now = DateTime.now();
      final diff = endTime.difference(now).inSeconds;

      if (diff > 0) {
        _activePaymentId = int.parse(paymentIdStr);
        _activeRedirectUrl = redirectUrl;
        _startCountdown(int.parse(paymentIdStr), redirectUrl, seconds: diff);
      } else {
        await _clearPersistedCountdown();
      }
    }
  }

  Future<void> _persistCountdown(int paymentId, String redirectUrl, int duration) async {
    final endTime = DateTime.now().add(Duration(seconds: duration));
    await _storage.write(key: 'payment_countdown_end', value: endTime.toIso8601String());
    await _storage.write(key: 'payment_active_id', value: paymentId.toString());
    await _storage.write(key: 'payment_redirect_url', value: redirectUrl);
  }

  Future<void> _clearPersistedCountdown() async {
    await _storage.delete(key: 'payment_countdown_end');
    await _storage.delete(key: 'payment_active_id');
    await _storage.delete(key: 'payment_redirect_url');
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await _repository.getMembershipUpgradeInfo();
      setState(() {
        _packages = result['packages'];
        _currentMembership = result['currentMembership'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _startCountdown(int paymentId, String redirectUrl, {int seconds = 600}) {
    _countdownTimer?.cancel();
    _pollingTimer?.cancel();
    
    setState(() {
      _activePaymentId = paymentId;
      _activeRedirectUrl = redirectUrl;
      _secondsRemaining = seconds;
    });

    if (seconds == 600) {
       _persistCountdown(paymentId, redirectUrl, seconds);
    }

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        if (mounted) setState(() => _secondsRemaining--);
      } else {
        _stopCountdown();
      }
    });

    // Background Polling setiap 30 detik
    _pollingTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _verifyPaymentSilently(paymentId);
    });
  }

  Future<void> _stopCountdown() {
    _countdownTimer?.cancel();
    _pollingTimer?.cancel();
    if (mounted) {
      setState(() {
        _secondsRemaining = 0;
        _activePaymentId = null;
        _activeRedirectUrl = null;
      });
    }
    return _clearPersistedCountdown();
  }

  /// Verifikasi tanpa dialog (untuk polling)
  Future<void> _verifyPaymentSilently(int paymentId) async {
    try {
      final status = await _repository.checkPaymentStatus(paymentId);
      final String paymentStatus = status['payment']['status'];
      
      if (paymentStatus == 'success' || paymentStatus == 'paid') {
        _stopCountdown();
        if (mounted) {
          _showSuccessDialog();
          _fetchData();
        }
      }
    } catch (_) {
      // Ignore polling errors
    }
  }

  Future<void> _handlePayment(MembershipPackageModel package) async {
    if (!_isLoggedIn) {
      // Direct guest users to Login Screen
      context.push('/login');
    } else {
      // Member logged in: check active package
      if (_currentMembership?.package['id'] == package.id) {
        _showInfoDialog(
          "Paket Aktif",
          "Anda sudah memiliki paket ${package.name} yang aktif hingga ${_currentMembership?.expiresAt ?? '-'}.",
        );
        return;
      }

      // Navigate to Payment Checkout Screen
      context.push(
        '/checkout',
        extra: {
          'package': package,
          'userName': 'Member',
          'userEmail': 'member@ricocapital.id',
          'userPhone': '-',
        },
      );
    }
  }

  void _openPaymentWebview(PaymentStoreResponse response) async {
    final bool? result = await context.push<bool>(
      '/payment-webview',
      extra: {
        'redirectUrl': response.redirectUrl,
        'paymentId': response.paymentId,
      },
    );

    if (result != true) {
      _startCountdown(response.paymentId, response.redirectUrl);
    } else {
      // Jika sukses (webview memanggil finish)
      _verifyPayment(response.paymentId);
    }
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator(color: AppColors.webRed)),
    );
  }

  Future<void> _verifyPayment(int paymentId) async {
    _showLoadingDialog();
    try {
      final status = await _repository.checkPaymentStatus(paymentId);
      if (!mounted) return;
      context.pop(); // Tutup loading

      final String paymentStatus = status['payment']['status'];
      
      if (paymentStatus == 'success' || paymentStatus == 'paid') {
        _stopCountdown();
        _showSuccessDialog();
        _fetchData(); // Refresh data membership
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Status Pembayaran: $paymentStatus")),
        );
      }
    } catch (e) {
      if (mounted) context.pop();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        title: const Text("Berhasil!", style: TextStyle(color: Colors.white)),
        content: const Text(
          "Pembayaran Anda telah diverifikasi. Akun VIP Anda kini aktif.",
          style: TextStyle(color: AppColors.textWhite70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("OK", style: TextStyle(color: AppColors.webRed)),
          )
        ],
      ),
    );
  }

  void _showInfoDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        title: Text(title, style: const TextStyle(color: Colors.white)),
        content: Text(content, style: const TextStyle(color: AppColors.textWhite70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Tutup", style: TextStyle(color: AppColors.webRed)),
          )
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }

  String _formatTime(int seconds) {
    final m = (seconds / 60).floor();
    final s = seconds % 60;
    return "${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.xl,
        ),
        child: Column(
          children: [
            const Text(
              "Pilih Paket Yang Tepat Untuk Anda",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textWhite,
                fontSize: AppFontSizes.xl2,
                fontFamily: AppFonts.display,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            const Text(
              "Bergabunglah dengan ribuan trader sukses dan mulai perjalanan trading crypto Anda hari ini",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textWhite70,
                fontSize: AppFontSizes.sm,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Container(
              width: 80,
              height: 3,
              decoration: BoxDecoration(
                color: AppColors.webRed,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            if (_secondsRemaining > 0) ...[
              const SizedBox(height: AppSpacing.xl),
              _buildCountdownBanner(),
            ],

            const SizedBox(height: AppSpacing.xl2),

            if (_isLoading)
              _buildSkeleton()
            else if (_errorMessage != null)
              _buildError()
            else
              ..._packages.map((package) {
                // Member Logic: Disable lower tiers
                bool isActive = false;
                bool isLowerTier = false;
                bool isUpgrade = false;

                if (_isLoggedIn && _currentMembership != null) {
                  final activePackageId = _currentMembership!.package['id'];
                  final activePrice = _currentMembership!.package['price'] ?? 0;
                  
                  isActive = activePackageId == package.id;
                  isLowerTier = package.price <= activePrice && !isActive;
                  isUpgrade = package.price > activePrice;
                }
                
                final bool isDisabled = isActive || isLowerTier;

                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xl),
                  child: PricingCard(
                    name: package.name,
                    price: package.formattedPrice,
                    originalPrice: package.formattedOriginalPrice ?? "",
                    discountLabel: "Hemat ${((1 - (package.price / (package.originalPrice ?? package.price))) * 100).round()}%",
                    period: package.duration,
                    description: package.description,
                    benefits: package.benefits,
                    disabledBenefits: const [],
                    btnLabel: isActive 
                        ? "Paket Aktif" 
                        : (isLowerTier ? "Sudah di ambil" : (isUpgrade ? "Upgrade Paket" : (_isLoggedIn ? "Pilih ${package.name}" : "Pilih & Daftar"))),
                    gradient: const LinearGradient(
                      colors: [AppColors.webOrangeStart, AppColors.webOrangeEnd],
                    ),
                    onTap: isDisabled ? null : () => _handlePayment(package),
                  ),
                );
              }),

            if (!_isLoggedIn) ...[
              const SizedBox(height: AppSpacing.xl2),
              const Divider(color: AppColors.divider),
              const SizedBox(height: AppSpacing.xl2),
              _buildRegistrationForm(),
            ],
            
            const SizedBox(height: AppSpacing.xl3),
          ],
        ),
      ),
    );
  }

  Widget _buildRegistrationForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Belum Punya Akun? Daftar Sekarang",
            style: TextStyle(
              color: Colors.white,
              fontSize: AppFontSizes.xl,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          const Text(
            "Lengkapi data diri Anda untuk membuat akun dan melanjutkan pembayaran.",
            style: TextStyle(color: AppColors.textWhite70, fontSize: AppFontSizes.sm),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl2),
          
          _buildTextField(
            controller: _nameController,
            label: "Full Name",
            icon: Icons.person_outline,
            validator: (v) => v!.isEmpty ? "Nama lengkap wajib diisi" : null,
          ),
          const SizedBox(height: AppSpacing.md),
          _buildTextField(
            controller: _emailController,
            label: "Email Address",
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (v) => v!.isEmpty || !v.contains('@') ? "Email tidak valid" : null,
          ),
          const SizedBox(height: AppSpacing.md),
          _buildTextField(
            controller: _phoneController,
            label: "Phone Number",
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            validator: (v) => v!.isEmpty ? "Nomor telepon wajib diisi" : null,
          ),
          const SizedBox(height: AppSpacing.md),
          _buildTextField(
            controller: _domicileController,
            label: "Domicile (City/Region)",
            icon: Icons.location_on_outlined,
            validator: (v) => v!.isEmpty ? "Domisili wajib diisi" : null,
          ),
          const SizedBox(height: AppSpacing.md),
          _buildTextField(
            controller: _passwordController,
            label: "Password",
            icon: Icons.lock_outline,
            obscureText: true,
            validator: (v) => v!.length < 8 ? "Minimal 8 karakter" : null,
          ),
          const SizedBox(height: AppSpacing.md),
          _buildTextField(
            controller: _confirmPasswordController,
            label: "Confirm Password",
            icon: Icons.lock_reset_outlined,
            obscureText: true,
            validator: (v) => v != _passwordController.text ? "Password tidak cocok" : null,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: AppColors.webRed),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.webRed),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        filled: true,
        fillColor: AppColors.cardDark,
      ),
    );
  }

  Widget _buildCountdownBanner() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.webRed.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.webRed.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.timer_outlined, color: AppColors.webRed),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Menunggu Pembayaran",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Selesaikan pembayaran dalam ${_formatTime(_secondsRemaining)}",
                  style: const TextStyle(color: AppColors.textWhite70, fontSize: 12),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () async {
              if (_activeRedirectUrl != null && _activePaymentId != null) {
                final bool? result = await context.push<bool>(
                  '/payment-webview',
                  extra: {
                    'redirectUrl': _activeRedirectUrl,
                    'paymentId': _activePaymentId,
                  },
                );
                if (result == true) {
                  _verifyPayment(_activePaymentId!);
                }
              }
            },
            child: const Text("Lanjut", style: TextStyle(color: AppColors.webRed, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeleton() {
    return Column(
      children: List.generate(2, (index) => 
        Container(
          height: 300,
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: AppSpacing.xl),
          decoration: BoxDecoration(
            color: AppColors.cardDark.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: const Center(child: CircularProgressIndicator(color: AppColors.textWhite30)),
        ),
      ),
    );
  }

  Widget _buildError() {
    return Column(
      children: [
        const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
        const SizedBox(height: AppSpacing.md),
        Text(
          _errorMessage ?? "Gagal memuat paket",
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.textWhite70),
        ),
        TextButton(
          onPressed: _fetchData,
          child: const Text("Coba Lagi", style: TextStyle(color: AppColors.webRed)),
        ),
      ],
    );
  }
}
