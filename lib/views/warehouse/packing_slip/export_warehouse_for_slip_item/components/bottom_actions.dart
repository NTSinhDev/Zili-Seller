part of '../export_warehouse_for_slip_item_screen.dart';

class _BottomActions extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onSubmit;
  const _BottomActions({required this.onCancel, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .symmetric(horizontal: 20.w, vertical: 12.h),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.grayEA)),
      ),
      child: SafeArea(
        child: RowWidget(
          gap: 20.w,
          children: [
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.grayEA),
                  padding: .symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(borderRadius: .circular(8.r)),
                ),
                onPressed: onCancel,
                child: Text(
                  'Hủy',
                  style: AppStyles.text.semiBold(
                    fSize: 14.sp,
                    color: AppColors.black3,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: .symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(borderRadius: .circular(8.r)),
                  elevation: 0,
                ),
                onPressed: onSubmit,
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
      ),
    );
  }
}
