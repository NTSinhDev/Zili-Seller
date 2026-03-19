import 'package:zili_coffee/data/models/user/base_person.dart';

import '../../../utils/enums.dart';
import '../../../utils/enums/order_enum.dart';
import '../../../utils/extension/extension.dart';
import '../../../utils/functions/base_functions.dart';
import '../../../utils/helpers/parser.dart';
import '../../entity/system/reason.dart';
import '../order/order_delivery.dart';
import '../order/order_export.dart';
import '../order/order_info.dart';
import '../order/payment_detail/bank_info.dart';
import '../user/customer.dart';
import '../warehouse/warehouse.dart';

/// Quotation Model
///
/// Model đại diện cho phiếu báo giá, kế thừa toàn bộ thông tin từ [Order].
/// Phiếu báo giá chứa toàn bộ thông tin đơn hàng, với các trường đặc biệt:
/// - [totalAmount]: Giá báo giá (tổng giá trị sau khi điều chỉnh)
/// - [totalOrderAmount]: Giá đơn hàng thực tế (nếu phiếu đã được duyệt và tạo đơn)
class Quotation extends Order {
  String get quotationId => id;
  String? get quotationStatus => status;
  DateTime? get quotationCreatedAt => createdAt;
  DateTime? get quotationUpdatedAt => updatedAt;

  // Thông tin đơn hàng được override từ phiếu báo giá
  final String orderId;
  final String orderStatus;
  final String orderCreatedAt;
  final num? totalOrderAmount;

  //
  final BasePerson? quotationCreatedBy;
  final String quotationCode;
  BankInfo? quotationPayment;
  final String templateCode;
  String? imageUrl;
  String? pdfUrl;
  final String? rejectedNote;
  final ReasonEntity? rejectedReason;
  final List<String>? headerQuantities;

  Quotation({
    required super.id,
    required super.code,
    required super.totalAmount,
    required super.orderLineItems,
    required super.customer,
    required super.billingAddress,
    required super.shippingAddress,
    required super.paymentDetail,
    super.status,
    super.orderDate,
    super.orderCode,
    super.deliveryFailedNote,
    super.deliveryFailedReasonId,
    super.cancelNote,
    super.wallet,
    super.amount,
    super.cashbackDate,
    super.cashbackStatus,
    super.discountDate,
    super.discountStatus,
    super.refundDate,
    super.receivedDate,
    super.refundStatus,
    super.createdAt,
    super.updatedAt,
    super.adminCancelledById,
    super.adminVerifiedById,
    super.businessVerifiedById,
    super.orderPayments,
    super.orderProcesses,
    super.timelines,
    super.orderInfo,
    super.orderDelivery,
    super.addressJson,
    super.quantity,
    super.totalPaid,
    super.orderReturnExchangeAmount,
    super.deliveryFee,
    super.vat,
    super.vatPercent,
    super.deliveryCode,
    super.trackingOrder,
    super.delivery,
    super.isRefund,
    super.invoiceStatus,
    super.collaboratorsCode,
    super.isPrinted,
    super.isInvoice,
    super.trackingOrderLabel,
    super.saleChannel,
    super.discount,
    super.discountPercent,
    super.discountReason,
    super.statusGeneral,
    super.billingStatus,
    super.createdBy,
    super.warehouse,
    super.orderInvoice,
    super.company,
    super.type,
    super.note,
    required this.quotationCreatedBy,
    required this.quotationCode,
    this.totalOrderAmount,
    required this.orderId,
    required this.orderStatus,
    required this.orderCreatedAt,
    required this.quotationPayment,
    required this.templateCode,
    this.pdfUrl,
    this.imageUrl,
    this.rejectedReason,
    this.rejectedNote,
    this.headerQuantities,
  });

  QuoteStatus? get quoteStatus =>
      QuoteStatus.values.valueBy((e) => e.toConstant == quotationStatus);

  void setWarehouse(Warehouse? warehouse) => super.warehouse = warehouse;

