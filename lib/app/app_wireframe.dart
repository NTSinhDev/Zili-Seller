import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_native_splash/flutter_native_splash.dart'
    show FlutterNativeSplash;
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../views/address/add_address/add_address_screen.dart';
import '../../views/address/user_addresses_management/user_addresses_screen.dart';
import '../../views/auth/authentication/authentication_screen.dart';
import '../../views/auth/authentication/choose_region/choose_region_screen.dart';
import '../../views/auth/authentication/login/login_screen.dart';
import '../../views/auth/authentication/register/register_screen.dart';
import '../../views/auth/forgot_password/forgot_password_screen.dart';
import '../../views/blog/blogs/blogs_screen.dart';
import '../../views/cart/my_cart_screen.dart';
import '../../views/home/home_screen.dart';
import '../../views/notification/notification_screen.dart';
import '../../views/order/orders_history/orders_history_screen.dart';
// import '../../views/order/qr_code_scanner/qr_code_scanner_screen.dart';
import '../../views/payment/checkout/checkout_screen.dart';
import '../../views/payment/fill_info_payment/fill_info_payment_screen.dart';
import '../../views/product/product_detail/product_detail_screen.dart';
import '../../views/product/products/products_screen.dart';
import '../../views/product/products_by_lineages/products_by_lineages_screen.dart';
import '../../views/setting/change_information/change_information_screen.dart';
import '../../views/setting/change_password/change_password_screen.dart';
import '../bloc/address/address_cubit.dart';
import '../bloc/app/app_cubit.dart';
import '../bloc/collaborator/collaborator_cubit.dart';
import '../bloc/customer/customer_cubit.dart';
import '../bloc/payment/payment_cubit.dart';
import '../bloc/product/product_cubit.dart';
import '../data/dto/quotation/create_quotation.dart';
import '../data/models/address/address.dart';
import '../data/models/order/order_export.dart';
import '../data/models/product/product_variant.dart';
import '../data/models/quotation/quotation.dart';
import '../data/models/user/customer.dart';
import '../data/models/warehouse/packing_slip_item.dart';
import '../data/repositories/address_repository.dart';
import '../data/repositories/customer_repository.dart';
import '../data/repositories/order_repository.dart';
import '../data/repositories/payment_repository.dart';
import '../data/repositories/product_repository.dart';
import '../di/dependency_injection.dart';
import '../utils/enums.dart';
import '../utils/enums/customer_enum.dart';
import '../utils/enums/order_enum.dart';
import '../utils/enums/product_enum.dart';
import '../utils/enums/user_enum.dart';
import '../utils/extension/extension.dart';
import '../views/customer/config_customer_address/config_customer_address_screen.dart';
import '../views/customer/create/customer_create_screen.dart';
import '../views/customer/details/customer_details_screen.dart';
import '../views/customer_groups/create/create_screen.dart';
import '../views/customer_groups/details/customer_group_details_screen.dart';
import '../views/customer_groups/manage/customer_groups_screen.dart';
import '../views/loading/loading_screen.dart';
import '../views/order/add_new_product_service/add_new_product_service_screen.dart';
// import '../views/order/bar_code_scanner/bar_code_scanner_screen.dart';
import '../views/order/create_order/create_order_screen.dart';
import '../views/order/create_order/select_customers_screen.dart';
import '../views/order/create_order/select_products_screen.dart';
import '../views/order/details/order_detail_screen.dart';
import '../views/order/order_list/order_list_screen.dart';
import '../views/order/orders_management/orders_management_screen.dart';
import '../views/product/company_product_details/company_product_details_screen.dart';
import '../views/product/select_material_variants/select_material_variants_screen.dart';
import '../views/product/select_package_variants/select_package_variants_screen.dart';
import '../views/product/select_coffee_variant/select_coffee_variant_screen.dart';
import '../views/quote/manage_quotations/quotations_management_screen.dart';
import '../views/quote/quote_edition/edit_quote_screen.dart';
import '../views/quote/request_quote_creation/create_quote_screen.dart';
import '../views/setting/setting/account_information/account_information_screen.dart';
import '../views/splash/splash_screen.dart';
import '../views/warehouse/brands/export.dart';
import '../views/warehouse/green_beans/green_beans_screen.dart';
import '../views/warehouse/packing_slip/export_package_for_slip_item/export_package_for_slip_item_screen.dart';
import '../views/warehouse/packing_slip/export_warehouse_for_slip_item/export_warehouse_for_slip_item_screen.dart';
import '../views/warehouse/packing_slip/packing_slip_details/packing_slip_details_screen.dart';
import '../views/warehouse/packing_slip/packing_slip_item_details/packing_slip_item_details_screen.dart';
import '../views/warehouse/roasted_beans/roasted_beans_screen.dart';
import '../views/warehouse/roasting_slip/roasting_slip_create/roasting_slip_create_screen.dart';
import '../views/warehouse/roasting_slip/roasting_slip_detail/roasting_slip_detail_screen.dart';
import '../views/warehouse/roasting_slip/roasting_slips_of_roasted_bean/roasting_slips_of_roasted_bean_screen.dart';

