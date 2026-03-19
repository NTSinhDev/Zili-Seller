class CreatedBy {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String avatar;
  final String createdAt;
  final String username;
  final bool isTwoFactorAuthenticationEnabled;
  final bool isTwoFactorAuthenticated;
  final String? position;
  final double amount;
  final String pinCode;
  final String? company;
  final String? role;

  CreatedBy({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.avatar,
    required this.createdAt,
    required this.username,
    required this.isTwoFactorAuthenticationEnabled,
    required this.isTwoFactorAuthenticated,
    this.position,
    required this.amount,
    required this.pinCode,
    this.company,
    this.role,
  });

  factory CreatedBy.fromMap(Map<String, dynamic> map) {
    return CreatedBy(
      id: (map['id'] ?? '').toString(),
      fullName: (map['fullName'] ?? '').toString(),
      email: (map['email'] ?? '').toString(),
      phone: (map['phone'] ?? '').toString(),
      avatar: (map['avatar'] ?? '').toString(),
      createdAt: (map['createdAt'] ?? map['createTime'] ?? '').toString(),
      username: (map['username'] ?? '').toString(),
      isTwoFactorAuthenticationEnabled:
          map['isTwoFactorAuthenticationEnabled'] == true,
      isTwoFactorAuthenticated: map['isTwoFactorAuthenticated'] == true,
      position: map['position']?.toString(),
      amount: _parseDouble(map['amount']),
      pinCode: (map['pinCode'] ?? '').toString(),
      company: map['company']?.toString(),
      role: map['role']?.toString(),
    );
  }

  static double _parseDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}
