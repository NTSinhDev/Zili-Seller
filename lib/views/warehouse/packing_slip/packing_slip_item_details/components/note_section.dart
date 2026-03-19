part of '../packing_slip_item_details_screen.dart';

class _NoteSection extends StatelessWidget {
  final String note;
  const _NoteSection({required this.note});

  @override
  Widget build(BuildContext context) {
    return ColumnWidget(
      crossAxisAlignment: CrossAxisAlignment.start,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      backgroundColor: Colors.white,
      gap: 12.h,
      children: [
        Text(
          'Ghi chú',
          style: AppStyles.text.bold(
            fSize: 14.sp,
            color: AppColors.black3,
          ),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: AppColors.lightGrey,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Text(
            note,
            style: AppStyles.text.medium(
              fSize: 12.sp,
              color: AppColors.black3,
            ),
          ),
        ),
      ],
    );
  }
}