  /// Factory method để parse Quotation từ Map
  ///
  /// Parse như [Order.fromMapNew] nhưng điều chỉnh:
  /// - [totalAmount]: Giá báo giá từ map
  /// - [totalOrderAmount]: Giá đơn hàng thực tế từ map (nếu có)
  ///
  /// Sử dụng [catchErrorOnParseModel] để xử lý lỗi parse an toàn.
  factory Quotation.fromMap(Map<String, dynamic> map) {
    return catchErrorOnParseModel<Quotation>(() {
      final Order order = Order.fromMapNew(map);
      final orderQuotationInfo =  map['orderQuotationInfo'] != null
            ? OrderInfo.fromMap(
                map['orderQuotationInfo'] as Map<String, dynamic>,
              )
            : null;
      final orderQuotationDelivery = map['orderQuotationDelivery'] != null
          ? OrderDelivery.fromMap(map['orderQuotationDelivery'] as Map<String, dynamic>, null)
          : null;
      final Customer? customer = order.customer;
      customer?.fullName = orderQuotationInfo?.fullName;
      customer?.nickname = orderQuotationInfo?.nickname;
      customer?.phone = orderQuotationInfo?.phoneNumber;
      customer?.email = orderQuotationInfo?.email;
      customer?.purchaseAddress = orderQuotationDelivery;

      return Quotation(
        id: map['id']?.toString() ?? '',
        code: map['code']?.toString(),
        totalAmount: (map['totalAmount'] as num?) ?? 0,
        orderLineItems: map["orderQuotationItems"] != null
            ? List<OrderLineItem>.from(
                map["orderQuotationItems"].map<OrderLineItem>(
                  (data) => OrderLineItem.fromMap(data as Map<String, dynamic>),
                ),
              )
            : [],
        customer: customer,
        billingAddress: order.billingAddress,
        shippingAddress: order.shippingAddress,
        paymentDetail: order.paymentDetail,
        type: order.type,
        orderDate: order.orderDate,
        orderCode: order.orderCode,
        deliveryFailedNote: order.deliveryFailedNote,
        deliveryFailedReasonId: order.deliveryFailedReasonId,
        cancelNote: order.cancelNote,
        amount: order.amount,
        discountDate: order.discountDate,
        discountStatus: order.discountStatus,
        refundDate: order.refundDate,
        receivedDate: order.receivedDate,
        refundStatus: order.refundStatus,
        createdAt: parseServerTimeZoneDateTime(map['createdAt']),
        updatedAt: parseServerTimeZoneDateTime(map['updatedAt']),
        orderPayments: order.orderPayments,
        orderProcesses: order.orderProcesses,
        timelines: order.timelines,
        orderInfo: map['orderQuotationInfo'] != null
            ? OrderInfo.fromMap(
                map['orderQuotationInfo'] as Map<String, dynamic>,
              )
            : null,
        orderDelivery: order.orderDelivery,
        addressJson: order.addressJson,
        quantity: order.quantity,
        totalPaid: order.totalPaid,
        orderReturnExchangeAmount: order.orderReturnExchangeAmount,
        vat: order.vat,
        vatPercent: order.vatPercent,
        deliveryFee: order.deliveryFee,
        deliveryCode: order.deliveryCode,
        trackingOrder: order.trackingOrder,
        delivery: order.delivery,
        isRefund: order.isRefund,
        invoiceStatus: order.invoiceStatus,
        collaboratorsCode: order.collaboratorsCode,
        isPrinted: order.isPrinted,
        isInvoice: order.isInvoice,
        trackingOrderLabel: order.trackingOrderLabel,
        saleChannel: order.saleChannel,
        discount: order.discount,
        discountPercent: order.discountPercent,
        discountReason: order.discountReason,
        statusGeneral: order.statusGeneral,
        billingStatus: order.billingStatus,
        createdBy: order.createdBy,
        orderInvoice: order.orderInvoice,
        company: order.company,
        totalOrderAmount: order.totalAmount,
        quotationCreatedBy: map['createdByInfo'] != null
            ? BasePerson.fromMap(map['createdByInfo'])
            : null,
        quotationCode:
            map['quotationCode']?.toString() ?? map['code']?.toString() ?? '',
        orderId: map['orderId']?.toString() ?? '',
        orderStatus: map['orderStatus']?.toString() ?? '',
        orderCreatedAt: map['orderCreatedAt']?.toString() ?? '',
        status: map['status']?.toString() ?? '',
        quotationPayment: map['bankInfo'] != null
            ? BankInfo.fromMap(map['bankInfo'])
            : null,
        note: map['note']?.toString(),
        templateCode: map['templateCode']?.toString() ?? '',
        pdfUrl: map['pdfUrl']?.toString(),
        imageUrl: map['imageUrl']?.toString(),
        rejectedNote: map['rejectedNote']?.toString(),
        rejectedReason: map['rejectedReason'] != null
            ? ReasonEntity.fromMap(map['rejectedReason'])
            : null,
        headerQuantities: map['headerQuantities'] != null
            ? List<String>.from(
                map['headerQuantities'].map((x) => x.toString()),
              )
            : [],
      );
    }, map);
  }

