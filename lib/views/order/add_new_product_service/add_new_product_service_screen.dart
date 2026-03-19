import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/data/models/product/product_variant.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/extension/extension.dart';
import 'package:zili_coffee/utils/widgets/widgets.dart';

import '../../common/input_form_field.dart';

class AddNewProductServiceScreen extends StatefulWidget {
  const AddNewProductServiceScreen({super.key});

  static String keyName = '/add-new-product-service';

  @override
  State<AddNewProductServiceScreen> createState() =>
      _AddNewProductServiceScreenState();
}

class _AddNewProductServiceScreenState
    extends State<AddNewProductServiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameFieldKey = GlobalKey<FormFieldState>();
  final _quantityFieldKey = GlobalKey<FormFieldState>();
  final _priceFieldKey = GlobalKey<FormFieldState>();
  final _discountFieldKey = GlobalKey<FormFieldState>();
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');
  final _priceController = TextEditingController();
  final _discountController = TextEditingController(text: '0');
  String _discountUnit = 'đ'; // 'đ' hoặc '%'
  double _totalPrice = 0.0;

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập tên sản phẩm dịch vụ';
    }
    return null;
  }

  String? _validateQuantity(String? value) {
    final quantity = double.tryParse((value ?? '').replaceAll(',', '.'));
    if (quantity == null) {
      return 'Số lượng không hợp lệ';
    } else if (quantity <= 0) {
      return 'Số lượng phải lớn hơn 0';
    }
    return null;
  }

  String? _validatePrice(String? value) {
    final price = double.tryParse((value ?? '').replaceAll(',', '.'));
    if (price == null) {
      return 'Đơn giá không hợp lệ';
    } else if (price <= 0) {
      return 'Đơn giá phải lớn hơn 0';
    }
    return null;
  }

  String? _validateDiscount(String? value) {
    if (value == null || value.isEmpty) return null;
    final discount = double.tryParse(value);
    if (discount == null || discount < 0) {
      return 'Chiết khấu không hợp lệ';
    }
    if (_discountUnit == '%' && discount > 100) {
      return 'Chiết khấu % tối đa 100';
    }
    return null;
  }

  Widget _discountUnitDropdown({
    required String current,
    required ValueChanged<String> onChanged,
  }) {
    return PopupMenuButton<String>(
      initialValue: current,
      padding: .zero,
      constraints: BoxConstraints(minWidth: 150.w, minHeight: 0),
      onSelected: onChanged,
      itemBuilder: (context) => [
        PopupMenuItem(
          enabled: false,
          height: 36.h,
          child: Align(
            alignment: .centerLeft,
            child: Text(
              'Đơn vị',
              style: AppStyles.text.medium(
                fSize: 14.sp,
                color: AppColors.black5,
              ),
            ),
          ),
        ),
        const PopupMenuDivider(height: 1, color: AppColors.grayEA),
        PopupMenuItem(
          value: 'đ',
          height: 32.h,
          child: Align(
            alignment: .centerLeft,
            child: Text(
              'đ',
              style: AppStyles.text.medium(
                fSize: 14.sp,
                color: AppColors.black3,
              ),
            ),
          ),
        ),
        PopupMenuItem(
          value: '%',
          height: 32.h,
          child: Align(
            alignment: .centerLeft,
            child: Text(
              '%',
              style: AppStyles.text.medium(
                fSize: 14.sp,
                color: AppColors.black3,
              ),
            ),
          ),
        ),
      ],
      child: Container(
        padding: .symmetric(horizontal: 8.w, vertical: 6.h),
        child: RowWidget(
          gap: 4.w,
          mainAxisSize: .min,
          children: [
            Text(
              current,
              style: AppStyles.text.medium(
                fSize: 12.sp,
                color: AppColors.black3,
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 16,
              color: AppColors.grey84,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
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
    super.dispose();
  }

  void _calculateTotalPrice() {
    final quantity =
        double.tryParse(_quantityController.text.replaceAll(',', '.')) ?? 0;
    final price =
        double.tryParse(_priceController.text.replaceAll(',', '.')) ?? 0.0;
    final discount =
        double.tryParse(_discountController.text.replaceAll(',', '.')) ?? 0.0;

    if (quantity <= 0 || price <= 0) {
      setState(() => _totalPrice = 0.0);
      return;
    }

    // discount per unit
    final discountValue =
        _discountUnit == '%' ? price * (discount / 100) : discount;
    final unitTotal = (price - discountValue).clamp(0, double.infinity);
    final total = quantity * unitTotal;

    setState(() => _totalPrice = total);
  }

  void _onCreateService() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final name = _nameController.text.trim();
    final quantity = double.tryParse(_quantityController.text) ?? 1;
    final price = double.tryParse(_priceController.text) ?? 0.0;
    final discount = double.tryParse(_discountController.text) ?? 0.0;

    // Tạo ProductVariant mới cho sản phẩm dịch vụ
    final serviceProduct = ProductVariant(
      id: "", // Temporary ID
      options: [],
      price: price,
      originalPrice: price,
      costPrice: 0.0,
      wholesalePrice: 0.0,
      inventory: 0.0,
      length: 0.0,
      weight: 0.0,
      height: 0.0,
      width: 0.0,
      slotBuy: '0',
      transactionCount: '0',
      inTransitCount: '0',
      deliveryCount: '0',
      availableQuantity: '0',
      status: 'ACTIVE',
      commission: 0.0,
      calculateByUnit: 'cái',
      quantity: quantity.toInt(),
      discount: discount > 0 ? discount : null,
      discountUnit: discount > 0 ? _discountUnit : null,
      totalPrice: _totalPrice,
      product: ProductInfo(
        id: "",
        titleVi: name,
        price: price,
        originalPrice: price,
        costPrice: 0.0,
        wholesalePrice: 0.0,
        slotBuy: 0.0,
        availableQuantity: 0.0,
      ),
    );

    // Trả về ProductVariant và back về màn hình trước
    Navigator.pop(context, serviceProduct);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget.lightAppBar(
        context,
        label: 'Thêm sản phẩm dịch vụ',
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
                ),
                InputFormField(
                  controller: _quantityController,
                  formFieldKey: _quantityFieldKey,
                  label: 'Số lượng',
                  hint: 'Nhập số lượng',
                  type: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [LengthLimitingTextInputFormatter(20)],
                  validator: _validateQuantity,
                ),
                InputFormField(
                  controller: _priceController,
                  formFieldKey: _priceFieldKey,
                  label: 'Đơn giá (đ)',
                  hint: 'Nhập đơn giá',
                  type: const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (value) => setState(() {}),
                  validator: _validatePrice,
                  inputFormatters: [LengthLimitingTextInputFormatter(20)],
                ),
                InputFormField(
                  controller: _discountController,
                  formFieldKey: _discountFieldKey,
                  label: 'Chiết khấu',
                  hint: 'Nhập chiết khấu',
                  type: const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (value) => setState(() {}),
                  validator: _validateDiscount,
                  inputFormatters: [LengthLimitingTextInputFormatter(20)],
                  suffix: _discountUnitDropdown(
                    current: _discountUnit,
                    onChanged: (value) {
                      setState(() => _discountUnit = value);
                      _calculateTotalPrice();
                    },
                  ),
                  suffixPadding: EdgeInsets.only(right: 8.w),
                ),
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
}
