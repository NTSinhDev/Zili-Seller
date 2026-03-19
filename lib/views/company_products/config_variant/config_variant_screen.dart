// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../data/models/product/product_variant.dart';
import '../../../res/res.dart';
import '../../../utils/extension/extension.dart';
import '../../../utils/formatters/export.dart';
import '../../../utils/widgets/widgets.dart';
import '../../common/bottom_scaffold_button.dart';
import '../../common/input_form_field.dart';
import '../../common/radio_button.dart';
import '../../common/selector_form_field.dart';

class ConfigVariantProps {
  final num qty;
  final num price;
  final num discount;
  final String discountUnit;
  final String? note;
  final String? measureUnit;
  final bool isService;
  ConfigVariantProps({
    required this.qty,
    required this.price,
    required this.discount,
    required this.discountUnit,
    required this.isService,
    this.note,
    this.measureUnit,
  });
}

class ConfigVariantScreen extends StatefulWidget {
  final ProductVariant productVariant;
  final ConfigVariantProps props;
  const ConfigVariantScreen({
    super.key,
    required this.productVariant,
    required this.props,
  });

  @override
  State<ConfigVariantScreen> createState() => _ConfigVariantScreenState();
}

class _ConfigVariantScreenState extends State<ConfigVariantScreen> {
  final _formKey = GlobalKey<FormState>();
  // ** Text controllers
  late final TextEditingController _quantityController;
  late final TextEditingController _priceController;
  late final TextEditingController _discountController;
  late final TextEditingController _noteController;
  // ** Form field keys
  final _quantityFieldKey = GlobalKey<FormFieldState>();
  final _priceFieldKey = GlobalKey<FormFieldState>();
  final _discountFieldKey = GlobalKey<FormFieldState>();
  final _noteFieldKey = GlobalKey<FormFieldState>();

  String _discountUnit = 'đ'; // 'đ' hoặc '%'
  String? _meansureUnit; // 'đ' hoặc '%'
  double _totalPrice = 0.0;
  late ProductVariant _productVariant;

  @override
  void initState() {
    super.initState();
    _productVariant = widget.productVariant;
    _loadInitData();
    _quantityController.addListener(_calculateTotalPrice);
    _priceController.addListener(_calculateTotalPrice);
    _discountController.addListener(_calculateTotalPrice);
  }

  void _loadInitData() {
    _quantityController = TextEditingController(
      text: widget.props.qty > 0 ? widget.props.qty.decimalValueInput : '',
    );
    _priceController = TextEditingController(
      text: widget.props.price.decimalValueInput,
    );
    _discountController = TextEditingController(
      text: widget.props.discount > 0
          ? widget.props.discount.decimalValueInput
          : '',
    );
    _discountUnit = widget.props.discountUnit;
    _meansureUnit = widget.props.measureUnit;
    _noteController = TextEditingController(text: widget.props.note ?? '');
    _calculateTotalPrice();
  }

