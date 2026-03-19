part of '../customer_create_screen.dart';

class _AdditionalInformationSection extends StatelessWidget {
  final bool show;
  final Function() onAdd;
  final TextEditingController deliveryAddressController;
  final GlobalKey<FormFieldState> deliveryAddressFieldKey;
  final TextEditingController invoiceAddressController;
  final GlobalKey<FormFieldState> invoiceAddressFieldKey;
  final TextEditingController noteController;
  final GlobalKey<FormFieldState> noteFieldKey;
  final TextEditingController taxCodeController;
  final GlobalKey<FormFieldState> taxCodeFieldKey;
  final TextEditingController faxCodeController;
  final GlobalKey<FormFieldState> faxCodeFieldKey;
  final TextEditingController websiteController;
  final GlobalKey<FormFieldState> websiteFieldKey;
  final TextEditingController currentDebtController;
  final GlobalKey<FormFieldState> currentDebtFieldKey;
  final TextEditingController totalSpendingController;
  final GlobalKey<FormFieldState> totalSpendingFieldKey;
  final DateTime? birthday;
  final Function(DateTime?) onBirthdayChanged;
  final Gender? gender;
  final Function(Gender) onGenderChanged;

  const _AdditionalInformationSection({
    required this.show,
    required this.onAdd,
    required this.deliveryAddressController,
    required this.deliveryAddressFieldKey,
    required this.invoiceAddressController,
    required this.invoiceAddressFieldKey,
    required this.noteController,
    required this.noteFieldKey,
    required this.taxCodeController,
    required this.taxCodeFieldKey,
    required this.faxCodeController,
    required this.faxCodeFieldKey,
    required this.websiteController,
    required this.websiteFieldKey,
    required this.currentDebtController,
    required this.currentDebtFieldKey,
    required this.totalSpendingController,
    required this.totalSpendingFieldKey,
    required this.birthday,
    required this.onBirthdayChanged,
    required this.gender,
    required this.onGenderChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: !show ? onAdd : null,
      child: Container(
        padding: .symmetric(vertical: 16.h, horizontal: 20.w),
        color: AppColors.white,
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Offstage(
              offstage: show,
              child: RowWidget(
                gap: 12.w,
                children: [
                  const Icon(Icons.add, color: AppColors.primary),
                  Text(
                    'Thêm thông tin bổ sung',
                    style: AppStyles.text.semiBold(fSize: 16.sp),
                  ),
                ],
              ),
            ),
            Offstage(
              offstage: !show,
              child: ColumnWidget(
                crossAxisAlignment: .start,
                gap: 20.h,
                children: [
                  RowWidget(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Text(
                        'Thông tin bổ sung',
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
                  // InputFormField(
                  //   controller: deliveryAddressController,
                  //   formFieldKey: deliveryAddressFieldKey,
                  //   label: 'Địa chỉ giao hàng',
                  //   hint: 'Nhập địa chỉ giao hàng',
                  //   type: TextInputType.streetAddress,
                  //   textInputAction: TextInputAction.next,
                  //   maxLines: 3,
                  // ),
                  // InputFormField(
                  //   controller: invoiceAddressController,
                  //   formFieldKey: invoiceAddressFieldKey,
                  //   label: 'Địa chỉ nhận hóa đơn',
                  //   hint: 'Nhập địa chỉ nhận hóa đơn',
                  //   type: TextInputType.streetAddress,
                  //   textInputAction: TextInputAction.next,
                  //   maxLines: 3,
                  // ),
                  DateSelectorField(
                    label: 'Ngày sinh',
                    hint: 'Chọn ngày sinh',
                    datetime: birthday,
                    onChanged: onBirthdayChanged,
                  ),
                  ColumnWidget(
                    crossAxisAlignment: .start,
                    gap: 12.h,
                    children: [
                      Text(
                        'Giới tính',
                        style: InputFormField.labelStyle.copyWith(
                          color: gender != null
                              ? AppColors.black3
                              : AppColors.grey84,
                        ),
                      ),
                      Row(
                        children: [
                          _GenderRadioItem(
                            label: 'Nam',
                            value: Gender.male,
                            selected: gender,
                            onChanged: onGenderChanged,
                          ),
                          width(width: 30),
                          _GenderRadioItem(
                            label: 'Nữ',
                            value: Gender.female,
                            selected: gender,
                            onChanged: onGenderChanged,
                          ),
                          width(width: 30),
                          _GenderRadioItem(
                            label: 'Khác',
                            value: Gender.other,
                            selected: gender,
                            onChanged: onGenderChanged,
                          ),
                        ],
                      ),
                    ],
                  ),
                  InputFormField(
                    controller: faxCodeController,
                    formFieldKey: faxCodeFieldKey,
                    label: 'Mã số fax',
                    hint: 'Nhập mã số fax',
                    type: .text,
                    textInputAction: .next,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Z0-9-]+'),
                      ),
                    ],
                  ),
                  InputFormField(
                    controller: taxCodeController,
                    formFieldKey: taxCodeFieldKey,
                    label: 'Mã số thuế',
                    hint: 'Nhập mã số thuế',
                    type: .text,
                    textInputAction: .next,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Z0-9]+'),
                      ),
                    ],
                  ),
                  InputFormField(
                    controller: websiteController,
                    formFieldKey: websiteFieldKey,
                    label: 'website',
                    hint: 'Nhập website',
                    type: .text,
                    textInputAction: .next,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        // Cho phép domain/path đơn giản: chữ, số, ., -, _, :, /
                        RegExp(r'[a-zA-Z0-9._:/-]+'),
                      ),
                    ],
                  ),
                  InputFormField(
                    controller: currentDebtController,
                    formFieldKey: currentDebtFieldKey,
                    label: 'Công nợ',
                    hint: 'Nhập công nợ',
                    textInputAction: .next,
                    type: decimalInputType(),
                    inputFormatters: decimalInputFormatter(),
                  ),
                  InputFormField(
                    controller: totalSpendingController,
                    formFieldKey: totalSpendingFieldKey,
                    label: 'Tổng chi tiêu',
                    hint: 'Nhập tổng chi tiêu',
                    textInputAction: .done,
                    type: decimalInputType(),
                    inputFormatters: decimalInputFormatter(),
                  ),
                  // InputFormField(
                  //   controller: noteController,
                  //   formFieldKey: noteFieldKey,
                  //   label: 'Ghi chú',
                  //   hint: 'Nhập ghi chú',
                  //   type: TextInputType.multiline,
                  //   textInputAction: TextInputAction.newline,
                  //   maxLines: 5,
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GenderRadioItem extends StatelessWidget {
  final String label;
  final Gender value;
  final Gender? selected;
  final Function(Gender) onChanged;

  const _GenderRadioItem({
    required this.label,
    required this.value,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selected == value;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () => onChanged(value),
          borderRadius: BorderRadius.circular(20.r),
          child: Container(
            padding: EdgeInsets.all(4.w),
            child: CommonRadioButton(isActive: isSelected),
          ),
        ),
        width(width: 8),
        Text(
          label,
          style: AppStyles.text.medium(
            fSize: 14.sp,
            color: isSelected ? AppColors.primary : AppColors.black3,
          ),
        ),
      ],
    );
  }
}
