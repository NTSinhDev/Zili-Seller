import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/data/models/product/options.dart' as model;
import 'package:zili_coffee/data/models/product/product_detail.dart';
import 'package:zili_coffee/data/models/product/product_options.dart';
import 'package:zili_coffee/data/repositories/product_repository.dart';
import 'package:zili_coffee/di/dependency_injection.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/widgets/widgets.dart';

class Options extends StatefulWidget {
  final model.Options option;
  final ProductOptions productOptions;
  const Options({
    super.key,
    required this.option,
    required this.productOptions,
  });

  @override
  State<Options> createState() => __OptionsState();
}

class __OptionsState extends State<Options> {
  late final int currentOption;
  final ProductRepository productRepository = di<ProductRepository>();

  @override
  void initState() {
    super.initState();
    if (widget.option.name == widget.productOptions.opt1Name) {
      currentOption = 1;
    } else if (widget.option.name == widget.productOptions.opt2Name) {
      currentOption = 2;
    } else {
      currentOption = 3;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 13.w,
      spacing: 13.w,
      children: widget.option.values.map((String option) {
        return _OptionBtn(
          option: option,
          isActive: isActive(option),
          readOnly: false,
          onTap: () {
            if (isActive(option)) return;

            ProductDetail productDetail =
                productRepository.productDetailStreamData.value!.detail!;

            productDetail = productDetail.copyWith(
              productOptions: productDetail.productOptions.copyWith(
                option1: currentOption == 1 ? option : null,
                option2: currentOption == 2 ? option : null,
                option3: currentOption == 3 ? option : null,
              ),
            );

            productRepository.productDetailStreamData.sink.add(
              productRepository.productDetailStreamData.value!.copyWith(
                detail: productDetail,
              ),
            );

            productRepository.setVariantStreamData();
          },
        );
      }).toList(),
    );
  }

  bool isActive(String option) {
    switch (currentOption) {
      case 1:
        return option == widget.productOptions.option1;
      case 2:
        return option == widget.productOptions.option2;
      default:
        return option == widget.productOptions.option3;
    }
  }
}

class _OptionBtn extends StatelessWidget {
  final String option;
  final bool isActive;
  final bool readOnly;
  final Function() onTap;
  const _OptionBtn({
    required this.option,
    required this.isActive,
    required this.onTap,
    required this.readOnly,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButtonWidget(
      height: 36.h,
      width: 106.w,
      onTap: readOnly ? null : onTap,
      radius: 5.r,
      color: readOnly
          ? AppColors.gray4A.withOpacity(0.1)
          : isActive
              ? AppColors.primary
              : AppColors.white,
      borderColor: readOnly
          ? AppColors.gray4A.withOpacity(0.1)
          : isActive
              ? AppColors.primary
              : AppColors.black5,
      boxShadows: const [],
      child: Center(
        child: Text(
          option,
          style: AppStyles.text.semiBold(
            fSize: 14.sp,
            height: 1.18,
            color: readOnly
                ? AppColors.black5.withOpacity(0.5)
                : isActive
                    ? AppColors.white
                    : AppColors.black5,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
