import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/widgets/widgets.dart';

/// Header cho bottom sheet với title và nút đóng (tùy chọn).
///
/// Tùy biến: style title, màu/độ dày border bottom, padding, icon đóng
/// hoặc truyền hẳn widget close button riêng. Close button tự ẩn nếu
/// không có `onClose`, hoặc ép ẩn/hiện bằng `showCloseButton`.
///
/// Ví dụ nhanh:
/// ```dart
/// BottomSheetHeader(
///   title: 'Hình thức thanh toán', -> string | widget 
///   onClose: () => Navigator.pop(context),
///   titleStyle: AppStyles.text.semiBold(fSize: 16.sp),
///   borderColor: AppColors.greyC0,
/// )
/// ```
class BottomSheetHeader extends StatelessWidget {
  /// Title hiển thị (required)
  ///
  /// Ví dụ: 'Hình thức thanh toán', 'Chọn địa chỉ'
  final Object title;

  /// Callback khi tap vào close button (optional)
  ///
  /// Nếu null, close button sẽ không hiển thị.
  /// Thường được sử dụng để đóng bottom sheet: `() => Navigator.pop(context)`
  final VoidCallback? onClose;

  /// Hiển thị close button hay không (optional)
  ///
  /// Mặc định: true nếu [onClose] không null, false nếu [onClose] null.
  /// Có thể set false để ẩn close button ngay cả khi có [onClose].
  final bool? showCloseButton;

  /// Style của title text (optional)
  ///
  /// Mặc định: AppStyles.text.semiBold(fSize: 16.sp)
  final TextStyle? titleStyle;

  /// Màu border bottom (optional)
  ///
  /// Mặc định: AppColors.greyC0
  final Color? borderColor;

  /// Padding cho header (optional)
  ///
  /// Mặc định: EdgeInsets.fromLTRB(20.w, 10.h, 12.w, 5.h)
  final EdgeInsets? padding;

  /// Main axis alignment của RowWidget (optional)
  ///
  /// Mặc định: MainAxisAlignment.spaceBetween
  final MainAxisAlignment? mainAxisAlignment;

  /// Custom close button widget (optional)
  ///
  /// Nếu null, sẽ sử dụng default close button với [Icons.close].
  /// Có thể truyền custom widget để thay đổi icon hoặc style.
  final Widget? closeButton;

  /// Padding cho close button container (optional)
  ///
  /// Mặc định: EdgeInsets.all(4.w)
  /// Chỉ áp dụng khi [closeButton] là null.
  final EdgeInsets? closeButtonPadding;

  /// Icon cho close button (optional)
  ///
  /// Mặc định: Icons.close
  /// Chỉ áp dụng khi [closeButton] là null.
  final IconData? closeIcon;

  /// Màu của close icon (optional)
  ///
  /// Mặc định: AppColors.grey84
  /// Chỉ áp dụng khi [closeButton] là null.
  final Color? closeIconColor;

  /// Size của close icon (optional)
  ///
  /// Mặc định: 24.sp
  /// Chỉ áp dụng khi [closeButton] là null.
  final double? closeIconSize;

  const BottomSheetHeader({
    super.key,
    required this.title,
    this.onClose,
    this.showCloseButton,
    this.titleStyle,
    this.borderColor,
    this.padding,
    this.mainAxisAlignment,
    this.closeButton,
    this.closeButtonPadding,
    this.closeIcon,
    this.closeIconColor,
    this.closeIconSize,
  });

  /// Check xem có nên hiển thị close button hay không
  bool get _shouldShowCloseButton {
    if (showCloseButton != null) {
      return showCloseButton!;
    }
    return onClose != null;
  }

  /// Build close button widget
  Widget _buildCloseButton() {
    if (closeButton != null) {
      return InkWell(onTap: onClose, child: closeButton!);
    }

    return InkWell(
      onTap: onClose,
      child: Container(
        padding: closeButtonPadding ?? EdgeInsets.all(4.w),
        child: Icon(
          closeIcon ?? Icons.close,
          color: closeIconColor ?? AppColors.grey84,
          size: closeIconSize ?? 24.sp,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RowWidget(
      padding: padding ?? EdgeInsets.fromLTRB(20.w, 10.h, 12.w, 5.h),
      border: Border(
        bottom: BorderSide(color: borderColor ?? AppColors.greyC0),
      ),
      mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.spaceBetween,
      children: [
        if (title is String)
          Text(
            title as String,
            style: titleStyle ?? AppStyles.text.semiBold(fSize: 16.sp),
          )
        else if (title is Widget)
          title as Widget,
        if (_shouldShowCloseButton) _buildCloseButton(),
      ],
    );
  }
}
