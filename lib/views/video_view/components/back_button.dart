part of '../video_view_screen.dart';

class _BackButton extends StatelessWidget {
  final Function() onback;
  const _BackButton({required this.onback});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onback,
      child: Container(
        margin: EdgeInsets.only(top: 16.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              child: Icon(
                CupertinoIcons.chevron_back,
                size: 28.sp,
                color: AppColors.white,
              ),
            ),
            width(width: 2),
            Text(
              "Quay lại",
              style: AppStyles.text.semiBold(
                fSize: 18.sp,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
