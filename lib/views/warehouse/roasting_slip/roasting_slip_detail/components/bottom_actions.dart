part of '../roasting_slip_detail_screen.dart';

class _BottomActions extends StatelessWidget {
  final VoidCallback? onCancel;
  final VoidCallback? onExport;
  final VoidCallback? onComplete;
  final bool canEdit;
  const _BottomActions({
    this.onCancel,
    this.onExport,
    this.onComplete,
    this.canEdit = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!canEdit) return const SizedBox.shrink();

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
            if (onCancel.isNotNull)
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.cancel),
                    padding: .symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(borderRadius: .circular(8.r)),
                  ),
                  onPressed: onCancel,
                  child: Text(
                    'Hủy',
                    style: AppStyles.text.semiBold(
                      fSize: 14.sp,
                      color: AppColors.cancel,
                    ),
                  ),
                ),
              ),
            if (onExport.isNotNull)
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.warning,
                    padding: .symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(borderRadius: .circular(8.r)),
                    elevation: 0,
                  ),
                  onPressed: onExport,
                  child: Text(
                    'Xuất kho',
                    style: AppStyles.text.semiBold(
                      fSize: 14.sp,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            if (onComplete.isNotNull)
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: .symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(borderRadius: .circular(8.r)),
                    elevation: 0,
                  ),
                  onPressed: onComplete,
                  child: Text(
                    'Hoàn thành',
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
