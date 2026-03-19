part of "../orders_history_screen.dart";

class _OrderHistoryItem extends StatelessWidget {
  final bool loading;
  final bool isDone;
  const _OrderHistoryItem({this.isDone = true, this.loading = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.navigator.push(
          MaterialPageRoute(
            builder: (context) =>
                const OrderDetailsScreen(orderID: "1000112345"),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                width: Spaces.screenWidth(context),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _orderInforComp(),
                    height(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _OrderDuration(
                          loading: loading,
                          durationStart: DateTime.now(),
                        ),
                        Container(
                          width: 1.2.w,
                          height: 14.h,
                          color: AppColors.black5,
                        ),
                        _OrderDuration(
                          loading: loading,
                          durationEnd: DateTime.now(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (loading) _OrderStatus(isDone: isDone),
            ],
          ),
        ),
      ),
    );
  }

  Widget _orderInforComp() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80.w,
          height: 80.w,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Stack(
              children: [
                ImageLoadingWidget(
                  width: 80.w,
                  height: 80.w,
                  borderRadius: false,
                  url: loading
                      ? 'https://media.zili.vn/files/images/9725b435-1359-4675-8c3a-033e964edc05/ROBUSTA HONEY- COASTER_.webp'
                      : "",
                ),
                if (loading)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: 80.w,
                      height: 20.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.black.withOpacity(0.45),
                      ),
                      child: Text(
                        "x4",
                        style: AppStyles.text.medium(
                          fSize: 13.sp,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        width(width: 15),
        Expanded(
          child: height(
            height: 80.w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PlaceholderWidget(
                  width: 150.w,
                  height: 18.h,
                  borderRadius: false,
                  condition: loading,
                  child: CustomRichTextWidget(
                    defaultStyle: AppStyles.text.semiBold(
                      fSize: 14.sp,
                      color: AppColors.gray6A,
                    ),
                    texts: [
                      TextSpan(
                        text: '1000112345',
                        style: AppStyles.text.semiBold(fSize: 16.sp),
                      ),
                      ' - Zili Tea',
                    ],
                  ),
                ),
                PlaceholderWidget(
                  width: 150.w,
                  height: 16.h,
                  borderRadius: false,
                  condition: loading,
                  child: Text(
                    'Trương Hoàng Anh',
                    style: AppStyles.text.semiBold(fSize: 15.sp),
                  ),
                ),
                width(width: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    PlaceholderWidget(
                      width: 120.w,
                      height: 18.h,
                      condition: loading,
                      child: Text(
                        356000.toPrice(),
                        style: AppStyles.text.semiBold(fSize: 20.sp),
                      ),
                    ),
                    PlaceholderWidget(
                      width: 80.w,
                      height: 13.h,
                      condition: loading,
                      child: Text(
                        "4 sản phẩm",
                        style: AppStyles.text.semiBold(
                          fSize: 13.sp,
                          color: AppColors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
