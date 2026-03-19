// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/data/models/user/debt.dart';
import 'package:zili_coffee/utils/enums/customer_enum.dart';

import '../../../bloc/customer/customer_cubit.dart';
import '../../../data/repositories/customer_repository.dart';
import '../../../di/dependency_injection.dart';
import '../../../res/res.dart';
import '../../../utils/widgets/widgets.dart';
import '../../common/empty_view_state.dart';
import '../../common/shimmer_view.dart';
import 'components/debt_card.dart';

class DebtView extends StatefulWidget {
  final CustomerDetailsScreenTab tabIndex;
  final String customerId;
  const DebtView({super.key, required this.tabIndex, required this.customerId});

  static CustomerDetailsScreenTab tab = CustomerDetailsScreenTab.debt;

  @override
  State<DebtView> createState() => _DebtViewState();
}

class _DebtViewState extends State<DebtView> {
  final CustomerCubit _customerCubit = di<CustomerCubit>();
  final CustomerRepository _customerRepository = di<CustomerRepository>();
  bool _isLoadMore = false;

  @override
  void initState() {
    super.initState();
    _customerCubit.getCustomerDebts(widget.customerId);
  }

  @override
  void dispose() {
    _customerRepository.customerDebts.drain(null);
    _customerRepository.customerDebts.sink.add([]);
    _customerRepository.totalCustomerDebts = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: widget.tabIndex != DebtView.tab,
      child: StreamBuilder<List<Debt>>(
        stream: _customerRepository.customerDebts.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == .waiting) {
            return const ShimmerView(type: .loadingIndicatorAtHead);
          }

          final debts = snapshot.data ?? [];
          if (debts.isEmpty) {
            return const EmptyViewState(message: 'Chưa có công nợ nào');
          }

          return CommonLoadMoreRefreshWrapper(
            onRefresh: _onRefresh,
            onLoadMore: _onLoadMore,
            minusMaxScrollValue: 100.h,
            child: ListView.separated(
              padding: .only(top: 4.h),
              separatorBuilder: (context, index) =>
                  index == 0 ? const SizedBox.shrink() : SizedBox(height: 8.h),
              itemCount: debts.length + 2,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Container(
                    padding: .symmetric(horizontal: 16.w, vertical: 12.h),
                    color: AppColors.background,
                    child: Align(
                      alignment: .centerLeft,
                      child: Text(
                        '${_customerRepository.totalCustomerDebts} phiếu đối soát',
                        style: AppStyles.text.medium(
                          fSize: 14.sp,
                          color: AppColors.grey84,
                        ),
                      ),
                    ),
                  );
                }

                if (index == debts.length + 1) {
                  final total = _customerRepository.totalCustomerDebts;
                  if (debts.length < total) {
                    return const ShimmerView(type: .onlyLoadingIndicator);
                  }
                  return Padding(
                    padding: .all(20.w),
                    child: Center(
                      child: Text(
                        'Đã hiển thị tất cả phiếu đối soát',
                        style: AppStyles.text.medium(
                          fSize: 14.sp,
                          color: AppColors.grey84,
                        ),
                      ),
                    ),
                  );
                }

                final debt = debts[index - 1];
                return DebtCard(debt: debt);
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> _onRefresh() async {
    if (_isLoadMore) return;
    await _customerCubit.getCustomerDebts(widget.customerId);
    await Future.delayed(Durations.medium4);
  }

  bool _onLoadMore() {
    if (_isLoadMore) return true;
    final current = _customerRepository.customerDebts.valueOrNull ?? [];
    final total = _customerRepository.totalCustomerDebts;
    if (current.length >= total) return true;
    _isLoadMore = true;
    final future = _customerCubit.loadMoreCustomerDebts(
      widget.customerId,
      offset: current.length,
    );
    future.whenComplete(() {
      _isLoadMore = false;
    });
    return true;
  }
}
