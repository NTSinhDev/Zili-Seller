part of '../products_screen.dart';

class _TitleView extends StatelessWidget {
  final String title;
  final Function() more;
  const _TitleView({required this.title, required this.more});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          width(
            width: 224,
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: AppStyles.text.semiBold(fSize: 16.sp),
            ),
          ),
          width(width: 12),
          InkWell(
            onTap: more,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 8.w,
                vertical: 3.h,
              ),
              child: Row(
                children: [
                  Text(
                    'Xem thêm',
                    style: AppStyles.text.bold(
                      fSize: 16.sp,
                      color: AppColors.primary,
                    ),
                  ),
                  width(width: 8),
                  CustomIconStyle(
                    icon: CupertinoIcons.chevron_right,
                    style: AppStyles.text.bold(
                      fSize: 16.sp,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
