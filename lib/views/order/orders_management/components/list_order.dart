part of '../orders_management_screen.dart';

class _ListOrder extends StatelessWidget {
  final bool isLoading;
  const _ListOrder({required this.isLoading});

  @override
  Widget build(BuildContext context) {
    final OrderRepository orderRepository = di<OrderRepository>();
    return StreamBuilder<List<Order>>(
      stream: orderRepository.sellerOrdersStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting || isLoading) {
          return SliverToBoxAdapter(
            child: Container(
              color: AppColors.lightGrey.withOpacity(0.6),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  height(height: 10.h),
                  const _OrderItem(loading: true),
                  const _OrderItem(loading: true),
                  const _OrderItem(loading: true),
                  const _OrderItem(loading: true),
                  const _OrderItem(loading: true),
                  const _OrderItem(loading: true),
                  const _OrderItem(loading: true),
                  const _OrderItem(loading: true),
                  height(height: 20.h),
                ],
              ),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SliverToBoxAdapter(
            child: EmptyListViewWidget(),
          );
        }

        final List<Order> orders = snapshot.data!;
        final totalCount = orders.length == orderRepository.totalSellerOrders
            ? orders.length
            : orders.length + 1;
        
        return SliverList(
          
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              // First item is the header
              if (index == 0) {
                return Container(
                  margin: EdgeInsets.only(top: 10.h),
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                  color: AppColors.background,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${orderRepository.totalSellerOrders} đơn hàng',
                      style: AppStyles.text.medium(
                        fSize: 14.sp,
                        color: AppColors.grey84,
                      ),
                    ),
                  ),
                );
              }
              
              // Adjust index for orders (subtract 1 for header)
              final orderIndex = index - 1;
              
              // Last item (load more or end message)
              if (orderIndex == orders.length) {
                if (orderIndex < orderRepository.totalSellerOrders) {
                  return const _ListViewLoading();
                }
                return Container(
                  padding: EdgeInsets.all(20.w),
                  color: AppColors.white,
                  child: Center(
                    child: Text(
                      'Đã hiển thị tất cả đơn hàng',
                      style: AppStyles.text.medium(
                        fSize: 14.sp,
                        color: AppColors.grey84,
                      ),
                    ),
                  ),
                );
              }
              
              // Order item with divider
              return ColumnWidget(
                mainAxisSize: MainAxisSize.min,
                backgroundColor: AppColors.white,
                children: [
                  if (orderIndex > 0)
                    Divider(
                      color: AppColors.greyC0,
                      height: 1.h,
                    ),
                  _OrderItem(
                    order: orders[orderIndex],
                    loading: false,
                  ),
                ],
              );
            },
            childCount: totalCount + 1, // +1 for header
          ),
        );
      },
    );
  }
}
