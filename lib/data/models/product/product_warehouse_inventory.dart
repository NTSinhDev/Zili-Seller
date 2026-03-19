import '../../../utils/functions/base_functions.dart';
import '../warehouse/warehouse.dart';

/// Product Warehouse Inventory Model
///
/// Model đại diện cho thông tin tồn kho sản phẩm tại các kho
/// API: GET /company/product/warehouse/{productId}
///
/// Response structure:
/// {
///   "listData": [
///     {
///       "id": "...",
///       "warehouseId": "...",
///       "warehouse": { ... },
///       "quantityPurchased": 0,
///       "quantityInStock": 0,
///       "inventory": 0,
///       "status": "IN_STOCK",
///       "createdAt": "...",
///       "updatedAt": "...",
///       "variantsWarehouse": [...],
///       "slotBuy": 9,
///       "transactionCount": 0,
///       "inTransitCount": 0,
///       "deliveryCount": 0,
///       "availableQuantity": 9,
///       "minStock": null,
///       "maxStock": null,
///       "location": null
///     }
///   ],
///   "total": 4
/// }
class ProductWarehouseInventory {
  final String id;
  final String warehouseId;
  final Warehouse? warehouse;
  final num quantityPurchased;
  final num quantityInStock;
  final num inventory;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<ProductWarehouseVariantInventory> variantsWarehouse;
  final num slotBuy;
  final num transactionCount;
  final num inTransitCount;
  final num deliveryCount;
  final num availableQuantity;
  final num? minStock;
  final num? maxStock;
  final String? location;

  ProductWarehouseInventory({
    required this.id,
    required this.warehouseId,
    this.warehouse,
    required this.quantityPurchased,
    required this.quantityInStock,
    required this.inventory,
    required this.status,
    this.createdAt,
    this.updatedAt,
    required this.variantsWarehouse,
    required this.slotBuy,
    required this.transactionCount,
    required this.inTransitCount,
    required this.deliveryCount,
    required this.availableQuantity,
    this.minStock,
    this.maxStock,
    this.location,
  });

  factory ProductWarehouseInventory.fromMap(Map<String, dynamic> map) {
    return ProductWarehouseInventory(
      id: map['id']?.toString() ?? '',
      warehouseId: map['warehouseId']?.toString() ?? '',
      warehouse: map['warehouse'] is Map<String, dynamic>
          ? Warehouse.fromMap(map['warehouse'] as Map<String, dynamic>)
          : null,
      quantityPurchased: (map['quantityPurchased'] as num?) ?? 0,
      quantityInStock: (map['quantityInStock'] as num?) ?? 0,
      inventory: (map['inventory'] as num?) ?? 0,
      status: map['status']?.toString() ?? '',
      createdAt: parseServerTimeZoneDateTime(map['createdAt']),
      updatedAt: parseServerTimeZoneDateTime(map['updatedAt']),
      variantsWarehouse: map['variantsWarehouse'] is List
          ? (map['variantsWarehouse'] as List)
                .whereType<Map<String, dynamic>>()
                .map(ProductWarehouseVariantInventory.fromMap)
                .toList()
          : [],
      slotBuy: (map['slotBuy'] as num?) ?? 0,
      transactionCount: (map['transactionCount'] as num?) ?? 0,
      inTransitCount: (map['inTransitCount'] as num?) ?? 0,
      deliveryCount: (map['deliveryCount'] as num?) ?? 0,
      availableQuantity: (map['availableQuantity'] as num?) ?? 0,
      minStock: (map['minStock'] as num?),
      maxStock: (map['maxStock'] as num?),
      location: map['location']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'warehouseId': warehouseId,
      if (warehouse != null) 'warehouse': warehouse?.toMap(),
      'quantityPurchased': quantityPurchased,
      'quantityInStock': quantityInStock,
      'inventory': inventory,
      'status': status,
      if (createdAt != null) 'createdAt': createdAt?.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toIso8601String(),
      'variantsWarehouse': variantsWarehouse.map((v) => v.toMap()).toList(),
      'slotBuy': slotBuy,
      'transactionCount': transactionCount,
      'inTransitCount': inTransitCount,
      'deliveryCount': deliveryCount,
      'availableQuantity': availableQuantity,
      if (minStock != null) 'minStock': minStock,
      if (maxStock != null) 'maxStock': maxStock,
      if (location != null) 'location': location,
    };
  }
}

