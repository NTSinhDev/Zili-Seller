part of '../roasting_slip_create_screen.dart';

class _RoastedBeansSelector extends StatelessWidget {
  final ProductVariant? selected;
  final String importBranchId;
  final Function(ProductVariant variant) onSelected;
  final VoidCallback onClear;
  final TextEditingController weightController;
  final Future<void> Function(String variantId) onFetchGreenBeanDefault;
  final GlobalKey<FormFieldState> weightFieldKey;
  const _RoastedBeansSelector({
    required this.selected,
    required this.importBranchId,
    required this.onSelected,
    required this.onClear,
    required this.weightController,
    required this.onFetchGreenBeanDefault,
    required this.weightFieldKey,
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
        // Search view
        InkWell(
          onTap: () {
            context.navigator
                .pushNamed(
                  SelectCoffeeVariantScreen.routeName,
                  arguments: {
                    'branchId': importBranchId,
                    'type': CoffeeVariantType.commodity,
                  },
                )
                .then((value) async {
                  if (value != null && value is ProductVariant) {
                    if (context.mounted) {
                      debugPrint('[debugPrint] value: $value');
                      onSelected(value);
                      await onFetchGreenBeanDefault(value.id);
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
                    selected.isNull
                        ? 'Tìm kiếm theo tên, mã SKU,...'
                        : renderProductVariantName(selected, selected?.options),
                    style: AppStyles.text.medium(
                      fSize: 14.sp,
                      color: AppColors.grey84,
                    ),
                  ),
                ),
                Icon(Icons.chevron_right, color: AppColors.grey84, size: 24.sp),
              ],
            ),
          ),
        ),
        // Products list
        if (selected.isNull)
          SizedBox(
            width: .infinity,
            height: 180.h,
            child: ColumnWidget(
              gap: 16.h,
              crossAxisAlignment: .center,
              mainAxisAlignment: .center,
              children: [
                Image.asset(
                  AssetImages.emptyBoxPng,
                  width: 80,
                  fit: BoxFit.fitWidth,
                ),
                Text(
                  'Bạn chưa thêm sản phẩm nào',
                  style: AppStyles.text.medium(
                    fSize: 14.sp,
                    color: SystemColors.secondaryPurple10,
                  ),
                ),
              ],
            ),
          )
        else
          _RoastedBeansSelectorItem(
            variant: selected!,
            onClear: onClear,
            weightController: weightController,
            weightFieldKey: weightFieldKey,
          ),
      ],
    );
  }
}

class _RoastedBeansSelectorItem extends StatefulWidget {
  final ProductVariant? variant;
  final VoidCallback onClear;
  final TextEditingController weightController;
  final GlobalKey<FormFieldState> weightFieldKey;
  const _RoastedBeansSelectorItem({
    required this.variant,
    required this.onClear,
    required this.weightController,
    required this.weightFieldKey,
  });

  @override
  State<_RoastedBeansSelectorItem> createState() =>
      _RoastedBeansSelectorItemState();
}

class _RoastedBeansSelectorItemState extends State<_RoastedBeansSelectorItem> {
  @override
  Widget build(BuildContext context) {
    final variant = widget.variant;
    if (variant == null) return const SizedBox.shrink();

    final displayImage = variant.imageVariant;
    final availableQty = num.tryParse(variant.slotBuy) ?? 0;

    return Container(
      padding: .all(12.w),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: .circular(8.r),
        // border: Border.all(color: AppColors.greyC0),
      ),
      child: ColumnWidget(
        crossAxisAlignment: .start,
        gap: 20.h,
        children: [
          Row(
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
                      renderProductVariantName(variant, variant.options),
                      style: AppStyles.text.semiBold(
                        fSize: 14.sp,
                        color: AppColors.primary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      variant.sku ?? AppConstant.strings.DEFAULT_EMPTY_VALUE,
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
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: widget.onClear,
                icon: Icon(Icons.close, size: 18.sp, color: AppColors.grey84),
              ),
            ],
          ),
          InputFormField(
            formFieldKey: widget.weightFieldKey,
            controller: widget.weightController,
            bgColor: Colors.white,
            label: 'Khối lượng rang (kg)',
            type: decimalInputType(),
            inputFormatters: decimalInputFormatter(),
            validator: (value) {
              final text = value?.trim() ?? '';
              if (text.isEmpty) return 'Vui lòng nhập khối lượng rang';
              final parsed = NumExt.tryParseComma(text);
              if (parsed == null) return 'Khối lượng rang phải là số hợp lệ';
              if (parsed < 0.01) return 'Giá trị nhỏ nhất là 0.01 kg (10 gram)';
              return null;
            },
          ),
        ],
      ),
    );
  }
}
