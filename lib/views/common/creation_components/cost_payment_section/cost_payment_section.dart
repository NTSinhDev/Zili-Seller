import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../bloc/payment/payment_cubit.dart';
import '../../../../data/models/order/payment_detail/seller_payment_method.dart';
import '../../../../data/repositories/payment_repository.dart';
import '../../../../di/dependency_injection.dart';
import '../../../../res/res.dart';
import '../../../../utils/extension/extension.dart';
import '../../../../utils/formatters/export.dart';
import '../../../../utils/helpers/order_helper.dart';
import '../../../../utils/helpers/parser.dart';
import '../../../../utils/widgets/widgets.dart';
import '../../input_form_field.dart';
import '../../radio_button.dart';
import 'components/add_discount_screen.dart';
import 'components/add_shipping_fee_screen.dart';
import 'components/add_vat_screen.dart';

part 'components/payment_status_selector.dart';

class CostPaymentProps {
  final double totalProductPrice;
  final num totalQuantity;
  final double discount;
  final num? discountPercent;
  final String discountUnit;
  final double vat;
  final num? vatPercent;
  final String vatUnit;
  final double shippingFee;
  final bool isPaid;
  CostPaymentProps({
    required this.totalProductPrice,
    required this.totalQuantity,
    required this.discount,
    required this.discountPercent,
    required this.discountUnit,
    required this.vat,
    required this.vatPercent,
    required this.vatUnit,
    required this.shippingFee,
    this.isPaid = false,
  });
}

class CostPaymentSection extends StatelessWidget {
  final CostPaymentProps props;
  final Function(double, num?, String, String?) onDiscountChanged;
  final Function(double, num?, String) onTaxChanged;
  final Function(double) onShippingFeeChanged;
  final Function(bool)? onPaymentStatusChanged;
  final Function(List<Map<String, dynamic>>)? onPaymentDetailsChanged;
  const CostPaymentSection({
    super.key,
    required this.props,
    required this.onDiscountChanged,
    required this.onTaxChanged,
    required this.onShippingFeeChanged,
    this.onPaymentStatusChanged,
    this.onPaymentDetailsChanged,
  });

