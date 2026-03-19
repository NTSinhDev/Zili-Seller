import 'package:zili_coffee/app/app_flavor_config.dart';

class NetworkUrl {
  static String get baseURL => FlavorConfig.instance.env.baseUrl;
  static String get authBaseURL => FlavorConfig.instance.env.authUrl;
  static String get coreBaseURL => FlavorConfig.instance.env.coreUrl;
  static String get userBaseURL => FlavorConfig.instance.env.userUrl;
  static String get systemBaseURL => FlavorConfig.instance.env.systemUrl;
  static String get baseURLWebSite =>
      FlavorConfig.instance.env.ziliCoffeeWebsiteUrl;

  static final auth = _Authentication();
  static final product = _Product();
  static final customer = _Customer();
  static final address = _Address();
  static final order = _Order();
  static final review = _Review();
  static final upload = _Upload();
  static final blog = _Blog();
  static final warehouse = _Warehouse();
  static final orderProduct = _OrderProduct();
  static final purchaseOrderProduct = _PurchaseOrderProduct();
  static final greenBean = _GreenBean();
  static final customerAddress = _CustomerAddress();
  static final administrative = _Administrative();
  static final collaborator = _Collaborator();
  static final seller = _Seller();
  static const category = '/category/all';
  static const notification = '/notification';
  static const deliverPrice = '/deliver-price';
  static const paymentMethod = '/payment/method';
}

class _Blog {
  static const String _route = '/blog';
  final String blogCategory = '/blog-category/all';
  final String blog = _route;
}

class _Upload {
  static const String _route = '/upload';
  final String image = '$_route/image';
  final String images = '$_route/images';
  final String video = '$_route/video';
  final String blob = '$_route/blob';
}

class _Review {
  static const String _route = '/review';
  String productRating({required String productID}) =>
      '$_route/product/total/$productID';
  String productReviews({required String productID}) =>
      '$_route/product/filter/$productID';
  final String create = '$_route/create';
}

class _Order {
  static const String _route = '/order/customer';
  final String create = '$_route/create';
  final String update = '$_route/update';
  final String getAll = '$_route/all';
  final String orderStagURL = 'https://stag.zilicoffee.vn/dat-hang';
  final String orderURL = 'https://zilicoffee.vn/dat-hang';
  String get({required String id}) => '$_route/$id';
}

class _Address {
  static const String _route = '/address';
  final String provinces = '$_route/provinces';
  String districts(String provinceID) => '$_route/districts/$provinceID';
  String wards(String districtsID) => '$_route/wards/$districtsID';
}

class _Customer {
  static const String _route = '/seller';
  final String getProfile = '$_route/profile';
  final String updateProfile = '$_route/update';
  final String addresses = '$_route/addresses';
  final String changePassword = '$_route/change-password';
  final String deleteAccount = '$_route/delete';
  String address({String? id}) {
    return id != null ? '$_route/address/$id' : '$_route/address';
  }

  // Business customer endpoints (User Service)
  final String filterCustomers = '/business/customer/filter';
  final String createCustomer = '/business/customer/create';
  final String activeCustomerGroups = '/business/group-customer/active';
  final String createCustomerGroup = '/business/group-customer/create';
  String getCustomerById(String id) => '/business/customer/$id';
  String getCustomerGroupById(String id) => '/business/group-customer/$id';
}

class _CustomerAddress {
  static const String _route = '/company/customer-address';
  final String defaultAddress = '$_route/default';
  final String filter = '$_route/filter';
  final String create = _route;
  String update(String addressId) => '$_route/$addressId';
}

class _Authentication {
  static const String _route = '/auth/seller/';
  final String socialSingIn = '${_route}social/verify-token';
  final String register = '${_route}register';
  final String forgotpassword = '${_route}forgot';
  final String forgotCode = '${_route}verify-otp';
  final String createNewPassword = '${_route}reset';
  final String logout = '${_route}logout';
}

class _Product {
  final String search = '$_route/search/';
  static const String _route = '/product/local';
  String detail({required String slug}) => '/product/slug/$slug';
  String byID(String id) => '$_route/detail/$id';
  final String getByCompany = '/product/get-by-company';
  String companyProductDetail(String productId) => '/company/product/detail/$productId';
}

class _Warehouse {
  static const String _route = '/seller/warehouse';
  final String getAll = _route;
}

class _OrderProduct {
  static const String _route = '/company/product/order/filter';
  final String filter = _route;
}

class _PurchaseOrderProduct {
  static const String _route = '/company/product/purchase-order';
  final String filter = '$_route/filter';
}

class _GreenBean {
  static const String _route = '/coffee-variant/green-bean';
  String defaultById(String id) => '$_route/default/$id';
}

class _Administrative {
  static const String _route = '/administrative';
  final String provinces = '$_route/provinces';
  final String filterDistricts = '$_route/districts/filter';
  String getWards(String districtCode) => '$_route/wards/$districtCode';
}

class _Collaborator {
  static const String _route = '/company/collaborator';
  String all({List<String>? status}) {
    final queryParams = <String>[];
    if (status != null && status.isNotEmpty) {
      for (final s in status) {
        queryParams.add('status[]=$s');
      }
    }
    final queryString = queryParams.isEmpty ? '' : '?${queryParams.join('&')}';
    return '$_route/all$queryString';
  }

  String filter({int offset = 0, int limit = 10, List<String>? status}) {
    final queryParams = <String>[];
    queryParams.add('offset=$offset');
    queryParams.add('limit=$limit');
    if (status != null && status.isNotEmpty) {
      for (final s in status) {
        queryParams.add('status[]=$s');
      }
    }
    return '$_route/filter?${queryParams.join('&')}';
  }
}

class _Seller {
  static const String _route = '/seller';

  /// Get seller roles
  ///
  /// API: GET /auth/api/v1/seller/role
  ///
  /// Query Parameters:
  /// - offset: int (optional, default: 0)
  /// - limit: int (optional, default: 8)
  final String role = '$_route/role';

  /// Get payment methods (synthetic/active)
  ///
  /// API: GET /system/api/v1/seller/payment-method/synthetic/active
  ///
  /// Query Parameters:
  /// - notMethods[]: string[] (optional, exclude payment methods)
  String paymentMethodSyntheticActive({List<String>? notMethods}) {
    final queryParams = <String>[];
    if (notMethods != null && notMethods.isNotEmpty) {
      for (final method in notMethods) {
        queryParams.add('notMethods[]=$method');
      }
    }
    final queryString = queryParams.isNotEmpty
        ? '?${queryParams.join('&')}'
        : '';
    return '$_route/payment-method/synthetic/active$queryString';
  }

  /// Get payment methods (legacy)
  ///
  /// Query Parameters:
  /// - isActive: boolean (optional, default: true)
  /// - notMethods[]: string[] (optional, exclude payment methods)
  String paymentMethod({bool? isActive, List<String>? notMethods}) {
    final queryParams = <String>[];
    if (isActive != null) {
      queryParams.add('isActive=$isActive');
    }
    if (notMethods != null && notMethods.isNotEmpty) {
      for (final method in notMethods) {
        queryParams.add('notMethods[]=$method');
      }
    }
    final queryString = queryParams.isNotEmpty
        ? '?${queryParams.join('&')}'
        : '';
    return '$_route/payment-method$queryString';
  }
}
