import 'package:zili_coffee/res/res.dart';

import '../../../utils/functions/order_function.dart';
import '../../../utils/helpers/parser.dart';

class ServiceProduct extends ProductVariant {
  ServiceProduct({
    required super.price,
    required super.originalPrice,
    required super.quantity,
    required super.discount,
    required super.discountUnit,
    required super.totalPrice,
    required super.note,
    super.id = '',
    super.productId,
    super.options = const [],
    super.imageVariant,
    super.costPrice = 0.0,
    super.wholesalePrice = 0.0,
    super.promotion,
    super.inventory = 0.0,
    super.length = 0.0,
    super.weight = 0.0,
    super.height = 0.0,
    super.width = 0.0,
    super.packedWeight = 0.0,
    super.deleteFlag,
    super.sku,
    super.barcode,
    super.slotBuy = '0',
    super.transactionCount = '0',
    super.inTransitCount = '0',
    super.deliveryCount = '0',
    super.availableQuantity = '0',
    super.status = 'ACTIVE',
    super.commission = 0.0,
    super.commissionWeight,
    super.calculateByUnit = 'WEIGHT',
    super.product,
    super.createdAt,
  });

  ProductVariant get toProductVariant {
    return ProductVariant(
      id: id,
      options: options,
      price: price,
      originalPrice: price,
      costPrice: costPrice,
      wholesalePrice: wholesalePrice,
      inventory: inventory,
      length: length,
      weight: weight,
      height: this.height,
      width: this.width,
      slotBuy: slotBuy,
      transactionCount: transactionCount,
      inTransitCount: inTransitCount,
      deliveryCount: deliveryCount,
      availableQuantity: availableQuantity,
      status: status,
      commission: commission,
      calculateByUnit: calculateByUnit,
      quantity: quantity,
      discount: discount,
      discountUnit: discountUnit,
      totalPrice: totalPrice,
      note: note,
      product: product,
    );
  }
}

class ProductVariant implements MeasureUnitAndWeight {
  final String id;
  final String? productId; // ID của product mà variant này thuộc về
  final List<ProductVariantOption> options;
  final String? imageVariant;
  final double price;
  final double originalPrice;
  final double costPrice;
  final double wholesalePrice;
  final double? promotion;
  final double inventory;
  final double length;
  @override
  final double weight;
  final double height;
  final double width;
  final double packedWeight;
  final String? deleteFlag;
  final String? sku;
  final String? barcode;
  final String slotBuy;
  final String transactionCount;
  final String inTransitCount;
  final String deliveryCount;
  final String availableQuantity;
  final String status;
  final double commission;
  final double? commissionWeight;
  final String calculateByUnit;
  ProductInfo? product; // Thông tin product mà variant này thuộc về
  final num quantity; // Số lượng đã chọn (default: 1)
  final double? discount; // Chiết khấu
  final String?
  discountUnit; // Đơn vị chiết khấu: 'đ' (đồng) hoặc '%' (phần trăm)
  final double? totalPrice; // Tổng giá trị sau khi tính chiết khấu
  final String? note; // Ghi chú cho variant
  final DateTime? createdAt;

  ProductVariant({
    required this.id,
    this.productId,
    required this.options,
    this.imageVariant,
    required this.price,
    required this.originalPrice,
    required this.costPrice,
    required this.wholesalePrice,
    this.promotion,
    required this.inventory,
    required this.length,
    required this.weight,
    required this.height,
    required this.width,
    this.packedWeight = 0.0,
    this.deleteFlag,
    this.sku,
    this.barcode,
    required this.slotBuy,
    required this.transactionCount,
    required this.inTransitCount,
    required this.deliveryCount,
    required this.availableQuantity,
    required this.status,
    required this.commission,
    this.commissionWeight,
    required this.calculateByUnit,
    this.product,
    this.quantity = 1.0,
    this.discount = 0.0,
    this.discountUnit = 'đ',
    this.totalPrice = 0.0,
    this.note,
    this.createdAt,
  });

  num? get totalPriceByDiscount {
    if (discount == null || discount == 0.0) {
      return null;
    }
    if (discountUnit == '%') {
      return price * quantity * (1 - discount! / 100);
    } else {
      return price * quantity - discount!;
    }
  }

