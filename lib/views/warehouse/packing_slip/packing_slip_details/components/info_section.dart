part of '../packing_slip_details_screen.dart';

class _InfoSection extends StatelessWidget {
  final String title;
  final List<MapEntry<String, String>> rows;
  final List<MapEntry<String, String>>? belowBottomRows;
  final PackingSlipStatus? status;
  const _InfoSection({
    required this.title,
    required this.rows,
    required this.belowBottomRows,
    this.status,
  });

  @override
  Widget build(BuildContext context) {
    return ColumnWidget(
      crossAxisAlignment: .start,
      backgroundColor: Colors.white,
      padding: .symmetric(horizontal: 16.w, vertical: 8.h),
      gap: 12.h,
      children: [
        Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Text(
              'Thông tin phiếu đóng gói',
              style: AppStyles.text.bold(fSize: 14.sp, color: AppColors.black3),
            ),
            if (status != null && packingSlipStatusColor(status) != null)
              StatusBadge(
                label: packingSlipStatusLabel(status),
                color: packingSlipStatusColor(status)!,
              ),
          ],
        ),
        Container(
          width: .infinity,
          padding: .symmetric(horizontal: 14.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: AppColors.lightGrey,
            borderRadius: .circular(12.r),
          ),
          child: ColumnWidget(
            gap: 8.h,
            children: [
              ...rows
                  .map(
                    (e) => Row(
                      crossAxisAlignment: .start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            e.key,
                            style: AppStyles.text.medium(
                              fSize: 12.sp,
                              color: AppColors.black3,
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          flex: 3,
                          child: Text(
                            e.value,
                            style: AppStyles.text.medium(
                              fSize: 12.sp,
                              color: AppColors.black3,
                            ),
                            maxLines: 4,
                            textAlign: .right,
                          ),
                        ),
                      ],
                    ),
                  )
                  ,
              if (belowBottomRows != null) ...[
                Divider(height: 1, color: AppColors.greyC0, thickness: 1.sp),
                ...belowBottomRows!.map(
                  (e) => Row(
                    crossAxisAlignment: .start,
                    children: [
                      Expanded(
                        child: Text(
                          e.key,
                          style: AppStyles.text.medium(
                            fSize: 12.sp,
                            color: AppColors.black3,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        e.value,
                        style: AppStyles.text.medium(
                          fSize: 12.sp,
                          color: AppColors.black3,
                        ),
                        maxLines: 4,
                        textAlign: .right,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox.shrink(),
      ],
    );
  }
}