  @override
  void dispose() {
    _quantityController.removeListener(_calculateTotalPrice);
    _priceController.removeListener(_calculateTotalPrice);
    _discountController.removeListener(_calculateTotalPrice);
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
        label: 'Cấu hình sản phẩm',
        elevation: 1,
        shadowColor: AppColors.black.withValues(alpha: 0.5),
      ),
      backgroundColor: AppColors.background,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: .symmetric(vertical: 20.h),
          child: GestureDetector(
            onTap: context.focus.unfocus,
            child: ColumnWidget(
              crossAxisAlignment: .stretch,
              padding: .symmetric(horizontal: 20.w, vertical: 16.h),
              backgroundColor: AppColors.white,
              gap: 20.h,
              children: [
                if (!widget.props.isService) ...[
                  _PreviewVariant(productVariant: _productVariant),
                  Divider(
                    color: AppColors.grayEA,
                    height: 4.h,
                    thickness: 1.sp,
                  ),
                ],
                InputFormField(
                  formFieldKey: _quantityFieldKey,
                  controller: _quantityController,
                  label: 'Số lượng (*)',
                  hint: 'Nhập số lượng (*)',
                  type: decimalInputType(),
                  inputFormatters: decimalInputFormatter(),
                  validator: _validateQuantity,
                  textInputAction: .next,
                ),
                InputFormField(
                  formFieldKey: _priceFieldKey,
                  controller: _priceController,
                  label: 'Đơn giá (*)',
                  hint: 'Nhập đơn giá (*)',
                  type: decimalInputType(),
                  inputFormatters: decimalInputFormatter(),
                  validator: _validatePrice,
                  textInputAction: .next,
                ),
                ColumnWidget(
                  crossAxisAlignment: .start,
                  gap: 8.h,
                  children: [
                    InputFormField(
                      formFieldKey: _discountFieldKey,
                      controller: _discountController,
                      label: 'Chiết khấu',
                      hint: 'Nhập chiết khấu',
                      type: decimalInputType(),
                      inputFormatters: decimalInputFormatter(),
                      validator: _validateDiscount,
                      textInputAction: .next,
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
                  ],
                ),
                if (widget.props.measureUnit != null &&
                    widget.productVariant.measureUnit?.toUpperCase() == "KG")
                  AbsorbPointer(
                    absorbing: true,
                    child: SelectorFormField<String>(
                      label: 'Đơn vị tính',
                      hintOrValue: _meansureUnit!,
                      selected: _meansureUnit!,
                      disabled: true,
                      options: [_meansureUnit!],
                      renderValue: (value, onTap) => BottomSheetListItem(
                        isDense: false,
                        title: _meansureUnit!,
                        isSelected: true,
                        onTap: onTap,
                      ),
                      onSelected: (_) {},
                    ),
                  )
                else if (widget.props.measureUnit != null) ...[
                  SelectorFormField<String>(
                    label: 'Đơn vị tính',
                    hintOrValue: _meansureUnit ?? 'Chọn đơn vị tính',
                    selected: _meansureUnit!,
                    options: [widget.productVariant.measureUnit!, "KG"],
                    maxHeight: MediaQuery.of(context).size.height * 0.3,
                    renderValue: (value, onTap) => BottomSheetListItem(
                      isDense: false,
                      title: value,
                      isSelected: value == _meansureUnit,
                      onTap: onTap,
                    ),
                    onSelected: (v) {
                      setState(() {
                        _meansureUnit = v;
                      });
                    },
                  ),
                ],
                InputFormField(
                  formFieldKey: _noteFieldKey,
                  controller: _noteController,
                  label: 'Ghi chú',
                  hint: 'Nhập ghi chú',
                  maxLines: 3,
                  type: .text,
                  textInputAction: .done,
                ),
                _buildTotalPrice(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomScaffoldButton(
        onTap: () => _onSubmit(context),
        label: 'Cập nhật',
      ),
    );
  }

  Widget _buildTotalPrice() {
    return Container(
      padding: .symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: .circular(8.r),
        border: .all(color: AppColors.greyC0, width: 1),
      ),
      child: RowWidget(
        gap: 12.w,
        children: [
          Container(
            padding: .all(5.w),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: .circle,
            ),
            child: Icon(
              Icons.attach_money_outlined,
              size: 20.sp,
              color: AppColors.primary,
            ),
          ),
          Text('Tổng giá trị', style: AppStyles.text.medium(fSize: 14.sp)),
          Expanded(
            child: Text(
              '${_totalPrice.toUSD} ${AppConstant.strings.VND}',
              textAlign: .right,
              style: AppStyles.text.semiBold(
                fSize: 16.sp,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String? _validateQuantity(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập số lượng';
    }
    final quantity = NumExt.tryParseComma(value);
    if (quantity == null) {
      return 'Số lượng không hợp lệ';
    }
    if (quantity == 0) {
      return 'Số lượng không được bằng 0';
    }
    if (quantity < 0) {
      return 'Số lượng không được âm';
    }
    return null;
  }

  String? _validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập đơn giá';
    }
    final price = NumExt.tryParseComma(value);
    if (price == null) {
      return 'Đơn giá không hợp lệ';
    }
    if (price < 0) {
      return 'Đơn giá không được âm';
    }
    return null;
  }

  String? _validateDiscount(String? value) {
    if (value == null || value.isEmpty) return null;

    final price = NumExt.tryParseComma(_priceController.text) ?? 0;
    if (_discountUnit == 'đ') {
      final discount = NumExt.tryParseComma(value);
      if (discount == null) return 'Chiết khấu không hợp lệ';
      if (discount < 0) return 'Chiết khấu không được âm';
      if (discount > price) {
        return 'Chiết khấu không được vượt quá giá đơn hàng';
      }
    } else {
      final discount = NumExt.tryParseComma(value);
      if (discount == null) return 'Chiết khấu không hợp lệ';
      if (discount < 0) return 'Chiết khấu không được âm';
      if (discount > 100) return 'Chiết khấu không được lớn hơn 100%';
    }
    return null;
  }

  void _calculateTotalPrice() {
    final quantity = NumExt.tryParseComma(_quantityController.text) ?? 0.0;
    final price = NumExt.tryParseComma(_priceController.text) ?? 0;
    final discount = NumExt.tryParseComma(_discountController.text) ?? 0.0;

    if (quantity <= 0 || price <= 0) {
      setState(() {
        _totalPrice = 0.0;
      });
      return;
    }

    num discountValue = 0.0;
    if (_discountUnit == '%') {
      discountValue = price * (discount / 100);
    } else {
      discountValue = discount;
    }
    final total = price - discountValue;
    final result = total > 0 ? quantity * total : 0.0;
    setState(() {
      _totalPrice = result.toDouble();
    });
  }

  void _onSubmit(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final quantity = NumExt.tryParseComma(_quantityController.text);
    final price = NumExt.tryParseComma(_priceController.text);
    final discount = NumExt.tryParseComma(_discountController.text) ?? 0.0;
    final note = _noteController.text.trim();

    final ConfigVariantProps outPut = ConfigVariantProps(
      qty: quantity ?? 0,
      price: price ?? 0,
      discount: discount,
      discountUnit: _discountUnit,
      note: note.isNotEmpty ? note : null,
      measureUnit: _meansureUnit,
      isService: widget.props.isService,
    );

    Navigator.pop(context, outPut);
  }
}

class _PreviewVariant extends StatelessWidget {
  final ProductVariant productVariant;
  const _PreviewVariant({required this.productVariant});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: .symmetric(horizontal: 20.h),
      padding: .symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: .circular(8.r),
      ),
      child: RowWidget(
        mainAxisAlignment: .center,
        crossAxisAlignment: .center,
        mainAxisSize: .min,
        gap: 12.w,
        children: [
          Container(
            width: 56.w,
            height: 56.w,
            decoration: BoxDecoration(
              borderRadius: .circular(8.r),
              color: AppColors.lightGrey,
            ),
            child: ClipRRect(
              borderRadius: .circular(8.r),
              child: (productVariant.imageVariant ?? "").isNotEmpty
                  ? ImageLoadingWidget(
                      hasPlaceHolder: false,
                      url: productVariant.imageVariant ?? "",
                      width: 56.w,
                      height: 56.w,
                      borderRadius: false,
                    )
                  : Icon(
                      Icons.image_outlined,
                      size: 25.sp,
                      color: AppColors.grey84,
                    ),
            ),
          ),
          Expanded(
            child: ColumnWidget(
              crossAxisAlignment: .start,
              gap: 4.h,
              children: [
                Text(
                  productVariant.displayName,
                  style: AppStyles.text.semiBold(fSize: 14.sp),
                ),
                if (productVariant.sku != null)
                  Text(
                    'Mã SKU: ${productVariant.sku}',
                    style: AppStyles.text.medium(
                      fSize: 12.sp,
                      color: AppColors.grey84,
                    ),
                  ),
                if (productVariant.options.isNotEmpty)
                  Text(
                    productVariant.options
                        .map((opt) => '${opt.name}: ${opt.value}')
                        .join(', '),
                    style: AppStyles.text.medium(
                      fSize: 12.sp,
                      color: AppColors.grey84,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
