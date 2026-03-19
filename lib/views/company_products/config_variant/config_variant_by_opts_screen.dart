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
import '../../common/product_variant_title.dart';

class ConfigOptsVariantProps {
  final List<(String name, num value)> options;
  final String? note;
  ConfigOptsVariantProps({required this.options, this.note});
}

class ConfigOptsVariantScreen extends StatefulWidget {
  final ProductVariant productVariant;
  final ConfigOptsVariantProps props;
  const ConfigOptsVariantScreen({
    super.key,
    required this.productVariant,
    required this.props,
  });

  @override
  State<ConfigOptsVariantScreen> createState() =>
      _ConfigOptsVariantScreenState();
}

class _ConfigOptsVariantScreenState extends State<ConfigOptsVariantScreen> {
  final _formKey = GlobalKey<FormState>();
  // ** Text controllers
  List<TextEditingController> _controllers = [];
  late final TextEditingController _noteController;
  // ** Form field keys
  List<GlobalKey<FormFieldState>> _fieldKeys = [];
  final GlobalKey<FormFieldState> _noteFieldKey = GlobalKey();

  late ProductVariant _productVariant;

  @override
  void initState() {
    super.initState();
    _initControllersAndKeys();
    _productVariant = widget.productVariant;
  }

  void _initControllersAndKeys() {
    _controllers = List.generate(
      widget.props.options.length,
      (index) => TextEditingController(
        text: widget.props.options[index].$2.decimalValueInput,
      ),
    );
    _noteController = TextEditingController(text: widget.props.note ?? '');
    _fieldKeys = List.generate(
      widget.props.options.length,
      (index) => GlobalKey<FormFieldState>(
        debugLabel: 'Field ${widget.props.options[index].$1}',
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
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
                _PreviewVariant(
                  productVariant: _productVariant,
                  note: _noteController.text,
                ),
                Divider(color: AppColors.grayEA, height: 4.h, thickness: 1.sp),
                ...List.generate(
                  widget.props.options.length,
                  (index) => InputFormField(
                    formFieldKey: _fieldKeys[index],
                    controller: _controllers[index],
                    label: "Đơn giá ${widget.props.options[index].$1}",
                    hint: '0',
                    type: decimalInputType(),
                    inputFormatters: decimalInputFormatter(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập ${widget.props.options[index].$1.toLowerCase()}';
                      }
                      final numValue = NumExt.tryParseComma(value);
                      if (numValue == null) {
                        return 'Đơn giá ${widget.props.options[index].$1} không hợp lệ';
                      }
                      if (numValue < 0) {
                        return 'Đơn giá ${widget.props.options[index].$1} không được âm';
                      }
                      return null;
                    },
                    textInputAction: index == widget.props.options.length - 1
                        ? .done
                        : TextInputAction.next,
                  ),
                ),
                InputFormField(
                  formFieldKey: _noteFieldKey,
                  controller: _noteController,
                  label: 'Ghi chú',
                  hint: 'Nhập ghi chú',
                  maxLines: 3,
                  type: .text,
                  textInputAction: .done,
                ),
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

  void _onSubmit(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final note = _noteController.text.trim();
    final ConfigOptsVariantProps outPut = ConfigOptsVariantProps(
      note: note.isNotEmpty ? note : null,
      options: List.generate(widget.props.options.length, (i) {
        return (
          widget.props.options[i].$1,
          NumExt.tryParseComma(_controllers[i].text) ?? 0,
        );
      }),
    );

    Navigator.pop(context, outPut);
  }
}

class _PreviewVariant extends StatelessWidget {
  final ProductVariant productVariant;
  final String? note;
  const _PreviewVariant({required this.productVariant, this.note});

  @override
  Widget build(BuildContext context) {
    return ColumnWidget(
      // gap: 8.h,
      children: [
        RowWidget(
          mainAxisAlignment: .start,
          crossAxisAlignment: .start,
          gap: 12.w,
          children: [
            // Product image
            ImageLoadingWidget(
              width: 52.w,
              height: 52.w,
              borderRadius: false,
              url: productVariant.imageVariant ?? '',
            ),
            // Product info
            Expanded(
              child: ColumnWidget(
                mainAxisAlignment: .start,
                crossAxisAlignment: .start,
                mainAxisSize: .min,
                gap: 4.h,
                children: [
                  // Section 1: common info (product info)
                  if (productVariant.isNotNull)
                    RowWidget(
                      crossAxisAlignment: .start,
                      children: [
                        Expanded(
                          child: AbsorbPointer(
                            absorbing: true,
                            child: ProductVariantTitleWidget(
                              data: productVariant,
                              titleStyle: AppStyles.text.medium(
                                fSize: 12.sp,
                                height: 14 / 12,
                                color: AppColors.black3,
                              ),
                              skuStyle: AppStyles.text.medium(
                                fSize: 12.sp,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  RowWidget(
                    mainAxisAlignment: .start,
                    gap: 8.w,
                    children: [
                      Text(
                        "Đơn vị: ${productVariant.product?.measureUnit ?? 'KG'}",
                        style: AppStyles.text.medium(
                          fSize: 13.sp,
                          color: AppColors.black3,
                        ),
                      ),
                      if ((note ?? "").isNotEmpty)
                        Expanded(
                          child: CustomRichTextWidget(
                            defaultStyle: AppStyles.text.medium(
                              fSize: 11.sp,
                              height: 14 / 12,
                              color: AppColors.grey84,
                            ),
                            textAlign: .end,
                            texts: [
                              'Ghi chú: ',
                              TextSpan(
                                text: note,
                                style: AppStyles.text.medium(
                                  fSize: 11.sp,
                                  height: 14 / 12,
                                  color: AppColors.black5,
                                ),
                              ),
                            ],
                            maxLines: 1,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        // SizedBox(height: 8.h),
        // DottedBorder(
        //   color: AppColors.primary.withValues(alpha: 0.2),
        //   strokeWidth: 1.w,
        //   radius: .circular(4),
        //   dashPattern: const [4, 4, 4, 4],
        //   padding: .symmetric(horizontal: 16.w, vertical: 4.h),
        //   borderType: .RRect,
        //   child: GridView.builder(
        //     shrinkWrap: true,
        //     padding: .zero,
        //     itemCount: quantityPrices.length,
        //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //       crossAxisCount: 2, // số cột
        //       crossAxisSpacing: 20, // khoảng cách ngang
        //       mainAxisSpacing: 4.h, // khoảng cách dọc
        //       childAspectRatio: (0.5.sw - 10.w) / 20, // width / height
        //     ),
        //     itemBuilder: (_, i) => _qtyOptGenerator(i),
        //   ),
        // ),
      ],
    );
  }
}
