part of '../order_list_screen.dart';

class _OrderEmptyState extends StatelessWidget {
  final VoidCallback onCreateOrder;
  const _OrderEmptyState({required this.onCreateOrder});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long,
            size: 100.w,
            color: AppColors.grey84,
          ),
          SizedBox(height: 16.h),
          Text(
            'Chưa có đơn hàng nào',
            style: AppStyles.text.medium(
              fSize: 16.sp,
              color: AppColors.black3,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Tạo đơn hàng để bắt đầu quản lý',
            textAlign: TextAlign.center,
            style: AppStyles.text.medium(
              fSize: 14.sp,
              color: AppColors.grey84,
            ),
          ),
          SizedBox(height: 24.h),
          CustomButtonWidget(
            onTap: onCreateOrder,
            label: 'Tạo đơn hàng mới',
            width: 200.w,
            height: 45.h,
            radius: 10.r,
          ),
        ],
      ),
    );
  }
}

