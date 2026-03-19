part of '../customer_groups_screen.dart';

class _ItemListView extends StatelessWidget {
  final CustomerGroup item;
  final VoidCallback? onTap;
  const _ItemListView(this.item, {this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: .symmetric(horizontal: 16.w, vertical: 12.h),
        color: AppColors.white,
        child: RowWidget(
          crossAxisAlignment: .start,
          gap: 20.w,
          children: [
            Expanded(
              child: ColumnWidget(
                crossAxisAlignment: .start,
                gap: 4.h,
                children: [
                  Text(
                    item.displayName,
                    style: AppStyles.text.semiBold(
                      fSize: 16.sp,
                      color: AppColors.black3,
                    ),
                    maxLines: 1,
                    overflow: .ellipsis,
                  ),
                  Text(
                    item.code ?? AppConstant.strings.DEFAULT_EMPTY_VALUE,
                    style: AppStyles.text.medium(
                      fSize: 14.sp,
                      color: AppColors.grey84,
                    ),
                    maxLines: 1,
                    overflow: .ellipsis,
                  ),
                  if (item.description != null &&
                      (item.description ?? "").isNotEmpty)
                    Text(
                      item.description ??
                          AppConstant.strings.DEFAULT_EMPTY_VALUE,
                      style: AppStyles.text.medium(
                        fSize: 12.sp,
                        color: AppColors.grey84,
                      ),
                      maxLines: 2,
                      overflow: .ellipsis,
                    ),
                ],
              ),
            ),
            ColumnWidget(
              crossAxisAlignment: .end,
              gap: 5.h,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: item.totalUser.toString(),
                        style: AppStyles.text.bold(
                          fSize: 14.sp,
                          color: AppColors.black3,
                        ),
                      ),
                      TextSpan(
                        text: ' khách hàng',
                        style: AppStyles.text.medium(
                          fSize: 12.sp,
                          color: AppColors.black3,
                        ),
                      ),
                    ],
                  ),
                ),
                if (labelCustomerGroupType(item.type) != null)
                  Container(
                    padding: .symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: colorCustomerGroupType(
                        item.type,
                      )?.withValues(alpha: 0.1),
                      borderRadius: .circular(4.r),
                    ),
                    child: Text(
                      labelCustomerGroupType(item.type) ??
                          AppConstant.strings.DEFAULT_EMPTY_VALUE,
                      style: AppStyles.text.medium(
                        fSize: 12.sp,
                        color:
                            colorCustomerGroupType(item.type) ??
                            AppColors.black3,
                      ),
                    ),
                  ),
                Text(
                  item.createdAt?.formatWithTimezone() ??
                      AppConstant.strings.DEFAULT_EMPTY_VALUE,
                  style: AppStyles.text.medium(
                    fSize: 12.sp,
                    color: AppColors.black5,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
