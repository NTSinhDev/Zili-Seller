part of '../green_beans_screen.dart';

class _FilterView extends StatefulWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final Function(DateTime? startDate, DateTime? endDate) onFilterApplied;
  const _FilterView({this.startDate, this.endDate, required this.onFilterApplied});

  @override
  State<_FilterView> createState() => _FilterViewState();
}

class _FilterViewState extends State<_FilterView> {
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  TimeOption? selectedTimeOption;

  @override
  void initState() {
    super.initState();
    selectedStartDate = widget.startDate;
    selectedEndDate = widget.endDate;
  }

  @override
  Widget build(BuildContext context) {
    return ColumnWidget(
      crossAxisAlignment: .start,
      padding: .symmetric(horizontal: 20.w, vertical: 16.h),
      gap: 20.w,
      children: [
        ColumnWidget(
          gap: 10.w,
          crossAxisAlignment: .start,
          children: [
            Text(
              "Tùy chọn khoảng thời gian",
              style: AppStyles.text.semiBold(
                fSize: 14.sp,
                color: AppColors.black3,
              ),
            ),
            DateRangeSelectorField(
              dateRange: selectedStartDate.isNotNull && selectedEndDate.isNotNull
                  ? DateTimeRange<DateTime>(
                      start: selectedStartDate!,
                      end: selectedEndDate!,
                    )
                  : null,
              hint: 'Tùy chọn khoảng thời gian',
              label: 'khoảng thời gian',
              onChanged: (value) {
                selectedStartDate = value?.start;
                selectedEndDate = value?.end;
              },
            ),
          ],
        ),
        ColumnWidget(
          crossAxisAlignment: .start,
          gap: 10.w,
          children: [
            Text(
              "Thời gian",
              style: AppStyles.text.semiBold(
                fSize: 14.sp,
                color: AppColors.black3,
              ),
            ),
            RowWidget(
              gap: 10.w,
              children: TimeOption.values
                  .take(4)
                  .map(
                    (option) => _optionButtonLayout(
                      onPressed: () {
                        selectedTimeOption = option;
                        final timeRange = getRangeOfTimeOption(option);
                        selectedStartDate = timeRange.start;
                        selectedEndDate = timeRange.end;
                        setState(() {});
                      },
                      label: option.label,
                      isSelected: selectedTimeOption == option,
                    ),
                  )
                  .toList(),
            ),
            RowWidget(
              gap: 10.w,
              children: TimeOption.values
                  .skip(4)
                  .take(4)
                  .map(
                    (option) => _optionButtonLayout(
                      onPressed: () {
                        selectedTimeOption = option;
                        final timeRange = getRangeOfTimeOption(option);
                        selectedStartDate = timeRange.start;
                        selectedEndDate = timeRange.end;
                        setState(() {});
                      },
                      label: option.label,
                      isSelected: selectedTimeOption == option,
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: .symmetric(vertical: 14.h),
            shape: RoundedRectangleBorder(borderRadius: .circular(8.r)),
            elevation: 0,
          ),
          onPressed: () {
            context.navigator.pop();
            widget.onFilterApplied(selectedStartDate, selectedEndDate);
          },
          child: Container(
            width: .infinity,
            alignment: .center,
            child: Text(
              'Tìm kiếm',
              textAlign: .center,
              style: AppStyles.text.semiBold(
                fSize: 14.sp,
                color: AppColors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _optionButtonLayout({
    required String label,
    required Function() onPressed,
    required bool isSelected,
  }) {
    return Expanded(
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: isSelected ? AppColors.primary : AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
            side: BorderSide(
              color: isSelected ? AppColors.primary : AppColors.greyC0,
            ),
          ),
          padding: .zero,
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: AppStyles.text.medium(
            fSize: 12.sp,
            color: isSelected ? AppColors.white : AppColors.black3,
          ),
        ),
      ),
    );
  }
}
