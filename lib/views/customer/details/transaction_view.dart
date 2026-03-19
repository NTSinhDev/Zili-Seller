// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/data/models/order/order.dart';
import 'package:zili_coffee/utils/enums/customer_enum.dart';
import 'package:zili_coffee/views/common/order_card.dart';

import '../../../app/app_wireframe.dart';
import '../../../bloc/customer/customer_cubit.dart';
import '../../../data/repositories/customer_repository.dart';
import '../../../di/dependency_injection.dart';
import '../../../res/res.dart';
import '../../../utils/widgets/widgets.dart';
import '../../common/empty_view_state.dart';
import '../../common/shimmer_view.dart';

class TransactionView extends StatefulWidget {
  final CustomerDetailsScreenTab tabIndex;
  final String customerId;
  const TransactionView({
    super.key,
    required this.tabIndex,
    required this.customerId,
  });

  static CustomerDetailsScreenTab tab = CustomerDetailsScreenTab.transaction;

  @override
  State<TransactionView> createState() => _TransactionViewState();
}

class _TransactionViewState extends State<TransactionView> {
  final CustomerCubit _customerCubit = di<CustomerCubit>();
  final CustomerRepository _customerRepository = di<CustomerRepository>();
  bool _isLoadMore = false;

  @override
  void initState() {
    super.initState();
    _customerCubit.getCustomerTransactions(widget.customerId);
  }

  @override
  void dispose() {
    _customerRepository.customerTransactions.drain(null);
    _customerRepository.customerTransactions.sink.add([]);
    _customerRepository.totalCustomerTransactions = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: widget.tabIndex != TransactionView.tab,
      child: StreamBuilder<List<Order>>(
        stream: _customerRepository.customerTransactions.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == .waiting) {
            return const ShimmerView(type: .loadingIndicatorAtHead);
          }

          final orders = snapshot.data ?? [];
          if (orders.isEmpty) {
            return const EmptyViewState(message: 'Chưa có giao dịch nào');
          }

          return CommonLoadMoreRefreshWrapper(
            onRefresh: _onRefresh,
            onLoadMore: _onLoadMore,
            minusMaxScrollValue: 100.h,
            child: ListView.separated(
              padding: .only(top: 4.h),
              separatorBuilder: (context, index) => SizedBox(height: 4.h),
              itemCount: orders.length + 2,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Container(
                    padding: .symmetric(horizontal: 16.w, vertical: 12.h),
                    color: AppColors.background,
                    child: Align(
                      alignment: .centerLeft,
                      child: Text(
                        '${_customerRepository.totalCustomerTransactions} giao dịch',
                        style: AppStyles.text.medium(
                          fSize: 14.sp,
                          color: AppColors.grey84,
                        ),
                      ),
                    ),
                  );
                }

                if (index == orders.length + 1) {
                  final total = _customerRepository.totalCustomerTransactions;
                  if (orders.length < total) {
                    return const ShimmerView(type: .onlyLoadingIndicator);
                  }
                  return Padding(
                    padding: .all(20.w),
                    child: Center(
                      child: Text(
                        'Đã hiển thị tất cả giao dịch',
                        style: AppStyles.text.medium(
                          fSize: 14.sp,
                          color: AppColors.grey84,
                        ),
                      ),
                    ),
                  );
                }

                final order = orders[index - 1];
                return OrderCard(
                  order: order,
                  onTap: () => AppWireFrame.navigateToOrderDetails(
                    context,
                    code: order.code ?? order.orderCode ?? "",
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> _onRefresh() async {
    if (_isLoadMore) return;
    await _customerCubit.getCustomerTransactions(widget.customerId);
    await Future.delayed(Durations.medium4);
  }

  bool _onLoadMore() {
    if (_isLoadMore) return true;
    final current = _customerRepository.customerTransactions.valueOrNull ?? [];
    final total = _customerRepository.totalCustomerTransactions;
    if (current.length >= total) return true;
    _isLoadMore = true;
    final future = _customerCubit.loadMoreCustomerTransactions(
      widget.customerId,
      offset: current.length,
    );
    future.whenComplete(() {
      _isLoadMore = false;
    });
    return true;
  }
}
