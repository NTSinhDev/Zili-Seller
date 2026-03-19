part of '../order_list_screen.dart';

class _OrderListItem extends StatelessWidget {
  final Order order;
  const _OrderListItem({required this.order});

  String get _orderCode =>
      order.code ?? order.orderCode ?? AppConstant.strings.DEFAULT_EMPTY_VALUE;

  String get _customerName {
    final fullName = order.orderInfo?.fullName;
    if (fullName != null && fullName.isNotEmpty) {
      return fullName;
    }
    return 'Khách lẻ';
  }

  String get _orderDate {
    if (order.createdAt != null) {
      return order.createdAt!.toOrderListDate;
    }
    if (order.orderDate != null) {
      return order.orderDate!.toOrderListDate;
    }
    return AppConstant.strings.DEFAULT_EMPTY_VALUE;
  }

  String get _orderAmount {
    final amount = order.totalAmount ?? 0;
    return amount.toPrice();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        AppWireFrame.navigateToOrderDetails(
          context,
          code:
              order.code ??
              order.orderCode ??
              AppConstant.strings.DEFAULT_EMPTY_VALUE,
        );
      },
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Section - Order Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _orderCode,
                    style: AppStyles.text.semiBold(
                      fSize: 16.sp,
                      color: AppColors.black3,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    _customerName,
                    style: AppStyles.text.medium(
                      fSize: 14.sp,
                      color: AppColors.grey84,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
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
            SizedBox(width: 12.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _orderAmount,
                  style: AppStyles.text.semiBold(
                    fSize: 16.sp,
                    color: AppColors.black3,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  renderOrderStatus(order.statusEnum) ?? '',
                  style: AppStyles.text.medium(
                    fSize: 14.sp,
                    color: orderStatusColor(order.statusEnum),
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
