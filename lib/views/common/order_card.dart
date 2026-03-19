import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/utils/enums.dart';
import 'package:zili_coffee/views/common/status_badge.dart';

import '../../data/models/order/order.dart';
import '../../data/models/quotation/quotation.dart';
import '../../res/res.dart';
import '../../utils/enums/order_enum.dart';
import '../../utils/extension/extension.dart';
import '../../utils/functions/order_function.dart';
import '../../utils/widgets/widgets.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback? onTap;
  const OrderCard({super.key, required this.order, this.onTap});

  String get _orderCode =>
      order.code ?? order.orderCode ?? AppConstant.strings.DEFAULT_EMPTY_VALUE;

  String get _customerName {
    final fullName = order.orderInfo?.fullName;

    if (fullName != null && fullName.isNotEmpty) {
      if ((order.orderInfo?.phoneNumber ?? "").isNotEmpty) {
        return "$fullName - ${order.orderInfo?.phoneNumber ?? ""}";
      }
      return fullName;
    }
    return 'Khách lẻ';
  }

  String get _orderDate {
    if (order.createdAt != null) {
      return order.createdAt!.csToString('HH:mm dd/MM/yyyy');
    }
    if (order.orderDate != null) {
      return order.orderDate!.csToString('HH:mm dd/MM/yyyy');
    }
    return AppConstant.strings.DEFAULT_EMPTY_VALUE;
  }

  String get _orderAmount {
    final amount = order.totalAmount ?? 0;
    return amount.toPrice();
  }

  String get _renderStatus =>
      renderOrderStatus(order.statusEnum) ??
      AppConstant.strings.DEFAULT_EMPTY_VALUE;

  Color? get _statusColor => orderStatusColor(order.statusEnum);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: .circular(8.r),
      child: Container(
        padding: .symmetric(horizontal: 16.w, vertical: 12.h),
        color: Colors.white,
        child: RowWidget(
          crossAxisAlignment: .start,
          gap: 12.w,
          children: [
            Expanded(
              child: ColumnWidget(
                crossAxisAlignment: .start,
                gap: 6.h,
                children: [
                  Text(
                    _orderCode,
                    style: AppStyles.text.semiBold(
                      fSize: 16.sp,
                      color: AppColors.black3,
                    ),
                    maxLines: 1,
                    overflow: .ellipsis,
                  ),
                  Text(
                    _customerName,
                    style: AppStyles.text.medium(
                      fSize: 14.sp,
                      color: AppColors.grey84,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    _orderDate,
                    style: AppStyles.text.medium(
                      fSize: 12.sp,
                      color: AppColors.grey84,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: .end,
              children: [
                if (_statusColor != null)
                  StatusBadge(label: _renderStatus, color: _statusColor!)
                else
                  Text(
                    _renderStatus,
                    style: AppStyles.text.medium(
                      fSize: 14.sp,
                      color: _statusColor,
                    ),
                  ),
                SizedBox(height: 8.h),
                Text(
                  _orderAmount,
                  style: AppStyles.text.semiBold(
                    fSize: 16.sp,
                    color: AppColors.black3,
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

class QuotationCard extends OrderCard {
  final Quotation quotation;
  const QuotationCard({super.key, required this.quotation, super.onTap})
    : super(order: quotation);

  @override
  String get _orderCode =>
      quotation.code ?? AppConstant.strings.DEFAULT_EMPTY_VALUE;

  @override
  String get _orderDate {
    if (quotation.quotationCreatedAt != null) {
      return quotation.quotationCreatedAt!.csToString('HH:mm dd/MM/yyyy');
    }
    return AppConstant.strings.DEFAULT_EMPTY_VALUE;
  }

  @override
  String get _orderAmount {
    if (quotation.templateCode == QuoteMailType.quantityQuote.toConstant) {
      return AppConstant.strings.DEFAULT_EMPTY_VALUE;
    }

    final amount = quotation.totalOrderAmount ?? 0;
    return amount.toPrice();
  }

  @override
  String get _renderStatus =>
      renderQuoteStatus(quotation.quoteStatus) ??
      AppConstant.strings.DEFAULT_EMPTY_VALUE;

  @override
  Color? get _statusColor => quoteStatusColor(quotation.quoteStatus);
}
