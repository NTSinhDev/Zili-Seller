part of '../export_warehouse_for_slip_item_screen.dart';

class _ProductCard extends StatelessWidget {
  final PackingSlipDetailItem slip;
  const _ProductCard({required this.slip});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: .infinity,
      padding: .all(12.w),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: .circular(8.r),
      ),
      child: ColumnWidget(
        gap: 8.h,
        crossAxisAlignment: .stretch,
        children: [
          RowWidget(
            crossAxisAlignment: .start,
            gap: 16.w,
            children: [
              ClipRRect(
                borderRadius: .circular(4.r),
                child: ImageUrlWidget(
                  url: slip.productImage,
                  width: 40.w,
                  height: 40.w,
                ),
              ),
              Expanded(
                child: ColumnWidget(
                  crossAxisAlignment: .start,
                  gap: 6.h,
                  children: [
                    Text(
                      slip.productNameVi.trim(),
                      style: AppStyles.text.semiBold(
                        fSize: 14.sp,
                        color: AppColors.black3,
                        height: 18 / 14,
                      ),
                      maxLines: 2,
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
                slip.sku ?? AppConstant.strings.DEFAULT_EMPTY_VALUE,
                style: AppStyles.text.medium(
                  fSize: 12.sp,
                  color: AppColors.primary,
                  height: 20 / 14,
                ),
              ),
            ],
          ),
          const Divider(height: 1, color: AppColors.greyC0, thickness: 1),
          _summaryRow('Khối lượng', _weightByMeasureUnit ?? ""),
          if (slip.isWeightBased)
            _summaryRow(
              'Tổng khối lượng đóng gói',
              '${slip.totalWeight.toUSD} (kg)',
            )
          else
            _summaryRow(
              'Tổng số lượng đóng gói',
              '${slip.totalWeight.toUSD} ${slip.measureUnit}',
            ),
          // if (slip.isWeightBased) ...[
          //   if (_weightByMeasureUnit != null)
          //     _summaryRow('Khối lượng', _weightByMeasureUnit ?? ""),
          //   _summaryRow(
          //     'Tổng khối lượng đóng gói',
          //     '${slip.totalWeight.toUSD} (kg)',
          //   ),
          // ] else ...[
          //   if (_weightByMeasureUnit != null)
          //     _summaryRow('Tổng số lượng đóng gói', _weightByMeasureUnit ?? ""),
          // ],
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

  String get _variantOptions {
    if (slip.options.isEmpty) return '';
    final values = slip.options
        .map((o) => o.value.trim())
        .where((v) => v.isNotEmpty)
        .toList();
    if (values.isEmpty) return '';
    return values.join(' - ');
  }

  String? get _weightByMeasureUnit {
    if (slip.measureUnit == null || slip.weight == null) return null;
    final weightGram = slip.weight?.toUSD;
    return '${weightGram}gr/${slip.measureUnit}';
  }
}
