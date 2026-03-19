import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../res/res.dart';
import '../../../../../utils/extension/extension.dart';
import '../../../../../utils/formatters/export.dart';
import '../../../../../utils/widgets/widgets.dart';
import '../../../bottom_scaffold_button.dart';
import '../../../input_form_field.dart';
import '../../../radio_button.dart';

class AddVatFeeScreen extends StatefulWidget {
  final double totalPrice;
  final double initialVat;
  final num? initialVatPercent;
  final String initialVatUnit;

  const AddVatFeeScreen({
    super.key,
    required this.totalPrice,
    this.initialVat = 0.0,
    this.initialVatPercent = 0.0,
    this.initialVatUnit = 'đ',
  });

  @override
  State<AddVatFeeScreen> createState() => _AddVatFeeScreenState();
}

class _AddVatFeeScreenState extends State<AddVatFeeScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _vatController;
  final GlobalKey<FormFieldState> _vatFieldKey = GlobalKey<FormFieldState>();
  late String _vatUnit;

  @override
  void initState() {
    super.initState();
    _vatUnit = widget.initialVatUnit;
    String? initialText;
    if (_vatUnit == '%') {
      initialText = widget.initialVatPercent?.decimalValueInput;
    } else {
      initialText = widget.initialVat > 0
          ? widget.initialVat.decimalValueInput
          : "";
    }
    _vatController = TextEditingController(text: initialText);
  }

  @override
  void dispose() {
    _vatController.dispose();
    super.dispose();
  }

  String? _validateVat(String? value) {
    if (value == null || value.isEmpty) return null;

    final vat = NumExt.tryParseComma(value);
    if (vat == null) return 'VAT không hợp lệ';
    if (vat < 0) return 'VAT không được âm';
    if (_vatUnit == '%') {
      if (vat > 100) return 'VAT không được lớn hơn 100%';
    } else {
      if (vat > widget.totalPrice) {
        return 'VAT không được vượt quá tổng tiền';
      }
    }
    return null;
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;

    final value = NumExt.tryParseComma(_vatController.text) ?? 0.0;
    final vat = _vatUnit == '%' ? value * widget.totalPrice / 100 : value;
    Navigator.pop(context, {
      'vat': vat,
      'vatPercent': _vatUnit == '%' ? value : null,
      'vatUnit': _vatUnit,
    });
  }

  void _onCancel() {
    Navigator.pop(context, {'vat': 0.0, 'vatPercent': 0.0, 'vatUnit': 'đ'});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget.lightAppBar(
        context,
        elevation: 1,
        shadowColor: AppColors.black.withValues(alpha: 0.5),
        label: 'Thêm thuế (VAT)',
      ),
      backgroundColor: AppColors.background,
      body: Form(
        key: _formKey,
        child: ColumnWidget(
          padding: .symmetric(vertical: 20.h),
          gap: 20.h,
          children: [
            ColumnWidget(
              gap: 8.h,
              children: [
                Text(
                  'Tổng tiền hàng',
                  style: AppStyles.text.medium(
                    fSize: 14.sp,
                    color: AppColors.grey84,
                  ),
                ),
                Text(
                  widget.totalPrice.toPrice(),
                  style: AppStyles.text.bold(
                    fSize: 32.sp,
                    color: AppColors.black3,
                  ),
                ),
              ],
            ),
            ColumnWidget(
              margin: EdgeInsets.only(top: 16.h),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              backgroundColor: AppColors.white,
              crossAxisAlignment: CrossAxisAlignment.start,
              gap: 12.h,
              children: [
                Text(
                  'Thêm tùy chỉnh VAT cho đơn hàng',
                  style: AppStyles.text.semiBold(fSize: 16.sp),
                ),
                ColumnWidget(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  gap: 8.h,
                  children: [
                    CommonRadioButtonItem(
                      canExpand: false,
                      label: 'đ (đơn vị đồng)',
                      isSelected: _vatUnit == 'đ',
                      onSelect: () {
                        setState(() {
                          _vatUnit = 'đ';
                          _vatController.text = '';
                        });
                      },
                    ),
                    CommonRadioButtonItem(
                      canExpand: false,
                      label: '% (Phần trăm)',
                      isSelected: _vatUnit == '%',
                      onSelect: () {
                        setState(() {
                          _vatUnit = '%';
                          _vatController.text = '';
                        });
                      },
                    ),
                    SizedBox.shrink(),
                    InputFormField(
                      controller: _vatController,
                      formFieldKey: _vatFieldKey,
                      label: 'Nhập chiết khấu',
                      hint: '0',
                      textInputAction: .done,
                      type: decimalInputType(),
                      inputFormatters: decimalInputFormatter(),
                      validator: _validateVat,
                      suffix: Padding(
                        padding: .symmetric(horizontal: 8.w),
                        child: Text(
                          _vatUnit,
                          style: AppStyles.text.semiBold(fSize: 14.sp),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      extendBody: true,
      bottomNavigationBar: BottomScaffoldRowButtons(
        buttons: <BottomScaffoldButtonModel>[
          .new(
            label: 'Hủy áp dụng',
            onTap: _onCancel,
            style: .outline,
            color: .danger,
          ),
          .new(
            label: 'Xác nhận',
            onTap: _onSubmit,
            style: .filled,
            color: .primary,
          ),
        ],
      ),
    );
  }
}
