import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_colors.dart';
import '../constants/font.dart';
import '../models/payment_model.dart';
import '../repositories/auth_repository.dart';
import '../repositories/payment_repository.dart';
import '../services/token_service.dart';

class RegisterScreen extends StatefulWidget {
  final int? initialPackageId;
  const RegisterScreen({super.key, this.initialPackageId});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _domicileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final AuthRepository _authRepository = AuthRepository();
  final PaymentRepository _paymentRepository = PaymentRepository();
  final TokenService _tokenService = TokenService();

  List<MembershipPackageModel> _packages = [];
  int? _selectedPackageId;
  bool _isLoadingPackages = true;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _fetchPackages();
  }

  Future<void> _fetchPackages() async {
    try {
      final data = await _paymentRepository.getMembershipUpgradeInfo();
      final List<MembershipPackageModel> pkgs = data['packages'] ?? [];
      setState(() {
        _packages = pkgs;
        if (pkgs.isNotEmpty) {
          if (widget.initialPackageId != null && pkgs.any((p) => p.id == widget.initialPackageId)) {
            _selectedPackageId = widget.initialPackageId;
          } else {
            _selectedPackageId = pkgs.first.id;
          }
        }
        _isLoadingPackages = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingPackages = false;
      });
    }
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan lengkapi formulir pendaftaran')),
      );
      return;
    }

    if (_selectedPackageId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih paket membership terlebih dahulu')),
      );
      return;
    }

    final selectedPkg = _packages.firstWhere((p) => p.id == _selectedPackageId);

    setState(() => _isSubmitting = true);

    try {
      final registerRes = await _authRepository.register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        domicile: _domicileController.text.trim(),
        password: _passwordController.text,
        passwordConfirmation: _confirmPasswordController.text,
      );

      if (!registerRes.success || registerRes.token == null) {
        if (mounted) {
          setState(() => _isSubmitting = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(registerRes.message), backgroundColor: Colors.red),
          );
        }
        return;
      }

      await _tokenService.saveToken(registerRes.token!);

      if (!mounted) return;
      setState(() => _isSubmitting = false);

      // Navigate to Payment Checkout Screen
      context.push(
        '/checkout',
        extra: {
          'package': selectedPkg,
          'userName': _nameController.text.trim(),
          'userEmail': _emailController.text.trim(),
          'userPhone': _phoneController.text.trim(),
        },
      );
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _domicileController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo & Header
                const Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.currency_bitcoin, color: AppColors.webRed, size: 32),
                      SizedBox(width: 8),
                      Text('Ricocapital', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Join Ricocapital',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Start your crypto trading journey with us',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textWhite70, fontSize: 14),
                ),
                const SizedBox(height: 28),

                // Package Selection (Radio Cards)
                const Text(
                  'Pilih Paket Membership',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                if (_isLoadingPackages)
                  const Center(child: CircularProgressIndicator(color: AppColors.webRed))
                else if (_packages.isEmpty)
                  const Text('Gagal memuat paket keanggotaan', style: TextStyle(color: Colors.redAccent))
                else
                  ..._packages.map((pkg) => _buildPackageRadioCard(pkg)),

                const SizedBox(height: 24),

                // Form Fields
                _buildTextField(
                  controller: _nameController,
                  label: 'Full Name',
                  hint: 'Enter your full name',
                  icon: Icons.person_outline,
                  validator: (v) => v!.trim().isEmpty ? 'Nama lengkap wajib diisi' : null,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _emailController,
                  label: 'Email Address',
                  hint: 'Enter your email',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => v!.trim().isEmpty || !v.contains('@') ? 'Email tidak valid' : null,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _phoneController,
                  label: 'Phone Number',
                  hint: 'Enter your phone number',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: (v) => v!.trim().isEmpty ? 'Nomor telepon wajib diisi' : null,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _domicileController,
                  label: 'Domicile (City/Region)',
                  hint: 'Enter your city or region',
                  icon: Icons.location_on_outlined,
                  validator: (v) => v!.trim().isEmpty ? 'Domisili wajib diisi' : null,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _passwordController,
                  label: 'Password',
                  hint: 'Create a strong password',
                  icon: Icons.lock_outline,
                  obscureText: true,
                  validator: (v) => v!.length < 8 ? 'Minimal 8 karakter' : null,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _confirmPasswordController,
                  label: 'Confirm Password',
                  hint: 'Confirm your password',
                  icon: Icons.lock_reset_outlined,
                  obscureText: true,
                  validator: (v) => v != _passwordController.text ? 'Password tidak cocok' : null,
                ),
                const SizedBox(height: 20),

                // Terms Card
                InkWell(
                  onTap: () => context.push('/privacy-policy'),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.redAccent.withValues(alpha: 0.2)),
                    ),
                    child: const Text(
                      'By creating an account, you agree to our Terms of Service and Privacy Policy',
                      style: TextStyle(color: AppColors.textWhite70, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Submit Button
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.webRed,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    ),
                    onPressed: _isSubmitting ? null : _handleRegister,
                    child: _isSubmitting
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Create Account',
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
                const SizedBox(height: 20),

                // Back to Login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account? ', style: TextStyle(color: AppColors.textWhite70, fontSize: 14)),
                    GestureDetector(
                      onTap: () => context.go('/login'),
                      child: const Text(
                        'Sign in',
                        style: TextStyle(color: AppColors.webRed, fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPackageRadioCard(MembershipPackageModel pkg) {
    final bool isSelected = _selectedPackageId == pkg.id;
    return GestureDetector(
      onTap: () => setState(() => _selectedPackageId = pkg.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.webRed.withValues(alpha: 0.1) : AppColors.cardDark,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? AppColors.webRed : AppColors.cardBorder, width: isSelected ? 2 : 1),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(pkg.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      if (pkg.price > 1000000)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(10)),
                          child: const Text('Featured', style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(pkg.description, style: const TextStyle(color: AppColors.textWhite70, fontSize: 12)),
                  const SizedBox(height: 8),
                  Text(pkg.formattedPrice, style: const TextStyle(color: AppColors.webRed, fontWeight: FontWeight.bold, fontSize: 16)),
                  Text('Durasi: ${pkg.duration}', style: const TextStyle(color: AppColors.textWhite54, fontSize: 12)),
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? AppColors.webRed : AppColors.textWhite54,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontWeight: AppFontWeights.semiBold, fontSize: 14)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white38, fontSize: 14),
            prefixIcon: Icon(icon, color: AppColors.webRed, size: 20),
            filled: true,
            fillColor: AppColors.cardDark,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.cardBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.webRed),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.redAccent),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.redAccent),
            ),
          ),
        ),
      ],
    );
  }
}
