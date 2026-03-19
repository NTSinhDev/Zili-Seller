import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/data/models/order/order.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/extension/extension.dart';

import '../../../../utils/widgets/widgets.dart';

class PriceSummary extends StatelessWidget {
  final Order order;
  const PriceSummary({super.key, required this.order});

  String _formatPriceByTrailingCurrency(num price) => price.toUSD;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _row('Số lượng sản phẩm', order.totalOrderLineItems),
        _row('Tổng tiền hàng', order.lineItemsCost),
        _row(
          'Chiết khấu',
          (order.discount ?? 0),
          subValue: (order.discountPercent ?? 0.0) > 0.0
              ? order.discountPercent?.removeTrailingZero.toString()
              : null,
        ),
        _row('Thuế (VAT)', (order.vat ?? 0)),
        _row('Phí giao hàng', (order.deliveryFee ?? 0)),
        Divider(height: 16.h, color: AppColors.grayEA, thickness: 1.sp),
        _row(
          'Tổng hóa đơn',
          order.totalAmount ?? 0,
          isMainSection: true,
          fontSize: 14.sp,
          color: AppColors.primary,
        ),
        if ((order.note ?? "").isNotEmpty) ...[
          Divider(height: 16.h, color: AppColors.grayEA, thickness: 1.sp),
          ColumnWidget(
            crossAxisAlignment: .start,
            gap: 4.h,
            children: [
              Text(
                "Ghi chú",
                style: AppStyles.text.medium(
                  fSize: 12.sp,
                  color: AppColors.black5,
                ),
              ),
              Container(
                width: .infinity,
                padding: .all(10.w),
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: .circular(8.r),
                ),
                child: Text(
                  order.note!,
                  style: AppStyles.text.medium(
                    fSize: 12.sp,
                    color: AppColors.black5,
                  ),
                  maxLines: 10,
                  overflow: .ellipsis,
                ),
              ),
            ],
          ),
        ],

        SizedBox(height: 8),
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
