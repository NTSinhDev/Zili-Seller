import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../res/res.dart';
import '../../../../../utils/extension/extension.dart';
import '../../../../../utils/formatters/export.dart';
import '../../../../../utils/widgets/widgets.dart';
import '../../../bottom_scaffold_button.dart';
import '../../../input_form_field.dart';
import '../../../radio_button.dart';

class AddDiscountFeeScreen extends StatefulWidget {
  final double totalPrice;
  final double initialDiscount;
  final num? initialDiscountPercent;
  final String initialDiscountUnit;

  const AddDiscountFeeScreen({
    super.key,
    required this.totalPrice,
    this.initialDiscount = 0.0,
    this.initialDiscountPercent = 0.0,
    this.initialDiscountUnit = 'đ',
  });

  @override
  State<AddDiscountFeeScreen> createState() => _AddDiscountFeeScreenState();
}

class _AddDiscountFeeScreenState extends State<AddDiscountFeeScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _discountController;
  final GlobalKey<FormFieldState> _discountFieldKey =
      GlobalKey<FormFieldState>();

  late String _discountUnit;

  @override
  void initState() {
    super.initState();
    _discountUnit = widget.initialDiscountUnit;
    String? initialText;
    if (_discountUnit == '%') {
      initialText = widget.initialDiscountPercent?.decimalValueInput;
    } else {
      initialText = widget.initialDiscount > 0
          ? widget.initialDiscount.decimalValueInput
          : "";
    }
    _discountController = TextEditingController(text: initialText);
  }

  @override
  void dispose() {
    _discountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget.lightAppBar(
        context,
        elevation: 1,
        shadowColor: AppColors.black.withValues(alpha: 0.5),
        label: 'Thêm chiết khấu',
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
                    fSize: 40.sp,
                    color: AppColors.black3,
                  ),
                ),
              ],
            ),
            ColumnWidget(
              margin: .only(top: 16.h),
              padding: .symmetric(horizontal: 20.w, vertical: 16.h),
              backgroundColor: AppColors.white,
              crossAxisAlignment: .start,
              gap: 12.h,
              children: [
                Text(
                  'Thêm tùy chỉnh chiết khấu cho đơn hàng',
                  style: AppStyles.text.medium(fSize: 16.sp),
                ),
                ColumnWidget(
                  crossAxisAlignment: .start,
                  gap: 8.h,
                  children: [
                    CommonRadioButtonItem(
                      canExpand: false,
                      label: 'đ (đơn vị đồng)',
                      isSelected: _discountUnit == 'đ',
                      onSelect: () {
                        setState(() {
                          _discountUnit = 'đ';
                          // Khi đổi unit, reset về 0 để tránh nhầm lẫn
                          // User có thể nhập lại giá trị mới
                          _discountController.text = '';
                        });
                      },
                    ),
                    CommonRadioButtonItem(
                      canExpand: false,
                      label: '% (Phần trăm)',
                      isSelected: _discountUnit == '%',
                      onSelect: () {
                        setState(() {
                          _discountUnit = '%';
                          // Khi đổi unit, reset về 0 để tránh nhầm lẫn
                          // User có thể nhập lại giá trị mới
                          _discountController.text = '';
                        });
                      },
                    ),
                    SizedBox.shrink(),
                    InputFormField(
                      controller: _discountController,
                      formFieldKey: _discountFieldKey,
                      label: 'Nhập chiết khấu',
                      hint: '0',
                      textInputAction: .done,
                      type: decimalInputType(),
                      inputFormatters: decimalInputFormatter(),
                      validator: _validateDiscount,
                      suffix: Padding(
                        padding: .symmetric(horizontal: 8.w),
                        child: Text(
                          _discountUnit,
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

  String? _validateDiscount(String? value) {
    if (value == null || value.isEmpty) return null;

    if (_discountUnit == 'đ') {
      final discount = NumExt.tryParseComma(value);
      if (discount == null) return 'Chiết khấu không hợp lệ';
      if (discount < 0) return 'Chiết khấu không được âm';
      if (discount > widget.totalPrice) {
        return 'Chiết khấu không được vượt quá giá đơn hàng';
      }
    } else {
      final discount = NumExt.tryParseComma(value);
      if (discount == null) return 'Chiết khấu không hợp lệ';
      if (discount < 0) return 'Chiết khấu không được nhỏ hơn 0%';
      if (discount > 100) return 'Chiết khấu không được lớn hơn 100%';
    }
    return null;
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;

    final value = NumExt.tryParseComma(_discountController.text) ?? 0.0;
    final discount = _discountUnit == '%'
        ? value * widget.totalPrice / 100
        : value;
    Navigator.pop(context, {
      'discount': discount,
      'discountPercent': _discountUnit == '%' ? value : null,
      'discountUnit': _discountUnit,
    });
  }

  /// Hủy áp dụng discount - reset về 0 và unit mặc định 'đ'
  void _onCancel() {
    Navigator.pop(context, {
      'discount': 0.0,
      'discountPercent': 0.0,
      'discountUnit': 'đ', // Reset về unit mặc định
    });
  }
}
