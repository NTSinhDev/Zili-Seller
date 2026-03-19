part of '../roasted_beans_screen.dart';

class _FilterTabs extends StatelessWidget {
  final int selectedTab;
  final Function(int) onTabChanged;
  final VoidCallback onFilterPressed;
  final int totalRecords;

  const _FilterTabs({
    required this.selectedTab,
    required this.onTabChanged,
    required this.onFilterPressed,
    required this.totalRecords,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
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
                _buildTab(
                  'Phiếu rang',
                  isSelected: selectedTab == 1,
                  onTap: () => onTabChanged(1),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: onFilterPressed,
            borderRadius: BorderRadius.circular(1000),
            child: Padding(
              padding: EdgeInsets.all(8.h),
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
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? AppColors.primary : Colors.transparent,
              width: 2.w,
            ),
          ),
        ),
        child: Text(
          label,
          style: AppStyles.text
              .medium(
                fSize: 14.sp,
                color: isSelected ? AppColors.primary : AppColors.black3,
              )
              .copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
        ),
      ),
    );
  }
}
