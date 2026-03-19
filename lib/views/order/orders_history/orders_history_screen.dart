import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/extension/build_context.dart';
import 'package:zili_coffee/utils/extension/int.dart';
import 'package:zili_coffee/utils/widgets/widgets.dart';
import 'package:zili_coffee/views/order/order_details/order_details_screen.dart';
part 'components/input_order_id_field.dart';
part 'components/order_history_item.dart';
part 'components/order_status.dart';
part 'components/order_duration.dart';

class OrdersHistoryScreen extends StatefulWidget {
  const OrdersHistoryScreen({super.key});
  static const String keyName = "/orders-history";

  @override
  State<OrdersHistoryScreen> createState() => _OrdersHistoryScreenState();
}

class _OrdersHistoryScreenState extends State<OrdersHistoryScreen> {
  bool isSearchMode = false;
  final List<String> tabs = const ["Tất cả", "Hoàn thành", "Đã hủy"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget.darkAppBar(
        context,
        label: "Lịch sử đơn hàng",
        title: isSearchMode ? const _InputOrderIDField() : null,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.beige,
        elevation: 3,
        bottomPreferredHeight: 38.h,
        bottom: TabBarWidget(
          tabs: tabs,
          onChanged: () {},
          themeColor: AppColors.primary,
          height: 38.h,
        ),
        actions: [
          InkWell(
            onTap: () {
              setState(() {
                isSearchMode = !isSearchMode;
              });
            },
            splashColor: AppColors.primary,
            highlightColor: AppColors.primary,
            child: Container(
              padding: EdgeInsets.all(6.w),
              child: Icon(
                isSearchMode ? CupertinoIcons.xmark : CupertinoIcons.search,
              ),
            ),
          ),
          width(width: 20),
        ],
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: _listenScrollToLoadmore,
        child: RefreshIndicator(
          onRefresh: _onRefreshScreen,
          color: AppColors.primary,
          child: Scrollbar(
            radius: Radius.circular(4.r),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  height(height: 10.h),
                  const _OrderHistoryItem(),
                  const _OrderHistoryItem(isDone: false),
                  const _OrderHistoryItem(),
                  const _OrderHistoryItem(isDone: false),
                  const _OrderHistoryItem(),
                  const _OrderHistoryItem(),
                  const _OrderHistoryItem(),
                  const _OrderHistoryItem(),
                  height(height: 20.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future _onRefreshScreen() async {}

  bool _listenScrollToLoadmore(ScrollNotification scrollNotification) {
    // final ScrollMetrics metrics = scrollNotification.metrics;

    return true;
  }
}
