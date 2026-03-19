part of '../select_customers_screen.dart';

class _CustomerListItem extends StatelessWidget {
  final Customer customer;
  final bool isSelected;
  const _CustomerListItem({required this.customer, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        di<CustomerCubit>().getDefaultCustomerAddress(customer.id).then((
          address,
        ) {
          customer.purchaseAddress = address;
          customer.billingAddress = address;
          if (address != null) {
            di<CustomerRepository>().addressesOfCustomer.sink.add([address]);
          }
          Navigator.pop(context, customer);
        });
      },
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.greyC0,
                  width: 1.w,
                ),
              ),
              child: RowWidget(
                mainAxisAlignment: .start,
                crossAxisAlignment: .stretch,
                maxHeight: 32.h,
                children: [
                  Avatar(avatar: customer.avatar, size: 28.w),
                  width(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: .start,
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        Text(
                          customer.displayName,
                          style: AppStyles.text.semiBold(
                            fSize: 15.sp,
                            color: AppColors.black3,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (customer.phone != null &&
                            customer.phone!.isNotEmpty)
                          Text(
                            customer.phone!,
                            style: AppStyles.text.medium(
                              fSize: 12.sp,
                              color: AppColors.grey84,
                            ),
                          ),
                      ],
                    ),
                  ),
                  ColumnWidget(
                    crossAxisAlignment: .end,
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Text(
                        '${customer.totalOrder.toInt()} đơn',
                        style: AppStyles.text.medium(
                          fSize: 12.sp,
                          color: AppColors.black3,
                        ),
                      ),
                      Text(
                        customer.totalSpending.toInt().toPrice(),
                        style: AppStyles.text.medium(
                          fSize: 14.sp,
                          color: AppColors.black3,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
