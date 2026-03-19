import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/widgets/widgets.dart';

class Voucher extends StatelessWidget {
  final int code;
  final DateTime expiry;
  const Voucher({
    super.key,
    required this.code,
    required this.expiry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Spaces.screenWidth(context),
      margin: EdgeInsets.only(top: 20.h),
      padding: EdgeInsets.symmetric(horizontal: 51.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        image: DecorationImage(
          alignment: Alignment.center,
          image: Image.asset(AppConstant.images.voucherFrame).image,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(AppConstant.svgs.minimalistLogoApp),
          width(width: 20.w),
          SvgPicture.asset(AppConstant.svgs.imgDividerDashed),
          width(width: 20.w),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomRichTextWidget(
                  defaultStyle: AppStyles.text.medium(fSize: 12.sp),
                  texts: [
                    'Mã Voucher:\t',
                    TextSpan(
                        text: '$code',
                        style: AppStyles.text.semiBold(
                          fSize: 12.sp,
                          color: AppColors.primary,
                        )),
                  ],
                ),
                height(height: 19),
                CustomRichTextWidget(
                  defaultStyle: AppStyles.text.medium(
                    fSize: 14.sp,
                    height: 1.31,
                  ),
                  texts: [
                    'Giảm:\t',
                    TextSpan(
                      text: '20.000${AppConstant.strings.VND}',
                      style: AppStyles.text.semiBold(fSize: 16.sp),
                    ),
                    '\tcho hóa đơn từ\t',
                    TextSpan(
                      text: '199.900${AppConstant.strings.VND}',
                      style: AppStyles.text.semiBold(fSize: 16.sp),
                    ),
                  ],
                ),
                height(height: _isOutOfDate() ? 19 : 7),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CustomRichTextWidget(
                      defaultStyle: AppStyles.text.medium(fSize: 12.sp),
                      texts: [
                        'HSD:\t',
                        TextSpan(
                          text: _isOutOfDate() ? 'Đã hết hạn' : '10/06/2023',
                          style: AppStyles.text.semiBold(
                            fSize: 12.sp,
                            color: _isOutOfDate() ? AppColors.red : null,
                          ),
                        ),
                      ],
                    ),
                    if (!_isOutOfDate()) ...[
                      const Spacer(),
                      CustomOutlineBtnWidget(
                        label: 'Sử dụng',
                        onTap: () {},
                      ),
                    ]
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  bool _isOutOfDate() {
    if (expiry == DateTime.now()) return false;
    return false;
  }
}
