import 'package:zili_coffee/utils/enums.dart';
import 'package:zili_coffee/utils/extension/extension.dart';

import '../../../utils/enums/order_enum.dart';
import '../../../utils/enums/user_enum.dart';
import '../../models/order/payment_detail/bank_info.dart';
import '../../models/product/product_variant.dart';
import '../../models/user/customer.dart';
import '../../models/warehouse/warehouse.dart';
import '../product_variant_form_dto.dart';

class OrderQuotationProducts extends ProductVariantFormDto {
  List<num>? priceList;
  OrderQuotationProducts({
    required super.qty,
    required super.price,
    required super.discount,
    required super.discountPercent,
    required super.discountUnit,
    super.note,
    super.productVariant,
    super.measureUnit,
    this.priceList,
  });

  String get productId =>
      productVariant?.productId ?? productVariant?.product?.id ?? '';
  String get productVariantId => productVariant?.id ?? '';
  String get productNameVi => productVariant?.product?.titleVi ?? '';

  @override
  bool get isService => productVariantId.isEmpty;

  @override
  num get totalAmount {
    if (qty == 0 || price == 0.0) return 0.0;

    final doubleDiscount = (discountPercent ?? 0) > 0
        ? price * discountPercent! / 100
        : discount;

    return qty * (price - doubleDiscount);
  }

  @override
  num get totalPrice => qty * price;

