import 'package:rxdart/rxdart.dart';
import 'package:zili_coffee/data/models/sevenue.dart';
import 'package:zili_coffee/data/repositories/base_repository.dart';

class RevenueRepository extends BaseRepository {
  final BehaviorSubject<RevenueByMonth> revenueByMonthSubject =
      BehaviorSubject<RevenueByMonth>.seeded(
        RevenueByMonth(
          month: DateTime.now().month.toString().padLeft(2, '0'),
          revenues: [
            RevenueByDay(date: 01, value: 10000.0, totalRevenue: 0),
            RevenueByDay(date: 02, value: 18000.0, totalRevenue: 0),
            RevenueByDay(date: 03, value: 12000.0, totalRevenue: 0),
            RevenueByDay(date: 04, value: 8000.0, totalRevenue: 0),
            RevenueByDay(date: 05, value: 10000.0, totalRevenue: 0),
            RevenueByDay(date: 06, value: 16000.0, totalRevenue: 0),
          ],
          stepRevenue: 5000,
          stepDate: 1,
        ),
      );

  final BehaviorSubject<(double, int)> revenueStatisticsOnWeek =
      BehaviorSubject<(double, int)>.seeded((0.0, 0));

  void setRevenueByMonth(RevenueByMonth data) {
    revenueByMonthSubject.sink.add(data);
  }

  void setRevenueByWeek(double revenue, int pendingCount) {
    revenueStatisticsOnWeek.sink.add((revenue, pendingCount));
  }

  @override
  Future<void> clean() async {}
}
