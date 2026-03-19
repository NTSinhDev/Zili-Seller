part of '../products_screen.dart';

class _Appbar extends StatelessWidget {
  const _Appbar();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      child: Container(
        width: Spaces.screenWidth(context),
        height: Spaces.screenHeight(context),
        color: AppColors.primary,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            height(height: 44),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    margin: EdgeInsets.only(left: 20.w, right: 18.w),
                    child: const Icon(
                      CupertinoIcons.chevron_back,
                      color: AppColors.white,
                    ),
                  ),
                ),
                Text(
                  'CHỌN SẢN PHẨM',
                  style: AppStyles.text.bold(
                    fSize: 16.sp,
                    color: AppColors.white,
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: OpenCartView(
                    margin: EdgeInsets.only(right: 10.w),
                    padding: EdgeInsets.only(bottom: 8.h, top: 8.h),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
