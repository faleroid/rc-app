import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_colors.dart';
import '../constants/font.dart';
import '../constants/margin.dart';
import '../models/payment_model.dart';
import '../repositories/payment_repository.dart';
import '../widgets/crypto_payment_dialog.dart';

class PaymentCheckoutScreen extends StatefulWidget {
  final MembershipPackageModel package;
  final String userName;
  final String userEmail;
  final String userPhone;

  const PaymentCheckoutScreen({
    super.key,
    required this.package,
    required this.userName,
    required this.userEmail,
    required this.userPhone,
  });

  @override
  State<PaymentCheckoutScreen> createState() => _PaymentCheckoutScreenState();
}

class _PaymentCheckoutScreenState extends State<PaymentCheckoutScreen> {
  final PaymentRepository _repository = PaymentRepository();
  
  // Selected Payment Method Category & Specific Option
  // Categories: 'credit_card', 'bank_transfer', 'e_wallet', 'blockchain'
  String _selectedMethod = 'credit_card';
  String _selectedCrypto = 'usdt'; // 'usdt', 'bitcoin', 'ethereum'
  bool _isLoading = false;

  Future<void> _handlePayment() async {
    if (_selectedMethod == 'blockchain') {
      // Show Crypto QR & Upload Proof Dialog
      final bool? success = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (_) => CryptoPaymentDialog(
          package: widget.package,
          cryptoCurrency: _selectedCrypto,
        ),
      );

      if (success == true && mounted) {
        context.go('/main', extra: {'isLoggedIn': true, 'index': 0});
      }
      return;
    }

    // Midtrans Payment Methods
    setState(() => _isLoading = true);

