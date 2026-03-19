part of '../roasting_slips_of_roasted_bean_screen.dart';

class _SlipView extends StatelessWidget {
  final RoastingSlip slip;
  const _SlipView(this.slip);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.navigator.pushNamed(
        RoastingSlipDetailScreen.routeName,
        arguments: slip.code,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: .circular(8.r),
          border: .all(color: AppColors.primary),
        ),
        padding: .all(12.w),
        child: ColumnWidget(
          crossAxisAlignment: .start,
          gap: 6.h,
          children: [
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Text(
                  'Mã phiếu:',
                  style: AppStyles.text.medium(
                    fSize: 12.sp,
                    color: AppColors.black5,
                  ),
                ),
                Text(
                  slip.code,
                  style: AppStyles.text.semiBold(
                    fSize: 12.sp,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Text(
                  'Khối lượng (kg)',
                  style: AppStyles.text.medium(
                    fSize: 12.sp,
                    color: AppColors.black5,
                  ),
                ),
                Text(
                  slip.roastedWeight?.toUSD ?? "0",
                  style: AppStyles.text.medium(
                    fSize: 12.sp,
                    color: AppColors.black3,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
