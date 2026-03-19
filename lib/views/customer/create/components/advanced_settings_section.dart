part of '../customer_create_screen.dart';

class _AdvancedSettingsSection extends StatelessWidget {
  final bool show;
  final Function() onAdd;
  final String? discountType;
  final Function(String) onDiscountTypeChanged;
  final SellerPaymentMethod? selectedPaymentMethod;
  final Function(SellerPaymentMethod?) onPaymentMethodSelected;
  final String? defaultPriceType;
  final Function(String) onDefaultPriceTypeChanged;
  final TextEditingController discountController;
  final GlobalKey<FormFieldState> discountFieldKey;
  const _AdvancedSettingsSection({
    required this.show,
    required this.onAdd,
    required this.discountType,
    required this.onDiscountTypeChanged,
    this.selectedPaymentMethod,
    required this.onPaymentMethodSelected,
    this.defaultPriceType,
    required this.onDefaultPriceTypeChanged,
    required this.discountController,
    required this.discountFieldKey,
  });

  @override
  Widget build(BuildContext context) {
    final PaymentRepository paymentRepo = di<PaymentRepository>();
    return InkWell(
      onTap: !show ? onAdd : null,
      child: Container(
        padding: .symmetric(vertical: 16.h, horizontal: 20.w),
        color: AppColors.white,
        child: ColumnWidget(
          crossAxisAlignment: .start,
          gap: 20.h,
          children: [
            if (!show)
              RowWidget(
                gap: 12.w,
                children: [
                  const Icon(Icons.add, color: AppColors.primary),
                  Text(
                    'Thêm cài đặt nâng cao',
                    style: AppStyles.text.semiBold(fSize: 16.sp),
                  ),
                ],
              )
            else ...[
              RowWidget(
                mainAxisAlignment: .spaceBetween,
                children: [
                  Text(
                    'Cài đặt nâng cao',
                    style: AppStyles.text.semiBold(fSize: 16.sp),
                  ),
                  InkWell(
                    onTap: show ? onAdd : null,
                    child: Icon(
                      Icons.close,
                      color: AppColors.grey84,
                      size: 20.sp,
                    ),
                  ),
                ],
              ),
              ColumnWidget(
                crossAxisAlignment: .start,
                gap: 12.h,
                children: [
                  Text(
                    'Áp dụng ưu đãi',
                    style: InputFormField.labelStyle.copyWith(
                      color: AppColors.black3,
                      fontSize: 15.sp,
                    ),
                  ),
                  CommonRadioButtonItem(
                    label: 'Theo nhóm khách hàng',
                    isSelected: discountType == 'GROUP',
                    canExpand: true,
                    onSelect: () => onDiscountTypeChanged('GROUP'),
                  ),
                  CommonRadioButtonItem(
                    label: 'Theo khách hàng',
                    isSelected: discountType == 'USER',
                    canExpand: true,
                    onSelect: () => onDiscountTypeChanged('USER'),
                  ),
                ],
              ),
              Offstage(
                offstage: discountType != 'USER',
                child: StreamSelectorFormField<SellerPaymentMethod>(
                  label: 'Phương thức thanh toán',
                  hintOrValue:
                      selectedPaymentMethod?.paymentMethodName ??
                      'Chọn Phương thức thanh toán',
                  selected: selectedPaymentMethod,
                  selectorStream: paymentRepo.paymentMethods.stream,
                  renderValue: (SellerPaymentMethod? value, onTap) =>
                      BottomSheetListItem(
                        isDense: true,
                        title:
                            value?.paymentMethodName ??
                            AppConstant.strings.DEFAULT_EMPTY_VALUE,
                        isSelected: selectedPaymentMethod?.id == value?.id,
                        onTap: onTap,
                      ),
                  onSelected: onPaymentMethodSelected,
                ),
              ),
              Offstage(
                offstage: discountType != 'USER',
                child: SelectorFormField<String>(
                  label: 'Giá mặc định',
                  hintOrValue: defaultPriceType ?? 'Chọn Giá mặc định',
                  options: ["INPUT", "RETAIL", "WHOLESALE"],
                  renderValue: (value, onTap) => BottomSheetListItem(
                    isDense: true,
                    title: value == "INPUT"
                        ? "Giá nhập"
                        : value == "RETAIL"
                        ? "Giá bán lẻ"
                        : "Giá bán buôn",
                    isSelected: defaultPriceType == "INPUT",
                    onTap: onTap,
                  ),
                  onSelected: (value) =>
                      onDefaultPriceTypeChanged(value ?? "INPUT"),
                ),
              ),
              Offstage(
                offstage: discountType != 'USER',
                child: InputFormField(
                  controller: discountController,
                  formFieldKey: discountFieldKey,
                  label: 'Giảm giá (%)',
                  hint: '0',
                  type: decimalInputType(),
                  inputFormatters: decimalInputFormatter(),
                  textInputAction: .done,
                  validator: (value) {
                    final discount = NumExt.tryParseComma(value?.trim() ?? '0');
                    if (discount != null && (discount < 0 || discount > 100)) {
                      return 'Giá trị không hợp lệ!';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
