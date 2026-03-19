part of '../customer_screen.dart';

class _CustomerFilterTabs extends StatelessWidget {
  final List<CustomerStatus>? selectedTab;
  final Function(CustomerStatus?) onTabChanged;
  final VoidCallback onSortPressed;
  final VoidCallback onFilterPressed;

  const _CustomerFilterTabs({
    required this.selectedTab,
    required this.onTabChanged,
    required this.onSortPressed,
    required this.onFilterPressed,
  });

  @override
  Widget build(BuildContext context) {
    final tabsSource = [
      {
        "label": "Tất cả",
        "isSelected": (selectedTab ?? []).isEmpty,
        "onTap": () => onTabChanged(null),
      },
      {
        "label": "Đang giao dịch",
        "isSelected": listEquals((selectedTab ?? []), [CustomerStatus.active]),
        "onTap": () => onTabChanged(CustomerStatus.active),
      },
      if ((selectedTab ?? []).isNotEmpty &&
          !listEquals((selectedTab ?? []), [CustomerStatus.active]))
        {
          "label": "Kết quả",
          "isSelected":
              (selectedTab ?? []).isNotEmpty &&
              !listEquals((selectedTab ?? []), [CustomerStatus.active]),
          "onTap": () {},
        },
    ];
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      color: AppColors.white,
      child: Row(
        children: [
          // Tabs
          Expanded(
            child: RowWidget(
              gap: 20.w,
              children: List.generate(
                tabsSource.length,
                (index) => _buildTab(
                  tabsSource[index]["label"] as String,
                  isSelected: tabsSource[index]["isSelected"] as bool,
                  onTap: tabsSource[index]["onTap"] as VoidCallback,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: onSortPressed,
            borderRadius: BorderRadius.circular(1000),
            child: Padding(
              padding: EdgeInsets.all(8.h),
              child: Icon(
                Icons.swap_vert,
                color: AppColors.black3,
                size: 24.sp,
              ),
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
      onTap: isSelected ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
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
          textAlign: TextAlign.center,
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