class AppWireFrame {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>(
    debugLabel: 'navigatorGlobalKey',
  );
  static const rootName = '/';
  static final Map<String, WidgetBuilder> routes = {
    rootName: (_) => getRootScreen(),
    LoginScreen.keyName: (_) => const LoginScreen(),
    RegisterScreen.keyName: (_) => const RegisterScreen(),
    ForgotPasswordScreen.keyName: (_) => const ForgotPasswordScreen(),
    ChangeInformationScreen.keyName: (_) => const ChangeInformationScreen(),
    UserAddressesScreen.keyName: (_) => const UserAddressesScreen(),
    AddAddressScreen.keyName: (_) => const AddAddressScreen(),
    ProductsScreen.keyName: (_) => const ProductsScreen(),
    ProductsByLineageScreen.keyName: (_) => const ProductsByLineageScreen(),
    MyCartScreen.keyName: (_) => const MyCartScreen(),
    CheckoutScreen.keyName: (_) => const CheckoutScreen(),
    FillInfoPaymentScreen.keyName: (_) => const FillInfoPaymentScreen(),
    ProductDetailScreen.keyName: (_) => const ProductDetailScreen(),
    ChangePasswordScreen.keyName: (_) => const ChangePasswordScreen(),
    BlogsScreen.keyName: (_) => const BlogsScreen(),
    HomeScreen.keyName: (_) => const HomeScreen(),
    // MapScreen.keyName: (_) => const MapScreen(),
    ChooseRegionScreen.keyName: (_) => const ChooseRegionScreen(),
    NotificationScreen.keyName: (_) => const NotificationScreen(),
    OrdersHistoryScreen.keyName: (_) => const OrdersHistoryScreen(),
    // QRCodeScannerScreen.keyName: (_) => const QRCodeScannerScreen(),
    OrdersManagementScreen.keyName: (_) => const OrdersManagementScreen(),
    CreateOrderScreen.keyName: (_) => const CreateOrderScreen(),
    OrderListScreen.keyName: (_) => const OrderListScreen(),
    // BarCodeScannerScreen.keyName: (_) => const BarCodeScannerScreen(),
    CustomerCreateScreen.keyName: (_) => const CustomerCreateScreen(),
    GreenBeansScreen.routeName: (_) => const GreenBeansScreen(),
    RoastingSlipCreateScreen.routeName: (_) => const RoastingSlipCreateScreen(),
    RoastedBeansScreen.routeName: (_) => const RoastedBeansScreen(),
    BrandsScreen.routeName: (_) => const BrandsScreen(),
    SelectMaterialsScreen.routeName: (_) => const SelectMaterialsScreen(),
    CustomerGroupsScreen.keyName: (_) => const CustomerGroupsScreen(),
    SelectPackageVariantsScreen.routeName: (_) =>
        const SelectPackageVariantsScreen(),
    AccountInformationScreen.keyName: (_) => const AccountInformationScreen(),
    AddNewProductServiceScreen.keyName: (_) =>
        const AddNewProductServiceScreen(),
    QuotationsManagementScreen.keyName: (_) =>
        const QuotationsManagementScreen(),
    QuotationCreationScreen.keyName: (_) => const QuotationCreationScreen(),
    CustomerGrDetailsScreen.routeName: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is String) {
        return CustomerGrDetailsScreen(customerId: args);
      }
      return const Scaffold(
        body: Center(child: Text('Không tìm thấy thông tin nhóm khách hàng')),
      );
    },
    OrderDetailScreen.keyName: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is String) {
        return OrderDetailScreen(code: args);
      }
      return const Scaffold(
        body: Center(child: Text('Không tìm thấy thông tin đơn hàng')),
      );
    },
    CustomerGroupCreateScreen.keyName: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is CustomerGroupType) {
        return CustomerGroupCreateScreen(type: args);
      }
      return const Scaffold(
        body: Center(
          child: Text('Không tìm thấy thông tin loại nhóm khách hàng'),
        ),
      );
    },
    ConfigCustomerAddressScreen.updateRoute: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is Map) {
        return ConfigCustomerAddressScreen(
          mode: CRUDType.update,
          title: args['title'] as String?,
          customer: args['customer'] as Customer?,
          initialAddress: args['initialAddress'] as Address?,
        );
      }
      return const Scaffold(
        body: Center(child: Text('404 - Không tìm thấy trang')),
      );
    },
    ConfigCustomerAddressScreen.createRoute: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is Map) {
        return ConfigCustomerAddressScreen(
          mode: CRUDType.create,
          title: args['title'] as String?,
          customer: args['customer'] as Customer?,
          initialAddress: args['initialAddress'] as Address?,
        );
      }
      return const Scaffold(
        body: Center(child: Text('404 - Không tìm thấy trang')),
      );
    },
    SelectCustomersScreen.keyName: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is Map) {
        return SelectCustomersScreen(
          currentSelected: args['currentSelected'] as Customer?,
        );
      }
      return const SelectCustomersScreen();
    },
    SelectProductsScreen.keyName: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is Map) {
        return SelectProductsScreen(
          branchId:
              args['branchId'] as String? ?? args['saleBranchId'] as String?,
        );
      } else if (args != null && args is List) {
        return const SelectProductsScreen();
      }
      return const SelectProductsScreen();
    },
    LoadingScreen.keyName: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is Map) {
        return LoadingScreen(
          tasks: args['tasks'] as List<LoadingTask>?,
          successRoute: args['successRoute'] as String?,
          successRouteArguments: args['successRouteArguments'],
          loadingMessage: args['loadingMessage'] as String?,
          sequential: args['sequential'] as bool? ?? true,
          onSuccess: args['onSuccess'] as Function(Map<String, dynamic>)?,
          onError: args['onError'] as Function(String, LoadingTask?)?,
        );
      }
      return const LoadingScreen();
    },
    CustomerDetailsScreen.routeName: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is String) {
        return CustomerDetailsScreen(customerId: args);
      }
      return const Scaffold(
        body: Center(child: Text('Không tìm thấy thông tin khách hàng')),
      );
    },
    CompanyProductsDetailsScreen.routeName: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is String) {
        return CompanyProductsDetailsScreen(productId: args);
      }
      return const Scaffold(
        body: Center(child: Text('Không tìm thấy thông tin sản phẩm')),
      );
    },
    RoastingSlipsOfRoastedBeanScreen.routeName: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is ProductVariant) {
        return RoastingSlipsOfRoastedBeanScreen(roastedBean: args);
      }
      return const Scaffold(
        body: Center(child: Text('Không tìm thấy thông tin hạt rang')),
      );
    },
    PackingSlipItemDetailsScreen.routeName: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is PackingSlipDetailItem) {
        return PackingSlipItemDetailsScreen(item: args);
      }
      return const Scaffold(
        body: Center(child: Text('Không tìm thấy thông tin phiếu đóng gói')),
      );
    },
    SelectCoffeeVariantScreen.routeName: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is Map && args['type'] != null) {
        return SelectCoffeeVariantScreen(
          branchId: args['branchId'] as String?,
          categoryCode: args['type'] as CoffeeVariantType,
        );
      }
      return const Scaffold(
        body: Center(child: Text('Không tìm thấy thông tin sản phẩm')),
      );
    },
    RoastingSlipDetailScreen.routeName: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      final code = args is String ? args : '';
      return RoastingSlipDetailScreen(code: code);
    },
    PackingSlipDetailsScreen.routeName: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      final code = args is String ? args : '';
      return PackingSlipDetailsScreen(code: code);
    },
    PackingSlipsOfSpecialVariantScreen.routeName: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is ProductVariant) {
        return PackingSlipsOfSpecialVariantScreen(specialVariant: args);
      }
      return const Scaffold(
        body: Center(
          child: Text('Không tìm thấy thông tin sản phẩm thương hiệu'),
        ),
      );
    },
    ExportWarehouseForSlipItemScreen.routeName: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is PackingSlipDetailItem) {
        return ExportWarehouseForSlipItemScreen(slipItem: args);
      }
      return const Scaffold(
        body: Center(
          child: Text('Không tìm thấy thông tin sản phẩm thương hiệu'),
        ),
      );
    },
    ExportPackageForSlipItemScreen.routeName: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is PackingSlipDetailItem) {
        return ExportPackageForSlipItemScreen(slipItem: args);
      }
      return const Scaffold(
        body: Center(
          child: Text('Không tìm thấy thông tin sản phẩm thương hiệu'),
        ),
      );
    },
  };

  static Widget _initScreenDimension({required Widget screen}) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) => screen,
    );
  }

  static Widget getRootScreen() {
    return _initScreenDimension(
      screen: BlocBuilder<AppCubit, AppState>(
        // listenWhen: (previous, current) => current is AppManualLogoutSuccessState,
        // listener: (context, state) {
        //   if (state is AppManualLogoutSuccessState) {
        //     final navigatorState = navigatorKey.currentState;
        //     navigatorState?.pushAndRemoveUntil(
        //       PageRouteBuilder<void>(
        //         pageBuilder: (_, __, ___) => getRootScreen(),
        //         transitionDuration: Duration.zero,
        //         settings: const RouteSettings(name: '/'),
        //       ),
        //       (route) => false,
        //     );
        //   }
        // },
        // buildWhen: (previous, current) {
        //   if (current is AppManualLogoutSuccessState) {
        //     final navigatorState = navigatorKey.currentState;
        //     navigatorState?.pushAndRemoveUntil(
        //       PageRouteBuilder<void>(
        //         pageBuilder: (_, __, ___) => getRootScreen(),
        //         transitionDuration: Duration.zero,
        //         settings: const RouteSettings(name: '/'),
        //       ),
        //       (route) => false,
        //     );

        //     return false;
        //   }

        //   return previous != current;
        // },
        builder: (context, state) {
          if (state is AppUnauthorizedState ||
              state is AppInitialState ||
              state is AppReadyState) {
            FlutterNativeSplash.remove();
          }

          if (state is AppInitialState) return const SplashScreen();
          if (state is AppReadyWithAuthenticationState ||
              state is RefreshAppState) {
            return const HomeScreen();
          }

          return const AuthenticationScreen();
        },
      ),
    );
  }

  static Future<void> logout() async {
    di<AppCubit>().logout();
    navigatorKey.currentState?.pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (_, _, _) => const AuthenticationScreen(),
        transitionDuration: Duration.zero,
      ),
      (route) => false,
    );
  }

  static void pushNamed(String routeName, {dynamic arguments}) {
    navigatorKey.currentState?.pushNamed(routeName, arguments: arguments);
  }

  static void navigateToAddCustomer(BuildContext context) {
    final CollaboratorCubit collaboratorCubit = di<CollaboratorCubit>();
    final CustomerCubit customerCubit = di<CustomerCubit>();
    final AddressCubit addressCubit = di<AddressCubit>();
    final PaymentCubit paymentCubit = di<PaymentCubit>();

    final PaymentRepository paymentRepo = di<PaymentRepository>();
    final AddressRepository addressRepo = di<AddressRepository>();

    customerCubit.getActiveCustomerGroups();
    customerCubit.getActiveStaffs(aboutMe: true);
    collaboratorCubit.fetchCollaborators();
    if ((addressRepo.postMergerProvinceDistrictList.valueOrNull ?? [])
        .isEmpty) {
      addressCubit.filterDistrictsByType(.postMerger);
    }
    if ((paymentRepo.paymentMethods.valueOrNull ?? []).isEmpty) {
      paymentCubit.getPaymentMethods();
    }

    pushNamed(CustomerCreateScreen.keyName);
  }

  static void navigateToOrderCreation(BuildContext context) {
    pushNamed(CreateOrderScreen.keyName);
  }

  static void navigateToRequestQuote(BuildContext context) {
    pushNamed(CreateOrderScreen.keyName);
  }

  static void navigateToOrderDetails(
    BuildContext context, {
    required String code,
    bool replaceCurrentRoute = false,
  }) {
    final OrderRepository orderRepository = di<OrderRepository>();
    orderRepository.orderDetailData.sink.add(null);
    if (replaceCurrentRoute) {
      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        OrderDetailScreen.keyName,
        (route) => route.isFirst,
        arguments: code,
      );
    } else {
      pushNamed(OrderDetailScreen.keyName, arguments: code);
    }
  }

  static void navigateToCompanyProductDetails(
    BuildContext context, {
    required String productId,
  }) {
    final ProductCubit productCubit = di<ProductCubit>();
    final ProductRepository productRepository = di<ProductRepository>();

    final currentProduct =
        productRepository.companyProductDetailStreamData.valueOrNull;
    if (currentProduct?.id != productId) {
      productRepository.companyProductDetailStreamData.sink.add(null);
      productCubit.fetchCompanyProductDetail(productId: productId);
    }

    pushNamed(CompanyProductsDetailsScreen.routeName, arguments: productId);
  }

  static void navigateToQuotationCreation(BuildContext context) {
    // TODO: select quotation template if needed before
    pushNamed(QuotationCreationScreen.keyName);
  }

  static void navigateToCustomerGroupDetails(
    BuildContext context, {
    required String customerGroupId,
    bool replaceCurrentRoute = false,
  }) {
    final CustomerCubit cubit = di<CustomerCubit>();
    final CustomerRepository repository = di<CustomerRepository>();

    final currentGr = repository.selectedGroup.valueOrNull;
    if (currentGr?.id != customerGroupId) {
      repository.selectedGroup.sink.add(null);
      cubit.getCustomerGroupById(customerGroupId);
    }

    pushNamed(CustomerGrDetailsScreen.routeName, arguments: customerGroupId);
  }

  static void navToQuotationCreation(Quotation? quotation) {
    OrderQuotationProducts toElements(
      OrderLineItem item,
    ) => OrderQuotationProducts(
      discount: num.tryParse(item.discount.toString()) ?? 0,
      discountUnit: (item.discountPercent ?? 0) != 0 ? "%" : "đ",
      price: num.tryParse(item.price.toString()) ?? 0,
      discountPercent: item.discountPercent == 0 ? null : item.discountPercent,
      productVariant: item.productVariant.copyWith(
        id: item.isService ? "" : item.productVariant.id,
        product: item.isService
            ? ProductInfo(
                id: "",
                titleVi: item.productVariant.product?.titleVi,
                price: item.productVariant.product?.price ?? 0,
                originalPrice: item.productVariant.product?.originalPrice ?? 0,
                costPrice: 0.0,
                wholesalePrice: 0.0,
                slotBuy: 0.0,
                availableQuantity: 0.0,
                measureUnit: item.productVariant.product?.measureUnit,
              )
            : item.productVariant.product,
      ),
      qty: num.tryParse(item.quantity.toString()) ?? 0,
      measureUnit: item.measureUnit,
      priceList: item.priceList,
      note: item.productVariant.note,
    );
    final createQuotationInput = CreateQuotationInput(
      customer: quotation?.customer,
      order: OrderQuotation(
        products: List<OrderQuotationProducts>.from(
          quotation?.orderLineItems.map(toElements) ?? [],
        ),
        discount: quotation?.discount ?? 0,
        discountPercent: quotation?.discountPercent == 0
            ? null
            : quotation?.discountPercent,
        discountUnit: (quotation?.discountPercent ?? 0) != 0 ? "%" : "đ",
        discountReason: quotation?.discountReason,
        vat: quotation?.vat ?? 0,
        vatUnit: (quotation?.vatPercent ?? 0) != 0 ? "%" : "đ",
        vatPercent: quotation?.vatPercent == 0 ? null : quotation?.vatPercent,
        deliveryFee: quotation?.deliveryFee ?? 0,
        note: quotation?.note,
      ),
      mailType:
          QuoteMailType.values.valueBy(
            (e) => e.toConstant == quotation?.templateCode,
          ) ??
          QuoteMailType.greenBeanQuote,
      notes: quotation?.note,
      payment: quotation?.quotationPayment,
      quantityOpts: quotation?.headerQuantities,
      infoAdditionalQuotation: InfoAdditionalQuotation(
        salesType:
            DefaultPrice.values.valueBy(
              (e) =>
                  e.toConstant ==
                  quotation?.orderInfo?.infoAdditional?.salesType,
            ) ??
            DefaultPrice.retailPrice,
        branch: quotation?.warehouse,
      ),
    );

    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) =>
            QuotationCreationScreen(input: createQuotationInput),
      ),
    );
  }

  static void navToQuotationEdition(Quotation quotation) {
    OrderQuotationProducts toElements(
      OrderLineItem item,
    ) => OrderQuotationProducts(
      discount: num.tryParse(item.discount.toString()) ?? 0,
      discountUnit: (item.discountPercent ?? 0) != 0 ? "%" : "đ",
      price: num.tryParse(item.price.toString()) ?? 0,
      discountPercent: item.discountPercent == 0 ? null : item.discountPercent,
      productVariant: item.productVariant.copyWith(
        id: item.isService ? "" : item.productVariant.id,
        product: item.isService
            ? ProductInfo(
                id: "",
                titleVi: item.productVariant.product?.titleVi,
                price: item.productVariant.product?.price ?? 0,
                originalPrice: item.productVariant.product?.originalPrice ?? 0,
                costPrice: 0.0,
                wholesalePrice: 0.0,
                slotBuy: 0.0,
                availableQuantity: 0.0,
                measureUnit: item.productVariant.product?.measureUnit,
              )
            : item.productVariant.product,
      ),
      qty: num.tryParse(item.quantity.toString()) ?? 0,
      measureUnit: item.measureUnit,
      priceList: item.priceList,
      note: item.productVariant.note,
    );

    if (quotation.code == null) return;
    final createQuotationInput = CreateQuotationInput(
      customer: quotation.customer,
      order: OrderQuotation(
        products: List<OrderQuotationProducts>.from(
          quotation.orderLineItems.map(toElements),
        ),
        discount: quotation.discount ?? 0,
        discountPercent: quotation.discountPercent == 0
            ? null
            : quotation.discountPercent,
        discountUnit: (quotation.discountPercent ?? 0) != 0 ? "%" : "đ",
        discountReason: quotation.discountReason,
        vat: quotation.vat ?? 0,
        vatUnit: (quotation.vatPercent ?? 0) != 0 ? "%" : "đ",
        vatPercent: quotation.vatPercent == 0 ? null : quotation.vatPercent,
        deliveryFee: quotation.deliveryFee ?? 0,
        note: quotation.note,
      ),
      mailType:
          QuoteMailType.values.valueBy(
            (e) => e.toConstant == quotation.templateCode,
          ) ??
          QuoteMailType.greenBeanQuote,
      notes: quotation.note,
      payment: quotation.quotationPayment,
      quantityOpts: quotation.headerQuantities,
      infoAdditionalQuotation: InfoAdditionalQuotation(
        salesType:
            DefaultPrice.values.valueBy(
              (e) =>
                  e.toConstant ==
                  quotation.orderInfo?.infoAdditional?.salesType,
            ) ??
            DefaultPrice.retailPrice,
        branch: quotation.warehouse,
      ),
    );

    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) => QuotationEditionScreen(
          input: createQuotationInput,
          code: quotation.code!,
        ),
      ),
    );
  }
}
