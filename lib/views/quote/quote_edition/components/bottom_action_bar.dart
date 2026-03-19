part of '../edit_quote_screen.dart';

class _BottomActionBar extends StatelessWidget {
  final double totalAmount;
  final QuoteMailType quotationType;
  final VoidCallback onConfirm;
  final VoidCallback onExit;
  const _BottomActionBar({
    required this.totalAmount,
    required this.onConfirm,
    required this.quotationType,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .symmetric(horizontal: 20.w, vertical: 12.h),
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
            if (quotationType != .quantityQuote)
              RowWidget(
                mainAxisAlignment: .start,
                crossAxisAlignment: .center,
                gap: 6.w,
                children: [
                  Container(
                    padding: .all(4.w),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: .circle,
                    ),
                    child: Icon(
                      Icons.attach_money_outlined,
                      color: AppColors.primary,
                      size: 16.sp,
                    ),
                  ),
                  Text(
                    'Khách phải trả:',
                    style: AppStyles.text.medium(
                      fSize: 16.sp,
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
              gap: 20.w,
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onExit,
                    autofocus: false,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.grey84),
                      padding: .symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: .circular(8.r),
                      ),
                    ),
                    child: Text(
                      'Thoát',
                      style: AppStyles.text.semiBold(
                        fSize: 14.sp,
                        color: AppColors.black5,
                      ),
                    ),
                  ),
                ),
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
                    onPressed: onConfirm,
                    child: Text(
                      'Xác nhận',
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
