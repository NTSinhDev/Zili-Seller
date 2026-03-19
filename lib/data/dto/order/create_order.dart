import '../../../utils/enums.dart';
import '../../../utils/enums/order_enum.dart';
import '../../../utils/enums/user_enum.dart';
import '../../../utils/extension/extension.dart';
import '../../models/payment/collaborator.dart';
import '../../models/product/product_variant.dart';
import '../../models/user/customer.dart';
import '../../models/user/staff.dart';
import '../../models/warehouse/warehouse.dart';
import '../product_variant_form_dto.dart';

class CreateOrderInfoProd extends ProductVariantFormDto {
  CreateOrderInfoProd({
    required super.qty,
    required super.price,
    required super.discount,
    required super.discountPercent,
    required super.discountUnit,
    super.note,
    super.productVariant,
  });

  String get productId =>
      productVariant?.productId ?? productVariant?.product?.id ?? '';
  String get productVariantId => productVariant?.id ?? '';
  String get productNameVi => productVariant?.product?.titleVi ?? '';

  @override
  bool get isService => productVariantId.isEmpty;

  /// Tổng tiền sau khi đã trừ đi giá trị chiết khấu
  @override
  num get totalAmount {
    if (qty == 0 || price == 0.0) return 0.0;

    final doubleDiscount = (discountPercent ?? 0) > 0
        ? price * discountPercent! / 100
        : discount;

    return qty * (price - doubleDiscount);
  }

  factory CreateOrderInfoProd.fromProductVariant(
    ProductVariant productVariant,
    DefaultPrice salesType,
  ) {
    final discountUnit = productVariant.discountUnit ?? 'đ';
    final valueDiscount = productVariant.discount ?? 0;
    final discount = discountUnit == "đ"
        ? valueDiscount
        : (valueDiscount * productVariant.price) / 100;
    final discountPercent = discountUnit == "%" ? valueDiscount : null;
    return CreateOrderInfoProd(
      qty: productVariant.quantity > 0 ? productVariant.quantity : 1,
      discountUnit: discountUnit,
      productVariant: productVariant,
      price: salesType == .wholesalePrice
          ? productVariant.wholesalePrice
          : productVariant.price,
      discount: discount,
      discountPercent: discountPercent,
      note: productVariant.note,
    );
  }

  String? validateDiscountVerbose(num? discountPercent, num discount) {
    if (discountPercent == null) {
      return null;
    }
    if (discountPercent < 0 && discount < 0) {
      return 'Phần trăm chiết khấu và giá trị chiết khấu không được là số âm';
    }

    if (discountPercent < 0) {
      return 'Phần trăm chiết khấu không được là số âm';
    }

    if (discountPercent > 0 && discount <= 0) {
      return 'Vui lòng nhập giá trị chiết khấu lớn hơn 0';
    }

    return null;
  }

  String? validate() {
    if (qty <= 0) return "Số lượng sản phẩm $productNameVi không hợp lệ";
    if (price < 0) return "Đơn giá sản phẩm $productNameVi không hợp lệ";
    if (discount < 0) return "Chiết khấu sản phẩm $productNameVi không hợp lệ";
    if ((discountPercent ?? 0) < 0) {
      return "Chiết khấu phần trăm sản phẩm $productNameVi không hợp lệ";
    }
    return validateDiscountVerbose(discountPercent, discount);
  }

  Map<String, dynamic> toMap() {
    if (isService) {
      return {
        'productNameVi': productNameVi,
        'quantity': qty,
        'price': price,
        if (discount != 0) 'discount': discount,
        if (discountPercent != null) 'discountPercent': discountPercent,
      };
    }

    return {
      'productId': productId,
      'productVariantId': productVariantId,
      'quantity': qty,
      'price': price,
      if (discount != 0) 'discount': discount,
      if (discountPercent != null) 'discountPercent': discountPercent,
      'note': note,
    };
  }
}