/// Product Warehouse Variant Inventory Model
///
/// Model đại diện cho thông tin tồn kho của từng variant tại warehouse
class ProductWarehouseVariantInventory {
  final String id;
  final num inventoryVariant;
  final ProductWarehouseVariantInfo? productVariant;
  final String warehouseId;
  final ProductWarehouseInfo? productWarehouse;
  final num slotBuy;
  final num baseCost;
  final num transactionCount;
  final num inTransitCount;
  final num deliveryCount;
  final num availableQuantity;
  final String? location;

  ProductWarehouseVariantInventory({
    required this.id,
    required this.inventoryVariant,
    this.productVariant,
    required this.warehouseId,
    this.productWarehouse,
    required this.slotBuy,
    required this.baseCost,
    required this.transactionCount,
    required this.inTransitCount,
    required this.deliveryCount,
    required this.availableQuantity,
    this.location,
  });

  factory ProductWarehouseVariantInventory.fromMap(Map<String, dynamic> map) {
    return ProductWarehouseVariantInventory(
      id: map['id']?.toString() ?? '',
      inventoryVariant: (map['inventoryVariant'] as num?) ?? 0,
      productVariant: map['productVariant'] is Map<String, dynamic>
          ? ProductWarehouseVariantInfo.fromMap(
              map['productVariant'] as Map<String, dynamic>,
            )
          : null,
      warehouseId: map['warehouseId']?.toString() ?? '',
      productWarehouse: map['productWarehouse'] is Map<String, dynamic>
          ? ProductWarehouseInfo.fromMap(
              map['productWarehouse'] as Map<String, dynamic>,
            )
          : null,
      slotBuy: (map['slotBuy'] as num?) ?? 0,
      baseCost: (map['baseCost'] as num?) ?? 0,
      transactionCount: (map['transactionCount'] as num?) ?? 0,
      inTransitCount: (map['inTransitCount'] as num?) ?? 0,
      deliveryCount: (map['deliveryCount'] as num?) ?? 0,
      availableQuantity: (map['availableQuantity'] as num?) ?? 0,
      location: map['location']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'inventoryVariant': inventoryVariant,
      if (productVariant != null) 'productVariant': productVariant?.toMap(),
      'warehouseId': warehouseId,
      if (productWarehouse != null)
        'productWarehouse': productWarehouse?.toMap(),
      'slotBuy': slotBuy,
      'baseCost': baseCost,
      'transactionCount': transactionCount,
      'inTransitCount': inTransitCount,
      'deliveryCount': deliveryCount,
      'availableQuantity': availableQuantity,
      if (location != null) 'location': location,
    };
  }
}

/// Product Warehouse Variant Info (nested object)
class ProductWarehouseVariantInfo {
  final String id;

  ProductWarehouseVariantInfo({required this.id});

  factory ProductWarehouseVariantInfo.fromMap(Map<String, dynamic> map) {
    return ProductWarehouseVariantInfo(id: map['id']?.toString() ?? '');
  }

  Map<String, dynamic> toMap() {
    return {'id': id};
  }
}

/// Product Warehouse Info (nested object)
class ProductWarehouseInfo {
  final String id;

  ProductWarehouseInfo({required this.id});

  factory ProductWarehouseInfo.fromMap(Map<String, dynamic> map) {
    return ProductWarehouseInfo(id: map['id']?.toString() ?? '');
  }

  Map<String, dynamic> toMap() {
    return {'id': id};
  }
}

/// Result model for product warehouse inventory list with pagination
class ProductWarehouseInventoryResult {
  final List<ProductWarehouseInventory> items;
  final int total;

  ProductWarehouseInventoryResult({required this.items, required this.total});
}
