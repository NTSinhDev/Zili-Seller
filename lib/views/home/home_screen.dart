import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rxdart/rxdart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zili_coffee/bloc/app/app_cubit.dart';
import 'package:zili_coffee/bloc/product/product_cubit.dart';
import 'package:zili_coffee/data/models/review/rating.dart';
import 'package:zili_coffee/data/models/sevenue.dart';
import 'package:zili_coffee/data/network/network_url.dart';
import 'package:zili_coffee/data/repositories/product_repository.dart';
import 'package:zili_coffee/data/repositories/revenue_repository.dart';
import 'package:zili_coffee/di/dependency_injection.dart';
import 'package:zili_coffee/utils/helpers/permission_helper.dart';
import 'package:zili_coffee/utils/enums.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/extension/build_context.dart';
import 'package:zili_coffee/utils/widgets/widgets.dart';
import 'package:zili_coffee/views/auth/authentication/register/register_screen.dart';
import 'package:zili_coffee/views/module_common/avatar.dart';
import 'package:zili_coffee/views/customer/customer_screen.dart';
import 'package:zili_coffee/views/setting/setting/setting_screen.dart';

import '../../app/app_wireframe.dart';
import '../../bloc/company/company_cubit.dart';
import '../../bloc/warehouse/warehouse_cubit.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/warehouse_repository.dart';
import '../../utils/enums/warehouse_enum.dart';
import '../../utils/extension/num.dart';
import '../common/action_app_bar.dart';
import '../customer_groups/manage/customer_groups_screen.dart';
import '../order/manage/orders_management_screen.dart';
import '../product/raw_product_list/raw_product_list.dart';
import '../quote/manage_quotations/quotations_management_list.dart';
import '../quote/manage_quotations/quotations_management_screen.dart';
import '../product/company_product_list/product_list_screen.dart';
import '../warehouse/packing_slip_listview/packing_slip_listview.dart';
import '../warehouse/roasting_slip_listview/roasting_slip_listview.dart';
import '../warehouse/statistic/export_warehouse/export_warehouse_screen.dart';
import '../warehouse/statistic/packing_product/packing_product_screen.dart';
import '../warehouse/warehouse_entry/warehouse_entry_screen.dart';

