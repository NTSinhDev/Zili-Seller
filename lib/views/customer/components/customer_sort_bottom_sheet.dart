part of '../customer_screen.dart';

class _CustomerSortBottomSheet extends StatelessWidget {
  final String? currentSort;
  final Function(String?) onSortSelected;

  const _CustomerSortBottomSheet({
    required this.currentSort,
    required this.onSortSelected,
  });

  final List<Map<String, String>> _sortOptions = const [
    {'value': 'name_asc', 'label': 'Tên A-Z'},
    {'value': 'name_desc', 'label': 'Tên Z-A'},
    {'value': 'order_asc', 'label': 'Số đơn tăng dần'},
    {'value': 'order_desc', 'label': 'Số đơn giảm dần'},
    {'value': 'spending_asc', 'label': 'Tổng chi tiêu tăng dần'},
    {'value': 'spending_desc', 'label': 'Tổng chi tiêu giảm dần'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 12.h),
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColors.greyC0,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          // Title
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Text(
              'Sắp xếp',
              style: AppStyles.text.bold(
                fSize: 18.sp,
                color: AppColors.black3,
              ),
            ),
          ),
          // Sort Options
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _sortOptions.length,
            itemBuilder: (context, index) {
              final option = _sortOptions[index];
              final isSelected = currentSort == option['value'];
              return BottomSheetListItem(
                title: option['label']!,
                isSelected: isSelected,
                onTap: () => onSortSelected(
                  isSelected ? null : option['value'],
                ),
              );
            },
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}