  /// Tổng tiền đơn sau khi khấu trừ chiết khẩu, VAT, phí giao
  double get _amountAfterDeductions {
    final orderDiscount = calculateOrderDiscount(
      props.totalProductPrice,
      props.discount,
      'đ',
    );
    final netAfterDiscount = (props.totalProductPrice - orderDiscount)
        .clamp(0, double.infinity)
        .toDouble();
    final orderVat = calculateOrderTax(props.totalProductPrice, props.vat, 'đ');
    return netAfterDiscount + orderVat + props.shippingFee;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .all(16.w),
      color: AppColors.white,
      child: ColumnWidget(
        crossAxisAlignment: .start,
        gap: 12.h,
        children: [
          Text('Thanh toán', style: AppStyles.text.semiBold(fSize: 16.sp)),
          Divider(height: 1, color: AppColors.grayEA, thickness: 1.sp),
          RowWidget(
            crossAxisAlignment: .start,
            gap: 16.w,
            children: [
              Flexible(
                child: CustomRichTextWidget(
                  defaultStyle: AppStyles.text.medium(
                    fSize: 14.sp,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  texts: [
                    TextSpan(
                      text: "Tổng tiền hàng",
                      style: AppStyles.text.medium(fSize: 14.sp, height: 1.2),
                    ),
                    '\t',
                    TextSpan(
                      text:
                          '(${props.totalQuantity.removeTrailingZero} sản phẩm)',
                      style: AppStyles.text.medium(fSize: 14.sp, height: 1.2),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CustomRichTextWidget(
                  defaultStyle: AppStyles.text.medium(
                    fSize: 14.sp,
                    height: 1.2,
                  ),
                  textAlign: .end,
                  maxLines: 1,
                  texts: [
                    TextSpan(
                      text: props.totalProductPrice.toPrice(),
                      style: AppStyles.text.semiBold(
                        fSize: 14.sp,
                        color: AppColors.black3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          _PaymentRow(
            label: 'Chiết khấu',
            value: calculateOrderDiscount(
              props.totalProductPrice,
              props.discount,
              "đ",
            ),
            valuePercent: props.discountPercent,
            onTap: () {
              context.navigator
                  .push(
                    MaterialPageRoute(
                      builder: (context) => AddDiscountFeeScreen(
                        totalPrice: props.totalProductPrice,
                        initialDiscount: props.discount,
                        initialDiscountPercent: props.discountPercent,
                        initialDiscountUnit: props.discountUnit,
                      ),
                    ),
                  )
                  .then((result) {
                    if (result != null && result is Map) {
                      final discount = result['discount'] != null
                          ? num.tryParse("${result['discount']}") ?? 0.0
                          : 0.0;
                      final discountPercent = result['discountPercent'] != null
                          ? num.tryParse("${result['discountPercent']}")
                          : null;
                      final discountUnit =
                          result['discountUnit'] as String? ?? 'đ';
                      onDiscountChanged(
                        discount.toDouble(),
                        discountPercent,
                        discountUnit,
                        result['discountReason'] as String?,
                      );
                    }
                  });
            },
          ),
          _PaymentRow(
            label: 'Thuế (VAT)',
            value: calculateOrderTax(props.totalProductPrice, props.vat, "đ"),
            valuePercent: props.vatPercent,
            onTap: () {
              context.navigator
                  .push(
                    MaterialPageRoute(
                      builder: (context) => AddVatFeeScreen(
                        totalPrice: props.totalProductPrice,
                        initialVat: props.vat,
                        initialVatPercent: props.vatPercent,
                        initialVatUnit: props.vatUnit,
                      ),
                    ),
                  )
                  .then((result) {
                    if (result != null && result is Map) {
                      final vat = result['vat'] as double? ?? 0.0;
                      final vatPercent = result['vatPercent'] as num?;
                      final vatUnit = result['vatUnit'] as String? ?? 'đ';
                      onTaxChanged(vat, vatPercent, vatUnit);
                    }
                  });
            },
          ),
          _PaymentRow(
            label: 'Phí giao hàng',
            value: props.shippingFee,
            onTap: () {
              context.navigator
                  .push(
                    MaterialPageRoute(
                      builder: (context) => AddShippingFeeScreen(
                        initialShippingFee: props.shippingFee,
                      ),
                    ),
                  )
                  .then((result) {
                    if (result != null && result is Map) {
                      final shippingFee =
                          result['shippingFee'] as double? ?? 0.0;
                      onShippingFeeChanged(shippingFee);
                    }
                  });
            },
          ),
          if (_amountAfterDeductions > 0 &&
              onPaymentStatusChanged.isNotNull) ...[
            Divider(color: AppColors.greyC0, height: 1.h),
            _PaymentStatusSelector(
              isPaid: props.isPaid,
              totalAmount: _amountAfterDeductions.toDouble(),
              onChanged: onPaymentStatusChanged!,
              onPaymentDetailsChanged: onPaymentDetailsChanged,
            ),
          ],
        ],
      ),
    );
  }
}

class _PaymentRow extends StatelessWidget {
  final String label;
  final double value;
  final num? valuePercent;
  final VoidCallback? onTap;
  const _PaymentRow({
    required this.label,
    required this.value,
    this.valuePercent,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return RowWidget(
      mainAxisAlignment: .spaceBetween,
      children: [
        Text(label, style: AppStyles.text.medium(fSize: 14.sp)),
        if (onTap != null)
          InkWell(
            onTap: onTap,
            child: RowWidget(
              gap: 4.w,
              padding: .symmetric(vertical: 2.h),
              border: const Border(bottom: BorderSide(color: Colors.blue)),
              children: [
                Icon(
                  value == 0 ? Icons.add_circle_outline : Icons.edit,
                  size: 16.sp,
                  color: Colors.blue,
                ),
                Text(
                  value.toUSD,
                  style: AppStyles.text.semiBold(
                    fSize: 14.sp,
                    color: Colors.blue,
                  ),
                ),
                if (value != 0 && valuePercent != null)
                  Text(
                    '\t(${valuePercent!.removeTrailingZero}%)',
                    style: AppStyles.text.medium(
                      fSize: 13.sp,
                      color: AppColors.cancel,
                    ),
                  ),
              ],
            ),
          )
        else
          Text(
            value.toPrice(),
            style: AppStyles.text.semiBold(
              fSize: 14.sp,
              color: AppColors.black3,
            ),
          ),
      ],
    );
  }
}
