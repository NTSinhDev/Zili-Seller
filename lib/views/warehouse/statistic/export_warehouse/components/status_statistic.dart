part of '../export_warehouse_screen.dart';

class StatusStatisticItem {
  final Color theme;
  final String name;
  final int count;
  StatusStatisticItem(this.theme, this.name, this.count);
}

/// Widget thống kê số phiếu theo trạng thái
/// Dữ liệu đầu vào là list [StatusStatisticItem]
///
class StatusStatistic extends StatelessWidget {
  final List<StatusStatisticItem> list;
  final bool isLoadedState;
  const StatusStatistic({
    super.key,
    required this.list,
    required this.isLoadedState,
  });

  @override
  Widget build(BuildContext context) {
    return RowWidget(
      padding: .symmetric(horizontal: 20.w, vertical: 16.h),
      gap: 8.w,
      children: List.generate(list.length, (index) {
        if (isLoadedState) {
          return Expanded(
            child: Container(
              padding: .symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: list[index].theme.withValues(alpha: 0.1),
                borderRadius: .circular(16),
                border: .all(color: list[index].theme, width: 1),
              ),
              child: ColumnWidget(
                gap: 4.h,
                children: [
                  Text(
                    list[index].name,
                    style: AppStyles.text.semiBold(
                      fSize: 12.sp,
                      color: list[index].theme,
                    ),
                  ),
                  PlaceholderWidget(
                    width: 52,
                    height: 20,
                    condition: isLoadedState,
                    highlightColor: AppColors.greyFx,
                    // color: AppColors.greyFx,
                    child: Text(
                      list[index].count.toString(),
                      style: AppStyles.text.bold(
                        fSize: 20.sp,
                        color: list[index].theme,
                        height: 20 / 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return Expanded(
          child: Container(
            padding: .symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.white, 
              borderRadius: .circular(16),
            ),
            child: ColumnWidget(
              gap: 4.h,
              children: [
                PlaceholderWidget(
                  width: 80,
                  height: 14,
                  condition: false,
                  alphaValue: 0.4,
                  color: SystemColors.quarterWhite5,
                  highlightColor: SystemColors.quarterWhite50,
                  child: Text(
                    list[index].name,
                    style: AppStyles.text.semiBold(
                      fSize: 12.sp,
                      color: list[index].theme,
                    ),
                  ),
                ),
                PlaceholderWidget(
                  width: 40,
                  height: 20,
                  condition: false,
                  alphaValue: 0.4,
                  color: SystemColors.quarterWhite5,
                  highlightColor: SystemColors.quarterWhite50,
                  child: Text(
                    list[index].count.toString(),
                    style: AppStyles.text.bold(
                      fSize: 20.sp,
                      color: list[index].theme,
                      height: 20 / 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
