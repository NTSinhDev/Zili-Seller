part of '../export_warehouse_for_slip_item_screen.dart';

class _MaterialVariantCard extends StatelessWidget {
  final bool isWeightBased;
  final ProductVariant variant;
  final VoidCallback onRemove;
  final TextEditingController weightController;
  final GlobalKey<FormFieldState> weightFieldKey;
  const _MaterialVariantCard({
    required this.isWeightBased,
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
        gap: 20.h,
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
                      'Tồn kho: ${variant.inventory.removeTrailingZero} (kg)',
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
            label: isWeightBased ? 'Khối lượng (kg)' : 'Số lượng',
            bgColor: Colors.white,
            type: decimalInputType(),
            inputFormatters: decimalInputFormatter(),
            validator: (value) {
              final text = value?.trim() ?? '';
              if (text.isEmpty) {
                return isWeightBased
                    ? 'Vui lòng nhập khối lượng'
                    : 'Vui lòng nhập số lượng';
              }
              final parsed = NumExt.tryParseComma(text);
              if (parsed == null) {
                return isWeightBased
                    ? 'Khối lượng phải là số hợp lệ'
                    : 'Số lượng phải là số hợp lệ';
              }
              if (isWeightBased) {
                if (parsed < 0.01) {
                  return 'Giá trị nhỏ nhất là 0.01 kg (10gram)';
                }
              } else {
                if (parsed < 1) {
                  return 'Giá trị nhỏ nhất là 1';
                }
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
