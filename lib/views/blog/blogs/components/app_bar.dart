part of '../blogs_screen.dart';

class _Appbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      child: Container(
        width: Spaces.screenWidth(context),
        height: 166.h,
        padding: EdgeInsets.only(bottom: 20.h),
        color: AppColors.primary,
        child: Row(
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
              'Bài viết'.toUpperCase(),
              style: AppStyles.text.bold(
                fSize: 16.sp,
                color: AppColors.white,
              ),
            ),
            Container(
              width: 60.w,
            )
          ],
        ),
      ),
    );
  }
}
