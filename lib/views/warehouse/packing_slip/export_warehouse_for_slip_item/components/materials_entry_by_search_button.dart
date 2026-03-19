part of '../export_warehouse_for_slip_item_screen.dart';

class _MaterialsEntryBySearchButton extends StatelessWidget {
  final ProductRepository prodRepository;
  const _MaterialsEntryBySearchButton(this.prodRepository);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.navigator.pushNamed(SelectMaterialsScreen.routeName).then((
          value,
        ) async {
          if (value != null && value is List<ProductVariant>) {
            prodRepository.materialVariants.sink.add(value);
          }
        });
      },
      child: Container(
        padding: .symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: .circular(8.r),
          border: Border.all(color: AppColors.greyC0),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: AppColors.grey84),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                'Tìm kiếm theo tên, mã SKU,...',
                style: AppStyles.text.medium(
                  fSize: 14.sp,
                  color: AppColors.grey84,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.grey84, size: 24.sp),
          ],
        ),
      ),
    );
  }
}
