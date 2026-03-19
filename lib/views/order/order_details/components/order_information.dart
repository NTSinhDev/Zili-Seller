part of '../order_details_screen.dart';

class _OrderInformation extends StatelessWidget {
  final String orderID;
  const _OrderInformation({required this.orderID});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20.w),
      width: Spaces.screenWidth(context),
      height: Spaces.screenWidth(context) - 96.h,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.2),
            offset: const Offset(0, 1),
            blurRadius: 6.r,
          ),
        ],
      ),
      child: Column(
        children: [
          _compUserInformation(),
          Divider(color: AppColors.lightGrey, height: 1.5.h, thickness: 1.5.sp),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              padding: EdgeInsets.all(12.w),
              width: Spaces.screenWidth(context),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      height(height: 4),
                      Text(
                        DateTime.now().csToString("dd/MM/yyyy, hh:kk"),
                        style: AppStyles.text.medium(
                          fSize: 13.sp,
                          color: AppColors.black5,
                        ),
                      ),
                      height(height: 12),
                      Text(
                        DateTime.now().csToString(3500000.toPrice()),
                        style: AppStyles.text.bold(fSize: 26.sp),
                      ),
                      height(height: 24),
                      Text(
                        "cửa hàng Zili Tea",
                        style: AppStyles.text
                            .bold(fSize: 16.5.sp, color: AppColors.primary)
                            .copyWith(
                          shadows: [
                            Shadow(
                              color: AppColors.primary.withOpacity(0.2),
                              offset: const Offset(1, 1),
                              blurRadius: 4.r,
                            ),
                          ],
                        ),
                      ),
                      height(height: 12),
                      Text(
                        "phường 7, quận Gò Vấp, HCM.",
                        style: AppStyles.text.medium(
                          fSize: 13.sp,
                          color: AppColors.primary,
                        ),
                      ),
                      height(height: 12),
                      Divider(
                        color: AppColors.primary.withOpacity(0.4),
                        height: 1.h,
                        thickness: 1.sp,
                      ),
                      height(height: 14),
                      const _OrderStatus(),
                    ],
                  ),
                  _compQRCode(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _compUserInformation() {
    const String avatar =
        "https://i.pinimg.com/236x/df/bc/45/dfbc45996e55a0aea92d8dc5405ef358.jpg";
    final userPhoneNumber = AppConstant.strings.ZILI_STORE_TELEPHONE;
    return InkWell(
      onTap: () async {
        final Uri telLaunchUri = Uri(scheme: 'tel', path: userPhoneNumber);
        await launchUrl(telLaunchUri);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Avatar(avatar: avatar, size: 40.r),
            width(width: 14),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Phạm Duy Phong",
                  style: AppStyles.text.semiBold(fSize: 15.sp),
                ),
                height(height: 6),
                Text(
                  userPhoneNumber,
                  style: AppStyles.text.semiBold(
                    fSize: 14.sp,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Container(
              padding: EdgeInsets.all(5.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.r),
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.4),
                    AppColors.primary.withOpacity(0.5),
                    AppColors.primary.withOpacity(0.6),
                    AppColors.primary.withOpacity(0.7),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.2),
                    offset: const Offset(1, 1),
                    blurRadius: 3.r,
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Icon(
                CupertinoIcons.phone,
                color: AppColors.beige,
                size: 23.sp,
              ),
            ),
            width(width: 5),
            const Icon(Icons.chevron_right_sharp, color: AppColors.primary),
          ],
        ),
      ),
    );
  }

  Widget _compQRCode() {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        padding: EdgeInsets.all(1.w),
        width: 88.w,
        height: 88.w,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.2),
              offset: const Offset(1, 1),
              blurRadius: 14.r,
            ),
          ],
        ),
        child: QrImageView(data: orderID, version: QrVersions.auto),
      ),
    );
  }
}
