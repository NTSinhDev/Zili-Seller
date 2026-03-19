part of '../order_details_screen.dart';

class _OrderPriceDetails extends StatelessWidget {
  const _OrderPriceDetails();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.all(20.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Tổng giá sản phẩm",
                style: AppStyles.text.medium(fSize: 15.sp),
              ),
              Text(
                3500000.toPrice(),
                style: AppStyles.text.medium(fSize: 15.sp),
              ),
            ],
          ),
          height(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Thuế",
                style: AppStyles.text.medium(fSize: 15.sp),
              ),
              Text(
                "0",
                style: AppStyles.text.medium(fSize: 15.sp),
              ),
            ],
          ),
          height(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Chiết khấu",
                style: AppStyles.text.medium(fSize: 15.sp),
              ),
              Text(
                "0",
                style: AppStyles.text.medium(fSize: 15.sp),
              ),
            ],
          ),
          height(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Phí giao hàng",
                style: AppStyles.text.medium(fSize: 15.sp),
              ),
              Text(
                "0",
                style: AppStyles.text.medium(fSize: 15.sp),
              ),
            ],
          ),
          height(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Tổng hóa đơn",
                style: AppStyles.text.semiBold(fSize: 16.sp),
              ),
              Text(
                3500000.toPrice(),
                style: AppStyles.text.semiBold(fSize: 18.sp),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
