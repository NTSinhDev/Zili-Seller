part of '../setting_screen.dart';

class _OrderManager extends StatelessWidget {
  const _OrderManager();

  @override
  Widget build(BuildContext context) {
    final OrderRepository orderRepository = di<OrderRepository>();
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    AppConstant.svgs.icOrderManagement,
                    width: 24.w,
                    height: 24.w,
                  ),
                  width(width: 10),
                  Text(
                    'Đơn hàng',
                    style: AppStyles.text.semiBold(fSize: 16.sp),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  orderRepository.toolbarIndex = -1;
                  // context.navigator.pushNamed(OrdersManagementScreen.keyName);
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Xem tất cả đơn hàng',
                        style: AppStyles.text.semiBold(fSize: 14.sp),
                      ),
                      width(width: 6),
                      CustomIconStyle(
                        icon: CupertinoIcons.chevron_right,
                        style: AppStyles.text.semiBold(fSize: 14.sp),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(
          height: 1.h,
          thickness: 1,
          color: AppColors.lightGrey,
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 20.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _orderState(
                onTap: () {
                  openOrdersScreen(context, 0, orderRepository);
                },
                label: 'Đang xử lý',
                icon: AppConstant.svgs.icPackage,
              ),
              _orderState(
                onTap: () {
                  openOrdersScreen(context, 1, orderRepository);
                },
                label: 'Đang giao',
                icon: AppConstant.svgs.icDeliveryTruck,
              ),
              _orderState(
                onTap: () {
                  openOrdersScreen(context, 2, orderRepository);
                },
                label: 'Đã nhận',
                icon: AppConstant.svgs.icDelivery,
              ),
              _orderState(
                onTap: () {
                  openOrdersScreen(context, 3, orderRepository);
                },
                label: 'Đã hủy',
                hasDecor: true,
                icon: AppConstant.svgs.icPackage,
              ),
            ],
          ),
        ),
        Divider(
          height: 1.h,
          thickness: 5,
          color: AppColors.lightGrey,
        ),
      ],
    );
  }

  Future<void> openOrdersScreen(
    BuildContext context,
    int index,
    OrderRepository orderRepository,
  ) async {
    if (index == 3) {
      orderRepository.toolbarIndex = index;
      context.navigator.push(MaterialPageRoute(
        builder: (context) =>
            const OrdersManagementScreen(reverseToolbar: true),
      ));
    } else {
      orderRepository.toolbarIndex = index;
      // context.navigator.pushNamed(OrdersManagementScreen.keyName);
    }
  }

  Widget _orderState({
    int value = 0,
    bool hasDecor = false,
    required String icon,
    required String label,
    required Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 48.w,
            height: 48.h,
            child: Stack(
              children: [
                SvgPicture.asset(icon),
                if (hasDecor)
                  Positioned(
                    top: 3,
                    right: 3,
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.black, width: 1.1),
                        color: AppColors.white,
                        shape: BoxShape.circle,
                      ),
                      child: CustomIconStyle(
                        icon: Icons.clear,
                        style: AppStyles.text.semiBold(fSize: 10.sp),
                      ),
                    ),
                  ),
                if (value > 0)
                  Positioned(
                    top: 0,
                    right: 3,
                    child: Container(
                      padding: EdgeInsets.all(5.w),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.red,
                      ),
                      child: Text(
                        '$value',
                        style: AppStyles.text.bold(
                          fSize: 10.sp,
                          color: AppColors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Text(
            label,
            style: AppStyles.text.medium(fSize: 12.sp),
          ),
        ],
      ),
    );
  }
}
