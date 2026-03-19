part of '../orders_management_screen.dart';

class _OrderItem extends StatelessWidget {
  final Order? order;
  final bool loading;
  const _OrderItem({this.order, required this.loading});

  String get _orderCode {
    if (loading) return AppConstant.strings.DEFAULT_EMPTY_VALUE;
    return order?.code ?? order?.orderCode ?? AppConstant.strings.DEFAULT_EMPTY_VALUE;
  }

  String get _customerName {
    if (loading) return AppConstant.strings.DEFAULT_EMPTY_VALUE;
    final fullName = order?.orderInfo?.fullName;
    if (fullName != null && fullName.isNotEmpty) {
      return fullName;
    }
    return 'Khách lẻ';
  }

  String get _orderDate {
    if (loading) return AppConstant.strings.DEFAULT_EMPTY_VALUE;
    if (order?.createdAt != null) {
      return order!.createdAt!.toOrderListDate;
    }
    if (order?.orderDate != null) {
      return order!.orderDate!.toOrderListDate;
    }
    return AppConstant.strings.DEFAULT_EMPTY_VALUE;
  }

  String get _orderAmount {
    if (loading) return '0đ';
    final amount = order?.totalAmount ?? 0;
    return amount.toPrice();
  }

  String get _orderStatus {
    if (loading) return AppConstant.strings.DEFAULT_EMPTY_VALUE;
    final status = order?.statusGeneral ?? order?.status ?? '';
    switch (status) {
      case 'CANCELLED':
      case 'CANCELED':
        return 'Đã hủy';
      case 'PENDING':
        return 'Đặt hàng';
      case 'PROCESSING':
        return 'Đang giao dịch';
      case 'COMPLETED':
        return 'Đã hoàn thành';
      case 'DELIVERING':
        return 'Đang giao hàng';
      default:
        return status.isNotEmpty ? status : AppConstant.strings.DEFAULT_EMPTY_VALUE;
    }
  }

  Color get _statusColor {
    if (loading) return AppColors.grey84;
    final status = order?.statusGeneral ?? order?.status ?? '';
    switch (status) {
      case 'CANCELLED':
      case 'CANCELED':
        return AppColors.red;
      case 'PENDING':
        return AppColors.green;
      case 'PROCESSING':
        return const Color(0xFFFF9800); // Orange
      case 'COMPLETED':
        return AppColors.green;
      case 'DELIVERING':
        return const Color(0xFF2196F3); // Blue
      default:
        return AppColors.grey84;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: loading
          ? null
          : () {
              if (order != null) {
                context.navigator.push(
                  MaterialPageRoute(
                    builder: (context) => OrderDetailsScreen(
                      orderID: order!.id,
                    ),
                  ),
                );
              }
            },
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        child: loading
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PlaceholderWidget(
                          width: 120.w,
                          height: 16.h,
                          borderRadius: false,
                          condition: true,
                          child: Container(),
                        ),
                        SizedBox(height: 4.h),
                        PlaceholderWidget(
                          width: 100.w,
                          height: 14.h,
                          borderRadius: false,
                          condition: true,
                          child: Container(),
                        ),
                        SizedBox(height: 4.h),
                        PlaceholderWidget(
                          width: 80.w,
                          height: 12.h,
                          borderRadius: false,
                          condition: true,
                          child: Container(),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      PlaceholderWidget(
                        width: 100.w,
                        height: 16.h,
                        borderRadius: false,
                        condition: true,
                        child: Container(),
                      ),
                      SizedBox(height: 8.h),
                      PlaceholderWidget(
                        width: 80.w,
                        height: 14.h,
                        borderRadius: false,
                        condition: true,
                        child: Container(),
                      ),
                    ],
                  ),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                        _orderStatus,
                        style: AppStyles.text.medium(
                          fSize: 14.sp,
                          color: _statusColor,
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
