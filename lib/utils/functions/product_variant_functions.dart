import 'dart:convert';
import 'dart:ui';

import '../../data/models/product/product_variant.dart'
    show ProductVariant, ProductVariantOption;
import '../../res/res.dart';

/// Render product variant title + options (pattern tương tự JS renderProductVariantTitle)
/// - Ưu tiên titleVi/titleEn từ product nếu có; fallback productNameVi/productNameEn
/// - Options: hỗ trợ List<ProductVariantOption>, List<dynamic>, hoặc chuỗi JSON list
/// - Ngăn null/empty và join bằng " - "
/// Example:
/// ```dart
/// final product = ProductVariant(
///   product: Product(
///     titleVi: 'Cà phê đen',
///     titleEn: 'Black coffee',
///   ),
/// );
/// final title = renderProductVariantTitle(product);
/// // Result: "Cà phê đen - Black coffee"
/// ```
///
/// Parameters:
/// - item: ProductVariant object
/// - language: Language code ('vi' or 'en')
///
/// Returns formatted string or AppConstant.strings.DEFAULT_EMPTY_VALUE if no data available
///
String renderProductVariantTitle(
  ProductVariant? item, {
  String language = 'vi',
}) {
  final List<String> titleArr = [];

  // Title
  String? title;
  if (item?.product != null) {
    title = language == 'vi'
        ? (item?.product?.titleVi ?? item?.product?.titleEn)
        : (item?.product?.titleEn ?? item?.product?.titleVi);
  } else if (item != null) {
    final titleVi = _getDynamicValue(item, 'titleVi');
    final titleEn = _getDynamicValue(item, 'titleEn');
    if (titleVi != null || titleEn != null) {
      title = language == 'vi' ? (titleVi ?? titleEn) : (titleEn ?? titleVi);
    } else {
      final productNameVi = _getDynamicValue(item, 'productNameVi');
      final productNameEn = _getDynamicValue(item, 'productNameEn');
      title = language == 'vi'
          ? (productNameVi ?? productNameEn)
          : (productNameEn ?? productNameVi);
    }
  }
  if (title != null && title.trim().isNotEmpty) {
    titleArr.add(title.trim());
  }

  // Options
  final dynamic optionsDynamic = item?.options;
  final List<String> optionValues = [];

  void addOptionValue(String? v) {
    if (v != null && v.trim().isNotEmpty) optionValues.add(v.trim());
  }

  if (optionsDynamic is List<ProductVariantOption>) {
    for (final opt in optionsDynamic) {
      addOptionValue(opt.value);
    }
  } else if (optionsDynamic is List) {
    for (final opt in optionsDynamic) {
      if (opt is Map && opt['value'] != null) {
        addOptionValue(opt['value']?.toString());
      } else {
        addOptionValue(opt?.toString());
      }
    }
  } else if (optionsDynamic is String && optionsDynamic.trim().isNotEmpty) {
    try {
      final decoded = json.decode(optionsDynamic);
      if (decoded is List) {
        for (final opt in decoded) {
          if (opt is Map && opt['value'] != null) {
            addOptionValue(opt['value']?.toString());
          } else {
            addOptionValue(opt?.toString());
          }
        }
      }
    } catch (_) {
      // ignore parse errors, keep title only
    }
  }

  if (optionValues.isNotEmpty) {
    titleArr.addAll(optionValues);
  }

  return titleArr.isNotEmpty
      ? titleArr.join(' - ')
      : AppConstant.strings.DEFAULT_EMPTY_VALUE;
}

String? _getDynamicValue(dynamic item, String key) {
  if (item == null) return null;
  try {
    if (item is Map) {
      final value = item[key];
      return value?.toString();
    }
    return null;
  } catch (_) {
    return null;
  }
}

Color? renderVariantStatusColor(String? status) {
  switch (status) {
    case "PAUSED":
      return AppColors.scarlet;
    case "ACTIVE":
      return AppColors.success;
    default:
      return null;
  }
}

String? renderVariantStatus(String? status) {
  switch (status) {
    case "ACTIVE":
      return "Đang giao dịch";
    case "PAUSED":
      return "Ngừng giao dịch";
    default:
      return null;
  }
}
