part of '../export_package_for_slip_item_screen.dart';

class _ItemMixCard extends StatelessWidget {
  final PackingSlipItemMix itemMix;
  const _ItemMixCard(this.itemMix);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: .infinity,
      padding: .all(12.w),
      decoration: BoxDecoration(
        color: AppColors.green.withValues(alpha: 0.1),
        border: Border.all(
          color: AppColors.green.withValues(alpha: 0.3),
          width: 1,
        ),
        borderRadius: .circular(8.r),
      ),
      child: RowWidget(
        crossAxisAlignment: .start,
        children: [
          Expanded(
            child: ColumnWidget(
              crossAxisAlignment: .start,
              gap: 8.h,
              children: [
                Text(
                  itemMix.productNameVi?.trim() ??
                      AppConstant.strings.DEFAULT_EMPTY_VALUE,
                  style: AppStyles.text.semiBold(
                    fSize: 12.sp,
                    color: AppColors.black5,
                  ),
                  maxLines: 1,
                  overflow: .ellipsis,
                ),
                if (itemMix.options.isNotEmpty)
                  Text(
                    itemMix.options.map((e) => e.value).join(' - '),
                    style: AppStyles.text.medium(
                      fSize: 10.sp,
                      color: AppColors.grey84,
                    ),
                  ),
              ],
            ),
          ),
          ColumnWidget(
            crossAxisAlignment: .end,
            gap: 8.h,
            children: [
              Text(
                itemMix.sku ?? AppConstant.strings.DEFAULT_EMPTY_VALUE,
                style: AppStyles.text.medium(
                  fSize: 12.sp,
                  color: AppColors.primary,
                ),
              ),
              Text(
                '${itemMix.isWeightBased ? "Khối lượng" : "Số lượng"}: ${itemMix.totalWeight.toUSD} (kg)',
                style: AppStyles.text.medium(fSize: 12.sp),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