  /// Returns a string representation of this Quotation
  ///
  /// [isPrintOrder]: Nếu `true`, hiển thị thêm thông tin đơn hàng (nếu có)
  @override
  String toString({bool isPrintOrder = false}) {
    final buffer = StringBuffer();
    buffer.writeln('Quotation {');
    buffer.writeln('  id: $id');
    buffer.writeln('  code: $code');
    buffer.writeln('  status: $status');
    buffer.writeln('  totalAmount: $totalAmount (Giá báo giá)');
    if (totalOrderAmount != null) {
      buffer.writeln(
        '  totalOrderAmount: $totalOrderAmount (Giá đơn hàng thực tế)',
      );
    }
    buffer.writeln('  createdAt: ${createdAt?.toString() ?? 'null'}');
    buffer.writeln('  updatedAt: ${updatedAt?.toString() ?? 'null'}');
    buffer.writeln('  statusGeneral: $statusGeneral');
    buffer.writeln('  billingStatus: $billingStatus');
    buffer.writeln('  quantity: $quantity');
    buffer.writeln('  orderLineItems.length: ${orderLineItems.length}');
    buffer.writeln('  totalPaid: $totalPaid');
    buffer.writeln('  deliveryFee: $deliveryFee');
    buffer.writeln('  discount: $discount');
    buffer.writeln('  discountPercent: $discountPercent');
    buffer.writeln('  vat: $vat');
    buffer.writeln('  orderCode: $orderCode');
    buffer.writeln('  deliveryCode: $deliveryCode');
    buffer.writeln('  createdBy: $createdBy');
    buffer.writeln('  saleChannel: $saleChannel');
    buffer.writeln('  type: $type');
    buffer.writeln('  company: ${company?.id ?? 'null'}');
    buffer.writeln('  orderInfo: ${orderInfo?.id ?? 'null'}');
    buffer.writeln(
      '  orderDelivery: ${orderDelivery != null ? 'present' : 'null'}',
    );
    buffer.writeln('  delivery: ${delivery != null ? 'present' : 'null'}');
    buffer.writeln(
      '  orderInvoice: ${orderInvoice != null ? 'present' : 'null'}',
    );
    buffer.writeln('  orderPayments: ${orderPayments?.length ?? 0} items');
    buffer.writeln('  timelines: ${timelines?.length ?? 0} items');
    buffer.writeln('  isRefund: $isRefund');
    buffer.writeln('  isPrinted: $isPrinted');
    buffer.writeln('  isInvoice: $isInvoice');

    if (isPrintOrder) {
      buffer.writeln('');
      buffer.writeln('  === Order Information ===');
      if (orderInfo != null) {
        buffer.writeln('  orderInfo.id: ${orderInfo!.id}');
        buffer.writeln(
          '  orderInfo.fullName: ${orderInfo!.fullName ?? 'null'}',
        );
        buffer.writeln('  orderInfo.email: ${orderInfo!.email ?? 'null'}');
        buffer.writeln(
          '  orderInfo.phoneNumber: ${orderInfo!.phoneNumber ?? 'null'}',
        );
      }
      if (orderDelivery != null) {
        buffer.writeln(
          '  orderDelivery.address: ${orderDelivery!.address ?? 'null'}',
        );
        buffer.writeln(
          '  orderDelivery.province: ${orderDelivery!.province ?? 'null'}',
        );
        buffer.writeln(
          '  orderDelivery.district: ${orderDelivery!.district ?? 'null'}',
        );
        buffer.writeln(
          '  orderDelivery.ward: ${orderDelivery!.ward ?? 'null'}',
        );
      }
      if (orderPayments != null && orderPayments!.isNotEmpty) {
        buffer.writeln('  orderPayments:');
        for (final payment in orderPayments!) {
          buffer.writeln(
            '    - ${payment.method}: ${payment.totalAmount} (${payment.status})',
          );
        }
      }
      if (timelines != null && timelines!.isNotEmpty) {
        buffer.writeln('  timelines: ${timelines!.length} items');
      }
    }

    buffer.writeln('}');
    return buffer.toString();
  }
}
