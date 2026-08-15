import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../constants/app_colors.dart';
import '../constants/font.dart';
import '../constants/margin.dart';
import '../constants/crypto_wallets.dart';
import '../models/payment_model.dart';
import '../repositories/payment_repository.dart';

class CryptoPaymentDialog extends StatefulWidget {
  final MembershipPackageModel package;
  final String cryptoCurrency; // 'usdt', 'bitcoin', 'ethereum'

  const CryptoPaymentDialog({
    super.key,
    required this.package,
    required this.cryptoCurrency,
  });

  @override
  State<CryptoPaymentDialog> createState() => _CryptoPaymentDialogState();
}

class _CryptoPaymentDialogState extends State<CryptoPaymentDialog> {
  final PaymentRepository _repository = PaymentRepository();
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  bool _isUploading = false;

  String get _walletAddress {
    switch (widget.cryptoCurrency.toLowerCase()) {
      case 'bitcoin':
        return CryptoWallets.bitcoinAddress;
      case 'usdt_bep20':
      case 'bep20':
      case 'ethereum':
        return CryptoWallets.usdtBep20Address;
      case 'usdt':
      case 'usdt_trc20':
      case 'trc20':
      default:
        return CryptoWallets.usdtTrc20Address;
    }
  }

  String get _walletNetwork {
    switch (widget.cryptoCurrency.toLowerCase()) {
      case 'bitcoin':
        return CryptoWallets.bitcoinNetwork;
      case 'usdt_bep20':
      case 'bep20':
      case 'ethereum':
        return CryptoWallets.usdtBep20Network;
      case 'usdt':
      case 'usdt_trc20':
      case 'trc20':
      default:
        return CryptoWallets.usdtTrc20Network;
    }
  }

  String get _cryptoTitle {
    switch (widget.cryptoCurrency.toLowerCase()) {
      case 'bitcoin':
        return 'Bitcoin (BTC)';
      case 'usdt_bep20':
      case 'bep20':
      case 'ethereum':
        return 'USDT (BEP-20)';
      case 'usdt':
      case 'usdt_trc20':
      case 'trc20':
      default:
        return 'USDT (TRC-20)';
    }
  }

  String get _qrAssetPath {
    switch (widget.cryptoCurrency.toLowerCase()) {
      case 'bitcoin':
        return CryptoWallets.bitcoinQrAsset;
      case 'usdt_bep20':
      case 'bep20':
      case 'ethereum':
        return CryptoWallets.usdtBep20QrAsset;
      case 'usdt':
      case 'usdt_trc20':
      case 'trc20':
      default:
        return CryptoWallets.usdtTrc20QrAsset;
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memilih gambar: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _uploadProof() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan pilih foto bukti transfer terlebih dahulu'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isUploading = true);

    try {
      final result = await _repository.uploadCryptoPaymentProof(
        packageId: widget.package.id,
        cryptoCurrency: widget.cryptoCurrency,
        imageFile: _selectedImage!,
      );

      if (!mounted) return;
      setState(() => _isUploading = false);

      Navigator.of(context).pop(true); // Return true on success

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: AppColors.cardDark,
          title: const Text('Bukti Terkirim!', style: TextStyle(color: Colors.white)),
          content: Text(
            result['message'] ??
                'Bukti pembayaran berhasil diunggah! Keanggotaan VIP Anda akan diaktifkan setelah diverifikasi oleh Admin.',
            style: const TextStyle(color: AppColors.textWhite70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('OK', style: TextStyle(color: AppColors.webRed)),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isUploading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.cardDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.cardBorder),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Pembayaran Blockchain',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: AppFontSizes.lg,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white70),
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                ],
              ),
              const Divider(color: AppColors.divider),
              const SizedBox(height: AppSpacing.sm),

              // Coin Info Banner
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.redAccent.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _cryptoTitle,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Jaringan: $_walletNetwork',
                      style: const TextStyle(color: AppColors.textWhite70, fontSize: AppFontSizes.xs),
                    ),
                    Text(
                      'Total: ${widget.package.formattedPrice}',
                      style: const TextStyle(color: AppColors.webRed, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              // QR Code Image Asset
              Center(
                child: Container(
                  width: 180,
                  height: 180,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      _qrAssetPath,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.qr_code_2, size: 100, color: Colors.black),
                          Text(
                            _cryptoTitle,
                            style: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              // Wallet Address
              const Text(
                'Alamat Wallet Transfer:',
                style: TextStyle(color: AppColors.textWhite70, fontSize: AppFontSizes.xs),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _walletAddress,
                        style: const TextStyle(color: Colors.white, fontSize: 11, fontFamily: 'monospace'),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy, color: AppColors.webRed, size: 18),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: _walletAddress));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Alamat wallet berhasil disalin!')),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Upload Proof Section
              const Text(
                'Upload Bukti Transfer:',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSpacing.xs),

              if (_selectedImage != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(_selectedImage!, height: 140, width: double.infinity, fit: BoxFit.cover),
                ),
                const SizedBox(height: 8),
              ],

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: AppColors.cardBorder),
                      ),
                      onPressed: () => _pickImage(ImageSource.gallery),
                      icon: const Icon(Icons.photo_library, size: 18),
                      label: const Text('Galeri', style: TextStyle(fontSize: 12)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: AppColors.cardBorder),
                      ),
                      onPressed: () => _pickImage(ImageSource.camera),
                      icon: const Icon(Icons.camera_alt, size: 18),
                      label: const Text('Kamera', style: TextStyle(fontSize: 12)),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.lg),

              // Submit Button
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.webRed,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: _isUploading ? null : _uploadProof,
                  child: _isUploading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text(
                          'Kirim Bukti Pembayaran',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
