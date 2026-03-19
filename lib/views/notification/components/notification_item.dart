part of '../notification_screen.dart';

class _NotificationItem extends StatelessWidget {
  final NotificationModel? notification;
  const _NotificationItem({this.notification});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      width: Spaces.screenWidth(context) - 40.w,
      // color: notification!.isSeen ? null : AppColors.background,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Avatar(avatar: null, size: 40.r),
          width(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    PlaceholderWidget(
                      width: 162.w,
                      height: 17.h,
                      condition: notification != null,
                      borderRadius: false,
                      child: Text(
                        notification?.title ?? "",
                        style: AppStyles.text.semiBold(
                          fSize: 16.sp,
                          height: 1.18,
                        ),
                      ),
                    ),
                    width(width: 8),
                    PlaceholderWidget(
                      width: 75.w,
                      height: 15.h,
                      borderRadius: false,
                      condition: notification != null,
                      child: Text(
                        (notification?.date ?? DateTime.now()).dateByFormat(
                          format: DateTimeFormat.ddMMyyyy,
                        ),
                        style: AppStyles.text.medium(
                          fSize: 14.sp,
                          color: AppColors.gray6A,
                        ),
                      ),
                    ),
                  ],
                ),
                height(height: 4),
                const RatingBarWidget(
                  value: 4,
                  size: 11,
                  spacing: 3,
                ),
                height(height: 8),
                Text(
                  notification!.message,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.text.medium(
                    fSize: 14.sp,
                    color: const Color(0xFF303030),
                    height: 1.1,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
