part of '../brands_screen.dart';

class _FilterTabs extends StatelessWidget {
  final int selectedTab;
  final Function(int) onTabChanged;
  final VoidCallback onFilterPressed;

  const _FilterTabs({
    required this.selectedTab,
    required this.onTabChanged,
    required this.onFilterPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .symmetric(horizontal: 16.w, vertical: 8.h),
      color: AppColors.white,
      child: Row(
        children: [
          Expanded(
            child: RowWidget(
              gap: 20.w,
              children: [
                _buildTab(
                  'Tổng quan',
                  isSelected: selectedTab == 0,
                  onTap: () => onTabChanged(0),
                ),
                if (PermissionHelper.view(AbilitySubject.packagingManagement) ||
                    PermissionHelper.manage(AbilitySubject.packagingManagement))
                  StreamBuilder(
                    stream:
                        di<WarehouseRepository>().newPackingSlipsCounter.stream,
                    builder: (context, asyncSnapshot) {
                      final count = asyncSnapshot.data ?? 0;
                      return _buildTab(
                        'Phiếu đóng gói',
                        isSelected: selectedTab == 1,
                        onTap: () => onTabChanged(1),
                        count: count,
                      );
                    },
                  ),
              ],
            ),
          ),
          InkWell(
            onTap: onFilterPressed,
            borderRadius: .circular(1000),
            child: Padding(
              padding: .all(8.h),
              child: const Icon(Icons.filter_list, color: AppColors.black3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(
    String label, {
    required bool isSelected,
    required VoidCallback onTap,
    int? count,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: .symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? AppColors.primary : Colors.transparent,
              width: 2.w,
            ),
          ),
        ),
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: label,
                style: AppStyles.text
                    .medium(
                      fSize: 14.sp,
                      color: isSelected ? AppColors.primary : AppColors.black3,
                    )
                    .copyWith(
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                    ),
              ),
              if ((count ?? 0) > 0)
                TextSpan(
                  text: ' (${count! < 100 ? count : '99+'})',
                  style: AppStyles.text.medium(
                    fSize: 12.sp,
                    color: AppColors.scarlet,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
