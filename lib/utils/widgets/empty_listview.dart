import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zili_coffee/res/res.dart';

class EmptyListViewWidget extends StatelessWidget {
  final double? size;
  final double? comeDownByHeight;
  const EmptyListViewWidget({
    super.key,
    this.size,
    this.comeDownByHeight,
  });

  @override
  Widget build(BuildContext context) {
    final size = this.size ?? 220.w;
    final comeDownByHeight = this.comeDownByHeight ?? 200.w;
    return Center(
      child: Container(
        // margin: EdgeInsets.only(
        //   left: (Spaces.screenWidth(context) - size) / 2,
        //   top: (Spaces.screenHeight(context) - (comeDownByHeight + size)) / 2,
        // ),
        width: size,
        height: size,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.network(
              'https://stag.zilicoffee.vn/assets/svg/ic_data_empty.715e8e93a72d42977e3647985a5bb814.svg',
              width: 100.w,
            ),
            height(height: 20),
            Text(
              'Chưa có đơn hàng',
              style: AppStyles.text.medium(fSize: 14.sp, color: AppColors.greyB3),
            )
          ],
        ),
      ),
    );
  }
}
