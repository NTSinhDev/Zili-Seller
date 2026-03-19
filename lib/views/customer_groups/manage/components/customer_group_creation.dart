part of '../customer_groups_screen.dart';

class _CustomerGroupCreationAction extends StatelessWidget {
  const _CustomerGroupCreationAction();

  void _loadingDataBeforeNavigate(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: .vertical(top: .circular(20.r)),
      ),
      builder: (bottomSheetContext) {
        final tileFixedItem = ListTile(
          leading: Container(
            padding: .all(8.w),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: .circle,
            ),
            child: SvgPicture.asset(
              AssetIcons.iArticlePersonSvg,
              width: 24.w,
              height: 24.h,
              colorFilter: const .mode(AppColors.primary, .srcIn),
            ),
          ),
          title: Text(
            'Nhóm khách hàng cố định',
            style: AppStyles.text.semiBold(
              fSize: 14.sp,
              color: AppColors.black3,
            ),
          ),
          subtitle: Container(
            margin: .only(top: 4.h),

            child: Text(
              'Sử dụng khi các khách hàng trong nhóm không có điểm chung. Bạn cần chủ động gán khách hàng vào nhóm này.',
              style: AppStyles.text.medium(
                fSize: 12.sp,
                color: AppColors.grey84,
                height: 14 / 12,
              ),
            ),
          ),
          contentPadding: .symmetric(horizontal: 20.w, vertical: 12.h),
          onTap: () {
            bottomSheetContext.navigator.pop();
            context.navigator.pushNamed(
              CustomerGroupCreateScreen.keyName,
              arguments: CustomerGroupType.fixed,
            );
          },
        );

        final tileAutomaticItem = ListTile(
          leading: Container(
            padding: .all(8.w),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: .circle,
            ),
            child: SvgPicture.asset(
              AssetIcons.iGroupPeopleSvg,
              width: 24.w,
              height: 24.h,
              colorFilter: const .mode(AppColors.primary, .srcIn),
            ),
          ),
          title: Text(
            'Nhóm khách hàng tự động',
            style: AppStyles.text.semiBold(
              fSize: 14.sp,
              color: AppColors.black3,
            ),
          ),
          subtitle: Container(
            margin: .only(top: 4.h),
            child: Text(
              'Sử dụng khi bạn muốn tạo một tập khách hàng có cùng điểm chung để dễ chăm sóc hoặc chạy marketing.',
              style: AppStyles.text.medium(
                fSize: 12.sp,
                color: AppColors.grey84,
                height: 14 / 12,
              ),
            ),
          ),
          contentPadding: .symmetric(horizontal: 20.w, vertical: 12.h),
          onTap: () {
            bottomSheetContext.navigator.pop();
            context.navigator.pushNamed(
              CustomerGroupCreateScreen.keyName,
              arguments: CustomerGroupType.automatic,
            );
          },
        );

        return ColumnWidget(
          mainAxisSize: .min,
          children: [
            BottomSheetHeader(
              title: 'Chọn loại nhóm khách hàng',
              onClose: () => bottomSheetContext.navigator.pop(),
            ),
            Padding(
              padding: .symmetric(vertical: 8.h),
              child: ColumnWidget(
                mainAxisSize: .min,
                children: [
                  tileFixedItem,
                  Divider(
                    height: 1,
                    color: AppColors.greyC0,
                    indent: 20.w,
                    endIndent: 20.w,
                  ),
                  tileAutomaticItem,
                ],
              ),
            ),
            SizedBox(height: 16.h),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ActionAppBarIcon(
      icon: Icons.add,
      color: AppColors.primary,
      circleFrame: true,
      onTap: () => _loadingDataBeforeNavigate(context),
    );
  }
}
