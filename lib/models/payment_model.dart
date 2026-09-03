class MembershipPackageModel {
  final int id;
  final String name;
  final String description;
  final double price;
  final double? originalPrice;
  final String formattedPrice;
  final String? formattedOriginalPrice;
  final String duration;
  final int durationDays;
  final List<String> benefits;
  final bool isFeatured;
  final bool isBestSeller;

  MembershipPackageModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    required this.formattedPrice,
    this.formattedOriginalPrice,
    required this.duration,
    required this.durationDays,
    required this.benefits,
    this.isFeatured = false,
    this.isBestSeller = false,
  });

  factory MembershipPackageModel.fromJson(Map<String, dynamic> json) {
    // Robust parsing for benefits
    List<String> parsedBenefits = [];
    final rawBenefits = json['benefits'];
    
    if (rawBenefits is List) {
      parsedBenefits = List<String>.from(rawBenefits);
    }

        final durationDays = (json['duration_days'] as num?)?.toInt() ?? 0;
        final rawDuration = json['duration']?.toString().trim() ?? '';
        final duration = rawDuration.isNotEmpty
        ? rawDuration
        : durationDays > 0
        ? (durationDays >= 30
          ? (durationDays == 30
            ? '1 bulan'
            : '${(durationDays / 30).round()} bulan')
          : '$durationDays hari')
        : 'selamanya';

    return MembershipPackageModel(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num).toDouble(),
      originalPrice: json['original_price'] != null ? (json['original_price'] as num).toDouble() : null,
      formattedPrice: json['formatted_price'] ?? '',
      formattedOriginalPrice: json['formatted_original_price'],
      duration: duration,
      durationDays: durationDays,
      benefits: parsedBenefits,
      isFeatured: json['is_featured'] ?? false,
      isBestSeller: json['is_best_seller'] ?? false,
    );
  }
}

class CurrentMembershipModel {
  final Map<String, dynamic> package;
  final String? expiresAt;
  final int daysRemaining;
  final bool isExpiringSoon;

  CurrentMembershipModel({
    required this.package,
    this.expiresAt,
    required this.daysRemaining,
    required this.isExpiringSoon,
  });

  factory CurrentMembershipModel.fromJson(Map<String, dynamic> json) {
    return CurrentMembershipModel(
      package: json['package'] ?? {},
      expiresAt: json['expires_at'],
      daysRemaining: json['days_remaining'] ?? 0,
      isExpiringSoon: json['is_expiring_soon'] ?? false,
    );
  }
}

class PaymentStoreResponse {
  final int paymentId;
  final String snapToken;
  final String redirectUrl;
  final Map<String, dynamic> package;

  PaymentStoreResponse({
    required this.paymentId,
    required this.snapToken,
    required this.redirectUrl,
    required this.package,
  });

  factory PaymentStoreResponse.fromJson(Map<String, dynamic> json) {
    return PaymentStoreResponse(
      paymentId: json['payment_id'],
      snapToken: json['snap_token'] ?? '',
      redirectUrl: json['redirect_url'] ?? '',
      package: json['package'] ?? {},
    );
  }
}
