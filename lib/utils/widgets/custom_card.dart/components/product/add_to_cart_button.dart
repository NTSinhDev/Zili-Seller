part of '../../custom_card_widget.dart';

class _AddToCartBtn extends StatelessWidget {
  final Product? product;
  final bool condition;
  final Function() onTap;
  const _AddToCartBtn({
    required this.product,
    required this.condition,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.fromLTRB(17.w, 6.w, 6.w, 6.w),
        decoration: BoxDecoration(
          color: const Color(0xFF346448),
          borderRadius: BorderRadius.circular(76.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: pricesSale(condition),
            ),
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.lightGrey,
              ),
              child: Icon(
                Icons.add_rounded,
                color: AppColors.primary,
                size: 22.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> pricesSale(bool condition) {
    return condition
        ? [
            Text(
              (product?.price ?? 000000).toPrice(),
              style: AppStyles.text
                  .medium(fSize: 10.sp, color: Colors.grey[300])
                  .copyWith(decoration: TextDecoration.lineThrough),
            ),
            Text(
              (product?.promotionPrice ?? 000000).toPrice(),
              style: AppStyles.text.bold(fSize: 16.sp, color: Colors.amber),
            ),
          ]
        : [
            Text(
              (product?.price ?? 000000).toPrice(),
              style: AppStyles.text.bold(fSize: 16.sp, color: AppColors.white),
            ),
          ];
  }
}
