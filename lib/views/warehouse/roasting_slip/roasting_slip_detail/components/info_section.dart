part of '../roasting_slip_detail_screen.dart';

class _InfoSection extends StatelessWidget {
  final String title;
  final RoastingSlipStatus? status;
  final List<MapEntry<String, String>> rows;
  const _InfoSection({
    required this.title,
    required this.rows,
    this.status,
  });

  @override
  Widget build(BuildContext context) {
    return ColumnWidget(
      crossAxisAlignment: .start,
      gap: 8.h,
      children: [
        RowWidget(
          mainAxisAlignment: .spaceBetween,
          children: [
            Text(
              title,
              style: AppStyles.text.bold(fSize: 14.sp, color: AppColors.black3),
            ),
            if (status != null)
              StatusBadge(
                label: roastingSlipStatusLabel(status),
                color: roastingSlipStatusColor(status)!,
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
            children: rows
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
                .toList(),
          ),
        ),
      ],
    );
  }
}
