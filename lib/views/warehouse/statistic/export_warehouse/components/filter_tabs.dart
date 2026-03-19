part of '../export_warehouse_screen.dart';

class _FilterTabs extends StatelessWidget {
  final int selectedTab;
  final Function(int) onTabChanged;

  const _FilterTabs({required this.selectedTab, required this.onTabChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.background, width: 1.sp),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: RowWidget(
              gap: 20.w,
              children: [
                StreamBuilder(
                  stream:
                      di<WarehouseRepository>().newRoastingSlipsCounter.stream,
                  builder: (context, asyncSnapshot) {
                    final count = asyncSnapshot.data ?? 0;
                    return _buildTab(
                      'Phiếu rang',
                      isSelected: selectedTab == 0,
                      onTap: () => onTabChanged(0),
                      count: count,
                    );
                  },
                ),
                if (PermissionHelper.view(AbilitySubject.packagingManagement))
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
        padding: EdgeInsets.symmetric(vertical: 8.h),
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
                style: AppStyles.text.medium(
                  fSize: 14.sp,
                  color: isSelected ? AppColors.primary : AppColors.black3,
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