part 'components/bottom_navbar.dart';
part 'components/sales_statistics_chart.dart';
part 'components/store_rating.dart';
part 'components/zili_featured_products.dart';
part 'components/main_screen.dart';
part 'components/state_connectivity.dart';
part 'components/functions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static String keyName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  // Data of screen
  late final PageController _pageController;
  int _pageIndex = 0;
  late final List<_TabConfig> _tabs;
  // BloCs
  final AppCubit _appCubit = di<AppCubit>();
  final WarehouseCubit _warehouseCubit = di<WarehouseCubit>();
  final CompanyCubit _companyCubit = di<CompanyCubit>();

  final WarehouseRepository _warehouseRepository = di<WarehouseRepository>();
  final AuthRepository _authRepository = di<AuthRepository>();

  RoastingSlipStatus? _roastingSlipStatus;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Build
    _pageController = PageController(initialPage: _pageIndex);
    _tabs = _buildTabs();
    _pageIndex = 0;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      FirebaseMessaging.instance
        ..onTokenRefresh.listen((token) {
          _appCubit.sendDeviceTokenToServer(token);
        })
        ..getInitialMessage().then((message) {
          if (message != null) {
            // final fcmType = message.data["type"] != null
            //     ? NotifyType.fromString(message.data["type"] as String)
            //     : null;
            // switch (fcmType) {
            //   case NotifyType.NEW_KYC:
            //   case NotifyType.UPDATE_KYC:
            //     _appRepository.changedPage(NavbarItems.userManagement);
            //     break;
            //   case NotifyType.NEW_DEPOSIT_USER:
            //   case NotifyType.NEW_WITHDRAW_USER:
            //     _appRepository.changedPage(NavbarItems.amountManagement);
            //     break;
            //   default:
            // }
          }
        });

      _fetchData();
    });
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      // handleFCMFromSQFLite();
    }
  }

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    _tabs = _buildTabs();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pageController.dispose();
    super.dispose();
  }

  PreferredSizeWidget? _appBar(BuildContext context) {
    if (_tabs.isEmpty) return null;

    final currentKey = _tabs[_pageIndex].navbarKey;
    if (currentKey == NavbarItems.home) {
      return AppBarWidget.greenAppBar(context);
    } else if (currentKey == NavbarItems.customer) {
      return AppBar(
        title: Text(
          'Khách hàng'.toUpperCase(),
          style: AppStyles.text.bold(fSize: 16.sp, color: AppColors.beige),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: AppColors.primary,
        systemOverlayStyle: ThemeApp.systemDark,
        actions: AppBarActions.build([
          if (PermissionHelper.create(AbilitySubject.customerGroupManagement))
            AppBarActionModel(
              icon: Icons.group,
              onTap: () =>
                  context.navigator.pushNamed(CustomerGroupsScreen.keyName),
              color: AppColors.beige,
            ),
          if (PermissionHelper.create(AbilitySubject.customerManagement))
            AppBarActionModel(
              icon: Icons.person_add_alt_1_rounded,
              onTap: () => AppWireFrame.navigateToAddCustomer(context),
              color: AppColors.beige,
            ),
        ]),
      );
    } else if (currentKey == .orders) {
      return AppBar(
        title: Text(
          'Đơn hàng'.toUpperCase(),
          style: AppStyles.text.bold(fSize: 16.sp, color: AppColors.beige),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: AppColors.primary,
        systemOverlayStyle: ThemeApp.systemDark,
        actions: PermissionHelper.create(AbilitySubject.orderManagement)
            ? AppBarActions.build([
                if (_authRepository.currentAuth?.isShowQuoteOnOrder ?? false)
                  AppBarActionModel(
                    icon: Icons.list_alt,
                    onTap: () => context.navigator.pushNamed(
                      QuotationsManagementScreen.keyName,
                    ),
                    color: AppColors.beige,
                  ),
                AppBarActionModel(
                  icon: Icons.add_box,
                  onTap: () => AppWireFrame.navigateToOrderCreation(context),
                  color: AppColors.beige,
                ),
              ])
            : null,
      );
    } else if (currentKey == .quotations) {
      return AppBar(
        title: Text(
          'Phiếu báo giá'.toUpperCase(),
          style: AppStyles.text.bold(fSize: 16.sp, color: AppColors.beige),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: AppColors.primary,
        systemOverlayStyle: ThemeApp.systemDark,
        actions: PermissionHelper.create(AbilitySubject.quotationManagement)
            ? AppBarActions.build([
                AppBarActionModel(
                  icon: Icons.post_add,
                  onTap: () =>
                      AppWireFrame.navigateToQuotationCreation(context),
                  color: AppColors.beige,
                ),
              ])
            : null,
      );
    } else if (currentKey == NavbarItems.products) {
      return AppBar(
        title: Text(
          'Sản phẩm'.toUpperCase(),
          style: AppStyles.text.bold(fSize: 16.sp, color: AppColors.beige),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: AppColors.primary,
        systemOverlayStyle: ThemeApp.systemDark,
      );
    } else if (currentKey == NavbarItems.warehouse) {
      return AppBar(
        title: Text(
          'Kho'.toUpperCase(),
          style: AppStyles.text.bold(fSize: 16.sp, color: AppColors.beige),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: AppColors.primary,
        systemOverlayStyle: ThemeApp.systemDark,
      );
    } else if (currentKey == .roastingSlip) {
      return AppBar(
        title: Text(
          'Phiếu rang'.toUpperCase(),
          style: AppStyles.text.bold(fSize: 16.sp, color: AppColors.beige),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: AppColors.primary,
        systemOverlayStyle: ThemeApp.systemDark,
      );
    } else if (currentKey == .packingSlip) {
      return AppBar(
        title: Text(
          'Phiếu đóng gói'.toUpperCase(),
          style: AppStyles.text.bold(fSize: 16.sp, color: AppColors.beige),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: AppColors.primary,
        systemOverlayStyle: ThemeApp.systemDark,
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) _exitApp(context);
      },
      child: Scaffold(
        appBar: _appBar(context),
        body: SizedBox(
          width: Spaces.screenWidth(context),
          height: Spaces.screenHeight(context),
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: _buildTabs()
                .map((tab) => KeepAlivePageWidget(page: tab.page))
                .toList(),
          ),
        ),
        bottomNavigationBar: _BottomNavbar(
          items: _tabs,
          currentIndex: _pageIndex,
          onChangePage: _onChangePage,
        ),
        //   floatingActionButton:
        //       _tabs.isNotEmpty &&
        //           _tabs[_pageIndex].navbarKey == NavbarItems.products
        //       ? StreamBuilder<bool>(
        //           stream: _productRepository.actionType,
        //           builder: (context, snapshot) {
        //             bool isRemoveAction = snapshot.data ?? false;
        //             return FloatingActionButton(
        //               onPressed: () {},
        //               splashColor: AppColors.beige.withValues(alpha: 0.2),
        //               backgroundColor: AppColors.primary,
        //               child: Icon(!isRemoveAction ? Icons.add : Icons.delete),
        //             );
        //           },
        //         )
        //       : null,
      ),
    );
  }

  void _onChangePage(int pageIndex) {
    if (pageIndex < 0 || pageIndex >= _tabs.length) return;
    setState(() => _pageIndex = pageIndex);
    _pageController.jumpToPage(pageIndex);
  }

  List<_TabConfig> _buildTabs() {
    final tabs = <_TabConfig>[];
    // 1. Home / Dashboard
    // include statistics chart and new orders counter
    // show only if user is not technical staff
    if (PermissionHelper.manage(AbilitySubject.dashboard)) {
      // Dashboard for :
      if (_authRepository.currentAuth?.isTechnicalStaff ?? false) {
        if ((_authRepository.currentAuth?.isExportedWarehouseStaff ?? false) &&
            PermissionHelper.view(AbilitySubject.roastingSlipManagement)) {
          tabs.add(
            _TabConfig(
              navbarKey: .home,
              iconRoute: AssetIcons.iHomeSvg,
              label: 'Trang chủ',
              page: ExportedWarehouseScreen(
                changePageCallback: (pageIndex, status) {
                  _roastingSlipStatus = status;
                  _onChangePage(pageIndex);
                },
              ),
            ),
          );
        } else if ((_authRepository.currentAuth?.isPackingStaff ?? false) &&
            PermissionHelper.view(AbilitySubject.packagingManagement)) {
          tabs.add(
            _TabConfig(
              navbarKey: .home,
              iconRoute: AssetIcons.iHomeSvg,
              label: 'Trang chủ',
              page: PackingProductScreen(
                changePageCallback: (pageIndex, status) {
                  _roastingSlipStatus = status;
                  _onChangePage(pageIndex);
                },
              ),
            ),
          );
        }
      } else {
        tabs.add(
          const _TabConfig(
            navbarKey: NavbarItems.home,
            iconRoute: AssetIcons.iHomeSvg,
            label: 'Trang chủ',
            page: _MainScreen(),
          ),
        );
      }
    }

    // 2. Customer
    // show only if user has permission to view customers
    if (PermissionHelper.view(AbilitySubject.customers)) {
      tabs.add(
        _TabConfig(
          navbarKey: NavbarItems.customer,
          iconRoute: AppConstant.svgs.icCustomer,
          label: 'Khách hàng',
          page: const CustomerScreen(),
        ),
      );
    }

    // 3. Warehouse
    // show only if user has permission to view warehouses
    // if user is technical staff, show roasting slip and packing slip
    // if user is not technical staff, show warehouse entry
    if (PermissionHelper.view(AbilitySubject.warehouses)) {
      if ((_authRepository.currentAuth?.isTechnicalStaff ?? false)) {
        if (PermissionHelper.view(AbilitySubject.roastingSlipManagement)) {
          tabs.add(
            _TabConfig(
              navbarKey: .roastingSlip,
              iconRoute: AssetIcons.iGreenBeansSvg,
              label: 'Phiếu rang',
              page: RoastingSlipListView(status: _roastingSlipStatus),
              counter: _warehouseRepository.newRoastingSlipsCounter.stream,
            ),
          );
        }
        if (PermissionHelper.view(AbilitySubject.packagingManagement)) {
          tabs.add(
            _TabConfig(
              navbarKey: .packingSlip,
              iconRoute: AssetIcons.iWarehouseManagementSvg,
              label: 'Đóng gói',
              page: const PackingSlipListView(),
              counter: _warehouseRepository.newPackingSlipsCounter.stream,
            ),
          );
        }
      } else {
        final combinedCounter =
            CombineLatestStream.list<int>([
                  if (PermissionHelper.view(
                    AbilitySubject.roastingSlipManagement,
                  ))
                    _warehouseRepository.newRoastingSlipsCounter.stream,
                  if (PermissionHelper.view(AbilitySubject.packagingManagement))
                    _warehouseRepository.newPackingSlipsCounter.stream,
                ])
                .map(
                  (values) => values.fold<int>(0, (sum, value) => sum + value),
                )
                .shareValueSeeded(
                  ((PermissionHelper.view(
                            AbilitySubject.roastingSlipManagement,
                          ))
                          ? _warehouseRepository
                                    .newRoastingSlipsCounter
                                    .valueOrNull ??
                                0
                          : 0) +
                      (PermissionHelper.view(AbilitySubject.packagingManagement)
                          ? _warehouseRepository
                                    .newPackingSlipsCounter
                                    .valueOrNull ??
                                0
                          : 0),
                );

        tabs.add(
          _TabConfig(
            navbarKey: (_authRepository.currentAuth?.isTechnicalStaff ?? false)
                ? .home
                : .warehouse,
            iconRoute: (_authRepository.currentAuth?.isTechnicalStaff ?? false)
                ? AssetIcons.iHomeSvg
                : AssetIcons.iWarehouseManagementSvg,
            label: 'Kho',
            page: const WarehouseEntryScreen(),
            counter: combinedCounter,
          ),
        );
      }
    }

    // 4. Orders
    // show only if user has permission to view orders
    // if user is sales, show quotations
    if (PermissionHelper.view(AbilitySubject.orders)) {
      tabs.add(
        const _TabConfig(
          navbarKey: NavbarItems.orders,
          iconRoute: AssetIcons.iOrderManagementSvg,
          label: 'Đơn hàng',
          page: OrdersManagementScreen(),
        ),
      );
      if (PermissionHelper.view(AbilitySubject.quotationManagement) &&
          (_authRepository.currentAuth?.isSales ?? false)) {
        tabs.add(
          const _TabConfig(
            navbarKey: NavbarItems.quotations,
            iconRoute: AssetIcons.iQuotationSvg,
            label: 'Báo giá',
            page: QuotationsManagementView(),
          ),
        );
      }
    }

    // 5. Products
    // show only if user has permission to view products
    // if user is sales, show product list
    // if user is not sales, show raw product list
    if (PermissionHelper.view(AbilitySubject.productManagement)) {
      tabs.add(
        const _TabConfig(
          navbarKey: NavbarItems.products,
          iconRoute: AssetIcons.iProductManagementSvg,
          label: 'Sản phẩm',
          page: ProductListScreen(),
        ),
      );
    } else if (PermissionHelper.view(AbilitySubject.products)) {
      tabs.add(
        const _TabConfig(
          navbarKey: NavbarItems.products,
          iconRoute: AssetIcons.iProductManagementSvg,
          label: 'Sản phẩm',
          page: RawProductList(),
        ),
      );
    }

    // 6. Setting
    // show only if user has permission to view setting
    // if user is not technical staff, show setting
    if (PermissionHelper.view(AbilitySubject.auth) || tabs.isNotEmpty) {
      tabs.add(
        const _TabConfig(
          navbarKey: NavbarItems.setting,
          iconRoute: AssetIcons.iSettingSvg,
          label: 'Thiết lập',
          page: SettingScreen(),
        ),
      );
    }

    // Nếu không có quyền nào, fallback render Setting để tránh crash
    if (tabs.isEmpty) {
      tabs.add(
        const _TabConfig(
          navbarKey: NavbarItems.setting,
          iconRoute: AssetIcons.iSettingSvg,
          label: 'Thiết lập',
          page: SettingScreen(),
        ),
      );
    }
    return tabs;
  }

  void _fetchData() async {
    Future.wait([
      _warehouseCubit.getTotalOfNewRequestSlip(),
      _companyCubit.getRevenuesChartOnMonth(),
    ]);
  }
}

class _TabConfig {
  final NavbarItems navbarKey;
  final String iconRoute;
  final String label;
  final Widget page;
  final ValueStream<int>? counter;

  const _TabConfig({
    required this.navbarKey,
    required this.iconRoute,
    required this.label,
    required this.page,
    this.counter,
  });
}
