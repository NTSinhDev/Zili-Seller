part of '../home_screen.dart';

class _MainScreen extends StatelessWidget {
  const _MainScreen();

  @override
  Widget build(BuildContext context) {
    return ColumnWidget(
      backgroundColor: Colors.white,
      children: [
        const _RevenueStatisticsChart(),
        // height(height: 24),
        // TextButton(
        //   onPressed: () {},

        //   child: RowWidget(
        //     mainAxisSize: .min,
        //     gap: 12.w,
        //     children: [
        //       Text(
        //         'Xem đơn hàng',
        //         style: AppStyles.text.medium(
        //           fSize: 14.sp,
        //           color: AppColors.primary,
        //         ),
        //       ),
        //       Icon(
        //         Icons.arrow_forward_ios,
        //         size: 12.sp,
        //         color: AppColors.primary,
        //       ),
        //     ],
        //   ),
        // ),
        // height(height: 24),
        Spacer(),
        // const _StoreRating(),
        // height(height: 24),
      ],
    );
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: ColumnWidget(
        backgroundColor: Colors.white,
        children: [
          const _RevenueStatisticsChart(),
          height(height: 24),
          TextButton(
            onPressed: () {},

            child: RowWidget(
              mainAxisSize: .min,
              gap: 12.w,
              children: [
                Text(
                  'Xem đơn hàng',
                  style: AppStyles.text.medium(
                    fSize: 14.sp,
                    color: AppColors.primary,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 12.sp,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
          height(height: 24),
          // const _StoreRating(),
          // height(height: 24),
        ],
      ),
    );
  }
}
