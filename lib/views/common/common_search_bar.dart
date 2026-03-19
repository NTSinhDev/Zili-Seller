import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../res/res.dart';

class CommonSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onScanBarcode;
  final String hintSearch;
  final FocusNode? focusNode;

  //
  final EdgeInsetsGeometry? padding;
  const CommonSearchBar({
    super.key,
    required this.controller,
    required this.hintSearch,
    this.leadingWrapper,
    this.onScanBarcode,
    this.padding,
    this.focusNode,
  });

  final Widget Function(BuildContext context, Widget child, Widget loading)?
  leadingWrapper;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? .symmetric(horizontal: 20.w, vertical: 16.h),
      color: AppColors.white,
      child: Container(
        height: 48.h,
        decoration: BoxDecoration(
          color: AppColors.lightGrey,
          borderRadius: .circular(8.r),
        ),
        child: Row(
          crossAxisAlignment: .center,
          children: [
            Padding(
              padding: .only(left: 16.w),
              child: leadingWrapper != null
                  ? leadingWrapper!(
                      context,
                      const Icon(Icons.search, color: AppColors.grey84),
                      Container(
                        width: 20.w,
                        height: 20.w,
                        margin: EdgeInsets.all(2.w),
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          backgroundColor: AppColors.greyC0,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primary,
                          ),
                        ),
                      ),
                    )
                  : const Icon(Icons.search, color: AppColors.grey84),
            ),
            Expanded(
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                autofocus: false,
                style: AppStyles.text.medium(fSize: 14.sp),
                onTapOutside: (event) => focusNode?.unfocus(),
                decoration: InputDecoration(
                  hintText: hintSearch,
                  hintStyle: AppStyles.text.medium(
                    fSize: 14.sp,
                    color: AppColors.grey84,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
                ),
              ),
            ),
            if (onScanBarcode != null)
              InkWell(
                onTap: onScanBarcode,
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  child: SvgPicture.asset(
                    AppConstant.svgs.icBarcode,
                    width: 24.sp,
                    height: 24.sp,
                    colorFilter: const ColorFilter.mode(
                      AppColors.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
