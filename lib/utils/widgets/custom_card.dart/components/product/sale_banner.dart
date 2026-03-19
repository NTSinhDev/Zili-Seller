part of '../../custom_card_widget.dart';

class _SaleBanner extends StatelessWidget {
  final int price;
  final int promotionPrice;
  final String promotionType;
  const _SaleBanner({
    required this.price,
    required this.promotionPrice,
    required this.promotionType,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10.w,
      right: 10.w,
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.r),
          color: AppColors.red,
        ),
        child: Text(
          'Giảm ${discountValue(price: price, promotionPrice: promotionPrice)}$promotionType',
          style: AppStyles.text.bold(
            fSize: 12.sp,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }

  String discountValue({
    required int price,
    required int promotionPrice,
  }) {
    final discount = ((100 * (price - promotionPrice)) / price);
    final discountValue = discount.floor().toString();
    return discountValue;
  }
}
