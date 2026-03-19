import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/widgets/widgets.dart';

/// Button mở bottom sheet chọn từ danh sách (label + value/placeholder).
///
/// Tùy biến: màu/background/border, icon/trailing, font size label/value,
/// placeholder khi chưa chọn. Tự đổi màu value/placeholder theo trạng thái.
///
/// Ví dụ nhanh:
/// ```dart
/// OpenBottomSheetListButton(
///   label: 'Hình thức thanh toán', // String hoặc Widget
///   value: selectedPaymentMethod?.displayName,
///   placeholder: 'Chọn hình thức',
///   onTap: showPaymentMethodSelector,
/// )
/// ```
///
/// Xem thêm:
/// - BottomSheetListItem: item trong bottom sheet list
/// - CustomModalBottomSheet: wrapper cho bottom sheet
class OpenBottomSheetListButton extends StatelessWidget {
  /// Label hiển thị phía trên (required)
  ///
  /// Ví dụ: 'Hình thức thanh toán', 'Địa chỉ giao hàng'
  final Object label;

  /// Value hiển thị phía dưới (optional)
  ///
  /// Nếu null hoặc empty, sẽ hiển thị [placeholder] thay thế.
  /// Màu text sẽ tự động đổi: đen nếu có value, xám nếu không có.
  final String? value;

  /// Placeholder text khi value null hoặc empty (optional)
  ///
  /// Mặc định: empty string ''.
  /// Nên cung cấp placeholder có ý nghĩa để hướng dẫn người dùng.
  ///
  /// Ví dụ: 'Chọn hình thức', 'Chọn địa chỉ'
  final String? placeholder;

  /// Callback khi tap vào button (required)
  ///
  /// Thường được sử dụng để mở bottom sheet với danh sách options.
  final VoidCallback onTap;

  /// Màu nền của container (optional)
  ///
  /// Mặc định: [AppColors.white]
  final Color? backgroundColor;

  /// Màu border của container (optional)
  ///
  /// Mặc định: [AppColors.greyC0]
  final Color? borderColor;

  /// Màu text của label (optional)
  ///
  /// Mặc định: [AppColors.grey84]
  final Color? labelTextColor;

  /// Màu text của value khi có giá trị (optional)
  ///
  /// Mặc định: [AppColors.black3]
  /// Chỉ áp dụng khi [value] không null và không empty.
  final Color? valueTextColor;

  /// Màu text của placeholder khi không có value (optional)
  ///
  /// Mặc định: [AppColors.grey84]
  /// Chỉ áp dụng khi [value] null hoặc empty.
  final Color? placeholderTextColor;

  /// Font size của label (optional)
  ///
  /// Mặc định: 12.sp
  final double? labelFontSize;

  /// Font size của value/placeholder (optional)
  ///
  /// Mặc định: 14.sp
  final double? valueFontSize;

  /// Padding cho container (optional)
  ///
  /// Mặc định: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h)
  final EdgeInsetsGeometry? padding;

  /// Border radius của container (optional)
  ///
  /// Mặc định: 8.r
  final double? borderRadius;

  /// Custom trailing widget (optional)
  ///
  /// Nếu null, sẽ sử dụng [Icons.chevron_right] với [trailingIconSize] và [trailingIconColor].
  /// Có thể truyền custom widget để thay đổi icon hoặc thêm các widget khác.
  final Widget? trailing;

  /// Size của icon trailing (optional)
  ///
  /// Mặc định: 24.sp
  /// Chỉ áp dụng khi [trailing] là null.
  final double? trailingIconSize;

  /// Màu của icon trailing (optional)
  ///
  /// Mặc định: [AppColors.grey84]
  /// Chỉ áp dụng khi [trailing] là null.
  final Color? trailingIconColor;

  const OpenBottomSheetListButton({
    super.key,
    required this.label,
    this.value,
    this.placeholder,
    required this.onTap,
    this.backgroundColor,
    this.borderColor,
    this.labelTextColor,
    this.valueTextColor,
    this.placeholderTextColor,
    this.labelFontSize,
    this.valueFontSize,
    this.padding,
    this.borderRadius,
    this.trailing,
    this.trailingIconSize,
    this.trailingIconColor,
    this.disable,
  });

  final bool? disable;

  /// Get display value (value hoặc placeholder)
  String get _displayValue {
    if (value != null && value!.isNotEmpty) {
      return value!;
    }
    return placeholder ?? '';
  }

  /// Check xem có value hay không (để đổi màu text)
  bool get _hasValue => value != null && value!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: disable ?? false ? null : onTap,
      child: Container(
        padding: padding ?? .symmetric(horizontal: 16.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: disable ?? false
              ? AppColors.greyC0.withValues(alpha: 0.3)
              : backgroundColor ?? AppColors.white,
          borderRadius: .circular(borderRadius ?? 8.r),
          border: .all(
            color: disable ?? false
                ? AppColors.greyC0
                : borderColor ?? AppColors.greyC0,
          ),
        ),
        child: RowWidget(
          mainAxisAlignment: .spaceBetween,
          children: [
            Expanded(
              child: ColumnWidget(
                crossAxisAlignment: .start,
                gap: 4.h,
                children: [
                  if (label is String)
                    Text(
                      label as String,
                      style: AppStyles.text.medium(
                        fSize: labelFontSize ?? 12.sp,
                        color: labelTextColor ?? AppColors.grey84,
                      ),
                    )
                  else if (label is Widget)
                    label as Widget,
                  Text(
                    _displayValue,
                    style: AppStyles.text.medium(
                      fSize: valueFontSize ?? 14.sp,
                      color: _hasValue
                          ? (valueTextColor ?? AppColors.black3)
                          : (placeholderTextColor ?? AppColors.grey84),
                    ),
                  ),
                ],
              ),
            ),
            if (!(disable ?? false))
              trailing ??
                  Icon(
                    Icons.chevron_right,
                    color: trailingIconColor ?? AppColors.grey84,
                    size: trailingIconSize ?? 24.sp,
                  ),
          ],
        ),
      ),
    );
  }
}
