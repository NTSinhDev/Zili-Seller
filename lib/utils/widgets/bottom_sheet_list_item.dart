import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/widgets/widgets.dart';

class BottomSheetListItem extends StatelessWidget {
  final Widget? leading;
  final String title;
  final String? subTitle;
  final String? content;
  final bool isDefault;
  final bool isSelected;
  final VoidCallback onTap;

  // Customization options
  final bool isDense;
  final String? defaultBadgeText;
  final Color? selectedBackgroundColor;
  final Color? selectedTextColor;
  final Color? unselectedTextColor;
  final Color? defaultBadgeColor;
  final Widget? trailing;
  final double? nameFontSize;
  final double? addressFontSize;
  final double? defaultBadgeFontSize;
  final int? addressMaxLines;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool disableTap;
  final double? leadingWidth;
  final double? leadingHeight;

  const BottomSheetListItem({
    super.key,
    this.leading,
    required this.title,
    this.subTitle,
    this.content,
    this.isDefault = false,
    this.isSelected = false,
    required this.onTap,
    this.defaultBadgeText,
    this.selectedBackgroundColor,
    this.selectedTextColor,
    this.unselectedTextColor,
    this.defaultBadgeColor,
    this.trailing,
    this.nameFontSize,
    this.addressFontSize,
    this.defaultBadgeFontSize,
    this.addressMaxLines,
    this.padding,
    this.margin,
    this.disableTap = false,
    this.isDense = false,
    this.leadingWidth,
    this.leadingHeight,
  });

  @override
  Widget build(BuildContext context) {
    final badgeText = defaultBadgeText ?? 'Mặc định';

    Widget widget = Container(
      color: isSelected
          ? (selectedBackgroundColor ?? AppColors.background)
          : null,
      child: ListTile(
        contentPadding: padding,
        leading: leading != null
            ? SizedBox(
                width: leadingWidth ?? (isDense ? 40.w : 56.w),
                height: leadingHeight ?? (isDense ? 40.w : 56.w),
                child: Center(child: leading),
              )
            : null,
        dense: isDense,
        visualDensity: isDense ? .compact : null,
        title: RowWidget(
          crossAxisAlignment: .end,
          gap: 8.w,
          children: [
            if (subTitle == null || subTitle == "")
              Expanded(
                child: Text(
                  title,
                  style: AppStyles.text.medium(
                    fSize: nameFontSize ?? 14.sp,
                    color: disableTap
                        ? AppColors.grey84
                        : (isSelected
                              ? (selectedTextColor ?? AppColors.primary)
                              : (unselectedTextColor ?? AppColors.black3)),
                    height: 16 / 14,
                  ),
                  maxLines: 2,
                  overflow: .ellipsis,
                ),
              )
            else
              Text(
                title,
                style: AppStyles.text.medium(
                  fSize: nameFontSize ?? 14.sp,
                  height: 16 / 14,
                  color: disableTap
                      ? AppColors.grey84
                      : (isSelected
                            ? (selectedTextColor ?? AppColors.primary)
                            : (unselectedTextColor ?? AppColors.black3)),
                ),
              ),
            if (subTitle != null && (subTitle ?? "").isNotEmpty)
              Text(
                subTitle!,
                style: AppStyles.text.medium(
                  fSize: 12.sp,
                  height: 14 / 12,
                  color: AppColors.grey84,
                ),
              ),
          ],
        ),
        isThreeLine: isDefault,
        subtitle: content != null
            ? Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    content!,
                    maxLines: addressMaxLines ?? 2,
                    overflow: .ellipsis,
                    style: AppStyles.text.medium(
                      fSize: addressFontSize ?? 12.sp,
                      color: AppColors.grey84,
                      height: 14 / 12,
                    ),
                  ),
                  if (isDefault) ...[
                    SizedBox(height: 4.h),
                    Text(
                      badgeText,
                      style: AppStyles.text.bold(
                        fSize: defaultBadgeFontSize ?? 10.sp,
                        color: defaultBadgeColor ?? AppColors.scarlet,
                      ),
                    ),
                  ],
                ],
              )
            : null,
        trailing:
            trailing ??
            (isSelected
                ? const Icon(Icons.check, color: AppColors.primary)
                : null),
        onTap: disableTap ? null : onTap,
      ),
    );

    if (margin != null) {
      return Padding(padding: margin!, child: widget);
    }

    return widget;
  }
}
