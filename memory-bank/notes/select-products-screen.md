# SelectProductsScreen - Context

> Đoạn chat về SelectProductsScreen và Order Module integration

## ✅ Đã thực hiện trong đoạn chat này

### 1. SelectProductsScreen Implementation
- File: `lib/views/order/create_order/select_products_screen.dart`
- Features: Product search, pagination, variant selection, barcode scanning
- State management: Local state với OrderMiddleware
- Output format: List<Map<String, dynamic>> với selected products

### 2. OrderProduct Model
- File: `lib/data/models/product/order_product.dart`
- Fields: id, avatar, titleVi, titleEn, shortName, barcode, sku, measureUnit, price, productVariants, availableQuantity
- Helper methods: displayName, displayUnit, hasVariants (length > 1), firstVariant
- Parsing: fromMap(), toMap(), toJson() với error handling

### 3. ProductVariant Model
- File: `lib/data/models/product/product_variant.dart`
- Fields: id, options (List<ProductVariantOption>), imageVariant, price, inventory, sku, barcode, availableQuantity (String), status
- Note: availableQuantity stored as String, needs double.tryParse() when used

### 4. OrderMiddleware.getProductsForOrder()
- File: `lib/data/middlewares/order_middleware.dart`
- Method: getProductsForOrder() với params: limit, offset, keyword, branchId
- Uses coreDio for Core Service API
- Returns ResponseState với {count, products: List<OrderProduct>}

### 5. OrderRepository Warehouse Management
- File: `lib/data/repositories/order_repository.dart`
- Uses BehaviorSubject<List<Warehouse>> for reactive updates
- Auto-selects default warehouse
- Provides warehousesStream và selectedWarehouse

### 6. UI Components
- _ProductListItem: Displays product with selection state
- _ProductSearchBar: Search input với QR scanner icon
- Variant selector: Bottom sheet để chọn variant
- Loading state: LoadingAnimationWidget.flickr

### 7. Bug Fixes
- Fixed pagination load more: _allProducts.addAll(products) khi loadMore = true
- Fixed price formatting: Sử dụng toInt().toPrice() thay vì toPrice() trực tiếp

## 📁 Files đã tạo/sửa

**Core Files:**
- `lib/views/order/create_order/select_products_screen.dart` - Main screen
- `lib/data/models/product/order_product.dart` - Product model
- `lib/data/models/product/product_variant.dart` - Variant model
- `lib/data/middlewares/order_middleware.dart` - Added getProductsForOrder()
- `lib/data/repositories/order_repository.dart` - Warehouse management
- `lib/data/network/network_common.dart` - Added coreDio instance
- `lib/data/network/network_url.dart` - Added _OrderProduct class

**Component Files:**
- `lib/views/order/create_order/components/product_list_item.dart`
- `lib/views/order/create_order/components/product_search_bar.dart`
- `lib/views/order/create_order/components/selected_product_item.dart`

**Integration Files:**
- `lib/views/order/create_order/create_order_screen.dart` - Integration với SelectProductsScreen
- `lib/app/app_wireframe.dart` - Routing configuration

## ⚠️ Lưu ý

### Known Issues
- Price được lưu dạng String trong selected products, cần convert khi tính toán
- hasVariants logic: length > 1 (sản phẩm có 1 variant được coi là không có variants)
- Selected product detection có thể không chính xác với multiple variants
- Pagination: Chưa có scroll to load more UI (code đã sẵn sàng)
- Barcode scanner: Chỉ set text vào search field, chưa auto-select product

### Important Patterns
- Debounce search: 500ms với EasyDebounce
- Pagination: limit 20, offset-based
- Variant selection: Bottom sheet với disable nếu available <= 0
- Price formatting: Sử dụng extension toPrice() cho int/num
- Selected state: Background color + border để indicate

### Data Format
Selected product format:
```dart
{
  'productId': String,
  'variantId': String?,
  'name': String,
  'unit': String,
  'price': String, // Lưu dạng string!
  'image': String,
  'available': num,
  'sku': String,
  'barcode': String,
  'quantity': int,
  'product': Map<String, dynamic>, // Full OrderProduct.toMap()
  'variant': Map<String, dynamic>?, // Full ProductVariant.toMap()
}
```

## 🔜 Chưa hoàn thành / Cần làm tiếp

- [ ] Implement scroll to load more UI
- [ ] Fix selected product detection logic cho multiple variants
- [ ] Convert price từ String về num khi tính toán trong CreateOrderScreen
- [ ] Handle barcode scan result để auto-select product
- [ ] Add product filtering by category
- [ ] Add sorting options (price, name, etc.)
- [ ] Add product detail view
- [ ] Handle edge cases: empty variants, out of stock, etc.

