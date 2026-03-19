import '../../../../utils/functions/base_functions.dart';
import '../../../../utils/helpers/parser.dart';
import '../../user/base_person.dart';
import 'seller_payment_method.dart';

/// Order Payment Model
///
/// Represents a payment record for an order, including payment method,
/// status, amounts, timestamps, and related information.
class OrderPayment {
  final String id;
  final String method;
  final String status;
  final num totalAmount;
  final num totalAmountDeliveryFee;
  final String? code;
  final String? url;
  final DateTime? receivedAt;
  final DateTime? lastedRequestAt;
  final DateTime? createdAt;
  final String? note;
  final String? reference;
  final dynamic bankInfo;
  final BasePerson? createdBy;
  final Map<String, dynamic>? detailJson;
  final SellerPaymentMethod? paymentMethodInfo;

  OrderPayment({
    required this.id,
    required this.method,
    required this.status,
    required this.totalAmount,
    required this.totalAmountDeliveryFee,
    this.code,
    this.url,
    this.receivedAt,
    this.lastedRequestAt,
    this.createdAt,
    this.note,
    this.reference,
    this.bankInfo,
    this.createdBy,
    this.detailJson,
    this.paymentMethodInfo,
  });

  /// Gets the person who collected the payment (from detailJson.collectedBy).
  ///
  /// Returns null if detailJson or collectedBy is not available.
  BasePerson? get collectedBy {
    if (detailJson == null) return null;
    final collectedByData = detailJson!['collectedBy'];
    if (collectedByData is! Map<String, dynamic>) return null;
    try {
      return BasePerson.fromMap(collectedByData);
    } catch (e) {
      return null;
    }
  }

  /// Checks if this is a COD (Cash on Delivery) payment.
  ///
  /// A payment is considered COD if detailJson is not empty.
  bool get isCODCollect => detailJson != null && detailJson!.isNotEmpty;

  factory OrderPayment.fromMap(Map<String, dynamic> map) {
    return catchErrorOnParseModel<OrderPayment>(() {
      // Parse detailJson
      final detailJsonData = map['detailJson'];
      final detailJson = detailJsonData is Map<String, dynamic>
          ? detailJsonData
          : null;
      // Parse paymentMethodInfo
      SellerPaymentMethod? paymentMethodInfo;
      final paymentMethodInfoData = map['paymentMethodInfo'];
      if (paymentMethodInfoData is Map<String, dynamic>) {
        try {
          paymentMethodInfo = SellerPaymentMethod.fromMap(
            paymentMethodInfoData,
          );
        } catch (e) {
          // Ignore parse error, paymentMethodInfo will remain null
        }
      }
      final createdBy = map['createdBy'] != null
          ? BasePerson.fromMap(map['createdBy'])
          : null;
      return OrderPayment(
        id: map['id']?.toString() ?? '',
        method: map['method']?.toString() ?? '',
        status: map['status']?.toString() ?? '',
        totalAmount: (map['totalAmount'] as num?) ?? 0,
        totalAmountDeliveryFee: (map['totalAmountDeliveryFee'] as num?) ?? 0,
        code: map['code']?.toString(),
        url: map['url']?.toString(),
        receivedAt: parseServerTimeZoneDateTime(map['receivedAt']),
        lastedRequestAt: parseServerTimeZoneDateTime(map['lastedRequestAt']),
        createdAt: parseServerTimeZoneDateTime(map['createdAt']),
        note: map['note']?.toString(),
        reference: map['reference']?.toString(),
        bankInfo: map['bankInfo'],
        createdBy: createdBy,
        detailJson: detailJson,
        paymentMethodInfo: paymentMethodInfo,
      );
    }, map);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'method': method,
      'status': status,
      'totalAmount': totalAmount,
      'totalAmountDeliveryFee': totalAmountDeliveryFee,
      'code': code,
      'url': url,
      'receivedAt': receivedAt?.toIso8601String(),
      'lastedRequestAt': lastedRequestAt?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'note': note,
      'reference': reference,
      'bankInfo': bankInfo,
      'createdBy': createdBy != null
          ? {
              'id': createdBy!.id,
              'fullName': createdBy!.fullName,
              'username': createdBy!.username,
              'email': createdBy!.email,
              'phone': createdBy!.phone,
              'avatar': createdBy!.avatar,
              'createdAt': createdBy!.createdAt?.toIso8601String(),
            }
          : null,
      'detailJson': detailJson,
      'paymentMethodInfo': paymentMethodInfo?.toMap(),
    };
  }
}
