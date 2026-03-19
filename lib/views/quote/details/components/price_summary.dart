import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../data/models/quotation/quotation.dart';
import '../../../../res/res.dart';
import '../../../../utils/extension/extension.dart';
import '../../../../utils/widgets/widgets.dart';

class PriceSummary extends StatelessWidget {
  final Quotation quotation;
  const PriceSummary({super.key, required this.quotation});

  String _formatPriceByTrailingCurrency(num price) => price.toUSD;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _row('Số lượng sản phẩm', quotation.totalOrderLineItems),
        _row('Tổng tiền hàng', quotation.lineItemsCost),
        _row(
          'Chiết khấu',
          (quotation.discount ?? 0),
          subValue: (quotation.discountPercent ?? 0.0) > 0.0
              ? quotation.discountPercent?.removeTrailingZero.toString()
              : null,
        ),
        _row('Thuế (VAT)', (quotation.vat ?? 0)),
        _row('Phí giao hàng', (quotation.deliveryFee ?? 0)),
        Divider(height: 16.h, color: AppColors.grayEA, thickness: 1.sp),
        _row(
          'Tổng hóa đơn',
          quotation.totalAmount ?? 0,
          isMainSection: true,
          fontSize: 14.sp,
          color: AppColors.primary,
        ),
      ],
    );
  }

  Widget _row(
    String label,
    num value, {
    String? subValue,
    double? fontSize,
    Color? color,
    bool isMainSection = false,
  }) {
    return Padding(
      padding: .symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          Text(
            label,
            style: AppStyles.text.medium(
              fSize: fontSize ?? 12.sp,
              color: isMainSection ? AppColors.black3 : AppColors.black5,
            ),
          ),
          CustomRichTextWidget(
            defaultStyle: isMainSection
                ? AppStyles.text.bold(
                    fSize: fontSize ?? 14.sp,
                    color: color ?? AppColors.black,
                  )
                : AppStyles.text.medium(
                    fSize: fontSize ?? 14.sp,
                    color: color ?? AppColors.black3,
                  ),
            texts: [
              _formatPriceByTrailingCurrency(value),
              if (subValue != null)
                TextSpan(
                  text: ' ($subValue%)',
                  style: AppStyles.text.medium(
                    fSize: 11.sp,
                    color: AppColors.scarlet,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
