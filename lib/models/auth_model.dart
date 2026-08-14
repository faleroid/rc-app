class UserModel {
  final int id;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? domicile;
  final String role;
  final String status;
  final DateTime? membershipExpiresAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.domicile,
    required this.role,
    required this.status,
    this.membershipExpiresAt,
  });

  bool get isActive {
    if (role == 'admin') return true;
    if (status != 'active') return false;
    if (membershipExpiresAt == null) return false;
    return membershipExpiresAt!.isAfter(DateTime.now());
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'],
      domicile: json['domicile'],
      role: json['role'] ?? 'user',
      status: json['status'] ?? 'inactive',
      membershipExpiresAt: json['membership_expires_at'] != null
          ? DateTime.parse(json['membership_expires_at'])
          : null,
    );
  }
}

class AuthResponse {
  final bool success;
  final String message;
  final UserModel? data;
  final String? token;

  AuthResponse({
    required this.success,
    required this.message,
    this.data,
    this.token,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? UserModel.fromJson(json['data']) : null,
      token: json['token'],
    );
  }
}