  factory OrderQuotationProducts.fromProductVariant(
    ProductVariant productVariant,
    DefaultPrice salesType,
    List<String>? quantityPrices,
  ) {
    if (quantityPrices != null) {
      final price = salesType == .wholesalePrice
          ? productVariant.wholesalePrice
          : productVariant.price;
      return OrderQuotationProducts(
        qty: 1,
        discountUnit: 'đ',
        productVariant: productVariant,
        price: price,
        priceList: List.generate(quantityPrices.length, (_) => price),
        discount: 0,
        discountPercent: 0,
      );
    }

    final discountUnit = productVariant.discountUnit ?? 'đ';
    final valueDiscount = productVariant.discount ?? 0;
    final discount = discountUnit == "đ"
        ? valueDiscount
        : (valueDiscount * productVariant.price) / 100;
    final discountPercent = discountUnit == "%" ? valueDiscount : null;
    return OrderQuotationProducts(
      qty: productVariant.quantity > 0 ? productVariant.quantity : 1,
      discountUnit: discountUnit,
      productVariant: productVariant,
      price: salesType == .wholesalePrice
          ? productVariant.wholesalePrice
          : productVariant.price,
      discount: discount,
      discountPercent: discountPercent,
      note: productVariant.note,
      measureUnit: productVariant.id == ""
          ? null
          : productVariant.product?.measureUnit ?? "KG",
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

  String? validate({
    required QuoteMailType quoteType,
    List<String> quantityOpts = const [],
  }) {
    if (quoteType == .quantityQuote && quantityOpts.isNotEmpty) {
      if (priceList.isNullOrEmpty) {
        return "Đơn giá sản phẩm $productNameVi không hợp lệ";
      } else if ((priceList ?? []).valueBy((e) => e < 0) != null) {
        return "Đơn giá sản phẩm $productNameVi không hợp lệ";
      }
      return null;
    } else {
      if (price < 0) {
        return "Đơn giá sản phẩm $productNameVi không hợp lệ";
      }
      if (qty <= 0) return "Số lượng sản phẩm $productNameVi không hợp lệ";
      if (discount < 0) {
        return "Chiết khấu sản phẩm $productNameVi không hợp lệ";
      }
      if ((discountPercent ?? 0) < 0) {
        return "Chiết khấu phần trăm sản phẩm $productNameVi không hợp lệ";
      }
      return validateDiscountVerbose(discountPercent, discount);
    }
  }

  Map<String, dynamic> toMap() {
    if (isService) {
      return {
        'productNameVi': productNameVi,
        'quantity': qty,
        'price': price,
        if (discount != 0) 'discount': discount,
        if (discountPercent != null) 'discountPercent': discountPercent,
        'note': note,
      };
    }

    return {
      'productId': productId,
      'productVariantId': productVariantId,
      'quantity': qty,
      'price': price,
      if (discount != 0) 'discount': discount,
      if (discountPercent != null) 'discountPercent': discountPercent,
      if (measureUnit != null) 'measureUnit': measureUnit,
      'note': note,
    };
  }

  Map<String, dynamic> toQuantityMap() {
    return {
      'productId': productId,
      'productVariantId': productVariantId,
      'priceArr': priceList ?? [],
      'price': price < 0 ? 0 : price,
      'note': note,
    };
  }
}

class OrderQuotation {
  List<OrderQuotationProducts> products;
  String? note;
  num? discount;
  num? discountPercent;
  String? discountUnit;
  String? discountReason;
  num? vat;
  num? vatPercent;
  String? vatUnit;
  num? deliveryFee;

  OrderQuotation({
    required this.products,
    this.note,
    this.discount,
    this.discountPercent,
    this.discountUnit,
    this.discountReason,
    this.vat,
    this.vatPercent,
    this.vatUnit,
    this.deliveryFee,
  });

  Map<String, dynamic> toMap() {
    return {
      'products': products.map((p) => p.toMap()).toList(),
      if (note != null) 'note': note,
      if (discount != null) 'discount': discount,
      if (discountPercent != null) 'discountPercent': discountPercent,
      if (discountReason != null) 'discountReason': discountReason,
      if (vat != null) 'vat': vat,
      if (vatPercent != null) 'vatPercent': vatPercent,
      if (deliveryFee != null) 'deliveryFee': deliveryFee,
    };
  }

  Map<String, dynamic> toQuantityMap() {
    return {
      'products': products.map((p) => p.toQuantityMap()).toList(),
      "deliveryFee": 0,
      "discount": 0,
      "discountPercent": 0,
      "discountReason": 0,
      "vat": 0,
      "vatPercent": 0,
    };
  }
}

class InfoAdditionalQuotation {
  Warehouse? branch;
  DefaultPrice salesType;
  String? saleChannel; // Not use at 27/01/2026
  String? soldById; // Not use at 27/01/2026
  String? web; // Not use at 27/01/2026
  String? orderUrl; // Not use at 27/01/2026
  String? reference; // Not use at 27/01/2026

  InfoAdditionalQuotation({
    this.branch,
    this.salesType = DefaultPrice.retailPrice,
    this.saleChannel,
    this.soldById,
    this.web,
    this.orderUrl,
    this.reference,
  });

  Map<String, dynamic> toMap() {
    return {
      'salesType': salesType.toConstant,
      if (branch != null) 'branchId': branch?.id,
      if (soldById != null) 'soldById': soldById,
      if (saleChannel != null) 'saleChannel': saleChannel,
      if (web != null) 'web': web,
      if (orderUrl != null) 'orderUrl': orderUrl,
      if (reference != null) 'reference': reference,
    };
  }
}

class CreateQuotationInput {
  OrderQuotation? order;
  Customer? customer;
  InfoAdditionalQuotation? infoAdditionalQuotation;
  String? notes;
  QuoteMailType mailType;
  List<String>? quantityOpts;
  BankInfo? payment;

  CreateQuotationInput({
    this.order,
    this.customer,
    this.infoAdditionalQuotation,
    this.notes,
    this.mailType = QuoteMailType.greenBeanQuote,
    this.payment,
    this.quantityOpts,
  });

  // ** Getter methods
  Warehouse? get salesBranch => infoAdditionalQuotation?.branch;
  List<ProductVariant> get productVariants =>
      order?.products.map((e) => e.productVariant).nonNulls.toList() ?? [];

  Map<String, dynamic> toMap() {
    return {
      if ((customer?.id ?? "").isNotEmpty) 'customerId': customer?.id,
      if ((customer?.purchaseAddress?.id ?? "").isNotEmpty)
        'addressCustomerId': customer?.purchaseAddress?.id,
      if (quantityOpts != null) 'headerQuantities': quantityOpts,
      if (order != null)
        'order': mailType == QuoteMailType.quantityQuote
            ? order?.toQuantityMap()
            : order?.toMap(),
      if (infoAdditionalQuotation != null)
        'infoAdditional': infoAdditionalQuotation?.toMap(),
      if (notes != null) 'note': notes,
      if (payment != null) 'bankingCode': payment?.code,
      'templateCode': mailType.toConstant,
    };
  }

  String? validate() {
    // ** Validate customer
    if ((customer?.id ?? "").isEmpty) {
      return "Không tìm thấy thông tin khách hàng";
    }
    // ** Validate order
    if ((order?.products ?? []).isEmpty) {
      return "Vui lòng chọn ít nhất một sản phẩm";
    }
    for (OrderQuotationProducts product in order?.products ?? []) {
      final error = product.validate(
        quoteType: mailType,
        quantityOpts: quantityOpts ?? [],
      );
      if (error != null) return error;
    }
    // ** Validate additional information
    if ((infoAdditionalQuotation?.branch?.id ?? "").isEmpty) {
      return "Vui lòng chọn chi nhánh bán hàng";
    }
    if (payment == null) return "Vui lòng chọn phương thức thanh toán";
    return null;
  }

  // ** Handle customer
  void setCustomer(Customer? customer) => this.customer = customer;

  // ** Handle products
  void _createOrderFieldIfNull() {
    if (order.isNull) order = OrderQuotation(products: []);
  }

  void addProducts(List<ProductVariant> productVariants) {
    _createOrderFieldIfNull();

    final isAddServiceProduct =
        productVariants.length == 1 &&
        (productVariants.firstOrNull?.id ?? "").isEmpty;
    if (isAddServiceProduct) {
      order?.products.addAll(
        productVariants.map(
          (e) => OrderQuotationProducts.fromProductVariant(
            e,
            infoAdditionalQuotation?.salesType ?? DefaultPrice.retailPrice,
            quantityOpts,
          ),
        ),
      );
      return;
    }

    if ((order?.products ?? []).isEmpty) {
      order?.products.addAll(
        productVariants.map(
          (e) => OrderQuotationProducts.fromProductVariant(
            e,
            infoAdditionalQuotation?.salesType ?? DefaultPrice.retailPrice,
            quantityOpts,
          ),
        ),
      );
    } else {
      final crList = order?.products ?? [];
      final needJoin = productVariants
          .map(
            (e) => OrderQuotationProducts.fromProductVariant(
              e,
              infoAdditionalQuotation?.salesType ?? DefaultPrice.retailPrice,
              quantityOpts,
            ),
          )
          .nonNulls
          .toList();

      order?.products.addWhere(
        needJoin,
        (e) =>
            !(crList.any((p) => p.productVariantId == e.productVariantId)) ||
            e.isService,
      );
    }
  }

  void updateServiceProduct(int index, OrderQuotationProducts product) {
    if (index != -1) order?.products[index] = product;
  }

  void removeServiceProduct(int index) {
    if ((order?.products ?? []).isNotEmpty) {
      order?.products.removeAt(index);
    }
  }

  void replaceProductsByQuantityOpts(List<String>? opts) {
    final target = opts != null
        ? (order?.products ?? [])
              .where((p) => p.productVariantId.isNotEmpty)
              .toList()
        : order?.products ?? [];
    order?.products = target
        .map(
          (e) => OrderQuotationProducts.fromProductVariant(
            e.productVariant!,
            infoAdditionalQuotation?.salesType ?? DefaultPrice.retailPrice,
            opts,
          ),
        )
        .toList();
  }

  void removeProduct(OrderQuotationProducts productVariant) {
    _createOrderFieldIfNull();
    order?.products.removeWhere(
      (p) => p.productVariantId == productVariant.productVariantId,
    );
  }

  void updateProduct(OrderQuotationProducts product) {
    if (order.isNull) return;
    final index = order!.products.indexWhere(
      (p) => p.productVariantId == product.productVariantId,
    );
    if (index != -1) {
      order?.products[index] = product;
    }
  }

  // ** Handle quotation information
  void setQuotationNote(String note) => notes = note;
  void setQuotationDiscount(
    num discount,
    num? discountPercent,
    String discountUnit,
    String? discountReason,
  ) {
    _createOrderFieldIfNull();
    order?.discount = discount;
    order?.discountUnit = discountUnit;
    order?.discountPercent = discountPercent;
    order?.discountReason = discountReason;
  }

  void setQuotationDiscountPercent(num discountPercent) {
    _createOrderFieldIfNull();
    order?.discountPercent = discountPercent;
  }

  void setQuotationDiscountReason(String discountReason) {
    _createOrderFieldIfNull();
    order?.discountReason = discountReason;
  }

  void setQuotationVat(num vat, num? vatPercent, String vatUnit) {
    _createOrderFieldIfNull();
    order?.vat = vat;
    order?.vatUnit = vatUnit;
    order?.vatPercent = vatPercent;
  }

  void setQuotationVatPercent(num vatPercent) {
    _createOrderFieldIfNull();
    order?.vatPercent = vatPercent;
  }

  void setQuotationDeliveryFee(num deliveryFee) {
    _createOrderFieldIfNull();
    order?.deliveryFee = deliveryFee;
  }

  // ** Handle additional information
  void createInfoAdditionalFieldIfNull() {
    if (infoAdditionalQuotation.isNull) {
      infoAdditionalQuotation = InfoAdditionalQuotation();
    }
  }

  void setSalesBranch(Warehouse wh) {
    createInfoAdditionalFieldIfNull();
    infoAdditionalQuotation?.branch = wh;
  }

  void setSalesType(DefaultPrice priceType) {
    createInfoAdditionalFieldIfNull();
    infoAdditionalQuotation?.salesType = priceType;
  }

  void setSaleChannel(String saleChannel) {
    createInfoAdditionalFieldIfNull();
    infoAdditionalQuotation?.saleChannel = saleChannel;
  }
}