  factory ProductVariant.fromMap(Map<String, dynamic> map) {
    return ProductVariant(
      id: map['id']?.toString() ?? '',
      productId: map['product']?['id']?.toString(),
      options:
          (map['options'] as List<dynamic>?)
              ?.map(
                (option) => ProductVariantOption.fromMap(
                  option as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
      imageVariant: map['imageVariant']?.toString(),
      price: (map['price'] is num) ? (map['price'] as num).toDouble() : 0.0,
      originalPrice: (map['originalPrice'] is num)
          ? (map['originalPrice'] as num).toDouble()
          : 0.0,
      costPrice: (map['costPrice'] is num)
          ? (map['costPrice'] as num).toDouble()
          : 0.0,
      wholesalePrice: (map['wholesalePrice'] is num)
          ? (map['wholesalePrice'] as num).toDouble()
          : 0.0,
      promotion: map['promotion'] != null
          ? (map['promotion'] as num).toDouble()
          : null,
      inventory: (map['inventory'] is num)
          ? (map['inventory'] as num).toDouble()
          : 0.0,
      length: (map['length'] is num) ? (map['length'] as num).toDouble() : 0.0,
      weight: (map['weight'] is num) ? (map['weight'] as num).toDouble() : 0.0,
      height: (map['height'] is num) ? (map['height'] as num).toDouble() : 0.0,
      width: (map['width'] is num) ? (map['width'] as num).toDouble() : 0.0,
      packedWeight: (map['packedWeight'] is num)
          ? (map['packedWeight'] as num).toDouble()
          : double.tryParse(map['packedWeight']?.toString() ?? '') ?? 0.0,
      deleteFlag: map['deleteFlag']?.toString(),
      sku: map['sku']?.toString(),
      barcode: map['barcode']?.toString(),
      slotBuy: map['slotBuy']?.toString() ?? '0',
      transactionCount: map['transactionCount']?.toString() ?? '0',
      inTransitCount: map['inTransitCount']?.toString() ?? '0',
      deliveryCount: map['deliveryCount']?.toString() ?? '0',
      availableQuantity: map['availableQuantity']?.toString() ?? '0',
      status: map['status']?.toString() ?? '',
      commission: (map['commission'] is num)
          ? (map['commission'] as num).toDouble()
          : 0.0,
      commissionWeight: map['commissionWeight'] != null
          ? (map['commissionWeight'] as num).toDouble()
          : null,
      calculateByUnit: map['calculateByUnit']?.toString() ?? '',
      product: map['product'] != null
          ? ProductInfo.fromMap(map['product'] as Map<String, dynamic>)
          : null,
      quantity: (map['quantity'] is num) ? (map['quantity'] as num).toInt() : 1,
      discount: map['discount'] != null
          ? (map['discount'] as num).toDouble()
          : null,
      discountUnit: map['discountUnit']?.toString(),
      totalPrice: map['totalPrice'] != null
          ? (map['totalPrice'] as num).toDouble()
          : null,
      note: map['note']?.toString(),
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString())
          : null,
    );
  }

  factory ProductVariant.fromOrderLineItem(Map<String, dynamic> map) {
    return catchErrorOnParseModel<ProductVariant>(() {
      final prodId = map['productId']?.toString();
      final productVariantMap = map['productVariant'] as Map<String, dynamic>;
      final List<ProductVariantOption> options =
          (productVariantMap['options'] as List<dynamic>?)
              ?.map(
                (option) => ProductVariantOption.fromMap(
                  option as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [];
      return ProductVariant(
        id: productVariantMap['id']?.toString() ?? '',
        productId: prodId,
        options: options,
        imageVariant: productVariantMap['imageVariant']?.toString(),
        sku: productVariantMap['sku']?.toString(),
        barcode: productVariantMap['barcode']?.toString(),
        weight: productVariantMap['weight'] != null
            ? double.tryParse(productVariantMap['weight']!.toString()) ?? 0.0
            : 0.0,
        note: map['note']?.toString(),
        price:
            double.tryParse(productVariantMap["price"]?.toString() ?? '') ??
            0.0,
        originalPrice:
            double.tryParse(
              productVariantMap["originalPrice"]?.toString() ?? '',
            ) ??
            0.0,
        costPrice:
            double.tryParse(productVariantMap["costPrice"]?.toString() ?? '') ??
            0.0,
        wholesalePrice:
            double.tryParse(
              productVariantMap["wholesalePrice"]?.toString() ?? '',
            ) ??
            0.0,
        inventory: 0.0, // Not used
        length: 0.0, // Not used
        height: 0.0, // Not used
        width: 0.0, // Not used
        packedWeight: 0.0, // Not used
        deleteFlag: '', // Not used
        slotBuy: '', // Not used
        transactionCount: '', // Not used
        inTransitCount: '', // Not used
        deliveryCount: '', // Not used
        availableQuantity: '', // Not used
        status: '', // Not used
        commission: 0.0, // Not used
        calculateByUnit: '', // Not used
        product: ProductInfo(
          id: map['productId']?.toString() ?? '',
          titleVi:
              map["titleVi"]?.toString() ?? map["productNameVi"]?.toString(),
          measureUnit: (productVariantMap["product"]?["measureUnit"])
              ?.toString(),
        ), // Not used
        quantity: 1.0, // Not used
        discount: 0.0, // Not used
        discountUnit: '', // Not used
        totalPrice: 0.0, // Not used
        createdAt: null, // Not used
      );
    });
  }

  factory ProductVariant.fromServiceVariant(Map<String, dynamic> map) {
    return catchErrorOnParseModel<ProductVariant>(() {
      return ProductVariant(
        id: map['id']?.toString() ?? '',
        productId: map['id']?.toString() ?? '',
        note: map['note']?.toString(),
        options: [],
        imageVariant: null,
        sku: null,
        barcode: null,
        weight: 0.0, // Not used
        price: 0.0, // Not used
        originalPrice: 0.0, // Not used
        costPrice: 0.0, // Not used
        wholesalePrice: 0.0, // Not used
        inventory: 0.0, // Not used
        length: 0.0, // Not used
        height: 0.0, // Not used
        width: 0.0, // Not used
        packedWeight: 0.0, // Not used
        deleteFlag: '', // Not used
        slotBuy: '', // Not used
        transactionCount: '', // Not used
        inTransitCount: '', // Not used
        deliveryCount: '', // Not used
        availableQuantity: '', // Not used
        status: '', // Not used
        commission: 0.0, // Not used
        calculateByUnit: '', // Not used
        product: ProductInfo(
          id: map['id']?.toString() ?? '',
          titleVi:
              map["productNameVi"]?.toString() ??
              map["productNameEn"]?.toString(),
        ), // Not used
        quantity: 1.0, // Not used
        discount: 0.0, // Not used
        discountUnit: '', // Not used
        totalPrice: 0.0, // Not used
        createdAt: null, // Not used
      );
    });
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id.isEmpty ? null : id,
      'productId': productId,
      'options': options.map((option) => option.toMap()).toList(),
      'imageVariant': imageVariant,
      'price': price,
      'originalPrice': originalPrice,
      'costPrice': costPrice,
      'wholesalePrice': wholesalePrice,
      'promotion': promotion,
      'inventory': inventory,
      'length': length,
      'weight': weight,
      'height': height,
      'width': width,
      'packedWeight': packedWeight,
      'deleteFlag': deleteFlag,
      'sku': sku,
      'barcode': barcode,
      'slotBuy': slotBuy,
      'transactionCount': transactionCount,
      'inTransitCount': inTransitCount,
      'deliveryCount': deliveryCount,
      'availableQuantity': availableQuantity,
      'status': status,
      'commission': commission,
      'commissionWeight': commissionWeight,
      'calculateByUnit': calculateByUnit,
      'product': product?.toMap(),
      'quantity': quantity,
      'discount': discount,
      'discountUnit': discountUnit,
      'totalPrice': totalPrice,
      if (note != null && note!.isNotEmpty) 'note': note,
    };
  }

  /// Get display name từ product hoặc từ options
  String get displayName {
    if (product != null) {
      return product!.titleVi ??
          product!.titleEn ??
          product!.shortName ??
          AppConstant.strings.DEFAULT_EMPTY_VALUE;
    }
    if (options.isNotEmpty) {
      return options.map((o) => '${o.name}: ${o.value}').join(', ');
    }
    return AppConstant.strings.DEFAULT_EMPTY_VALUE;
  }

  /// Get display unit từ product hoặc từ calculateByUnit
  String get displayUnit {
    return product?.measureUnit ?? calculateByUnit;
  }

  /// Get avatar từ product hoặc từ imageVariant
  String? get displayAvatar {
    return product?.avatar ?? imageVariant;
  }

  /// Copy with method để tạo instance mới với một số fields thay đổi
  ProductVariant copyWith({
    String? id,
    String? productId,
    List<ProductVariantOption>? options,
    String? imageVariant,
    double? price,
    double? originalPrice,
    double? costPrice,
    double? wholesalePrice,
    double? promotion,
    double? inventory,
    double? length,
    double? weight,
    double? height,
    double? width,
    double? packedWeight,
    String? deleteFlag,
    String? sku,
    String? barcode,
    String? slotBuy,
    String? transactionCount,
    String? inTransitCount,
    String? deliveryCount,
    String? availableQuantity,
    String? status,
    double? commission,
    double? commissionWeight,
    String? calculateByUnit,
    ProductInfo? product,
    num? quantity,
    double? discount,
    String? discountUnit,
    double? totalPrice,
    String? note,
  }) {
    return ProductVariant(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      options: options ?? this.options,
      imageVariant: imageVariant ?? this.imageVariant,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      costPrice: costPrice ?? this.costPrice,
      wholesalePrice: wholesalePrice ?? this.wholesalePrice,
      promotion: promotion ?? this.promotion,
      inventory: inventory ?? this.inventory,
      length: length ?? this.length,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      width: width ?? this.width,
      packedWeight: packedWeight ?? this.packedWeight,
      deleteFlag: deleteFlag ?? this.deleteFlag,
      sku: sku ?? this.sku,
      barcode: barcode ?? this.barcode,
      slotBuy: slotBuy ?? this.slotBuy,
      transactionCount: transactionCount ?? this.transactionCount,
      inTransitCount: inTransitCount ?? this.inTransitCount,
      deliveryCount: deliveryCount ?? this.deliveryCount,
      availableQuantity: availableQuantity ?? this.availableQuantity,
      status: status ?? this.status,
      commission: commission ?? this.commission,
      commissionWeight: commissionWeight ?? this.commissionWeight,
      calculateByUnit: calculateByUnit ?? this.calculateByUnit,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      discount: discount ?? this.discount,
      discountUnit: discountUnit ?? this.discountUnit,
      totalPrice: totalPrice ?? this.totalPrice,
      note: note ?? this.note,
    );
  }

  @override
  String? get measureUnit => product?.measureUnit ?? calculateByUnit;
}

class ProductVariantOption {
  final String name;
  final String value;

  ProductVariantOption({required this.name, required this.value});

  factory ProductVariantOption.fromMap(Map<String, dynamic> map) {
    return ProductVariantOption(
      name: map['name']?.toString() ?? '',
      value: map['value']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'value': value};
  }
}

/// Thông tin Product mà ProductVariant thuộc về
class ProductInfo {
  String id;
  final String? titleVi;
  final String? titleEn;
  final String? shortName;
  final String? avatar;
  final String? barcode;
  final String? sku;
  final String? measureUnit;
  final double price;
  final double originalPrice;
  final double costPrice;
  final double wholesalePrice;
  final double slotBuy;
  final double availableQuantity;
  final String? status;
  final bool? isSaleAllowed;
  final bool? isInventoryManaged;
  final bool? isOnWebsite;
  final bool? isCanPacking;
  final List<String>? imageDetail;
  final DateTime? createdAt;
  ProductInfo({
    required this.id,
    this.titleVi,
    this.titleEn,
    this.shortName,
    this.avatar,
    this.barcode,
    this.sku,
    this.measureUnit,
    this.price = 0,
    this.originalPrice = 0,
    this.costPrice = 0,
    this.wholesalePrice = 0,
    this.slotBuy = 0,
    this.availableQuantity = 0,
    this.status,
    this.isSaleAllowed,
    this.isInventoryManaged,
    this.isOnWebsite,
    this.isCanPacking,
    this.imageDetail,
    this.createdAt,
  });

  factory ProductInfo.fromMap(Map<String, dynamic> map) {
    return ProductInfo(
      id: map['id']?.toString() ?? '',
      titleVi: map['titleVi']?.toString(),
      titleEn: map['titleEn']?.toString(),
      shortName: map['shortName']?.toString(),
      avatar: map['avatar']?.toString(),
      barcode: map['barcode']?.toString(),
      sku: map['sku']?.toString(),
      measureUnit: map['measureUnit']?.toString(),
      price: (map['price'] is num) ? (map['price'] as num).toDouble() : 0.0,
      originalPrice: (map['originalPrice'] is num)
          ? (map['originalPrice'] as num).toDouble()
          : 0.0,
      costPrice: (map['costPrice'] is num)
          ? (map['costPrice'] as num).toDouble()
          : 0.0,
      wholesalePrice: (map['wholesalePrice'] is num)
          ? (map['wholesalePrice'] as num).toDouble()
          : 0.0,
      slotBuy: (map['slotBuy'] is num)
          ? (map['slotBuy'] as num).toDouble()
          : 0.0,
      availableQuantity: (map['availableQuantity'] is num)
          ? (map['availableQuantity'] as num).toDouble()
          : 0.0,
      status: map['status']?.toString(),
      isSaleAllowed: map['isSaleAllowed'] as bool?,
      isInventoryManaged: map['isInventoryManaged'] as bool?,
      isOnWebsite: map['isOnWebsite'] as bool?,
      isCanPacking: map['isCanPacking'] as bool?,
      imageDetail: (map['imageDetail'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id.isEmpty ? null : id,
      'titleVi': titleVi,
      'titleEn': titleEn,
      'shortName': shortName,
      'avatar': avatar,
      'barcode': barcode,
      'sku': sku,
      'measureUnit': measureUnit,
      'price': price,
      'originalPrice': originalPrice,
      'costPrice': costPrice,
      'wholesalePrice': wholesalePrice,
      'slotBuy': slotBuy,
      'availableQuantity': availableQuantity,
      'status': status,
      'isSaleAllowed': isSaleAllowed,
      'isInventoryManaged': isInventoryManaged,
      'isOnWebsite': isOnWebsite,
      'isCanPacking': isCanPacking,
      'imageDetail': imageDetail,
    };
  }

  /// Get display name (prefer Vietnamese title)
  String get displayName => titleVi ?? titleEn ?? shortName ?? 'Sản phẩm';
}
