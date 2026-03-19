import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/bloc/order/order_cubit.dart';
import 'package:zili_coffee/data/models/order/order.dart';
import 'package:zili_coffee/data/repositories/order_repository.dart';
import 'package:zili_coffee/di/dependency_injection.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/extension/extension.dart';
import 'package:zili_coffee/utils/widgets/widgets.dart';
import 'package:zili_coffee/views/order/order_details/order_details_screen.dart';
import 'package:zili_coffee/views/order/orders_history/orders_history_screen.dart';

part 'components/listview_loading.dart';
part 'components/list_order.dart';
part 'components/order_item.dart';
part 'components/screen_appbar.dart';
part 'components/search_bar.dart';

// class OrdersManagementScreen extends StatefulWidget {
//   final bool? reverseToolbar;
//   const OrdersManagementScreen({super.key, this.reverseToolbar});

//   static const String keyName = "/orders-management";

//   @override
//   State<OrdersManagementScreen> createState() => _OrdersManagementScreenState();
// }

// class _OrdersManagementScreenState extends State<OrdersManagementScreen> {
//   final OrderRepository _orderRepository = di<OrderRepository>();
//   final AuthRepository _authRepository = di<AuthRepository>();
//   final OrderCubit _orderCubit = di<OrderCubit>();
//   late final String? _userID;
//   bool _loading = true; // to create a UI shimmer while get data from network
//   // bool _loadmoring = false;
//   bool _hideShadowSearchBar = false;

//   @override
//   void initState() {
//     super.initState();
//     _userID = _authRepository.currentUser?.id;
//     if (_orderRepository.orders.isEmpty && _userID != null) {
//       _orderCubit.getAllOrders(userID: _userID!);
//     }
//     Future.delayed(
//       const Duration(seconds: 2),
//       () {
//         setState(() {
//           _loading = false;
//         });
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: ThemeApp.systemLight,
//       child: Scaffold(
//         body: NotificationListener<ScrollNotification>(
//           onNotification: _listenScrollToLoadmore,
//           child: RefreshIndicator(
//             onRefresh: _onRefreshScreen,
//             color: AppColors.primary,
//             child: Scrollbar(
//               radius: Radius.circular(4.r),
//               child: CustomScrollView(
//                 slivers: <Widget>[
//                   _ScreenSliverAppbar(
//                     hideShadowSearchBar: _hideShadowSearchBar,
//                     searchController: _searchController,
//                   ),
//                   SliverToBoxAdapter(
//                     child: _ListOrder(isLoading: _loading),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Future _onRefreshScreen() async {
//     // loading = true;
//     // setState(() {});
//     // orderCubit.getAllOrders(userID: userID!).then((_) {
//     //   setState(() => loading = false);
//     // });
//   }

//   bool _listenScrollToLoadmore(ScrollNotification scrollNotification) {
//     final ScrollMetrics metrics = scrollNotification.metrics;
//     if (metrics.pixels > 36.h) {
//       if (!_hideShadowSearchBar) {
//         setState(() {
//           _hideShadowSearchBar = true;
//         });
//       }
//     } else {
//       if (_hideShadowSearchBar) {
//         setState(() {
//           _hideShadowSearchBar = false;
//         });
//       }
//     }
//     // if (metrics.pixels > (metrics.maxScrollExtent - 68.h)) {
//     //   if (loadmoring) return true;
//     //   if (orderRepository.orders.length >= orderRepository.totalOrders) {
//     //     return true;
//     //   }
//     //   setState(() => loadmoring = true);
//     //   orderCubit.getAllOrders(userID: userID!, paging: true).then((_) {
//     //     setState(() => loadmoring = false);
//     //   });
//     // }

//     return true;
//   }
// }

class OrdersManagementScreen extends StatefulWidget {
  final bool? reverseToolbar;
  const OrdersManagementScreen({super.key, this.reverseToolbar});

  static const String keyName = "/orders-management";

  @override
  State<OrdersManagementScreen> createState() => _OrdersManagementScreenState();
}

class _OrdersManagementScreenState extends State<OrdersManagementScreen> {
  final OrderRepository _orderRepository = di<OrderRepository>();
  final OrderCubit _orderCubit = di<OrderCubit>();
  final TextEditingController _searchController = TextEditingController();
  
  bool _loading = true; // to create a UI shimmer while get data from network
  bool _isLoadMore = false;
  bool _hideShadowSearchBar = false;
  String? _currentKeyword;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadInitialData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadInitialData() {
    _orderCubit.getSellerOrders(
      keyword: null,
      event: "",
    );
    Future.delayed(
      const Duration(seconds: 1),
      () {
        if (mounted) {
          setState(() {
            _loading = false;
          });
        }
      },
    );
  }

  void _onSearchChanged() {
    EasyDebounce.cancel('orderSearch');
    EasyDebounce.debounce(
      'orderSearch',
      const Duration(milliseconds: 500),
      () {
        final keyword = _searchController.text.trim();
        if (keyword != _currentKeyword) {
          setState(() {
            _currentKeyword = keyword.isEmpty ? null : keyword;
          });
          _orderCubit.getSellerOrders(
            keyword: keyword.isEmpty ? null : keyword,
            event: "search",
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: ThemeApp.systemLight,
      child: Scaffold(
        body: BlocListener<OrderCubit, OrderState>(
          bloc: _orderCubit,
          listener: (context, state) {
            if (state is OrderErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error?.toString() ?? 'Có lỗi xảy ra'),
                  backgroundColor: AppColors.red,
                ),
              );
            }
          },
          child: NotificationListener<ScrollNotification>(
            onNotification: _listenScrollToLoadmore,
            child: RefreshIndicator(
              onRefresh: _onRefreshScreen,
              color: AppColors.primary,
              child: Scrollbar(
                radius: Radius.circular(4.r),
              child: CustomScrollView(
                slivers: <Widget>[
                  _ScreenSliverAppbar(
                    hideShadowSearchBar: _hideShadowSearchBar,
                    searchController: _searchController,
                  ),
                  _ListOrder(isLoading: _loading),
                ],
              ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future _onRefreshScreen() async {
    if (_isLoadMore) return;
    await _orderCubit.getSellerOrders(
      keyword: _currentKeyword,
      event: "refresh",
    );
  }

  bool _listenScrollToLoadmore(ScrollNotification scrollNotification) {
    final ScrollMetrics metrics = scrollNotification.metrics;
    if (metrics.pixels > 36.h) {
      if (!_hideShadowSearchBar) {
        setState(() {
          _hideShadowSearchBar = true;
        });
      }
    } else {
      if (_hideShadowSearchBar) {
        setState(() {
          _hideShadowSearchBar = false;
        });
      }
    }
    
    // Load more when scroll near bottom
    if (metrics.pixels > (metrics.maxScrollExtent - 200.h)) {
      if (_isLoadMore) return true;
      final orders = _orderRepository.sellerOrders.valueOrNull;
      if (orders != null) {
        final records = orders.length;
        final maxRecords = _orderRepository.totalSellerOrders;
        if (maxRecords == records) return true;
      }
      _isLoadMore = true;
      if (mounted) setState(() {});
      _orderCubit.loadMoreSellerOrders(
        keyword: _currentKeyword,
      ).then((_) {
        _isLoadMore = false;
        if (mounted) setState(() {});
      });
    }

    return true;
  }
}
