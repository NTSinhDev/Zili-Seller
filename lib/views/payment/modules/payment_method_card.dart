import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/widgets/widgets.dart';

class PaymentMethodCard extends StatelessWidget {
  final String method;
  final String icon;
  final Function() selected;
  final bool isSelected;
  const PaymentMethodCard({
    super.key,
    required this.method,
    required this.icon,
    required this.selected,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: selected,
      child: Container(
        padding: EdgeInsets.all(20.w),
        width: Spaces.screenWidth(context) - 40.w,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(6.r),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: AppColors.black.withOpacity(0.15),
              offset: const Offset(0.0, 0.0),
              blurRadius: 5.r,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.network(
                  icon,
                  width: 34.w,
                  height: 34.w,
                  fit: BoxFit.contain,
                ),
                width(width: 20.w),
                Text(
                  method,
                  style: AppStyles.text.medium(fSize: 16.sp),
                )
              ],
            ),
            CustomRadioBtnWidget(isActive: isSelected),
          ],
        ),
      ),
    );
  }
}

// class _IconState extends StatelessWidget {
//   final String icon;
//   const _IconState({required this.icon});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: _widget(),
//     );
//   }

//   Widget _widget() {
//     Widget? widget;
//     http.get(Uri.parse(icon)).then((response) {
//       if (response.statusCode != 200) {
//         widget = SvgPicture.network(
//           AppConstant.svgs.icPaymentMethodZalopay,
//           width: 34.w,
//           height: 34.w,
//           fit: BoxFit.contain,
//         );
//       }
//       widget = SvgPicture.network(
//         icon,
//         width: 34.w,
//         height: 34.w,
//         fit: BoxFit.contain,
//       );
//     });
//     return widget!;
//   }
// }
