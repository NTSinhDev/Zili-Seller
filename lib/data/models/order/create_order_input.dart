import 'dart:convert';

import 'package:zili_coffee/utils/extension/extension.dart';

/// Model cho input khi tạo order mới
///
/// Sử dụng để type-safe khi generate order body
class CreateOrderInput {
  final OrderInput order;
  final String customerId;
  final String? collaboratorId;
  final String? addressCustomerId;
  final List<PaymentInput> paid;
  final Map<String, dynamic>? delivery; // User sẽ tự implement
  final InfoAdditionalInput infoAdditional;
  final InvoiceInput invoice;

  CreateOrderInput({
    required this.order,
    required this.customerId,
    this.collaboratorId,
    this.addressCustomerId,
    required this.paid,
    this.delivery,
    required this.infoAdditional,
    required this.invoice,
  });

  /// Convert sang Map để gửi lên API
  Map<String, dynamic> toMap() {
    return {
      'order': order.toMap(),
      'customerId': customerId,
      if (collaboratorId != null) 'collaboratorId': collaboratorId,
      if (addressCustomerId != null) 'addressCustomerId': addressCustomerId,
      'paid': paid.map((p) => p.toMap()).toList(),
      if (delivery != null) 'delivery': delivery,
      'infoAdditional': infoAdditional.toMap(),
      'invoice': invoice.toMap(),
    };
  }

  /// Convert sang JSON string
  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'CreateOrderInput(order: $order, customerId: $customerId, collaboratorId: $collaboratorId, addressCustomerId: $addressCustomerId, paid: $paid, delivery: $delivery, infoAdditional: $infoAdditional, invoice: $invoice)';
  }
}

/// Model cho order object trong CreateOrderInput
class OrderInput {
  final num deliveryFee;
  final num? discount;
  final double? discountPercent;
  final num? vat;
  final double? vatPercent;
  final String? discountReason;
  final String? companyId;
  final List<OrderProductInput> products;
  final String? note;
  final List<String>? tags;

  OrderInput({
    required this.deliveryFee,
    this.discount,
    this.discountPercent,
    this.vat,
    this.vatPercent,
    this.discountReason,
    this.companyId,
    required this.products,
    this.note,
    this.tags,
  });

  Map<String, dynamic> toMap() {
    return {
      'deliveryFee': deliveryFee.toString(), // Convert to String as API expects
      if (discount != null)
        'discount': discount.toString(), // Convert to String as API expects
      if (discountPercent != null) 'discountPercent': discountPercent,
      if (vat != null) 'vat': vat.toString(),
      if (vatPercent != null) 'vatPercent': vatPercent,
      if (discountReason != null) 'discountReason': discountReason,
      if (companyId != null) 'companyId': companyId,
      'products': products.map((p) => p.toMap()).toList(),
      if (note != null && note!.isNotEmpty) 'note': note,
      if (tags != null) 'tags': tags,
    };
  }
}

/// Model cho product trong order
class OrderProductInput {
  final String productId;
  final String productVariantId;
  final int quantity;
  final double? discountPercent;
  final num? discount;
  final num price;
  final String? note;
  final String? productNameVi;

  OrderProductInput({
    required this.productId,
    required this.productVariantId,
    required this.quantity,
    this.discountPercent,
    this.discount,
    required this.price,
    this.note,
    this.productNameVi,
  });

  Map<String, dynamic> toMap() {
    return {
      if (productId.isNotEmpty && productId.isNotNull) 'productId': productId,
      if (productVariantId.isNotEmpty && productVariantId.isNotNull)
        'productVariantId': productVariantId,
      if (productNameVi != null && productNameVi!.isNotEmpty)
        'productNameVi': productNameVi,
      'quantity': quantity,
      if (discountPercent != null) 'discountPercent': discountPercent,
      if (discount != null) 'discount': discount,
      'price': price,
      if (note != null && note!.isNotEmpty) 'note': note,
    };
  }
}

/// Model cho payment input
class PaymentInput {
  final String method;
  final num amount;

  PaymentInput({required this.method, required this.amount});

  Map<String, dynamic> toMap() {
    return {'method': method, 'amount': amount};
  }
}

/// Model cho infoAdditional object
class InfoAdditionalInput {
  final String salesType;
  final String? branchId;
  final String? soldById;
  final String? saleChannel;
  final String? scheduledDeliveryAt;
  final String? saleDate;
  final String? orderCode;
  final String? expectedPayment;

  InfoAdditionalInput({
    required this.salesType,
    this.branchId,
    this.soldById,
    this.saleChannel,
    this.scheduledDeliveryAt,
    this.saleDate,
    this.orderCode,
    this.expectedPayment,
  });

  Map<String, dynamic> toMap() {
    return {
      'salesType': salesType,
      if (branchId != null) 'branchId': branchId,
      if (soldById != null) 'soldById': soldById,
      if (saleChannel != null) 'saleChannel': saleChannel,
      if (scheduledDeliveryAt != null)
        'scheduledDeliveryAt': scheduledDeliveryAt,
      if (saleDate != null) 'saleDate': saleDate,
      if (orderCode != null) 'orderCode': orderCode,
      if (expectedPayment != null) 'expectedPayment': expectedPayment,
    };
  }
}

/// Model cho invoice object
class InvoiceInput {
  final String type;
  final String? taxCode;
  final String? email;
  final String? addressId;
  final String? name;

  InvoiceInput({
    required this.type,
    this.taxCode,
    this.email,
    this.addressId,
    this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      if (taxCode != null) 'taxCode': taxCode,
      if (email != null) 'email': email,
      if (addressId != null) 'addressId': addressId,
      if (name != null) 'name': name,
    };
  }
}
