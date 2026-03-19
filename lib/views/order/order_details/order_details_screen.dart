import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/extension/build_context.dart';
import 'package:zili_coffee/utils/extension/date_time.dart';
import 'package:zili_coffee/utils/extension/int.dart';
import 'package:zili_coffee/utils/widgets/widgets.dart';
import 'package:zili_coffee/views/module_common/avatar.dart';
part 'components/order_information.dart';
part 'components/order_status.dart';
part 'components/order_products.dart';
part 'components/order_price_details.dart';
part 'components/order_note.dart';

@Deprecated('This screen is deprecated. Use OrderDetailScreen instead.')
class OrderDetailsScreen extends StatelessWidget {
  final String orderID;
  const OrderDetailsScreen({super.key, required this.orderID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget.lightAppBar(
        context,
        label: "Đơn hàng: $orderID",
        elevation: 3,
      ),
      backgroundColor: AppColors.lightGrey,
      body: SizedBox(
        width: Spaces.screenWidth(context),
        height: Spaces.screenHeight(context),
        child: Scrollbar(
          radius: Radius.circular(4.r),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: order base information
                Stack(
                  children: [
                    ImageLoadingWidget(
                      width: Spaces.screenWidth(context),
                      height: Spaces.screenWidth(context) - 120.h,
                      url:
                          'https://www.sapo.vn/Upload/ImageManager/Image/cafe-zili%20%2810%29.jpg',
                    ),
                    Container(
                      width: Spaces.screenWidth(context),
                      height: Spaces.screenWidth(context) - 120.h,
                      color: AppColors.black24.withOpacity(0.5),
                    ),
                    _OrderInformation(orderID: orderID),
                  ],
                ),
                // Body: products of order.
                const _OrderProducts(),
                const _OrderNote(),
                height(height: 14.h),
                const _OrderPriceDetails(),
                height(height: 14.h),
                InkWell(
                  onTap: () {
                    context.showCustomDialog(
                      height: 368.h,
                      barrierColor: Colors.black38,
                      canDismiss: true,
                      backgroundColor: AppColors.white,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Column(
                          children: [
                            Lottie.asset(
                              AppConstant.animations.trash,
                              height: 220.h,
                              fit: BoxFit.cover,
                              width: Spaces.screenWidth(context) / 2.5,
                            ),
                            Text(
                              'Xác nhận hủy đơn hàng?',
                              style: AppStyles.text.semiBold(
                                fSize: 16.sp,
                                color: AppColors.scarlet,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            height(height: 6),
                            Text(
                              'Sau khi hủy, đơn hàng sẽ được chuyển đến lịch sử đơn hàng. Bạn có thể xem lại hoặc khôi phục đơn hàng trong trang lịch sử đơn hàng.',
                              style: AppStyles.text
                                  .medium(fSize: 12.sp, height: 1.28.sp),
                              textAlign: TextAlign.center,
                            ),
                            height(height: 20),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 120.w,
                                    height: 36.h,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      borderRadius: BorderRadius.circular(8.r),
                                      border:
                                          Border.all(color: AppColors.primary),
                                    ),
                                    child: Text(
                                      "Từ chối",
                                      style: AppStyles.text.semiBold(
                                        fSize: 14.sp,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 120.w,
                                    height: 36.h,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      borderRadius: BorderRadius.circular(8.r),
                                      border:
                                          Border.all(color: AppColors.scarlet),
                                    ),
                                    child: Text(
                                      "Xác nhận",
                                      style: AppStyles.text.semiBold(
                                        fSize: 14.sp,
                                        color: AppColors.scarlet,
                                      ),
                                    ),
                                  )
                                ])
                          ],
                        ),
                      ),
                    );
                  },
                  splashColor: Colors.transparent,
                  child: Container(
                    width: Spaces.screenWidth(context),
                    height: 48.h,
                    margin: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 12.h,
                    ),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: AppColors.scarlet),
                    ),
                    child: Text(
                      "Hủy đơn hàng",
                      style: AppStyles.text.medium(
                        fSize: 18.sp,
                        color: AppColors.scarlet,
                      ),
                    ),
                  ),
                ),
                height(height: 14.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