// Chứa toàn bộ thông tin cần thiết để cấu hình nên đơn hàng
class CreateOrderInfo {
  String companyId;
  List<CreateOrderInfoProd> products = [];
  OrderStatus status = OrderStatus.pending;
  String? quotationCode;
  String? note;
  num? discount;
  num? discountPercent;
  String? discountUnit;
  String? discountReason;
  num? vat;
  num? vatPercent;
  String? vatUnit;
  num? deliveryFee;
  CreateOrderInfo(this.companyId);

  Map<String, dynamic> toMap() {
    return {
      'products': products.map((p) => p.toMap()).toList(),
      'status': status.toConstant,
      'companyId': companyId,
      if (quotationCode != null) 'quotationCode': quotationCode,
      if (note != null) 'note': note,
      if (discount != null) 'discount': discount,
      if (discountPercent != null) 'discountPercent': discountPercent,
      if (discountReason != null) 'discountReason': discountReason,
      if (vat != null) 'vat': vat,
      if (vatPercent != null) 'vatPercent': vatPercent,
      if (deliveryFee != null) 'deliveryFee': deliveryFee,
    };
  }
}

class CreateOrderInfoAdditional {
  DefaultPrice? salesType;
  Warehouse? branch;
  String? soldById;
  String? saleChannel;
  DateTime? saleDate;
  DateTime? scheduledDeliveryAt;
  String? expectedPayment;

  Map<String, dynamic> toMap() {
    return {
      'salesType': (salesType ?? DefaultPrice.retailPrice).toConstant,
      if (branch?.id != null) 'branchId': branch?.id,
      if (soldById != null) 'soldById': soldById,
      if (saleChannel != null) 'saleChannel': saleChannel,
      if (saleDate != null) 'saleDate': saleDate?.toIso8601StringWithTimezone(),
      if (scheduledDeliveryAt != null)
        'scheduledDeliveryAt': scheduledDeliveryAt
            ?.toIso8601StringWithTimezone(),
      if (expectedPayment != null) 'expectedPayment': expectedPayment,
    };
  }
}

class CreateOrderDTO {
  Customer? customer;
  CreateOrderInfo order;
  String? collaboratorId;
  CreateOrderInfoAdditional infoAdditional = CreateOrderInfoAdditional();
  Staff? staff;
  Collaborator? collaborator;
  List<Map<String, dynamic>> paymentDetails = [];
  bool isPaid = false;
  CreateOrderDTO(String companyId) : order = CreateOrderInfo(companyId);
  // ** Getter methods
  List<ProductVariant> get productVariants =>
      order.products.map((e) => e.productVariant).nonNulls.toList();

  void addProducts(List<ProductVariant> productVariants) {
    final isAddServiceProduct =
        productVariants.length == 1 &&
        (productVariants.firstOrNull?.id ?? "").isEmpty;
    if (isAddServiceProduct) {
      order.products.addAll(
        productVariants.map(
          (e) => CreateOrderInfoProd.fromProductVariant(
            e,
            infoAdditional.salesType ?? DefaultPrice.retailPrice,
          ),
        ),
      );
      return;
    }

    if (order.products.isEmpty) {
      order.products.addAll(
        productVariants.map(
          (e) => CreateOrderInfoProd.fromProductVariant(
            e,
            infoAdditional.salesType ?? DefaultPrice.retailPrice,
          ),
        ),
      );
    } else {
      final needJoin = productVariants
          .map(
            (e) => CreateOrderInfoProd.fromProductVariant(
              e,
              infoAdditional.salesType ?? DefaultPrice.retailPrice,
            ),
          )
          .nonNulls
          .toList();

      order.products.addWhere(
        needJoin,
        (e) =>
            !(order.products.any(
              (p) => p.productVariantId == e.productVariantId,
            )) ||
            e.isService,
      );
    }
  }

  void setProducts(List<CreateOrderInfoProd> coips) =>
      order.products.addAll(coips);

  void removeProduct(ProductVariantFormDto pvf) => order.products.removeWhere(
    (p) => p.productVariantId == pvf.toCreateOrderInfoProds().productVariantId,
  );

  void removeServiceProduct(int index) {
    order.products.removeAt(index);
  }

