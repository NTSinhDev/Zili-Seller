part of '../packing_slips_of_special_variant_screen.dart';

class _SpecialVariantCard extends StatelessWidget {
  final ProductVariant specialVariant;
  const _SpecialVariantCard({required this.specialVariant});

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
              ClipRRect(
                borderRadius: .circular(4.r),
                child: ImageUrlWidget(
                  url: specialVariant.displayAvatar,
                  width: 36.w,
                  height: 36.w,
                ),
              ),
              width(width: 16.w),
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
                specialVariant.sku ?? AppConstant.strings.DEFAULT_EMPTY_VALUE,
                style: AppStyles.text.medium(
                  fSize: 12.sp,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const Divider(height: 1, color: AppColors.greyC0, thickness: 1),
          _summaryRow('Tồn kho', _slotBuyToDouble.toUSD),
          _summaryRow('Có thể bán', _availableQuantityToDouble.toUSD),
          _summaryRow(
            'Thời gian tạo',
            specialVariant.product?.createdAt?.formatWithTimezone() ??
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
    return (specialVariant.product?.titleVi?.trim()) ??
        AppConstant.strings.DEFAULT_EMPTY_VALUE;
  }

  String get _variantOptions {
    if (specialVariant.options.isEmpty) return '';
    final values = specialVariant.options
        .map((o) => o.value.trim())
        .where((v) => v.isNotEmpty)
        .toList();
    if (values.isEmpty) return '';
    return values.join(' - ');
  }

  double get _slotBuyToDouble => double.tryParse(specialVariant.slotBuy) ?? 0;
  double get _availableQuantityToDouble => double.tryParse(specialVariant.availableQuantity) ?? 0;
}
