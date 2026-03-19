// ignore_for_file: public_member_api_docs, sort_constructors_first
part of '../home_screen.dart';

class _RevenueStatisticsChart extends StatelessWidget {
  const _RevenueStatisticsChart();

  @override
  Widget build(BuildContext context) {
    final RevenueRepository revenueRepository = di<RevenueRepository>();
    return SizedBox(
      width: Spaces.screenWidth(context),
      height: Spaces.screenWidth(context),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              AssetImages.bgStatisticChartJpg,
              width: Spaces.screenWidth(context),
              height: Spaces.screenWidth(context),
              fit: BoxFit.cover,
            ),
          ),
          // Overlay
          Positioned.fill(
            child: Container(
              width: Spaces.screenWidth(context),
              height: Spaces.screenWidth(context),
              color: AppColors.black24.withValues(alpha: 0.5),
            ),
          ),
          Positioned(
            left: 20.w,
            top: 20.h,
            child: Container(
              padding: .symmetric(vertical: 16.h, horizontal: 10.w),
              width: Spaces.screenWidth(context) - 40.w,
              height: Spaces.screenWidth(context) - 40.h,
              alignment: .center,
              decoration: BoxDecoration(
                borderRadius: .circular(10.r),
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withValues(alpha: 0.1),
                    offset: const Offset(1, 1),
                    blurRadius: 4.r,
                  ),
                ],
              ),
              child: StreamBuilder<RevenueByMonth>(
                stream: revenueRepository.revenueByMonthSubject.stream,
                builder: (context, asyncSnapshot) {
                  final data =
                      asyncSnapshot.data ??
                      RevenueByMonth(
                        month: DateTime.now().month.toString().padLeft(2, '0'),
                        revenues: [],
                        stepRevenue: 1,
                        stepDate: 1,
                      );
                  return Column(
                    mainAxisAlignment: .start,
                    crossAxisAlignment: .start,
                    children: [
                      Row(
                        mainAxisAlignment: .spaceBetween,
                        crossAxisAlignment: .center,
                        children: [
                          Text(
                            "Doanh thu - tháng ${data.month}".toUpperCase(),
                            style: AppStyles.text.medium(
                              fSize: 14.sp,
                              color: AppColors.grey,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: .end,
                            crossAxisAlignment: .center,
                            mainAxisSize: .min,
                            children: [
                              Text(
                                data.totalRevenue.toUSD,
                                style: AppStyles.text.bold(fSize: 14.sp),
                              ),
                              width(width: 6),
                              CustomIconStyle(
                                icon: CupertinoIcons.chevron_forward,
                                style: AppStyles.text.medium(
                                  fSize: 15.sp,
                                  color: AppColors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      height(height: 20),
                      Expanded(child: _revenueChart(data)),
                      height(height: 20),
                      StreamBuilder<(double, int)>(
                        stream:
                            revenueRepository.revenueStatisticsOnWeek.stream,
                        builder: (context, asyncSnapshot) {
                          final data = asyncSnapshot.data ?? (0.0, 0);
                          return ColumnWidget(
                            mainAxisAlignment: .start,
                            crossAxisAlignment: .start,
                            children: [
                              Text(
                                "Tuần này:",
                                style: AppStyles.text.medium(
                                  fSize: 14.sp,
                                  color: AppColors.grey,
                                ),
                              ),
                              height(height: 8),
                              Container(
                                padding: .symmetric(horizontal: 12.w),
                                child: Row(
                                  mainAxisAlignment: .spaceBetween,
                                  crossAxisAlignment: .center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: .start,
                                      crossAxisAlignment: .center,
                                      children: [
                                        Container(
                                          width: 6.w,
                                          height: 6.w,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        width(width: 4),
                                        Text(
                                          "Doanh thu:",
                                          style: AppStyles.text.medium(
                                            fSize: 12.sp,
                                          ),
                                        ),
                                        width(width: 8),
                                        Text(
                                          data.$1.toPrice(),
                                          style: AppStyles.text.semiBold(
                                            fSize: 12.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: .start,
                                      crossAxisAlignment: .center,
                                      children: [
                                        Container(
                                          width: 6.w,
                                          height: 6.w,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppColors.yellow,
                                          ),
                                        ),
                                        width(width: 4),
                                        Text(
                                          "Đơn hàng:",
                                          style: AppStyles.text.medium(
                                            fSize: 12.sp,
                                          ),
                                        ),
                                        width(width: 8),
                                        Text(
                                          "${data.$2} đơn",
                                          style: AppStyles.text.semiBold(
                                            fSize: 12.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  SfCartesianChart _revenueChart(RevenueByMonth data) {
    return SfCartesianChart(
      margin: .only(right: 12.w),
      primaryXAxis: NumericAxis(
        axisLine: const AxisLine(width: 0),
        majorTickLines: const MajorTickLines(color: Colors.transparent),
        labelPosition: .outside,
        interval: data.stepDate.toDouble(),
        labelStyle: AppStyles.text.medium(fSize: 12.sp, color: AppColors.grey),
        axisLabelFormatter: (AxisLabelRenderDetails details) =>
            _axisLabelFormatter(details, data.month),
      ),
      primaryYAxis: NumericAxis(
        axisLine: const AxisLine(width: 0),
        majorTickLines: const MajorTickLines(color: Colors.transparent),
        labelPosition: .outside,
        interval: data.stepRevenue.toDouble(),
        labelStyle: AppStyles.text.medium(fSize: 12.sp, color: AppColors.grey),
        axisLabelFormatter: (d) => _axisLabelFormatterY(d, data.maxRevenue),
      ),
      borderWidth: 0,
      series: <CartesianSeries>[
        LineSeries<RevenueByDay, int>(
          dataSource: data.revenues,
          color: Colors.blue,
          markerSettings: const MarkerSettings(
            isVisible: true,
            width: 6,
            height: 6,
          ),
          width: 1.3,
          xValueMapper: (RevenueByDay sales, _) => sales.date,
          yValueMapper: (RevenueByDay sales, _) => sales.value,
        ),
      ],
    );
  }

  ChartAxisLabel _axisLabelFormatterY(
    AxisLabelRenderDetails details,
    double maxY,
  ) {
    final numValue = double.tryParse(details.text) ?? 0;

    if ((maxY) > 1000000) {
      return ChartAxisLabel(
        '${(numValue / 1000000).toUSD}M',
        details.textStyle,
      );
    }
    return ChartAxisLabel(numValue.toUSD, details.textStyle);
  }

  /// Format axis label: day/month
  /// Ví dụ: day = 13, month = "09" → "13/09"
  /// day = 5, month = "01" → "05/01"
  ChartAxisLabel _axisLabelFormatter(
    AxisLabelRenderDetails details,
    String month,
  ) {
    // details.text là day (1-31) dạng string
    final dayStr = details.text;
    // Format day với leading zero nếu < 10, giữ nguyên nếu >= 10
    final formattedDay = dayStr.length == 1 ? "0$dayStr" : dayStr;
    // Format: day/month
    return ChartAxisLabel("$formattedDay/$month", details.textStyle);
  }
}
