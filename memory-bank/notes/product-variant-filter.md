# Product Variant Filter - Context

> Mỗi file context đại diện cho 1 đoạn chat, ghi lại những gì đã thực hiện

## ✅ Đã thực hiện trong đoạn chat này

### 1. Tạo ProductEntity và ProductVariantEntity
- Tạo file: `lib/data/entity/product/product_entity.dart`
- Nội dung: Convert từ TypeORM entity sang Dart class với đầy đủ fields, enums (`ProductStatus`, `ProductType`, `WalletCaseBackWallet`), và methods (`fromMap`, `fromJson`, `toMap`, `toJson`, `copyWith`)

- Tạo file: `lib/data/entity/product/product_variant_entity.dart`
- Nội dung: Convert từ TypeORM entity sang Dart class với enums (`ProductVariantStatus`, `CalculateByUnit`) và các methods tương tự

### 2. Tạo Output Models
- Tạo file: `lib/data/use_cases/product/output/product_output.dart`
- Nội dung: DTO cho Product, expose các thuộc tính cần thiết cho presentation layer

- Tạo file: `lib/data/use_cases/product/output/product_variant_output.dart`
- Nội dung: DTO cho ProductVariant với factory method `fromEntity()`, tự động parse `options` từ JSON string sang dynamic object (tương tự `@Transform` trong TypeScript)

### 3. Tạo UseCase
- Tạo file: `lib/data/use_cases/product/product_variant_filter.dart`
- Nội dung: Class `ProductVariantFilterUseCases` với method `filterProductVariants()` để lọc variants và map từ entities sang outputs

### 4. Tích hợp API trong Middleware
- Sửa file: `lib/data/middlewares/order_middleware.dart`
- Thay đổi: Thêm method `getProductVariantsFilter()` (dòng 230-306) gọi API `GET company/product/variant/filter`, parse response thành `List<ProductVariantEntity>`, và fix import `ProductVariantEntity`

### 5. Tạo Test Files
- Tạo file: `test/api/core/product/product_variant_filter.http`
- Nội dung: REST Client test file với nhiều test cases, sử dụng variables từ `variables.http`

- Tạo file: `test/api/variables.http`
- Nội dung: Shared variables (`@domain`, `@coreBaseUrl`, `@token`, `@contentType`, `@accept`)

- Tạo file: `test/api/README.md`
- Nội dung: Documentation về cách test API theo service structure

### 6. Tạo Memory Bank Pattern
- Tạo thư mục: `memory-bank/` và các file template, README để lưu context cho các đoạn chat sau

## 📁 Files đã tạo/sửa

- `lib/data/entity/product/product_entity.dart` - Product entity từ TypeORM
- `lib/data/entity/product/product_variant_entity.dart` - ProductVariant entity từ TypeORM
- `lib/data/use_cases/product/product_variant_filter.dart` - UseCase để filter variants
- `lib/data/use_cases/product/output/product_output.dart` - Product output model
- `lib/data/use_cases/product/output/product_variant_output.dart` - ProductVariant output model
- `lib/data/middlewares/order_middleware.dart` - Thêm method `getProductVariantsFilter()`
- `test/api/core/product/product_variant_filter.http` - API test file
- `test/api/variables.http` - Shared variables
- `test/api/README.md` - Test documentation
- `memory-bank/README.md` - Memory bank hướng dẫn
- `memory-bank/CONTEXT_TEMPLATE.md` - Context template
- `memory-bank/product-variant-filter.md` - Context này

## ⚠️ Lưu ý

- Middleware đang dùng hardcode URL `'company/product/variant/filter'` thay vì `NetworkUrl.productVariant.filter()`
- Chưa test API thực tế để xác nhận response structure, có thể cần điều chỉnh parsing logic
- `ProductVariantOutput` tự động parse `options` từ JSON string sang dynamic object
- Middleware trả về entities, UseCase map sang outputs (theo Clean Architecture)

## 🔜 Chưa hoàn thành / Cần làm tiếp

- [ ] Thêm `_ProductVariant` class vào `NetworkUrl` và sử dụng trong middleware thay vì hardcode
- [ ] Test API thực tế để xác nhận response structure
- [ ] Điều chỉnh parsing logic nếu response structure khác với expected
- [ ] Implement `filterProductVariantsWithProduct()` nếu cần product info kèm theo

