part of '../roasting_slips_of_roasted_bean_screen.dart';

class _RoastedBeanCard extends StatelessWidget {
  final ProductVariant roastedBean;
  const _RoastedBeanCard({required this.roastedBean});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: .symmetric(horizontal: 16.w),
      width: .infinity,
      padding: .all(12.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: .circular(8.r),
      ),
      child: ColumnWidget(
        gap: 8.h,
        crossAxisAlignment: .stretch,
        children: [
          RowWidget(
            crossAxisAlignment: .start,
            children: [
              Expanded(
                child: ColumnWidget(
                  crossAxisAlignment: .start,
                  gap: 4.h,
                  children: [
                    Text(
                      _productTitle,
                      style: AppStyles.text.semiBold(
                        fSize: 14.sp,
                        color: AppColors.black3,
                      ),
                      maxLines: 1,
                      overflow: .ellipsis,
                    ),
                    if (_variantOptions.isNotEmpty)
                      Text(
                        _variantOptions,
                        style: AppStyles.text.medium(
                          fSize: 12.sp,
                          color: AppColors.grey84,
                        ),
                      ),
                  ],
                ),
              ),
              Text(
                roastedBean.sku ?? AppConstant.strings.DEFAULT_EMPTY_VALUE,
                style: AppStyles.text.medium(
                  fSize: 12.sp,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const Divider(height: 1, color: AppColors.greyC0, thickness: 1),
          _summaryRow('Tổng khối lượng (kg)', _totalWeightDisplay),
          _summaryRow('Đã đóng gói (kg)', roastedBean.packedWeight.toUSD),
          _summaryRow('Tổng khối lượng còn lại (kg)', _slotBuyToDouble.toUSD),
          _summaryRow(
            'Thời gian tạo',
            roastedBean.product?.createdAt?.formatWithTimezone() ??
                AppConstant.strings.DEFAULT_EMPTY_VALUE,
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: .spaceBetween,
      mainAxisSize: .max,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: .ellipsis,
          style: AppStyles.text.medium(fSize: 12.sp, color: AppColors.black5),
        ),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: .ellipsis,
            textAlign: .right,
            style: AppStyles.text.medium(fSize: 12.sp, color: AppColors.black3),
          ),
        ),
      ],
    );
  }

  String get _productTitle {
    return (roastedBean.product?.titleVi?.trim()) ??
        AppConstant.strings.DEFAULT_EMPTY_VALUE;
  }

  String get _variantOptions {
    if (roastedBean.options.isEmpty) return '';
    final values = roastedBean.options
        .map((o) => o.value.trim())
        .where((v) => v.isNotEmpty)
        .toList();
    if (values.isEmpty) return '';
    return values.join(' - ');
  }

  String get _totalWeightDisplay {
    final packed = roastedBean.packedWeight;
    final total = _slotBuyToDouble + packed;
    return total.toUSD;
  }

  double get _slotBuyToDouble => double.tryParse(roastedBean.slotBuy) ?? 0;
}
