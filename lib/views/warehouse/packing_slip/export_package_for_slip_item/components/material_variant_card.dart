part of '../export_package_for_slip_item_screen.dart';

class _PackageVariantCard extends StatelessWidget {
  final ProductVariant variant;
  final VoidCallback onRemove;
  final TextEditingController weightController;
  final GlobalKey<FormFieldState> weightFieldKey;
  const _PackageVariantCard({
    required this.variant,
    required this.onRemove,
    required this.weightController,
    required this.weightFieldKey,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .all(12.w),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: .circular(8.r),
      ),
      child: ColumnWidget(
        crossAxisAlignment: .start,
        gap: 16.h,
        children: [
          Row(
            crossAxisAlignment: .start,
            children: [
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
                      'Số lượng: ${variant.availableQuantity} ${variant.product?.measureUnit != null ? '(${variant.product?.measureUnit})' : ''}',
                      style: AppStyles.text.medium(
                        fSize: 12.sp,
                        color: AppColors.black3,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: onRemove,
                icon: Icon(Icons.close, size: 18.sp, color: AppColors.grey84),
              ),
            ],
          ),
          InputFormField(
            formFieldKey: weightFieldKey,
            controller: weightController,
            label: 'Xuất kho',
            bgColor: Colors.white,
            type: decimalInputType(),
            inputFormatters: decimalInputFormatter(),
            validator: (value) {
              final text = value?.trim() ?? '';
              if (text.isEmpty) return 'Vui lòng nhập khối lượng';
              final parsed = NumExt.tryParseComma(text);
              if (parsed == null) return 'Khối lượng phải là số hợp lệ';
              if (parsed < 0.01) return 'Giá trị nhỏ nhất là 0.01';
              return null;
            },
          ),
        ],
      ),
    );
  }
}
