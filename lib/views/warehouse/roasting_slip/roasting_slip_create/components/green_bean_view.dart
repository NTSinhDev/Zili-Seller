part of '../roasting_slip_create_screen.dart';

class _GreenBeanView extends StatelessWidget {
  final ProductVariant? greenBean;
  final bool isDefault;
  final String branchId;
  final Function(ProductVariant variant) onSelected;
  const _GreenBeanView({
    required this.greenBean,
    required this.branchId,
    required this.onSelected,
    this.isDefault = false,
  });

  @override
  Widget build(BuildContext context) {
    return ColumnWidget(
      crossAxisAlignment: .start,
      gap: 8.h,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "Sản phẩm",
                style: AppStyles.text.medium(
                  fSize: 12.sp,
                  color: AppColors.grey84,
                ),
              ),
              TextSpan(
                text: ' *',
                style: AppStyles.text.medium(
                  fSize: 12.sp,
                  color: AppColors.scarlet,
                ),
              ),
            ],
          ),
        ),
        if (!isDefault)
          // Search view
          InkWell(
            onTap: () {
              context.navigator
                  .pushNamed(
                    SelectCoffeeVariantScreen.routeName,
                    arguments: {
                      'branchId': branchId,
                      'type': CoffeeVariantType.greenBean,
                    },
                  )
                  .then((value) async {
                    if (value != null && value is ProductVariant) {
                      if (context.mounted) {
                        debugPrint('[debugPrint] value: $value');
                        onSelected(value);
                      }
                    }
                  });
            },
            child: Container(
              padding: .symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: .circular(8.r),
                border: Border.all(color: AppColors.greyC0),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: AppColors.grey84),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      'Tìm kiếm theo tên, mã SKU,...',
                      style: AppStyles.text.medium(
                        fSize: 14.sp,
                        color: AppColors.grey84,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: AppColors.grey84,
                    size: 24.sp,
                  ),
                ],
              ),
            ),
          ),

        if (greenBean != null)
          // Products list
          _GreenBean(variant: greenBean),
      ],
    );
  }
}

class _GreenBean extends StatelessWidget {
  final ProductVariant? variant;
  const _GreenBean({required this.variant});

  @override
  Widget build(BuildContext context) {
    if (variant == null) return const SizedBox.shrink();

    final displayImage = variant!.imageVariant;
    final availableQty = num.tryParse(variant!.slotBuy) ?? 0;

    return Container(
      padding: .all(12.w),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: .circular(8.r),
        // border: Border.all(color: AppColors.greyC0),
      ),
      child: Row(
        crossAxisAlignment: .start,
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: AppColors.lightGrey,
              borderRadius: .circular(8.r),
            ),
            child: ClipRRect(
              borderRadius: .circular(8.r),
              child: displayImage != null && displayImage.isNotEmpty
                  ? ImageLoadingWidget(
                      hasPlaceHolder: false,
                      url: displayImage,
                      width: 48.w,
                      height: 48.w,
                      borderRadius: false,
                    )
                  : Icon(
                      Icons.image_outlined,
                      size: 24.sp,
                      color: AppColors.grey84,
                    ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: ColumnWidget(
              crossAxisAlignment: .start,
              gap: 4.h,
              children: [
                Text(
                  renderProductVariantName(variant!, variant!.options),
                  style: AppStyles.text.semiBold(
                    fSize: 14.sp,
                    color: AppColors.primary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  variant!.sku ?? AppConstant.strings.DEFAULT_EMPTY_VALUE,
                  style: AppStyles.text.medium(
                    fSize: 12.sp,
                    color: AppColors.black3,
                  ),
                ),
                Text(
                  'Tồn kho: ${availableQty.removeTrailingZero}',
                  style: AppStyles.text.medium(
                    fSize: 12.sp,
                    color: AppColors.black3,
                    // AppStyles medium đã có weight chuẩn; tô đậm nhẹ qua color/size
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
