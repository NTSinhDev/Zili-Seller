part of '../export_package_for_slip_item_screen.dart';

class _PackagesEntryBySearchButton extends StatelessWidget {
  final ProductRepository prodRepository;
  const _PackagesEntryBySearchButton(this.prodRepository);

  // void _loadingDataBeforeNavigate(BuildContext context) {
  //   if (context.mounted) {
  //     // Show loading screen if there are tasks
  //     LoadingScreen.navigate(
  //       context,
  //       tasks: <LoadingTask>[
  //         LoadingTask(
  //           name: 'Danh sách sản phẩm',
  //           errorMessage: 'Không thể tải danh sách sản phẩm',
  //           loader: () async =>
  //               await di<ProductCubit>().filterPackageVariants(),
  //         ),
  //       ],
  //       successRoute: SelectPackageVariantsScreen.routeName,
  //       successRouteArguments: (dynamic value) {
  //         if (value != null && value is List<ProductVariant>) {
  //           prodRepository.packageVariants.sink.add(value);
  //         }
  //       },
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // _loadingDataBeforeNavigate(context);
        context.navigator.pushNamed(SelectPackageVariantsScreen.routeName).then(
          (value) async {
            if (value != null && value is List<ProductVariant>) {
              prodRepository.packageVariants.sink.add(value);
            }
          },
        );
      },
      child: Container(
        padding: .symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: .circular(8.r),
          border: .all(color: AppColors.greyC0),
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