  void updateServiceProduct(int index, ProductVariantFormDto pvf) {
    final updateData = pvf.toCreateOrderInfoProds();
    if (index != -1) order.products[index] = updateData;
  }

  void updateProduct(ProductVariantFormDto pvf) {
    final updateData = pvf.toCreateOrderInfoProds();
    final index = order.products.indexWhere(
      (v) => v.productVariantId == updateData.productVariantId,
    );
    if (index != -1) order.products[index] = updateData;
  }

  // ** Handle quotation information
  void setNote(String note) => order.note = note;
  void setDiscount(
    num discount,
    num? discountPercent,
    String discountUnit,
    String? discountReason,
  ) {
    order.discount = discount;
    order.discountUnit = discountUnit;
    order.discountPercent = discountPercent;
    order.discountReason = discountReason;
  }

  void setVat(num vat, num? vatPercent, String vatUnit) {
    order.vat = vat;
    order.vatUnit = vatUnit;
    order.vatPercent = vatPercent;
  }

  void setSalesType(DefaultPrice priceType) =>
      infoAdditional.salesType = priceType;
  void setSaleChannel(String saleChannel) =>
      infoAdditional.saleChannel = saleChannel;

  void setStaff(Staff staff) {
    this.staff = staff;
    infoAdditional.soldById = staff.id;
  }

  void setCollaborator(Collaborator col) {
    collaborator = col;
    collaboratorId = col.id;
  }

  Map<String, dynamic> toMap() {
    final paidList = paymentDetails
        .where((item) {
          final label = item['paymentMethodEnum'] as String?;
          final value = (item['customerPaid'] as num?)?.toDouble() ?? 0.0;
          return label != null && label.isNotEmpty && value > 0;
        })
        .nonNulls
        .map(
          (item) => PaymentInput(
            method: item['paymentMethodEnum'] as String,
            amount: ((item['customerPaid'] as num?)?.toDouble() ?? 0.0).toInt(),
            bankCode: item['bankCode'] as String?,
          ),
        )
        .toList();
    return {
      'order': order.toMap(),
      if (customer?.id != null) 'customerId': customer?.id,
      if (customer?.purchaseAddress?.id != null)
        'addressCustomerId': customer?.purchaseAddress?.id,
      if (customer?.billingAddress != null)
        'invoice': {
          "type": "COMPANY",
          "taxCode": null,
          "email": customer?.billingAddress?.email,
          "addressId": customer?.billingAddress?.id,
          "name": customer?.billingAddress?.name,
        },
      'infoAdditional': infoAdditional.toMap(),
      if (collaboratorId != null) 'collaboratorId': collaboratorId,
      if (paidList.isNotEmpty) "paid": paidList.map((p) => p.toMap()).toList(),
      "delivery": {
        "deliveryCode": "DELIVERY_LATER",
        if (infoAdditional.branch?.id != null)
          "warehouseId": infoAdditional.branch?.id,
      },
    };
  }

  String? validate() {
    if ((customer?.id ?? "").isEmpty ||
        (customer?.purchaseAddress?.id ?? "").isEmpty) {
      return "Không tìm thấy thông tin khách hàng";
    }
    if (order.products.isEmpty) {
      return "Vui lòng chọn ít nhất một sản phẩm";
    }
    for (CreateOrderInfoProd product in order.products) {
      final error = product.validate();
      if (error != null) return error;
    }
    if ((infoAdditional.branch?.id ?? "").isEmpty) {
      return "Vui lòng chọn chi nhánh bán hàng";
    }
    if ((infoAdditional.soldById ?? "").isEmpty) {
      return "Vui lòng chọn nhân viên phụ trách đơn";
    }
    return null;
  }
}

class PaymentInput {
  final String method;
  final num amount;
  final String? bankCode;

  PaymentInput({required this.method, required this.amount, this.bankCode});

  Map<String, dynamic> toMap() {
    return {
      'method': method,
      'amount': amount,
      if (bankCode != null) 'bankCode': bankCode,
    };
  }
}
