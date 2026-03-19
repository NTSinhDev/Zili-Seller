part of '../create_order_screen.dart';

class _BottomActionBar extends StatelessWidget {
  final double totalAmount;
  final VoidCallback onCreateOrder;

  const _BottomActionBar({
    required this.totalAmount,
    required this.onCreateOrder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.grayEA)),
      ),
      child: SafeArea(
        child: ColumnWidget(
          crossAxisAlignment: .stretch,
          mainAxisSize: .min,
          gap: 20.h,
          children: [
            RowWidget(
              mainAxisAlignment: .start,
              crossAxisAlignment: .end,
              children: [
                Icon(
                  Icons.attach_money_outlined,
                  color: AppColors.primary,
                  size: 18.sp,
                ),
                Text(
                  'Tổng tiền khách phải trả',
                  style: AppStyles.text.medium(
                    fSize: 14.sp,
                    color: AppColors.black3,
                  ),
                ),
                Expanded(
                  child: Text(
                    totalAmount.toPrice(),
                    overflow: .ellipsis,
                    maxLines: 1,
                    textAlign: .right,
                    style: AppStyles.text.bold(
                      fSize: 20.sp,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            RowWidget(
              children: [
                Expanded(
                  child: ElevatedButton(
                    autofocus: false,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: .symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: .circular(8.r),
                      ),
                      elevation: 0,
                    ),
                    onPressed: onCreateOrder,
                    child: Text(
                      'Tạo đơn hàng',
                      style: AppStyles.text.semiBold(
                        fSize: 14.sp,
                        color: AppColors.white,
                      ),
                    ),
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
