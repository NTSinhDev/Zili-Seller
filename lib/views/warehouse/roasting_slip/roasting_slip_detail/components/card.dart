part of '../roasting_slip_detail_screen.dart';

class _CardProductSection extends StatelessWidget {
  final String title;
  final ProductVariant? variant;
  final String? branch;
  final String? exportWeight;
  final String? expectedWeight;
  final List<MapEntry<String, String>> extraRows;
  const _CardProductSection({
    required this.title,
    required this.variant,
    required this.branch,
    this.exportWeight,
    this.expectedWeight,
    this.extraRows = const [],
  });

  @override
  Widget build(BuildContext context) {
    return ColumnWidget(
      crossAxisAlignment: .start,
      gap: 8.h,
      children: [
        Text(
          title,
          style: AppStyles.text.bold(fSize: 14.sp, color: AppColors.black3),
        ),
        Container(
          width: .infinity,
          padding: .all(12.w),
          decoration: BoxDecoration(
            color: AppColors.lightGrey,
            borderRadius: .circular(12.r),
            border: .all(color: AppColors.lightGrey),
          ),
          child: ColumnWidget(
            gap: 8.h,
            children: [
              Row(
                children: [
                  Container(
                    width: 48.w,
                    height: 48.w,
                    decoration: BoxDecoration(
                      color: AppColors.lightGrey,
                      borderRadius: .circular(8.r),
                    ),
                    child: variant?.displayAvatar != null
                        ? ClipRRect(
                            borderRadius: .circular(8.r),
                            child: ImageLoadingWidget(
                              url: variant!.displayAvatar!,
                              width: 48.w,
                              height: 48.w,
                              borderRadius: false,
                              hasPlaceHolder: false,
                              fit: .contain,
                            ),
                          )
                        : Icon(
                            Icons.image,
                            size: 24.w,
                            color: AppColors.grey84,
                          ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        Text(
                          renderProductVariantTitle(variant),
                          style: AppStyles.text.bold(
                            fSize: 14.sp,
                            color: AppColors.black3,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          variant?.sku ?? variant?.barcode ?? '',
                          style: AppStyles.text.medium(
                            fSize: 12.sp,
                            color: AppColors.black5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Divider(
                color: AppColors.black.withValues(alpha: 0.2),
                height: 12.h,
              ),
              _row(
                'Chi nhánh',
                branch ?? AppConstant.strings.DEFAULT_EMPTY_VALUE,
              ),
              if (exportWeight != null)
                _row('Khối lượng xuất kho', exportWeight!),
              if (expectedWeight != null)
                _row('Khối lượng yêu cầu', expectedWeight!),
              ...extraRows.map(
                (e) => _row(
                  e.key,
                  e.value,
                  valueColor: e.value.contains('%') ? AppColors.scarlet : null,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _row(String k, String v, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        Expanded(
          child: Text(
            k,
            style: AppStyles.text.medium(fSize: 12.sp, color: AppColors.black3),
          ),
        ),
        SizedBox(width: 12.w),
        Text(
          v,
          style: AppStyles.text.medium(
            fSize: 12.sp,
            color: valueColor ?? AppColors.black3,
          ),
          textAlign: .right,
        ),
      ],
    );
  }
}
