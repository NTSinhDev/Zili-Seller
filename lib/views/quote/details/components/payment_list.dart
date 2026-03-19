import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/res/res.dart';

import '../../../../data/models/order/payment_detail/bank_info.dart';
import '../../../../utils/widgets/widgets.dart';

class PaymentSections extends StatelessWidget {
  final BankInfo? payment;
  const PaymentSections({
    super.key,
    required this.payment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: .infinity,
      padding: .symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        borderRadius: .circular(8.r),
        color: AppColors.greyC0.withValues(alpha: 0.1),
        border: .all(color: AppColors.greyC0),
      ),
      child: ColumnWidget(
        crossAxisAlignment: .start,
        gap: 8.h,
        children: [
          _RowItem(
            label: 'Chủ tài khoản',
            value:
                payment?.accountOwner ??
                AppConstant.strings.DEFAULT_EMPTY_VALUE,
          ),
          _RowItem(
            label: 'Số tài khoản',
            value:
                payment?.bankNumber ?? AppConstant.strings.DEFAULT_EMPTY_VALUE,
          ),
          _RowItem(
            label: 'Chi nhánh',
            value: payment?.bankName ?? AppConstant.strings.DEFAULT_EMPTY_VALUE,
          ),
          _RowItem(
            label: 'Swift code',
            value:
                payment?.bankIdentifier ??
                AppConstant.strings.DEFAULT_EMPTY_VALUE,
          ),
        ],
      ),
    );
  }
}

class _RowItem extends StatelessWidget {
  final String label;
  final String value;
  const _RowItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return CustomRichTextWidget(
      defaultStyle: AppStyles.text.medium(
        fSize: 12.sp,
        color: AppColors.black5,
      ),
      maxLines: 1,
      texts: [
        "$label:\t\t",
        TextSpan(
          text: value,
          style: AppStyles.text.medium(fSize: 14.sp, color: AppColors.black3),
        ),
      ],
    );
  }
}
