import 'package:zili_coffee/data/models/order/payment_detail/seller_payment_method.dart';

/// Extension để render payment method name
extension PaymentMethodNameExtension on SellerPaymentMethod {
  /// Render payment method name theo logic JavaScript
  /// 
  /// Logic tương tự renderPaymentMethodName:
  /// 1. Lấy title từ nameVi hoặc nameEn (ưu tiên nameVi, chỉ dùng case "vi")
  /// 2. Nếu có bankInfo:
  ///    - Nếu có methodName: return methodName
  ///    - Nếu không: return [title, bankCode, accountOwner].filter(Boolean).join(" ")
  /// 3. Nếu không có bankInfo: return title
  String get displayPaymentName {
    // Lấy title từ nameVi hoặc nameEn (ưu tiên nameVi)
    String title = nameVi.isNotEmpty ? nameVi : nameEn;

    // Kiểm tra bankInfo (có thể là bankInfo.bankInfo hoặc bankInfo trực tiếp)
    final bankInfoData = bankInfo;
    if (bankInfoData != null) {
      // Nếu có methodName trong bankInfo, trả về methodName
      if (bankInfoData.methodName != null && bankInfoData.methodName!.isNotEmpty) {
        return bankInfoData.methodName!;
      }

      // Nếu không có methodName, ghép title + bankCode (từ SellerPaymentMethod) + accountOwner
      final parts = <String>[
        title,
        if (bankCode != null && bankCode!.isNotEmpty) bankCode!,
        if (bankInfoData.accountOwner != null && bankInfoData.accountOwner!.isNotEmpty)
          bankInfoData.accountOwner!,
      ].where((part) => part.isNotEmpty).toList();

      return parts.join(' ');
    }

    // Nếu không có bankInfo, chỉ trả về title
    return title;
  }
}

