import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/data/models/order/order.dart';
import 'package:zili_coffee/res/res.dart';

import '../../../../data/models/user/base_person.dart';
import '../../../../utils/extension/date_time.dart';
import '../../../../utils/enums/order_enum.dart';
import '../../../../utils/widgets/widgets.dart';

typedef TimelineEntity = ({
  int index,
  String type,
  String label,
  String? createdAt,
  String? reason,
  bool isActive,
  BasePerson? createdBy,
});

class TimelineList extends StatelessWidget {
  final Order order;
  const TimelineList({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final processes = mergedTimelines;
    if (processes.isEmpty) {
      return SizedBox.shrink();
    }
    return ColumnWidget(
      crossAxisAlignment: .start,
      gap: 12.h,
      children: [
        // Container(
        //   padding: .symmetric(horizontal: 8.w, vertical: 4.h),
        //   decoration: BoxDecoration(
        //     color: AppColors.background,
        //     borderRadius: .circular(4.r),
        //   ),
        //   child: RowWidget(
        //     gap: 4.w,
        //     mainAxisSize: .min,
        //     children: [
        //       Icon(Icons.history, size: 18.sp, color: AppColors.black3),
        //       Text(
        //         'Trạng thái',
        //         style: AppStyles.text.semiBold(
        //           fSize: 14.sp,
        //           color: AppColors.black3,
        //         ),
        //       ),
        //       SizedBox.shrink()
        //     ],
        //   ),
        // ),
        Stack(
          children: [
            Positioned(
              left: 7.w,
              top: 8.h,
              bottom: 8.h,
              child: Container(
                width: 2.w,
                color: AppColors.grey84.withValues(alpha: 0.3),
              ),
            ),
            Column(
              children: processes.asMap().entries.map((entry) {
                final timelineItem = entry.value;
                final isLast = timelineItem.index == processes.length - 1;
                final dotColor =
                    timelineItem.type ==
                        OrderTimelineProcessStatus.cancelled.toConstant
                    ? AppColors.scarlet
                    : timelineItem.isActive
                    ? AppColors.green
                    : AppColors.greyC0;
                final textColor =
                    timelineItem.type ==
                        OrderTimelineProcessStatus.cancelled.toConstant
                    ? AppColors.scarlet
                    : timelineItem.isActive
                    ? AppColors.primary
                    : AppColors.greyC0;
                final dateColor = timelineItem.isActive
                    ? AppColors.grey
                    : AppColors.greyC0;

                return IntrinsicHeight(
                  child: RowWidget(
                    crossAxisAlignment: .start,
                    gap: 16.w,
                    children: [
                      // Build timeline dot line
                      Column(
                        children: [
                          Container(
                            margin: .only(top: 4.h),
                            width: 16.w,
                            height: 16.w,
                            decoration: BoxDecoration(
                              shape: .circle,
                              color: dotColor,
                              border: .all(color: AppColors.white, width: 2.w),
                            ),
                          ),
                          if (!isLast)
                            Expanded(
                              child: Container(
                                width: 2.w,
                                color: Colors.transparent, // Placeholder
                              ),
                            ),
                        ],
                      ),
                      Expanded(
                        child: Padding(
                          padding: .only(bottom: isLast ? 0 : 16.h),
                          child: ColumnWidget(
                            crossAxisAlignment: .start,
                            gap: 5.h,
                            children: [
                              CustomRichTextWidget(
                                defaultStyle: AppStyles.text.semiBold(
                                  fSize: 14.sp,
                                  color: textColor,
                                ),
                                maxLines: 2,
                                texts: [
                                  timelineItem.label,
                                  if (timelineItem.isActive &&
                                      (timelineItem.createdBy?.fullName ?? "")
                                          .isNotEmpty)
                                    TextSpan(
                                      text:
                                          " - ${timelineItem.createdBy?.fullName}",
                                      style: AppStyles.text.medium(
                                        fSize: 11.sp,
                                        color: dateColor,
                                      ),
                                    ),
                                ],
                              ),
                              if (timelineItem.isActive &&
                                  (timelineItem.createdAt ?? "").isNotEmpty)
                                Text(
                                  timelineItem.createdAt!,
                                  style: AppStyles.text.medium(
                                    fSize: 12.sp,
                                    color: dateColor,
                                  ),
                                ),
                              if (timelineItem.isActive &&
                                  timelineItem.reason != null &&
                                  (timelineItem.reason ?? "").isNotEmpty)
                                Container(
                                  padding: .all(8.w),
                                  decoration: BoxDecoration(
                                    color: AppColors.lightGrey,
                                    borderRadius: .circular(6.r),
                                  ),
                                  child: Text(
                                    'Lý do: ${timelineItem.reason}',
                                    style: AppStyles.text.medium(
                                      fSize: 12.sp,
                                      color: AppColors.black3,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ],
    );
  }

  /// Danh sách các step có thể có trong timeline
  List<Map<String, dynamic>> get timelinesMapView {
    return [
      {
        'key': 0,
        'type': OrderTimelineProcessStatus.pending.toConstant,
        'label': OrderTimelineProcessStatus.pending.label,
      },
      {
        'key': 1,
        'type': OrderTimelineProcessStatus.processing.toConstant,
        'label': OrderTimelineProcessStatus.processing.label,
      },
      {
        'key': 2,
        'type': OrderTimelineProcessStatus.packed.toConstant,
        'label': OrderTimelineProcessStatus.packed.label,
      },
      {
        'key': 3,
        'type': OrderTimelineProcessStatus.dispatched.toConstant,
        'label': OrderTimelineProcessStatus.dispatched.label,
      },
      {
        'key': 4,
        'type': OrderTimelineProcessStatus.completed.toConstant,
        'label': OrderTimelineProcessStatus.completed.label,
      },
      {
        'key': 5,
        'type': OrderTimelineProcessStatus.cancelled.toConstant,
        'label': OrderTimelineProcessStatus.cancelled.label,
      },
    ];
  }

  /// Merge timeline thực tế từ order.timelines với timelinesMapView
  /// Hiển thị TẤT CẢ các step, step nào có data thì active và hiển thị createdAt
  List<TimelineEntity> get mergedTimelines {
    final actualTimelines = order.timelines ?? [];
    final stepMap = timelinesMapView;

    // Tạo map để lookup nhanh timeline thực tế theo type
    final actualTimelineByType = <String, Map<String, dynamic>>{};
    for (final timeline in actualTimelines) {
      if (timeline is! Map<String, dynamic>) continue;
      final type = timeline['type']?.toString() ?? '';
      if (type.isNotEmpty) {
        actualTimelineByType[type] = timeline;
      }
    }

    // Tạo danh sách TẤT CẢ các step, merge với data thực tế nếu có
    // Lưu ý: Step "Hủy đơn" (cancelled) chỉ hiển thị nếu có data thực tế
    final merged = <TimelineEntity>[];

    for (final step in stepMap) {
      final type = step['type']?.toString() ?? '';
      final actualTimeline = actualTimelineByType[type];

      // Parse và format createdAt nếu có
      String formattedCreatedAt = '';
      String? reason;
      bool isActive = false;
      BasePerson? createdBy;

      if (actualTimeline != null) {
        isActive = true;
        final createdAtStr = actualTimeline['createdAt']?.toString();
        if (createdAtStr != null && createdAtStr.isNotEmpty) {
          final dateTime = createdAtStr.parseFromServerTimezone();
          if (dateTime != null) {
            // Format: "HH:mm dd/MM/yyyy"
            formattedCreatedAt = dateTime.csToString('HH:mm dd/MM/yyyy');
          } else {
            formattedCreatedAt = createdAtStr;
          }
        }
        reason = actualTimeline['reason']?.toString();

        // Parse createdBy từ detailJson nếu có
        final detailJson = actualTimeline['detailJson'];
        if (detailJson is Map<String, dynamic> &&
            detailJson['createdBy'] != null) {
          try {
            createdBy = BasePerson.fromMap(
              detailJson['createdBy'] as Map<String, dynamic>,
            );
          } catch (e) {
            // Ignore parse error, createdBy will remain null
          }
        }
      }

      // Đặc biệt: Step "Hủy đơn" (cancelled) chỉ hiển thị nếu có data
      final isCancelled =
          type == OrderTimelineProcessStatus.cancelled.toConstant;
      if (isCancelled && !isActive) {
        // Bỏ qua step cancelled nếu không có data
        continue;
      }

      // Thêm step vào danh sách với TimelineEntity record
      final stepKey = step['key'] as int;
      merged.add((
        index: stepKey,
        type: type,
        label: step['label'] as String,
        createdAt: formattedCreatedAt.isEmpty ? null : formattedCreatedAt,
        reason: reason,
        isActive: isActive,
        createdBy: createdBy,
      ));
    }

    // Kiểm tra xem đơn hàng có bị hủy không
    final cancelledType = OrderTimelineProcessStatus.cancelled.toConstant;
    final isOrderCancelled = actualTimelineByType.containsKey(cancelledType);

    // Nếu đơn hàng bị hủy, chỉ giữ lại các step đã active (đã xảy ra)
    if (isOrderCancelled) {
      return merged.where((item) => item.isActive).toList();
    }

    // Đã sort sẵn theo key trong timelinesMapView, không cần sort lại
    return merged;
  }
}