    try {
      final response = await _repository.createPayment(widget.package.id);

      if (!mounted) return;
      setState(() => _isLoading = false);

      final bool? result = await context.push<bool>(
        '/payment-webview',
        extra: {
          'redirectUrl': response.redirectUrl,
          'paymentId': response.paymentId,
        },
      );

      if (!mounted) return;

      if (result == true) {
        context.go('/main', extra: {'isLoggedIn': true, 'index': 0});
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Pembayaran Membership', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Section
            const Text(
              'Pembayaran Membership',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: AppFontSizes.xl2,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            const Text(
              'Selesaikan pembayaran untuk mengaktifkan membership VIP Anda',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textWhite70,
                fontSize: AppFontSizes.sm,
              ),
            ),
            const SizedBox(height: AppSpacing.xl2),

            // ── TOP SECTION (Left side on desktop, TOP on mobile) ──
            _buildLeftPackageDetailsCard(),

            const SizedBox(height: AppSpacing.xl2),

            // ── BOTTOM SECTION (Right side on desktop, BOTTOM on mobile) ──
            _buildRightPaymentMethodsCard(),

            const SizedBox(height: AppSpacing.xl3),
          ],
        ),
      ),
    );
  }

  /// Top Card: Detail Paket & Detail Pembeli
  Widget _buildLeftPackageDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Detail Paket',
            style: TextStyle(color: Colors.white, fontSize: AppFontSizes.lg, fontWeight: FontWeight.bold),
          ),
          const Text(
            'Ringkasan paket membership yang dipilih',
            style: TextStyle(color: AppColors.textWhite70, fontSize: AppFontSizes.xs),
          ),
          const SizedBox(height: AppSpacing.md),

          // Inner Package Card
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.black38,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: AppColors.cardBorder.withValues(alpha: 0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.package.name,
                  style: const TextStyle(color: Colors.white, fontSize: AppFontSizes.lg, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  widget.package.description,
                  style: const TextStyle(color: AppColors.textWhite70, fontSize: AppFontSizes.xs),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Harga:', style: TextStyle(color: AppColors.textWhite70, fontSize: AppFontSizes.sm)),
                    Text(
                      widget.package.formattedPrice,
                      style: const TextStyle(color: AppColors.webRed, fontSize: AppFontSizes.lg, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Durasi:', style: TextStyle(color: AppColors.textWhite70, fontSize: AppFontSizes.sm)),
                    Text(
                      widget.package.duration,
                      style: const TextStyle(color: Colors.white, fontSize: AppFontSizes.sm, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // Benefits List
          const Text(
            'Benefit yang didapat:',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: AppFontSizes.sm),
          ),
          const SizedBox(height: AppSpacing.xs),
          ...widget.package.benefits.map(
            (benefit) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 3.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('🔴 ', style: TextStyle(fontSize: 10)),
                  Expanded(
                    child: Text(
                      benefit,
                      style: const TextStyle(color: AppColors.textWhite70, fontSize: AppFontSizes.xs),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Divider(color: AppColors.divider, height: AppSpacing.xl2),

          // Detail Pembeli
          const Text(
            'Detail Pembeli:',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: AppFontSizes.sm),
          ),
          const SizedBox(height: AppSpacing.xs),
          _buildBuyerRow('Nama:', widget.userName),
          _buildBuyerRow('Email:', widget.userEmail),
          _buildBuyerRow('Telepon:', widget.userPhone),
        ],
      ),
    );
  }

  Widget _buildBuyerRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textWhite70, fontSize: AppFontSizes.xs)),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white, fontSize: AppFontSizes.xs, fontWeight: AppFontWeights.semiBold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  /// Bottom Card: Metode Pembayaran
  Widget _buildRightPaymentMethodsCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Metode Pembayaran',
            style: TextStyle(color: Colors.white, fontSize: AppFontSizes.lg, fontWeight: FontWeight.bold),
          ),
          const Text(
            'Pilih metode pembayaran yang diinginkan',
            style: TextStyle(color: AppColors.textWhite70, fontSize: AppFontSizes.xs),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Option 1: Credit / Debit Card
          _buildPaymentMethodOption(
            id: 'credit_card',
            icon: Icons.credit_card,
            title: 'Kartu Kredit/Debit',
            subtitle: 'Visa, Mastercard, JCB',
          ),
          const SizedBox(height: AppSpacing.md),

          // Option 2: Bank Transfer
          _buildPaymentMethodOption(
            id: 'bank_transfer',
            icon: Icons.account_balance,
            title: 'Transfer Bank',
            subtitle: 'BCA, BNI, BRI, Mandiri',
          ),
          const SizedBox(height: AppSpacing.md),

          // Option 3: E-Wallet
          _buildPaymentMethodOption(
            id: 'e_wallet',
            icon: Icons.account_balance_wallet,
            title: 'E-Wallet',
            subtitle: 'GoPay, OVO, DANA, ShopeePay',
          ),
          const SizedBox(height: AppSpacing.md),

          // Option 4: Blockchain / Crypto (New Added Option)
          _buildBlockchainPaymentOption(),

          const SizedBox(height: AppSpacing.xl2),

          // Action Button
          SizedBox(
            height: 52,
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.webRed,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
              ),
              onPressed: _isLoading ? null : _handlePayment,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                      'Bayar ${widget.package.formattedPrice}',
                      style: const TextStyle(color: Colors.white, fontSize: AppFontSizes.md, fontWeight: FontWeight.bold),
                    ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Center(
            child: Text(
              _selectedMethod == 'blockchain'
                  ? 'Pembayaran dilindungi oleh verifikasi Blockchain & Admin'
                  : 'Pembayaran dilindungi oleh Midtrans\nData pembayaran Anda aman dan terenkripsi',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textWhite54, fontSize: AppFontSizes.xs),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodOption({
    required String id,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final bool isSelected = _selectedMethod == id;
    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = id),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.webRed.withValues(alpha: 0.1) : Colors.black26,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: isSelected ? AppColors.webRed : AppColors.cardBorder),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? AppColors.webRed : Colors.white70),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  Text(subtitle, style: const TextStyle(color: AppColors.textWhite70, fontSize: AppFontSizes.xs)),
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

  Widget _buildBlockchainPaymentOption() {
    final bool isSelected = _selectedMethod == 'blockchain';
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? AppColors.webRed.withValues(alpha: 0.1) : Colors.black26,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: isSelected ? AppColors.webRed : AppColors.cardBorder),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => setState(() => _selectedMethod = 'blockchain'),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Icon(Icons.currency_bitcoin, color: isSelected ? AppColors.webRed : Colors.white70),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Bayar Pakai Blockchain (Crypto)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        const Text('USDT, Bitcoin, Ethereum', style: TextStyle(color: AppColors.textWhite70, fontSize: AppFontSizes.xs)),
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
          ),
          if (isSelected) ...[
            const Divider(color: AppColors.divider, height: 1),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Pilih Koin Crypto:', style: TextStyle(color: AppColors.textWhite70, fontSize: AppFontSizes.xs)),
                  const SizedBox(height: AppSpacing.xs),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildCryptoChip('usdt', 'USDT (TRC-20)'),
                        const SizedBox(width: 8),
                        _buildCryptoChip('usdt_bep20', 'USDT (BEP-20)'),
                        const SizedBox(width: 8),
                        _buildCryptoChip('bitcoin', 'Bitcoin'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCryptoChip(String id, String label) {
    final bool isChipSelected = _selectedCrypto == id;
    return ChoiceChip(
      label: Text(label),
      selected: isChipSelected,
      onSelected: (val) {
        if (val) setState(() => _selectedCrypto = id);
      },
      selectedColor: AppColors.webRed,
      backgroundColor: Colors.black45,
      labelStyle: TextStyle(
        color: isChipSelected ? Colors.white : AppColors.textWhite70,
        fontWeight: isChipSelected ? FontWeight.bold : FontWeight.normal,
        fontSize: 12,
      ),
    );
  }
}
