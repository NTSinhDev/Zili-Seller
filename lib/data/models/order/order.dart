import 'dart:convert';

import 'package:zili_coffee/data/models/payment/collaborator.dart';

import '../../../data/models/address/customer_address.dart';
import '../../../data/models/order/delivery_group.dart';
import '../../../data/models/order/order_delivery.dart';
import '../../../data/models/order/order_export.dart';
import '../../../data/models/order/order_info.dart';
import '../../../data/models/order/order_invoice.dart';
import '../../../data/models/user/company.dart';
import '../../../utils/enums.dart';
import '../../../utils/enums/order_enum.dart';
import '../../../utils/enums/payment_enum.dart';
import '../../../utils/extension/extension.dart';
import '../user/customer.dart';
import '../warehouse/warehouse.dart';
import 'payment_detail/order_payment.dart';

part 'order_constant.dart';
part 'order_to_json.dart';

class Order {
  final String id;
  final String? code;
  final String? status;
  final num? totalAmount;
  final List<OrderLineItem> orderLineItems;
  final Customer? customer;
  final List<dynamic> billingAddress;
  final CustomerAddress? shippingAddress;
  final PaymentDetail? paymentDetail;

  // New fields from API response
  final String? type;
  final DateTime? orderDate;
  final String? orderCode;
  final String? deliveryFailedNote;
  final String? deliveryFailedReasonId;
  final String? cancelNote;
  final dynamic wallet;
  final int? amount; // New field from API
  final DateTime? cashbackDate;
  final String? cashbackStatus;
  final DateTime? discountDate;
  final String? discountStatus;
  final DateTime? refundDate;
  final DateTime? receivedDate;
  final String? refundStatus;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? adminCancelledById;
  final String? adminVerifiedById;
  final String? businessVerifiedById;
  final List<OrderPayment>? orderPayments;
  final List<dynamic>? orderProcesses;
  final List<dynamic>? timelines; // New field for timeline
  final OrderInfo? orderInfo; // New: orderInfo from API
  final OrderDelivery? orderDelivery; // New: orderDelivery from API
  final Map<String, dynamic>? addressJson;
  final int quantity;
  final num? totalPaid;
  final num? orderReturnExchangeAmount;
  final num? deliveryFee;
  final num? vat;
  final num? vatPercent;
  final String? deliveryCode;
  final dynamic trackingOrder;
  final DeliveryGroup? delivery; // New: delivery object from API
  final bool? isRefund;
  final String? invoiceStatus;
  final String? collaboratorsCode;
  final bool? isPrinted;
  final bool? isInvoice;
  final String? trackingOrderLabel;
  final String? saleChannel;
  final num? discount;
  final double? discountPercent;
  final String? discountReason;
  final String? statusGeneral;
  final String? billingStatus;
  final String? createdBy;
  final OrderInvoice? orderInvoice; // New: orderInvoice from API
  final Company? company; // New: company from API
  final String? note;
  Warehouse? warehouse;
  Collaborator? collaborator;

  Order({
    required this.id,
    required this.code,
    required this.totalAmount,
    required this.orderLineItems,
    required this.customer,
    required this.billingAddress,
    required this.shippingAddress,
    required this.paymentDetail,
    this.status,
    this.orderDate,
    this.orderCode,
    this.deliveryFailedNote,
    this.deliveryFailedReasonId,
    this.cancelNote,
    this.wallet,
    this.amount,
    this.cashbackDate,
    this.cashbackStatus,
    this.discountDate,
    this.discountStatus,
    this.refundDate,
    this.receivedDate,
    this.refundStatus,
    this.createdAt,
    this.updatedAt,
    this.adminCancelledById,
    this.adminVerifiedById,
    this.businessVerifiedById,
    this.orderPayments,
    this.orderProcesses,
    this.timelines,
    this.orderInfo,
    this.orderDelivery,
    this.addressJson,
    this.quantity = 0,
    this.totalPaid,
    this.orderReturnExchangeAmount,
    this.deliveryFee,
    this.deliveryCode,
    this.trackingOrder,
    this.delivery,
    this.isRefund,
    this.invoiceStatus,
    this.collaboratorsCode,
    this.isPrinted,
    this.isInvoice,
    this.trackingOrderLabel,
    this.saleChannel,
    this.discount,
    this.discountPercent,
    this.discountReason,
    this.statusGeneral,
    this.billingStatus,
    this.createdBy,
    this.warehouse,
    this.orderInvoice,
    this.company,
    this.type,
    this.vat,
    this.vatPercent,
    this.note,
    this.collaborator,
  });

