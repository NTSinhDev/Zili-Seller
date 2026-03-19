part of '../packing_slip_details_screen.dart';

class _NoteSection extends StatelessWidget {
  final String note;
  const _NoteSection({required this.note});

  @override
  Widget build(BuildContext context) {
    return ColumnWidget(
      crossAxisAlignment: .start,
      padding: .symmetric(horizontal: 16.w, vertical: 16.h),
      backgroundColor: Colors.white,
      gap: 12.h,
      children: [
        Text(
          'Ghi chú',
          style: AppStyles.text.bold(fSize: 14.sp, color: AppColors.black3),
        ),
        Container(
          width: .infinity,
          padding: .all(12.w),
          height: 100.h,
          decoration: BoxDecoration(
            color: AppColors.lightGrey,
            borderRadius: .circular(12.r),
          ),
          child: Text(
            note,
            maxLines: 4,
            style: AppStyles.text.medium(fSize: 12.sp, color: AppColors.black3),
          ),
        ),
      ],
    );
  }
}
