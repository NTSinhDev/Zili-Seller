part of '../packing_slip_item_details_screen.dart';

class _InfoSection extends StatelessWidget {
  final PackingSlipDetailItem item;
  const _InfoSection({required this.item});

  @override
  Widget build(BuildContext context) {
    return ColumnWidget(
      crossAxisAlignment: CrossAxisAlignment.start,
      backgroundColor: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      gap: 12.h,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Thông tin phiếu đóng gói',
              style: AppStyles.text.bold(fSize: 14.sp, color: AppColors.black3),
            ),
            if (item.statusEnum != null &&
                packingSlipStatusColor(item.statusEnum) != null)
              StatusBadge(
                label: packingSlipStatusLabel(item.statusEnum),
                color: packingSlipStatusColor(item.statusEnum)!,
              ),
          ],
        ),
        RowWidget(
          gap: 4.w,
          children: [
            Text(
              'Ngày tạo:',
              style: AppStyles.text.medium(
                fSize: 12.sp,
                color: AppColors.black5,
              ),
            ),
            Text(
              item.createdAt,
              style: AppStyles.text.medium(
                fSize: 14.sp,
                color: AppColors.black3,
              ),
            ),
          ],
        ),
        if (item.statusEnum == .cancelled) ...[
          RowWidget(
            gap: 4.w,
            children: [
              Text(
                'Ngày hủy:',
                style: AppStyles.text.medium(
                  fSize: 12.sp,
                  color: AppColors.black5,
                ),
              ),
              Text(
                item.cancelledAt ?? AppConstant.strings.DEFAULT_EMPTY_VALUE,
                style: AppStyles.text.medium(
                  fSize: 14.sp,
                  color: AppColors.black3,
                ),
              ),
            ],
          ),
          RowWidget(
            gap: 4.w,
            children: [
              Text(
                'Lý do hủy:',
                style: AppStyles.text.medium(
                  fSize: 12.sp,
                  color: AppColors.black5,
                ),
              ),
              Text(
                item.cancelReason ?? AppConstant.strings.DEFAULT_EMPTY_VALUE,
                style: AppStyles.text.medium(
                  fSize: 14.sp,
                  color: AppColors.black3,
                ),
              ),
            ],
          ),
        ],
        PackingSlipItemCard(item: item, isShowActions: false),
      ],
    );
  }
}
