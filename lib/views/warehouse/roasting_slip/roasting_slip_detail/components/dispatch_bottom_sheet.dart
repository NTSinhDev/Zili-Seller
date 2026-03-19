part of '../roasting_slip_detail_screen.dart';

class _DispatchBottomSheet extends StatefulWidget {
  final RoastingSlipDetail detail;
  final Function(double weight, String roastingSlipId, String? note) onSubmit;
  const _DispatchBottomSheet({required this.detail, required this.onSubmit});

  @override
  State<_DispatchBottomSheet> createState() => _DispatchBottomSheetState();
}

class _DispatchBottomSheetState extends State<_DispatchBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState> _weightFieldKey = GlobalKey<FormFieldState>();
  late final TextEditingController _weightController;
  late final TextEditingController _noteController;

  @override
  void initState() {
    _weightController = TextEditingController();
    _noteController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _weightController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  ProductVariant? get _variant => widget.detail.greenVariant;

  @override
  Widget build(BuildContext context) {
    final branchName =
        widget.detail.exportWarehouseName ?? widget.detail.warehouseName ?? '';
    final availableQty = double.tryParse(_variant?.slotBuy ?? '') ?? 0;

    return SafeArea(
      child: SingleChildScrollView(
        child: ColumnWidget(
          children: [
            BottomSheetHeader(
              title: 'Xuất kho nhân xanh',
              onClose: context.navigator.pop,
            ),
            Form(
              key: _formKey,
              child: ColumnWidget(
                padding: .symmetric(horizontal: 16.w, vertical: 16.h),
                gap: 20.h,
                children: [
                  _buildProductCard(availableQty),
                  OpenBottomSheetListButton(
                    label: 'Chi nhánh xuất',
                    value: branchName.isNotEmpty
                        ? branchName
                        : AppConstant.strings.DEFAULT_EMPTY_VALUE,
                    disable: true,
                    onTap: () {},
                  ),
                  InputFormField(
                    formFieldKey: _weightFieldKey,
                    controller: _weightController,
                    label: 'Khối lượng xuất kho (kg)',
                    type: decimalInputType(),
                    inputFormatters: decimalInputFormatter(),
                    validator: (value) {
                      final text = value?.trim() ?? '';
                      if (text.isEmpty) return 'Vui lòng nhập khối lượng xuất';
                      final parsed = NumExt.tryParseComma(text);
                      if (parsed == null) return 'Khối lượng phải là số hợp lệ';
                      if (parsed < 0) return 'Khối lượng phải lớn hơn 0';
                      if (parsed > availableQty) {
                        return 'Không được vượt tồn kho (${availableQty.removeTrailingZero} kg)';
                      }
                      return null;
                    },
                  ),
                  NoteInputField(
                    controller: _noteController,
                    labelText: 'Ghi chú',
                    hintText: 'Ghi chú',
                  ),
                  RowWidget(
                    gap: 12.w,
                    margin: .only(top: 8.h),
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: context.navigator.pop,
                          style: OutlinedButton.styleFrom(
                            padding: .symmetric(vertical: 12.h),
                            side: const BorderSide(color: AppColors.grayEA),
                            shape: RoundedRectangleBorder(
                              borderRadius: .circular(8.r),
                            ),
                          ),
                          child: Text(
                            'Hủy',
                            style: AppStyles.text.medium(
                              fSize: 14.sp,
                              color: AppColors.black3,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _handleSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: .symmetric(vertical: 12.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: .circular(8.r),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Xác nhận',
                            style: AppStyles.text.semiBold(
                              fSize: 14.sp,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(double availableQty) {
    final variant = _variant;
    final title = renderProductVariantTitle(variant);
    final sku = variant?.sku ?? AppConstant.strings.DEFAULT_EMPTY_VALUE;
    final image = variant?.imageVariant;
    return ColumnWidget(
      gap: 12.h,
      children: [
        Container(
          padding: .all(12.w),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: .circular(8.r),
          ),
          width: .infinity,
          child: RowWidget(
            crossAxisAlignment: .center,
            gap: 12.w,
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: .circular(8.r),
                ),
                child: ClipRRect(
                  borderRadius: .circular(8.r),
                  child: image != null && image.isNotEmpty
                      ? ImageLoadingWidget(
                          hasPlaceHolder: false,
                          url: image,
                          width: 40.w,
                          height: 40.w,
                          borderRadius: false,
                        )
                      : Icon(
                          Icons.image_outlined,
                          size: 24.sp,
                          color: AppColors.grey84,
                        ),
                ),
              ),
              Expanded(
                child: ColumnWidget(
                  crossAxisAlignment: .start,
                  gap: 6.h,
                  children: [
                    Text(
                      title,
                      style: AppStyles.text.semiBold(
                        fSize: 14.sp,
                        color: AppColors.black3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      sku,
                      style: AppStyles.text.medium(
                        fSize: 12.sp,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              ColumnWidget(
                crossAxisAlignment: .end,
                gap: 6.h,
                children: [
                  Text(
                    'Tồn kho',
                    style: AppStyles.text.medium(
                      fSize: 12.sp,
                      color: AppColors.black5,
                    ),
                  ),
                  Text(
                    '${availableQty.removeTrailingZero} kg',
                    style: AppStyles.text.bold(
                      fSize: 16.sp,
                      color: AppColors.black3,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Divider(color: AppColors.black.withValues(alpha: 0.2), height: 1.h),
      ],
    );
  }

  void _handleSubmit() {
    final isWeightValid = _weightFieldKey.currentState?.validate() ?? false;
    if (!isWeightValid) return;

    final parsed = NumExt.tryParseComma(_weightController.text) ?? 0;
    final txtNote =
        _noteController.text.trim().isEmpty ||
            _noteController.text == AppConstant.strings.DEFAULT_EMPTY_VALUE
        ? null
        : _noteController.text.trim();

    widget.onSubmit(parsed.toDouble(), widget.detail.code, txtNote);
  }
}
