import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:zili_coffee/bloc/base_cubit.dart';
import 'package:zili_coffee/data/middlewares/middlewares.dart';
import 'package:zili_coffee/data/models/sevenue.dart';
import 'package:zili_coffee/data/network/network_response_state.dart';
import 'package:zili_coffee/data/repositories/revenue_repository.dart';
import 'package:zili_coffee/di/dependency_injection.dart';
import 'package:zili_coffee/utils/extension/date_time.dart';

import '../../data/models/order/order.dart';
import '../../utils/functions/base_functions.dart';

part 'company_state.dart';

class CompanyCubit extends BaseCubit<CompanyState> {
  CompanyCubit() : super(CompanyInitial());

  final _companyMiddleware = di<CompanyMiddleware>();
  final _orderMiddleware = di<OrderMiddleware>();
  final _revenueRepo = di<RevenueRepository>();

  /// Get revenues report for a date range
  ///
  /// API: GET /company/order-report/revenues
  /// Service: Core
  ///
  /// Parameters:
  /// - startDate: Start date in ISO format (e.g., "2026-01-01T00:00:00+07:00")
  /// - endDate: End date in ISO format (e.g., "2026-01-31T23:59:59+07:00")
  ///
  /// States:
  /// - LoadingCompanyState: Loading
  /// - LoadedCompanyState: Success with RevenueByMonth
  /// - FailedCompanyState: Error
  Future<void> getRevenuesChartOnMonth() async {
    final duration = kDebugMode ? const Duration(seconds: 3) : Duration.zero;
    await Future.delayed(duration, () async {
      final now = DateTime.now();
      final startDate = now.startOfMonth();
      final endDate = now.endOfMonth();
      final convertStartDate = startDate.toIso8601StringWithTimezone();
      final convertEndDate = endDate.toIso8601StringWithTimezone();

      final month = now.month;
      final result = await _companyMiddleware.getRevenues(
        month: month,
        startDate: convertStartDate,
        endDate: convertEndDate,
      );
      if (result is ResponseSuccessState<RevenueByMonth>) {
        _revenueRepo.setRevenueByMonth(result.responseData);
        Future.delayed(const Duration(seconds: 1), () {
          getRevenuesReportOnWeek();
        });
      }
    });
  }

  Future<void> getRevenuesReportOnWeek() async {
    final now = DateTime.now();
    final timeRange = getRangeOfTimeOption(.thisWeek);
    final startDate = timeRange.start;
    final endDate = now.endOfDate();
    final convertStartDate = startDate.toIso8601StringWithTimezone();
    final convertEndDate = endDate.toIso8601StringWithTimezone();

    final month = now.month;
    final result = await _companyMiddleware.getRevenues(
      month: month,
      startDate: convertStartDate,
      endDate: convertEndDate,
    );
    final pendingCount = await _orderMiddleware.getSellerOrders(
      createdAtFrom: convertStartDate,
      createdAtTo: convertEndDate,
    );
    if (result is ResponseSuccessState<RevenueByMonth> &&
        pendingCount is ResponseSuccessListState<List<Order>>) {
      _revenueRepo.setRevenueByWeek(
        result.responseData.totalRevenue.toDouble(),
        pendingCount.total,
      );
    }
  }
}
