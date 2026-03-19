part of '../customer_screen.dart';

class _CustomerListItem extends StatelessWidget {
  final Customer customer;
  final VoidCallback onTap;
  const _CustomerListItem({required this.customer, required this.onTap});

  String get _displayPhone =>
      customer.phone ?? AppConstant.strings.DEFAULT_EMPTY_VALUE;

  String get _displayAddress {
    final address = customer.purchaseAddress;
    if (address?.fullAddress != null) {
      return address!.fullAddress;
    }
    return AppConstant.strings.DEFAULT_EMPTY_VALUE;
  }

  String get _transactionCount => customer.totalOrder.toInt().toString();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: .circular(8.r),
      child: Container(
        padding: .symmetric(horizontal: 16.w, vertical: 12.h),
        color: AppColors.white,
        child: Row(
          crossAxisAlignment: .start,
          children: [
            // Left Section - Customer Info
            Expanded(
              child: ColumnWidget(
                crossAxisAlignment: .start,
                gap: 4.h,
                children: [
                  // Customer Name
                  Text(
                    customer.displayName,
                    style: AppStyles.text.semiBold(
                      fSize: 16.sp,
                      color: AppColors.black3,
                      height: 1.2,
                    ),
                    maxLines: 1,
                    overflow: .ellipsis,
                  ),
                  if ((customer.customerGroup?.displayName ?? "").isNotEmpty)
                    Text(
                      customer.customerGroup?.displayName ??
                          AppConstant.strings.DEFAULT_EMPTY_VALUE,
                      style: AppStyles.text.medium(
                        fSize: 14.sp,
                        color: AppColors.black5,
                      ),
                      maxLines: 1,
                      overflow: .ellipsis,
                    ),
                  // Phone Number
                  if ((customer.phone ?? "").isNotEmpty)
                    CustomRichTextWidget(
                      defaultStyle: AppStyles.text.medium(
                        fSize: 14.sp,
                        height: 1.2,
                        color: AppColors.grey84,
                      ),
                      texts: [
                        _displayPhone,
                        if ((customer.email ?? "").isNotEmpty)
                          TextSpan(
                            text: " (${customer.email!})",
                            style: AppStyles.text.medium(
                              fSize: 12.sp,
                              color: AppColors.grey84,
                            ),
                          ),
                      ],
                    ),
                  Text(
                    'Công nợ: ${customer.currentDebt.toUSD}',
                    style: AppStyles.text.medium(
                      fSize: 12.sp,
                      color: customer.currentDebt < 0
                          ? AppColors.scarlet
                          : AppColors.black5,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            // Right Section - Transaction Count & Status
            Column(
              crossAxisAlignment: .end,
              children: [
                // Transaction Count
                Text(
                  '$_transactionCount đơn',
                  style: AppStyles.text.medium(
                    fSize: 14.sp,
                    color: AppColors.black3,
                  ),
                ),
                SizedBox(height: 8.h),
                // Status Badge
                StatusBadge(
                  label:
                      renderCustomerStatus(customer.status) ??
                      AppConstant.strings.DEFAULT_EMPTY_VALUE,
                  color:
                      renderCustomerStatusColor(customer.status) ??
                      AppColors.grey84,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
