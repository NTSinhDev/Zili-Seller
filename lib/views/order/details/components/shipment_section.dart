import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/data/models/order/delivery_group.dart';
import 'package:zili_coffee/data/models/order/order_delivery.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/widgets/widgets.dart';

import '../../../../utils/extension/extension.dart';
import '../../../../utils/functions/order_function.dart';

class ShipmentSection extends StatelessWidget {
  final OrderDelivery? orderDelivery;
  final DeliveryGroup? delivery;
  final Map<String, dynamic>? deliveryOrderRaw;
  const ShipmentSection({
    super.key,
    this.orderDelivery,
    this.delivery,
    this.deliveryOrderRaw,
  });

  @override
  Widget build(BuildContext context) {
    if (orderDelivery == null) {
      return Text(
        'Chưa có vận đơn',
        style: AppStyles.text.medium(fSize: 13.sp, color: AppColors.grey84),
      );
    }
    return Column(
      crossAxisAlignment: .start,
      children: [
        if (delivery != null)
          Container(
            padding: .symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.05),
              borderRadius: .circular(8.r),
              border: .all(color: AppColors.primary.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                if (delivery?.logoUrl != null)
                  Container(
                    width: 32.w,
                    height: 32.w,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      shape: .circle,
                      border: .all(
                        color: AppColors.grey84.withValues(alpha: 0.2),
                      ),
                    ),
                    clipBehavior: .antiAlias,
                    child: ImageLoadingWidget(
                      url: delivery!.logoUrl!,
                      hasPlaceHolder: false,
                      width: 32.w,
                      height: 32.w,
                    ),
                  ),
                SizedBox(width: 10.w),
                Expanded(
                  child: ColumnWidget(
                    crossAxisAlignment: .start,
                    mainAxisAlignment: .spaceBetween,
                    gap: 4.h,
                    children: [
                      Text(
                        delivery?.displayName ??
                            AppConstant.strings.DEFAULT_EMPTY_VALUE,
                        style: AppStyles.text.semiBold(
                          fSize: 14.sp,
                          color: AppColors.black,
                        ),
                      ),
                      if ((_renderDeliveryName() ?? '').isNotEmpty)
                        Text(
                          _renderDeliveryName() ??
                              AppConstant.strings.DEFAULT_EMPTY_VALUE,
                          style: AppStyles.text.medium(
                            fSize: 12.sp,
                            color: AppColors.black5,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        SizedBox(height: 12.h),
        _infoRow(
          'Mã đóng gói',
          deliveryOrderRaw?['deliveryOrderCode']?.toString() ??
              AppConstant.strings.DEFAULT_EMPTY_VALUE,
        ),
        _infoRow(
          'Hình thức giao hàng',
          orderDelivery?.deliveryGroupName ??
              AppConstant.strings.DEFAULT_EMPTY_VALUE,
        ),
        _infoRow(
          'Yêu cầu giao hàng',
          renderRequiredDelivery(orderDelivery?.requiredNote) ??
              AppConstant.strings.DEFAULT_EMPTY_VALUE,
        ),
        _infoRow(
          'Địa chỉ',
          orderDelivery?.addressDisplay ??
              AppConstant.strings.DEFAULT_EMPTY_VALUE,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: const Divider(height: 1),
        ),
        _infoRow('Tổng tiền thu hộ COD', (orderDelivery?.cod ?? 0).toUSD),
        _infoRow(
          'Phí trả ĐTVC',
          num.tryParse(
                deliveryOrderRaw?['shippingFee']?.toString() ?? '0',
              )?.toUSD ??
              AppConstant.strings.DEFAULT_EMPTY_VALUE,
        ),
        _infoRow(
          'Kích thước (DxRxC)',
          '${orderDelivery?.length ?? 0} x ${orderDelivery?.width ?? 0} x ${orderDelivery?.height ?? 0} cm',
        ),
        _infoRow('Trọng lượng', '${orderDelivery?.weight ?? 0} gram'),
        _infoRow(
          'Người trả phí',
          renderPayingParty(orderDelivery?.paidBy) ??
              AppConstant.strings.DEFAULT_EMPTY_VALUE,
        ),
        _infoRow(
          'Đối soát',
          renderReconciliation(
                deliveryOrderRaw?['reconciliationStatus']?.toString(),
              ) ??
              AppConstant.strings.DEFAULT_EMPTY_VALUE,
        ),
      ],
    );
  }

  String? _renderDeliveryName() {
    if ((orderDelivery?.serviceNameVi ?? orderDelivery?.serviceNameEn ?? '')
        .isNotEmpty) {
      return (orderDelivery?.serviceNameVi ??
          orderDelivery?.serviceNameEn ??
          AppConstant.strings.DEFAULT_EMPTY_VALUE);
    }
    if (deliveryOrderRaw?['deliveryType'] == 'SELLER') {
      if (deliveryOrderRaw?['deliveryOutside'] != null) {
        return (deliveryOrderRaw?['deliveryOutside']?['nameVi'] ??
            deliveryOrderRaw?['deliveryOutside']?['nameEn'] ??
            AppConstant.strings.DEFAULT_EMPTY_VALUE);
      }
      if ((deliveryOrderRaw?['shipper']?['name'] ?? '').isNotEmpty) {
        return (deliveryOrderRaw?['shipper']?['name'] ??
            AppConstant.strings.DEFAULT_EMPTY_VALUE);
      }
    } else if (deliveryOrderRaw?['deliveryType'] == 'SELLER') {
      if (deliveryOrderRaw?['deliveryOutside'] != null) {
        return (deliveryOrderRaw?['deliveryOutside']?['nameVi'] ??
            deliveryOrderRaw?['deliveryOutside']?['nameEn'] ??
            AppConstant.strings.DEFAULT_EMPTY_VALUE);
      }
      if ((deliveryOrderRaw?['shipper']?['name'] ?? '').isNotEmpty) {
        return (deliveryOrderRaw?['shipper']?['name'] ??
            AppConstant.strings.DEFAULT_EMPTY_VALUE);
      }
    }

    return null;
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppStyles.text.medium(fSize: 12.sp, color: AppColors.black5),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: .end,
              maxLines: 2,
              overflow: .ellipsis,
              style: AppStyles.text.semiBold(
                fSize: 12.sp,
                color: AppColors.black3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _timelineRow(
    String label,
    String? date, {
    bool isCompleted = false,
    bool isLast = false,
  }) {
    return Row(
      children: [
        Column(
          children: [
            Container(
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted ? AppColors.primary : AppColors.lightGrey,
                border: Border.all(
                  color: isCompleted ? AppColors.primary : AppColors.grey84,
                  width: 1.5,
                ),
              ),
            ),
            if (!isLast)
              Container(
                width: 1.5,
                height: 20.h,
                color: AppColors.grey84.withOpacity(0.3),
              ),
          ],
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 20.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: AppStyles.text.medium(
                    fSize: 13.sp,
                    color: isCompleted ? AppColors.black : AppColors.grey84,
                  ),
                ),
                if (date != null)
                  Text(
                    date,
                    style: AppStyles.text.medium(
                      fSize: 13.sp,
                      color: AppColors.black,
                    ),
                  )
                else
                  Text(
                    '--',
                    style: AppStyles.text.medium(
                      fSize: 13.sp,
                      color: AppColors.grey84,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
