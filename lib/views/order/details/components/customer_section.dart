import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/data/models/order/order_invoice.dart';
import 'package:zili_coffee/data/models/user/customer.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../utils/extension/extension.dart';
import '../../../../utils/widgets/widgets.dart';
import '../../../module_common/avatar.dart';

class CustomerSection extends StatelessWidget {
  final Customer? customer;
  final OrderInvoice? orderInvoice;
  const CustomerSection({super.key, this.customer, this.orderInvoice});

  @override
  Widget build(BuildContext context) {
    if (customer == null) {
      return Text(
        'Chưa có thông tin khách hàng',
        style: AppStyles.text.medium(fSize: 13.sp, color: AppColors.grey84),
      );
    }
    return Column(
      crossAxisAlignment: .start,
      children: [
        Row(
          crossAxisAlignment: .start,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: .circle,
                border: Border.all(
                  color: AppColors.grey84.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Avatar(avatar: customer?.avatar, size: 48.w),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    customer?.fullName ?? 'Khách lẻ',
                    style: AppStyles.text.semiBold(
                      fSize: 15.sp,
                      color: AppColors.black,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  if (customer?.phone != null)
                    InkWell(
                      onTap: () => _launchUrl('tel:${customer!.phone}'),
                      child: Row(
                        children: [
                          Icon(
                            Icons.phone_outlined,
                            size: 14.sp,
                            color: AppColors.grey84,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            customer!.phone!,
                            style: AppStyles.text.medium(
                              fSize: 13.sp,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (customer?.email != null) ...[
                    SizedBox(height: 4.h),
                    InkWell(
                      onTap: () => _launchUrl('mailto:${customer!.email}'),
                      child: Row(
                        children: [
                          Icon(
                            Icons.email_outlined,
                            size: 14.sp,
                            color: AppColors.grey84,
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Text(
                              customer!.email!,
                              style: AppStyles.text.medium(
                                fSize: 13.sp,
                                color: AppColors.primary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding: .symmetric(vertical: 12.h),
          child: Divider(height: 1, color: AppColors.grayEA, thickness: 1.sp),
        ),
        _infoRow(
          'Công nợ',
          (customer?.currentDebt ?? 0).toPrice(),
          valueColor: (customer?.currentDebt ?? 0) > 0
              ? AppColors.scarlet
              : null,
        ),
        _infoRow('Tổng chi tiêu', (customer?.totalSpending ?? 0).toPrice()),
        if (orderInvoice != null) ...[
          Padding(
            padding: .symmetric(vertical: 12.h),
            child: Divider(height: 1, color: AppColors.grayEA, thickness: 1.sp),
          ),
          Text('Hóa đơn', style: AppStyles.text.semiBold(fSize: 14.sp)),
          _infoRow(
            'Loại/Tên',
            '${orderInvoice?.type ?? "--"} - ${orderInvoice?.name ?? "--"}',
          ),
          if (orderInvoice?.taxCode != null)
            _infoRow('MST', orderInvoice!.taxCode!),
          if (orderInvoice?.invoiceFileUrl != null)
            Padding(
              padding: .only(top: 8.h),
              child: InkWell(
                onTap: () => _launchUrl(orderInvoice!.invoiceFileUrl!),
                child: Container(
                  padding: .symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: .circular(6.r),
                  ),
                  child: RowWidget(
                    mainAxisSize: .min,
                    gap: 6.w,
                    children: [
                      Icon(
                        Icons.description_outlined,
                        size: 16.sp,
                        color: AppColors.primary,
                      ),
                      Text(
                        'Xem file hóa đơn',
                        style: AppStyles.text.medium(
                          fSize: 13.sp,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ],
    );
  }

  Widget _infoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppStyles.text.medium(fSize: 13.sp, color: AppColors.grey84),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: AppStyles.text.medium(
                fSize: 13.sp,
                color: valueColor ?? AppColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _launchUrl(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
