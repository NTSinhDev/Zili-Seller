part of '../customer_section.dart';

class _CustomerCard extends StatelessWidget {
  final Customer customer;
  final VoidCallback? onRemove;
  const _CustomerCard({required this.customer, this.onRemove});

  @override
  Widget build(BuildContext context) {
    final totalSpending = customer.totalSpending;
    final totalOrder = customer.totalOrder.removeTrailingZero;
    return Container(
      padding: .all(12.w),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: .circular(8.r),
      ),
      child: RowWidget(
        crossAxisAlignment: .start,
        gap: 12.w,
        children: [
          Avatar(avatar: customer.avatar, size: 32.w),
          Expanded(
            child: ColumnWidget(
              crossAxisAlignment: .start,
              gap: 4.h,
              children: [
                Text(
                  customer.displayName,
                  style: AppStyles.text.semiBold(fSize: 14.sp, height: 18 / 14),
                ),
                CustomRichTextWidget(
                  defaultStyle: AppStyles.text.medium(
                    fSize: 12.sp,
                    color: AppColors.black5,
                  ),
                  texts: [
                    'Tổng chi tiêu: ',
                    TextSpan(
                      text: totalSpending.toUSD,
                      style: AppStyles.text.semiBold(
                        fSize: 12.sp,
                        color: SystemColors.primaryBlue,
                      ),
                    ),
                    TextSpan(
                      text: ' ($totalOrder đơn)',
                      style: AppStyles.text.medium(
                        fSize: 12.sp,
                        color: AppColors.black3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Icon X để xóa
          if (onRemove != null)
            InkWell(
              onTap: onRemove,
              child: Icon(Icons.close, size: 20.sp, color: AppColors.black3),
            ),
        ],
      ),
    );
  }
}

class _TextItem extends StatelessWidget {
  final String label;
  final String value;
  const _TextItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return CustomRichTextWidget(
      defaultStyle: AppStyles.text.medium(
        fSize: 12.sp,
        color: AppColors.black5,
      ),
      texts: [
        TextSpan(text: label),
        TextSpan(
          text: value,
          style: AppStyles.text.medium(fSize: 14.sp, color: AppColors.black3),
        ),
      ],
    );
  }
}

class _ContactCard extends StatelessWidget {
  final String email;
  final String phone;
  const _ContactCard({required this.email, required this.phone});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: .start,
      children: [
        Expanded(
          child: ColumnWidget(
            crossAxisAlignment: .start,
            gap: 8.h,
            children: [
              Text('Liên hệ:\t\t', style: AppStyles.text.semiBold(fSize: 14.sp)),
              if (email.isNotEmpty) _TextItem(label: 'Email:\t\t', value: email),
              if (phone.isNotEmpty)
                _TextItem(label: 'Số điện thoại:\t\t', value: phone),
            ],
          ),
        ),
      ],
    );
  }
}

class _AddressCard extends StatelessWidget {
  final String title;
  final Address? address;
  final VoidCallback? onEdit;

  const _AddressCard({required this.title, required this.address, this.onEdit});

  @override
  Widget build(BuildContext context) {
    final renderAddress = address != null
        ? renderCustomerAddress(address)
        : 'Chưa có địa chỉ';
    return Row(
      crossAxisAlignment: .start,
      children: [
        Expanded(
          child: ColumnWidget(
            crossAxisAlignment: .start,
            gap: 8.h,
            children: [
              Text('$title:', style: AppStyles.text.semiBold(fSize: 14.sp)),
              if (address != null) ...[
                Text(
                  address?.name ?? '',
                  style: AppStyles.text.medium(
                    fSize: 12.sp,
                    color: address != null
                        ? AppColors.black3
                        : AppColors.grey84,
                  ),
                ),
                Text(
                  address?.phone ?? '',
                  style: AppStyles.text.medium(
                    fSize: 12.sp,
                    color: address != null
                        ? AppColors.black3
                        : AppColors.grey84,
                  ),
                ),
              ],
              Text(
                renderAddress,
                style: AppStyles.text.medium(
                  fSize: 12.sp,
                  color: address != null ? AppColors.black3 : AppColors.grey84,
                ),
              ),
            ],
          ),
        ),
        // Icon bút chì để edit
        if (onEdit != null)
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onEdit,
              borderRadius: .circular(1000),
              child: Container(
                padding: .all(6.w),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.edit_outlined,
                  size: 20.sp,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _PurchasedCard extends StatelessWidget {
  final Customer customer;
  const _PurchasedCard(this.customer);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: .start,
      children: [
        Expanded(
          child: ColumnWidget(
            crossAxisAlignment: .start,
            gap: 8.h,
            children: [
              Text(
                'Thông tin mua hàng:',
                style: AppStyles.text.semiBold(fSize: 14.sp),
              ),
              CustomRichTextWidget(
                defaultStyle: AppStyles.text.medium(
                  fSize: 12.sp,
                  color: AppColors.black5,
                ),
                texts: [
                  'Tổng chi tiêu:\t\t',
                  TextSpan(
                    text: customer.totalSpending.toUSD,
                    style: AppStyles.text.semiBold(
                      fSize: 12.sp,
                      color: SystemColors.primaryBlue,
                    ),
                  ),
                  TextSpan(
                    text: '\t\t(${customer.totalOrder.toInt()} đơn hàng)',
                    style: AppStyles.text.medium(
                      fSize: 12.sp,
                      color: AppColors.black3,
                    ),
                  ),
                ],
              ),
              CustomRichTextWidget(
                defaultStyle: AppStyles.text.medium(
                  fSize: 12.sp,
                  color: AppColors.black5,
                ),
                texts: [
                  'Công nợ hiện tại:\t\t',
                  TextSpan(
                    text: customer.currentDebt.toUSD,
                    style: AppStyles.text.semiBold(
                      fSize: 12.sp,
                      color: SystemColors.tertiaryRed,
                    ),
                  ),
                ],
              ),
              CustomRichTextWidget(
                defaultStyle: AppStyles.text.medium(
                  fSize: 12.sp,
                  color: AppColors.black5,
                ),
                texts: [
                  'Trả hàng:\t\t',
                  TextSpan(
                    text: customer.returnedTotalAmount.toUSD,
                    style: AppStyles.text.semiBold(
                      fSize: 12.sp,
                      color: SystemColors.tertiaryRed,
                    ),
                  ),
                  TextSpan(
                    text:
                        '\t\t(${customer.returnedProductQuantity.toInt()} sản phẩm)',
                    style: AppStyles.text.medium(
                      fSize: 12.sp,
                      color: AppColors.black3,
                    ),
                  ),
                ],
              ),
              CustomRichTextWidget(
                defaultStyle: AppStyles.text.medium(
                  fSize: 12.sp,
                  color: AppColors.black5,
                ),
                texts: [
                  'Giao thất bại:\t\t',
                  TextSpan(
                    text: customer.failedDeliveryTotalAmount.toUSD,
                    style: AppStyles.text.semiBold(
                      fSize: 12.sp,
                      color: SystemColors.tertiaryRed,
                    ),
                  ),
                  TextSpan(
                    text:
                        '\t\t(${customer.failedDeliveryOrderCount.toInt()} đơn hàng)',
                    style: AppStyles.text.medium(
                      fSize: 12.sp,
                      color: AppColors.black3,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
