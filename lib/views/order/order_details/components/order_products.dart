part of '../order_details_screen.dart';

class _OrderProducts extends StatelessWidget {
  const _OrderProducts();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.all(20.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Sản phẩm (3)",
            style: AppStyles.text.semiBold(fSize: 15.sp),
          ),
          height(height: 16),
          ..._compProductsOfOrder(),
        ],
      ),
    );
  }

  List<Widget> _compProductsOfOrder() {
    // TODO: Fetch data at here
    return List.generate(5, (index) {
      if (index.isEven) {
        return _compProductItem();
      }
      return Container(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        child: Divider(
          color: AppColors.lightGrey,
          height: 1.4.h,
          thickness: 1.4.sp,
        ),
      );
    });
  }

  Widget _compProductItem() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 92.w,
          height: 92.w,
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.all(6.w),
                child: ImageLoadingWidget(
                  width: 80.w,
                  height: 80.w,
                  borderRadius: false,
                  url:
                      'https://media.zili.vn/files/images/9725b435-1359-4675-8c3a-033e964edc05/ROBUSTA HONEY- COASTER_.webp',
                ),
              ),
              if (true) ...[
                Positioned(
                  top: 0.h,
                  right: 0.w,
                  child: Container(
                    width: 22.w,
                    height: 22.w,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  top: 2.h,
                  right: 2.w,
                  child: Container(
                    width: 18.w,
                    height: 18.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withOpacity(0.7),
                          AppColors.primary.withOpacity(0.9),
                          AppColors.primary.withOpacity(1),
                        ],
                      ),
                    ),
                    child: Text(
                      "4",
                      style: AppStyles.text.semiBold(
                        fSize: 12.sp,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ]
            ],
          ),
        ),
        width(width: 15),
        Expanded(
          child: height(
            height: 80.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    PlaceholderWidget(
                      width: 150.w,
                      height: 13.h,
                      borderRadius: false,
                      condition: true,
                      child: Text(
                        "Túi caffee đen Zili",
                        style: AppStyles.text.medium(fSize: 16.sp),
                      ),
                    ),
                    PlaceholderWidget(
                      width: 64.w,
                      height: 13.h,
                      borderRadius: false,
                      condition: true,
                      child: Text(
                        820000.toPrice(),
                        style: AppStyles.text.medium(fSize: 16.sp),
                      ),
                    ),
                  ],
                ),
                PlaceholderWidget(
                  width: 200.w,
                  height: 13.h,
                  borderRadius: false,
                  condition: true,
                  child: Text(
                    "Mã: TCF0018",
                    style: AppStyles.text.semiBold(
                      fSize: 13.sp,
                      color: AppColors.grey84,
                    ),
                  ),
                ),
                PlaceholderWidget(
                  width: 200.w,
                  height: 13.h,
                  borderRadius: false,
                  condition: true,
                  child: Text(
                    "Size: M",
                    style: AppStyles.text.semiBold(
                      fSize: 13.sp,
                      color: AppColors.grey84,
                    ),
                  ),
                ),
                width(width: 20),
                PlaceholderWidget(
                  width: 200.w,
                  height: 13.h,
                  borderRadius: false,
                  condition: true,
                  child: Text(
                    205000.toPrice(),
                    style: AppStyles.text.semiBold(
                      fSize: 13.sp,
                      color: AppColors.grey84,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
