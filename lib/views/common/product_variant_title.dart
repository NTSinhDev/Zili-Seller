import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/models/product/product_variant.dart';
import '../../res/res.dart';
import '../../utils/functions/order_function.dart';
import '../../app/app_wireframe.dart';
import '../../utils/widgets/widgets.dart';

enum LayoutDirection {
  /// **Sample Output:**
  /// ```dart
  /// "Cà phê đen" -> Tên sản phẩm (hoặc phiên bản)
  /// "Loại Arabica" -> option đã chọn cho phiên bản/sản phẩm (name - value)
  /// "T00029" -> SKU của sản phẩm (nếu cho phép hiển thị)
  /// ```
  vertical,

  /// **Sample Output:**
  /// ```dart
  /// "Cà phê đen - Loại Arabica" -> Tên sản phẩm (hoặc phiên bản) - option đã chọn cho phiên bản/sản phẩm (name - value)
  /// "T00029" -> SKU của sản phẩm (nếu cho phép hiển thị)
  /// ```
  horizontal,
}

/// Widget to display product variant title, options, and SKU link.
///
/// Similar to React component `ProductVariantTitle`, displays:
/// - Product title (with language preference)
/// - Variant options (if available)
/// - SKU link (if available and showSKU is true)
///
/// **Example:**
/// ```dart
/// ProductVariantTitleWidget(
///   data: productVariant,
///   showSKU: true,
/// )
/// **Sample Output:**
/// ```dart
/// "Cà phê đen" -> Tên sản phẩm (hoặc phiên bản)
/// "Loại Arabica" -> option đã chọn cho phiên bản/sản phẩm (name - value)
/// "T00029" -> SKU của sản phẩm (nếu cho phép hiển thị)
/// ```
/// ```
class ProductVariantTitleWidget extends StatelessWidget {
  /// Product variant data to display
  final ProductVariant data;

  /// Whether to show SKU link. Defaults to `true`.
  final bool showSKU;

  /// Layout direction. Defaults to `vertical`.
  final LayoutDirection layoutDirection;

  final TextStyle? titleStyle;
  final TextStyle? optionsStyle;
  final TextStyle? skuStyle;

  const ProductVariantTitleWidget({
    super.key,
    required this.data,
    this.showSKU = true,
    this.layoutDirection = .vertical,
    this.titleStyle,
    this.optionsStyle,
    this.skuStyle,
  });

  /// Get product title with language preference.
  ///
  /// Priority:
  /// 1. product.titleVi/product.titleEn from data.product
  /// 2. Fallback to other available title
  String _getProductTitle(BuildContext context) {
    final language = Localizations.localeOf(context).languageCode;
    String? titleVi;
    String? titleEn;

    // Check for product.titleVi/product.titleEn
    if (data.product != null) {
      final product = data.product;
      if (product?.titleVi != null || product?.titleEn != null) {
        titleVi = product?.titleVi;
        titleEn = product?.titleEn;
      }
    }

    // Return based on language preference
    if (language == 'vi') {
      return titleVi ?? titleEn ?? '';
    } else {
      return titleEn ?? titleVi ?? '';
    }
  }

  /// Get variant options as formatted string.
  ///
  /// Handles both List<ProductVariantOption> and JSON string.
  String _getVariantOptions() {
    if (data.options.isEmpty) {
      return '';
    }

    // Use existing renderVariantOptions function
    final options = renderVariantOptions(data.options);
    return options ?? '';
  }

  /// Get product ID for navigation.
  ///
  /// Returns product.id from data.product, or productId from data.
  String? _getProductId() {
    return data.product?.id ?? data.productId;
  }

  @override
  Widget build(BuildContext context) {
    final productTitle = _getProductTitle(context);
    final variantOptions = _getVariantOptions();
    final sku = data.sku;
    final productId = _getProductId();

    return GestureDetector(
      onTap: () {
        if (sku != null && showSKU && productId != null) {
          // Navigate to product detail
          // Note: In React version, it navigates to product detail with variantId
          // In Flutter, we navigate to company product details
          AppWireFrame.navigateToCompanyProductDetails(
            context,
            productId: productId,
          );
        }
      },
      child: ColumnWidget(
        crossAxisAlignment: .start,
        mainAxisSize: .min,
        gap: 4.h,
        children: [
          if (layoutDirection == LayoutDirection.vertical)
            CustomRichTextWidget(
              defaultStyle:
                  titleStyle ??
                  AppStyles.text.bold(
                    fSize: 14.sp,
                    color: AppColors.black3,
                    height: 1.2,
                  ),
              texts: [
                productTitle,
                if (variantOptions.isNotEmpty)
                  TextSpan(
                    text: " - $variantOptions",
                    style:
                        optionsStyle ??
                        AppStyles.text.medium(
                          fSize: 12.sp,
                          color: AppColors.grey84,
                          height: 1.2,
                        ),
                  ),
              ],
            )
          else ...[
            // Product title
            if (productTitle.isNotEmpty)
              Text(
                productTitle,
                style:
                    titleStyle ??
                    AppStyles.text.bold(
                      fSize: 14.sp,
                      color: AppColors.black3,
                      height: 1.2,
                    ),
                maxLines: 2,
                overflow: .ellipsis,
              ),

            // Variant options
            if (variantOptions.isNotEmpty) ...[
              Text(
                variantOptions,
                style:
                    optionsStyle ??
                    AppStyles.text.medium(
                      fSize: 12.sp,
                      color: AppColors.grey84,
                    ),
                maxLines: 2,
                overflow: .ellipsis,
              ),
            ],
          ],
          // SKU link
          if (sku != null && showSKU) ...[
            Text(
              sku,
              style:
                  skuStyle ??
                  AppStyles.text.semiBold(
                    fSize: 12.sp,
                    color: AppColors.primary,
                  ),
              maxLines: 1,
              overflow: .ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}
