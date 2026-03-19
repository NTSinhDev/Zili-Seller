import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../res/res.dart';
import '../../utils/extension/extension.dart';
import '../../utils/widgets/widgets.dart';

class DateSelectorField extends StatelessWidget {
  final String label;
  final String? hint;
  final DateTime? datetime;
  final Function(DateTime?) onChanged;
  const DateSelectorField({
    super.key,
    this.hint,
    this.datetime,
    required this.onChanged,
    required this.label,
  });

  String? get displayDate {
    final dateFormat = DateFormat('dd/MM/yyyy', 'vi_VN');
    final rsl = datetime != null ? dateFormat.format(datetime!) : null;
    return rsl;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _selectDate(context),
      child: Container(
        padding: .symmetric(horizontal: 16.w),
        height: 44.h,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: .circular(8.r),
          border: .all(color: AppColors.greyC0),
        ),
        child: RowWidget(
          mainAxisAlignment: .spaceBetween,
          children: [
            Expanded(
              child: ColumnWidget(
                mainAxisAlignment: .center,
                crossAxisAlignment: .start,
                gap: 4.h,
                children: [
                  if (displayDate != null)
                    Text(
                      label,
                      style: AppStyles.text.medium(
                        fSize: 10.sp,
                        color: AppColors.grey84,
                      ),
                    ),
                  Text(
                    displayDate ?? hint ?? 'Chọn ngày',
                    style: AppStyles.text.medium(
                      fSize: 14.sp,
                      color: displayDate == null
                          ? AppColors.grey84
                          : AppColors.black3,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.calendar_month_rounded, color: AppColors.grey84),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    context.focus.unfocus();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: datetime ?? DateTime.now().copyWith(year: 2000),
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 120)),
      lastDate: DateTime.now(),
      locale: const Locale('vi', 'VN'),
      fieldHintText: 'Ngày / Tháng / Năm',
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.white,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onChanged(picked);
    }
  }
}

class DateRangeSelectorField extends StatelessWidget {
  final DateTimeRange<DateTime>? dateRange;
  final String label;
  final String? hint;
  final Function(DateTimeRange<DateTime>?) onChanged;
  const DateRangeSelectorField({
    super.key,
    this.dateRange,
    this.hint,
    required this.onChanged,
    required this.label,
  });

  String? get displayDate {
    String formatDateTime(DateTime date) {
      final dateFormat = DateFormat('dd/MM/yyyy', 'vi_VN');
      return dateFormat.format(date);
    }

    if (dateRange != null) {
      final startDate = dateRange!.start;
      final endDate = dateRange!.end;
      return '${formatDateTime(startDate)} - ${formatDateTime(endDate)}';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _selectDateRange(context),
      child: Container(
        padding: .symmetric(horizontal: 16.w),
        height: 44.h,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: .circular(8.r),
          border: .all(color: AppColors.greyC0),
        ),
        child: RowWidget(
          mainAxisAlignment: .spaceBetween,
          children: [
            Expanded(
              child: ColumnWidget(
                mainAxisAlignment: .center,
                crossAxisAlignment: .start,
                gap: 4.h,
                children: [
                  if (displayDate != null)
                    Text(
                      label,
                      style: AppStyles.text.medium(
                        fSize: 10.sp,
                        color: AppColors.grey84,
                      ),
                    ),
                  Text(
                    displayDate ?? hint ?? 'Chọn thời gian',
                    style: AppStyles.text.medium(
                      fSize: 14.sp,
                      color: displayDate == null
                          ? AppColors.grey84
                          : AppColors.black3,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.calendar_month_rounded, color: AppColors.grey84),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDateRange(BuildContext context) async {
    context.focus.unfocus();
    final now = DateTime.now();
    final firstDate = now.copyWith(year: 2000).startOfDate();
    final lastDate = now.startOfDate();
    
    // Clamp initialDateRange to ensure it's within valid bounds
    DateTimeRange<DateTime>? clampedInitialDateRange;
    if (this.dateRange != null) {
      // Normalize dates to start of day for comparison
      final rangeStart = this.dateRange!.start.startOfDate();
      final rangeEnd = this.dateRange!.end.startOfDate();
      
      // Clamp start date
      DateTime clampedStart;
      if (rangeStart.isBefore(firstDate)) {
        clampedStart = firstDate;
      } else if (rangeStart.isAfter(lastDate)) {
        clampedStart = lastDate;
      } else {
        clampedStart = rangeStart;
      }
      
      // Clamp end date - must be on or before lastDate
      DateTime clampedEnd;
      if (rangeEnd.isBefore(firstDate)) {
        clampedEnd = firstDate;
      } else if (rangeEnd.isAfter(lastDate)) {
        clampedEnd = lastDate;
      } else {
        clampedEnd = rangeEnd;
      }
      
      // Ensure start is not after end
      if (clampedStart.isAfter(clampedEnd)) {
        clampedInitialDateRange = DateTimeRange<DateTime>(
          start: clampedEnd,
          end: clampedStart,
        );
      } else {
        clampedInitialDateRange = DateTimeRange<DateTime>(
          start: clampedStart,
          end: clampedEnd,
        );
      }
    }
    
    final dateRange = await showDateRangePicker(
      context: context,
      initialDateRange: clampedInitialDateRange,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (dateRange.isNotNull) {
      onChanged(dateRange);
    }
  }
}
