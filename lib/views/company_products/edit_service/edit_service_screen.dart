import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/data/models/product/product_variant.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/extension/extension.dart';
import 'package:zili_coffee/utils/widgets/widgets.dart';

import '../../../utils/formatters/export.dart';
import '../../common/input_form_field.dart';
import '../../common/radio_button.dart';

class EditServiceScreen extends StatefulWidget {
  final ServiceProduct serviceProduct;
  const EditServiceScreen({super.key, required this.serviceProduct});

  static String keyName = '/product/edit-service';

  @override
  State<EditServiceScreen> createState() => _EditServiceScreenState();
}

class _EditServiceScreenState extends State<EditServiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameFieldKey = GlobalKey<FormFieldState>();
  final _quantityFieldKey = GlobalKey<FormFieldState>();
  final _priceFieldKey = GlobalKey<FormFieldState>();
  final _discountFieldKey = GlobalKey<FormFieldState>();
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  final _discountController = TextEditingController();
  final _noteController = TextEditingController();
  String _discountUnit = 'đ'; // 'đ' hoặc '%'
  num _totalPrice = 0;

  @override
  void initState() {
    super.initState();
    // Init value
    _nameController.text = widget.serviceProduct.product?.titleVi ?? "";
    _quantityController.text = widget.serviceProduct.quantity.decimalValueInput;
    _priceController.text = widget.serviceProduct.price.decimalValueInput;
    _discountController.text =
        widget.serviceProduct.discount?.decimalValueInput ?? '';
    _discountUnit = widget.serviceProduct.discountUnit ?? 'đ';
    _calculateTotalPrice();

    // Add listen event
    _quantityController.addListener(_calculateTotalPrice);
    _priceController.addListener(_calculateTotalPrice);
    _discountController.addListener(_calculateTotalPrice);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _discountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget.lightAppBar(
        context,
        label: 'Chỉnh sửa sản phẩm dịch vụ',
        elevation: 1,
        shadowColor: AppColors.black.withValues(alpha: 0.5),
      ),
      backgroundColor: AppColors.background,
      body: GestureDetector(
        onTap: context.focus.unfocus,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: ColumnWidget(
              crossAxisAlignment: .start,
              margin: .only(top: 12.h),
              padding: .symmetric(horizontal: 20.w, vertical: 24.h),
              backgroundColor: Colors.white,
              gap: 16.h,
              children: [
                InputFormField(
                  controller: _nameController,
                  formFieldKey: _nameFieldKey,
                  label: 'Tên sản phẩm dịch vụ',
                  hint: 'Nhập tên sản phẩm dịch vụ',
                  validator: _validateName,
                  textInputAction: .done,
                ),
                InputFormField(
                  controller: _priceController,
                  formFieldKey: _priceFieldKey,
                  label: 'Đơn giá (đ)',
                  hint: 'Nhập đơn giá',
                  type: decimalInputType(),
                  inputFormatters: decimalInputFormatter(),
                  validator: _validatePrice,
                  textInputAction: .done,
                ),
                InputFormField(
                  controller: _quantityController,
                  formFieldKey: _quantityFieldKey,
                  label: 'Số lượng',
                  hint: 'Nhập số lượng',
                  type: decimalInputType(),
                  inputFormatters: decimalInputFormatter(),
                  validator: _validateQuantity,
                  textInputAction: .done,
                ),
                InputFormField(
                  controller: _discountController,
                  formFieldKey: _discountFieldKey,
                  label: 'Chiết khấu',
                  hint: 'Nhập chiết khấu',
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
                RowWidget(
                  gap: 20.w,
                  children: [
                    CommonRadioButtonItem(
                      canExpand: false,
                      label: 'đ (đơn vị đồng)',
                      isSelected: _discountUnit == 'đ',
                      onSelect: () {
                        setState(() {
                          _discountUnit = 'đ';
                        });
                        _discountController.text = '';
                        _calculateTotalPrice();
                      },
                    ),
                    CommonRadioButtonItem(
                      canExpand: false,
                      label: '% (Phần trăm)',
                      isSelected: _discountUnit == '%',
                      onSelect: () {
                        setState(() {
                          _discountUnit = '%';
                        });
                        _discountController.text = '';
                        _calculateTotalPrice();
                      },
                    ),
                  ],
                ),
                // InputFormField(
                //   formFieldKey: GlobalKey<FormFieldState>(),
                //   controller: _noteController,
                //   label: 'Ghi chú',
                //   hint: 'Nhập ghi chú',
                //   maxLines: 3,
                //   type: .text,
                //   textInputAction: .done,
                // ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: .symmetric(horizontal: 20.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border(top: BorderSide(color: AppColors.grayEA)),
        ),
        child: ColumnWidget(
          gap: 16.h,
          mainAxisSize: .min,
          children: [
            RowWidget(
              mainAxisAlignment: .start,
              crossAxisAlignment: .end,
              gap: 20.w,
              children: [
                Text(
                  'Tổng giá trị:',
                  style: AppStyles.text.semiBold(
                    fSize: 14.sp,
                    color: AppColors.black3,
                  ),
                ),
                Text(
                  _totalPrice.toPrice(),
                  style: AppStyles.text.bold(
                    fSize: 16.sp,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            RowWidget(
              gap: 20.w,
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.grayEA),
                      padding: .symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: .circular(8.r),
                      ),
                    ),
                    onPressed: context.navigator.maybePop,
                    child: Text(
                      'Hủy',
                      style: AppStyles.text.semiBold(
                        fSize: 14.sp,
                        color: AppColors.black3,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: .symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: .circular(8.r),
                      ),
                      elevation: 0,
                    ),
                    onPressed: _onCreateService,
                    child: Text(
                      'Xác nhận dịch vụ',
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
    );
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập tên sản phẩm dịch vụ';
    }
    return null;
  }

  String? _validateQuantity(String? value) {
    final quantity = NumExt.tryParseComma(value);
    if (quantity == null) {
      return 'Số lượng không hợp lệ';
    } else if (quantity <= 0) {
      return 'Số lượng phải lớn hơn 0';
    }
    return null;
  }

  String? _validatePrice(String? value) {
    final price = NumExt.tryParseComma(value);
    if (price == null) {
      return 'Đơn giá không hợp lệ';
    } else if (price <= 0) {
      return 'Đơn giá phải lớn hơn 0';
    }
    return null;
  }

  String? _validateDiscount(String? value) {
    if (value == null || value.isEmpty) return null;
    final discount = NumExt.tryParseComma(value);
    if (discount == null || discount < 0) {
      return 'Chiết khấu không hợp lệ';
    }
    if (_discountUnit == '%' && discount > 100) {
      return 'Chiết khấu % tối đa 100';
    }
    return null;
  }

  void _calculateTotalPrice() {
    final quantity = NumExt.tryParseComma(_quantityController.text) ?? 0;
    final price = NumExt.tryParseComma(_priceController.text) ?? 0.0;
    final discount = NumExt.tryParseComma(_discountController.text) ?? 0.0;

    if (quantity <= 0 || price <= 0) {
      setState(() => _totalPrice = 0.0);
      return;
    }

    // discount per unit
    final discountValue = _discountUnit == '%'
        ? price * (discount / 100)
        : discount;
    final unitTotal = (price - discountValue).clamp(0, double.infinity);
    final total = quantity * unitTotal;

    setState(() => _totalPrice = total);
  }

  void _onCreateService() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final name = _nameController.text.trim();
    final quantity = NumExt.tryParseComma(_quantityController.text) ?? 1;
    final price = NumExt.tryParseComma(_priceController.text) ?? 0.0;
    final discount = NumExt.tryParseComma(_discountController.text) ?? 0.0;

    // Tạo ProductVariant mới cho sản phẩm dịch vụ
    final serviceProduct = ServiceProduct(
      price: price.toDouble(),
      originalPrice: price.toDouble(),
      quantity: quantity.toDouble(),
      discount: discount > 0 ? discount.toDouble() : null,
      discountUnit: discount > 0 ? _discountUnit : null,
      totalPrice: _totalPrice.toDouble(),
      note: _noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim(),
      product: ProductInfo(
        id: "",
        titleVi: name,
        price: price.toDouble(),
        originalPrice: price.toDouble(),
      ),
    );

    // Trả về ProductVariant và back về màn hình trước
    Navigator.pop(context, serviceProduct);
  }
}