  double get lineItemsCost =>
      orderLineItems.fold(0.0, (sum, item) => sum + item.calculateTotalAmount);

  OrderStatus? get statusEnum =>
      OrderStatus.values.valueBy((e) => e.toConstant == statusGeneral);

  num get totalOrderLineItems => orderLineItems.fold(
    0,
    (sum, item) => sum + (num.tryParse(item.quantity) ?? 0),
  );

  double? get codAmount {
    return orderPayments
            ?.valueBy((item) => item.isCODCollect)
            ?.totalAmount
            .toDouble() ??
        0.0;
  }

  /// Statistic payments
  double? get totalCustomerMustPay =>
      billingStatus == OrderPaymentStatus.fullyPaid.toConstant
      ? totalPaid?.toDouble() ?? 0.0
      : ((totalAmount ?? 0.0) - (orderReturnExchangeAmount ?? 0.0)).toDouble();
  double? get totalCustomerPaid => totalPaid?.toDouble() ?? 0.0;
  double? get totalCustomerRemainingPayable =>
      billingStatus == OrderPaymentStatus.fullyPaid.toConstant
      ? 0
      : (totalCustomerMustPay ?? 0.0) - (totalPaid ?? 0.0) - (codAmount ?? 0.0);

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map[_Constant.id] as String,
      status: map[_Constant.status]?.toString(),
      code: map[_Constant.code] != null ? map[_Constant.code] as String : null,
      totalAmount: map[_Constant.totalAmount] as dynamic,
      orderLineItems: List<OrderLineItem>.from(
        map[_Constant.orderLineItems].map<OrderLineItem>(
          (data) => OrderLineItem.fromMap(data as Map<String, dynamic>),
        ),
      ),
      vat: map['vat'] as num?,
      customer: map[_Constant.customer] != null
          ? Customer.fromMap(map[_Constant.customer])
          : null,
      billingAddress: map[_Constant.billingAddress] == null
          ? []
          : List<dynamic>.from(
              (map[_Constant.billingAddress] as List<dynamic>),
            ),
      shippingAddress: _shippingAddressFromMap(map),
      paymentDetail: map[_Constant.paymentDetail] != null
          ? PaymentDetail.fromMap(map[_Constant.paymentDetail])
          : null,
    );
  }

  static CustomerAddress? _shippingAddressFromMap(Map<String, dynamic> map) {
    try {
      List<dynamic> address = map[_Constant.shippingAddress] == null
          ? []
          : map[_Constant.shippingAddress] as List<dynamic>;
      if (address.isEmpty) {
        return null;
      }
      // ignore: empty_catches
    } catch (e) {}
    return CustomerAddress.fromMap(map[_Constant.shippingAddress][0]);
  }

  /// Factory method để parse response mới từ API tạo đơn hàng
  ///
  /// Response structure: {"status":1,"data":{...}}
  factory Order.fromMapNew(Map<String, dynamic> map) {
    // Parse orderItems
    List<OrderLineItem>? orderLineItems;
    if (map['orderItems'] != null) {
      orderLineItems = (map['orderItems'] as List<dynamic>)
          .map((item) => OrderLineItem.fromMap(item as Map<String, dynamic>))
          .toList();
    }

    // Parse orderInfo
    OrderInfo? orderInfo;
    if (map['orderInfo'] != null) {
      orderInfo = OrderInfo.fromMap(map['orderInfo'] as Map<String, dynamic>);
    }

    // Parse orderDelivery
    OrderDelivery? orderDelivery;
    if (map['orderDelivery'] != null) {
      orderDelivery = OrderDelivery.fromMap(
        map['orderDelivery'] as Map<String, dynamic>,
        map['status']?.toString(),
      );
    }

    // Parse delivery (DeliveryGroup)
    DeliveryGroup? delivery;
    if (map['delivery'] != null) {
      delivery = DeliveryGroup.fromMap(map['delivery'] as Map<String, dynamic>);
    }

    return Order(
      id: map['id']?.toString() ?? '',
      code: map['code']?.toString(),
      orderLineItems: orderLineItems ?? [],
      totalAmount: (map['totalAmount'] as num?) ?? 0,
      customer: map[_Constant.customer] != null
          ? Customer.fromMap(map[_Constant.customer])
          : null,
      billingAddress: [],
      shippingAddress: null,
      paymentDetail: null,
      type: map['type']?.toString(),
      orderDate: map['orderDate'] != null
          ? DateTime.tryParse(map['orderDate'].toString())
          : null,
      orderCode: map['orderCode']?.toString(),
      deliveryFailedNote: map['deliveryFailedNote']?.toString(),
      deliveryFailedReasonId: map['deliveryFailedReasonId']?.toString(),
      cancelNote: map['cancelNote']?.toString(),
      wallet: map['wallet'],
      amount: (map['amount'] as num?)?.toInt(),
      cashbackDate: map['cashbackDate'] != null
          ? DateTime.tryParse(map['cashbackDate'].toString())
          : null,
      cashbackStatus: map['cashbackStatus']?.toString(),
      discountDate: map['discountDate'] != null
          ? DateTime.tryParse(map['discountDate'].toString())
          : null,
      discountStatus: map['discountStatus']?.toString(),
      refundDate: map['refundDate'] != null
          ? DateTime.tryParse(map['refundDate'].toString())
          : null,
      receivedDate: map['receivedDate'] != null
          ? DateTime.tryParse(map['receivedDate'].toString())
          : null,
      refundStatus: map['refundStatus']?.toString(),
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString())
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt'].toString())
          : null,
      adminCancelledById: map['adminCancelledById']?.toString(),
      adminVerifiedById: map['adminVerifiedById']?.toString(),
      businessVerifiedById: map['businessVerifiedById']?.toString(),
      orderPayments: map['orderPayments'] != null
          ? (map['orderPayments'] as List<dynamic>)
                .map<OrderPayment>(
                  (item) => OrderPayment.fromMap(item as Map<String, dynamic>),
                )
                .toList()
          : null,
      orderProcesses: map['orderProcesses'] != null
          ? List<dynamic>.from(map['orderProcesses'] as List<dynamic>)
          : null,
      timelines: map['timeline'] != null
          ? List<dynamic>.from(map['timeline'] as List<dynamic>)
          : null,
      orderInfo: orderInfo,
      orderDelivery: orderDelivery,
      addressJson: map['addressJson'] != null
          ? Map<String, dynamic>.from(map['addressJson'] as Map)
          : null,
      quantity: (map['quantity'] as num?)?.toInt() ?? 0,
      totalPaid: (map['totalPaid'] as num?),
      orderReturnExchangeAmount: (map['orderReturnExchangeAmount'] as num?),
      vat: map['vat'] as num?,
      vatPercent: map['vatPercent'] as num?,
      deliveryFee: (map['deliveryFee'] as num?),
      deliveryCode: map['deliveryCode']?.toString(),
      trackingOrder: map['trackingOrder'],
      delivery: delivery,
      isRefund: map['isRefund'] as bool?,
      invoiceStatus: map['invoiceStatus']?.toString(),
      collaboratorsCode: map['collaborators_code']?.toString(),
      isPrinted: map['isPrinted'] as bool?,
      isInvoice: map['isInvoice'] as bool?,
      trackingOrderLabel: map['trackingOrderLabel']?.toString(),
      saleChannel: map['saleChannel']?.toString(),
      discount: (map['discount'] as num?),
      discountPercent: (map['discountPercent'] as num?)?.toDouble(),
      discountReason: map['discountReason']?.toString(),
      statusGeneral: map['statusGeneral']?.toString(),
      billingStatus: map['billingStatus']?.toString(),
      createdBy: map['createdBy']?.toString(),
      orderInvoice: map['orderInvoice'] != null
          ? OrderInvoice.fromMap(map['orderInvoice'] as Map<String, dynamic>)
          : null,
      company: map['company'] != null
          ? Company.fromMap(map['company'] as Map<String, dynamic>)
          : null,
      note: map['note']?.toString(),
      collaborator: map['collaborator'] != null
          ? Collaborator.fromMap(map['collaborator'] as Map<String, dynamic>)
          : null,
    );
  }
}
