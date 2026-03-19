import '../../../../utils/helpers/parser.dart';

/// Bank Info Model
///
/// Model cho thông tin ngân hàng trong payment method
class BankInfo {
  final String id;
  final String? titleEn;
  final String? titleVi;
  final String code;
  final String? contextDefault;
  final bool isDefault;
  final String? accountOwner;
  final String? bankName;
  final String? bankNumber;
  final String? bankCode;
  final String? bankBin;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? methodName;
  final String? bankIdentifier;

  BankInfo({
    required this.id,
    this.titleEn,
    this.titleVi,
    required this.code,
    this.contextDefault,
    required this.isDefault,
    this.accountOwner,
    this.bankName,
    this.bankNumber,
    this.bankCode,
    this.bankBin,
    this.createdAt,
    this.updatedAt,
    this.methodName,
    this.bankIdentifier,
  });

  String get displayName {
    if (methodName != null && (methodName ?? "").isNotEmpty) {
      return methodName!;
    }
    return titleVi ?? titleEn ?? '';
  }

  factory BankInfo.fromMap(Map<String, dynamic> map) {
    return catchErrorOnParseModel<BankInfo>(() {
      return BankInfo(
        id: map['id']?.toString() ?? '',
        titleEn: map['titleEn'],
        titleVi: map['titleVi'],
        code: map['code'] ?? '',
        contextDefault: map['contextDefault'],
        isDefault: map['isDefault'] ?? false,
        accountOwner: map['accountOwner'],
        bankName: map['bankName'],
        bankNumber: map['bankNumber'],
        bankCode: map['bankCode'],
        bankBin: map['bankBin'],
        createdAt: map['createdAt'] != null
            ? DateTime.tryParse(map['createdAt'])
            : null,
        updatedAt: map['updatedAt'] != null
            ? DateTime.tryParse(map['updatedAt'])
            : null,
        methodName: map['methodName'],
        bankIdentifier: map['bankIdentifier'],
      );
    }, map);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titleEn': titleEn,
      'titleVi': titleVi,
      'code': code,
      'contextDefault': contextDefault,
      'isDefault': isDefault,
      'accountOwner': accountOwner,
      'bankName': bankName,
      'bankNumber': bankNumber,
      'bankCode': bankCode,
      'bankBin': bankBin,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'methodName': methodName,
    };
  }
}
