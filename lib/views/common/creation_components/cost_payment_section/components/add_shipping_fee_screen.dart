import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/utils/extension/extension.dart';

import '../../../../../res/res.dart';
import '../../../../../utils/enums/payment_enum.dart';
import '../../../../../utils/formatters/export.dart';
import '../../../../../utils/widgets/widgets.dart';
import '../../../bottom_scaffold_button.dart';
import '../../../input_form_field.dart';
import '../../../radio_button.dart';

class AddShippingFeeScreen extends StatefulWidget {
  final double initialShippingFee;

  const AddShippingFeeScreen({super.key, this.initialShippingFee = 0.0});

  @override
  State<AddShippingFeeScreen> createState() => _AddShippingFeeScreenState();
}

class _AddShippingFeeScreenState extends State<AddShippingFeeScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _feeController;
  final GlobalKey<FormFieldState> _feeFieldKey = GlobalKey<FormFieldState>();
  ShippingFeeType _feeType = .free;

  @override
  void initState() {
    super.initState();
    if (widget.initialShippingFee > 0) {
      _feeType = .fee;
      _feeController = TextEditingController(
        text: widget.initialShippingFee.decimalValueInput,
      );
    } else {
      _feeType = .free;
      _feeController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _feeController.dispose();
    super.dispose();
  }

  String? _validateFee(String? value) {
    if (_feeType == .fee) {
      if (value == null || value.isEmpty) {
        return 'Vui lòng nhập phí giao hàng';
      }
      final fee = NumExt.tryParseComma(value);
      if (fee == null) return 'Phí giao hàng không hợp lệ';
      if (fee < 0) return 'Phí giao hàng không được âm';
    }
    return null;
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;

    double shippingFee = 0.0;
    if (_feeType == .fee) {
      shippingFee =
          NumExt.tryParseComma(_feeController.text)?.toDouble() ?? 0.0;
    }
    // Nếu _feeType == 'config', shippingFee = 0 (sẽ tích hợp sau)

    Navigator.pop(context, {'shippingFee': shippingFee});
  }

  /// Hủy áp dụng shipping fee - reset về 0
  void _onCancel() {
    Navigator.pop(context, {'shippingFee': 0.0});
  }

  void _showSuggestedShippingFee() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: ColumnWidget(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: RowWidget(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Gợi ý phí giao hàng',
                    style: AppStyles.text.semiBold(fSize: 16.sp),
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.all(4.w),
                      child: const Icon(Icons.close, color: AppColors.grey84),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            CommonRadioButtonItem(
              label: 'Giao hàng sau',
              isSelected: false,
              onSelect: () {
                Navigator.pop(context);
                setState(() {
                  _feeType = .config;
                  _feeController.text = '';
                });
                // TODO: Tích hợp logic "Giao hàng sau" sau
              },
            ),
            CommonRadioButtonItem(
              label: 'Nhận tại cửa hàng',
              isSelected: false,
              onSelect: () {
                Navigator.pop(context);
                setState(() {
                  _feeType = .config;
                  _feeController.text = '';
                });
                // TODO: Tích hợp logic "Nhận tại cửa hàng" sau
              },
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget.lightAppBar(
        label: 'Thêm phí giao hàng',
        context,
        elevation: 1,
        shadowColor: AppColors.black.withValues(alpha: 0.5),
      ),
      backgroundColor: AppColors.background,
      body: Form(
        key: _formKey,
        child: ColumnWidget(
          margin: .only(top: 16.h),
          padding: .symmetric(horizontal: 20.w, vertical: 16.h),
          backgroundColor: AppColors.white,
          crossAxisAlignment: .start,
          mainAxisSize: .min,
          gap: 16.h,
          children: [
            Row(
              children: [
                ColumnWidget(
                  gap: 8.h,
                  children: [
                    Text(
                      'Cấu hình phí giao hàng',
                      style: AppStyles.text.semiBold(fSize: 16.sp),
                    ),
                    CommonRadioButtonItem(
                      canExpand: false,
                      label: 'Miễn phí',
                      isSelected: _feeType == .free,
                      onSelect: () {
                        if (_feeType != .free) {
                          setState(() {
                            _feeType = .free;
                          });
                        }
                      },
                    ),
                    CommonRadioButtonItem(
                      canExpand: false,
                      label: 'Phí khác',
                      isSelected: _feeType == .fee,
                      onSelect: () {
                        if (_feeType != .fee) {
                          setState(() {
                            _feeType = .fee;
                            if (_feeController.text == '0') {
                              _feeController.clear();
                            }
                          });
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
            Offstage(
              offstage: _feeType == .free,
              child: InputFormField(
                controller: _feeController,
                formFieldKey: _feeFieldKey,
                label: 'Nhập phí giao hàng',
                hint: '0',
                textInputAction: .done,
                type: decimalInputType(),
                inputFormatters: decimalInputFormatter(),
                validator: _validateFee,
                suffix: Padding(
                  padding: .symmetric(horizontal: 8.w),
                  child: Text(
                    AppConstant.strings.VND,
                    style: AppStyles.text.semiBold(fSize: 14.sp),
                  ),
                ),
              ),
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