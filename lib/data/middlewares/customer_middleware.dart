import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:zili_coffee/data/middlewares/base_middleware.dart';
import 'package:zili_coffee/data/models/user/customer.dart';
import 'package:zili_coffee/data/models/user/customer_group.dart';
import 'package:zili_coffee/data/models/user/user.dart';
import 'package:zili_coffee/data/models/user/debt.dart';
import 'package:zili_coffee/data/models/address/address.dart';
import 'package:zili_coffee/data/models/media_file.dart';
import 'package:zili_coffee/data/models/order/order.dart';
import 'package:zili_coffee/data/network/network_response_object.dart';
import 'package:zili_coffee/data/network/network_response_state.dart';
import 'package:zili_coffee/data/network/network_url.dart';
import 'package:zili_coffee/utils/enums.dart';

import '../dto/customer/filter_customers_input.dart';
import '../dto/customer/create_customer_input.dart';

class CustomerMiddleware extends BaseMiddleware {
  Future<ResponseState> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final response = await authDio.put(
        '/seller/change-password',
        data: {"oldPassword": oldPassword, "newPassword": newPassword},
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess<Map<String, dynamic>>) {
        final status = resultData.data["status"];
        return ResponseSuccessState<bool>(
          statusCode: response.statusCode ?? -1,
          responseData: int.tryParse(status.toString()) == 1,
        );
      }

      if (resultData is NWResponseFailed) {
        return ResponseFailedState.fromNWResponse(resultData);
      }

      return ResponseFailedState.unknownError();
    } on DioException catch (e) {
      return handleResponseFailedState(e);
    }
  }

  Future<ResponseState> getUserProfile() async {
    try {
      final response = await authDio.get<NWResponse>(
        NetworkUrl.customer.getProfile,
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess<Map<String, dynamic>>) {
        return ResponseSuccessState(
          statusCode: response.statusCode ?? -1,
          responseData: resultData.data["id"] != null
              ? User.fromMap(resultData.data)
              : null,
        );
      }

      if (resultData is NWResponseFailed) {
        return ResponseFailedState.fromNWResponse(resultData);
      }

      return ResponseFailedState.unknownError();
    } on DioException catch (e) {
      return handleResponseFailedState(e);
    }
  }

  Future<ResponseState> updateUserProfile({required User customer}) async {
    try {
      final response = await dio.put<NWResponse>(
        NetworkUrl.customer.updateProfile,
        data: {
          "avatar": customer.avatar,
          "phone": customer.phone,
          "name": customer.name,
          "email": customer.email,
          "gender": customer.gender?.toInt(),
        },
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess<Map<String, dynamic>>) {
        return ResponseSuccessState(
          statusCode: response.statusCode ?? -1,
          responseData: resultData.data['message'] as String,
        );
      }

      if (resultData is NWResponseFailed) {
        return ResponseFailedState.fromNWResponse(resultData);
      }

      return ResponseFailedState.unknownError();
    } on DioException catch (e) {
      return handleResponseFailedState(e);
    }
  }

  Future<ResponseState> updateUserAvatar({required MediaFile media}) async {
    try {
      final response = await authDio.put<NWResponse>(
        '/seller',
        data: {"avatar": media.url, "avatarThumb": media.urlThumb},
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess<Map<String, dynamic>>) {
        return ResponseSuccessState<String?>(
          statusCode: response.statusCode ?? -1,
          responseData: resultData.data['avatar'],
        );
      }

      if (resultData is NWResponseFailed) {
        return ResponseFailedState.fromNWResponse(resultData);
      }

      return ResponseFailedState.unknownError();
    } on DioException catch (e) {
      return handleResponseFailedState(e);
    }
  }

  /// Filter customers by keyword
  ///
  /// API: GET /business/customer/filter
  ///
  /// Parameters:
  /// - keyword: Search keyword (optional)
  /// - limit: Number of items per page (default: 10)
  /// - offset: Pagination offset (default: 0)
  ///
  /// Returns: ResponseState with {count: int, customers: List<Customer>}
  Future<ResponseState> filterCustomers(FilterCustomersInput input) async {
    try {
      final queryParameters = input.toMap();
      log('queryParameters: $queryParameters');
      final response = await userDio.get<NWResponse>(
        NetworkUrl.customer.filterCustomers,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess) {
        final data = resultData.data;
        int count = 0;
        List<Customer> customers = [];

        if (data is Map<String, dynamic>) {
          count = data['count'] ?? data['total'] ?? 0;
          // Try different possible keys for customers list
          final customersData =
              data['customers'] as List<dynamic>? ??
              data['data'] as List<dynamic>? ??
              data['listData'] as List<dynamic>?;
          if (customersData != null) {
            customers = customersData
                .map((item) => Customer.fromMap(item as Map<String, dynamic>))
                .toList();
          }
        } else if (data is List) {
          // If response is directly a list
          customers = data
              .map((item) => Customer.fromMap(item as Map<String, dynamic>))
              .toList();
          count = customers.length;
        }

        return ResponseSuccessListState<List<Customer>>(
          statusCode: response.statusCode ?? -1,
          total: count,
          responseData: customers,
        );
      }

      if (resultData is NWResponseFailed) {
        return ResponseFailedState.fromNWResponse(resultData);
      }

      return ResponseFailedState.unknownError();
    } on DioException catch (e) {
      return handleResponseFailedState(e);
    }
  }

  /// Get default address for a customer
  ///
  /// API: GET /company/customer-address/default
  ///
  /// Parameters:
  /// - customerId: Customer ID (required)
  ///
  /// Returns:
  /// - ResponseState chứa Address nếu thành công
  Future<ResponseState> getDefaultCustomerAddress({
    required String customerId,
  }) async {
    try {
      final response = await userDio.get<NWResponse>(
        NetworkUrl.customerAddress.defaultAddress,
        queryParameters: {'customerId': customerId},
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess) {
        final data = resultData.data;
        Address? address;

        if (data is Map<String, dynamic>) {
          address = Address.fromMap(data);
        }

        return ResponseSuccessState(
          statusCode: response.statusCode ?? -1,
          responseData: address,
        );
      }

      if (resultData is NWResponseFailed) {
        return ResponseFailedState.fromNWResponse(resultData);
      }

      return ResponseFailedState.unknownError();
    } on DioException catch (e) {
      return handleResponseFailedState(e);
    }
  }

  /// Filter customer addresses by customer ID
  ///
  /// API: GET /company/customer-address/filter
  ///
  /// Parameters:
  /// - customerId: Customer ID (required)
  ///
  /// Returns:
  /// - ResponseState chứa List<Address> nếu thành công
  Future<ResponseState> filterCustomerAddresses({
    required String customerId,
  }) async {
    try {
      final response = await userDio.get<NWResponse>(
        NetworkUrl.customerAddress.filter,
        queryParameters: {'customerId': customerId},
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess) {
        final data = resultData.data;

        final addresses = data['listData'] != null
            ? (data['listData'] as List<dynamic>)
                  .map((item) => Address.fromMap(item as Map<String, dynamic>))
                  .toList()
            : <Address>[];
        return ResponseSuccessListState<List<Address>>(
          statusCode: response.statusCode ?? -1,
          responseData: addresses,
          total: addresses.length,
        );
      }

      if (resultData is NWResponseFailed) {
        return ResponseFailedState.fromNWResponse(resultData);
      }

      return ResponseFailedState.unknownError();
    } on DioException catch (e) {
      return handleResponseFailedState(e);
    }
  }

  /// Create customer address
  ///
  /// API: POST /company/customer-address
  ///
  /// Parameters:
  /// - customerId: Customer ID (required)
  /// - name: Customer name (required)
  /// - phone: Phone number (optional)
  /// - email: Email (optional)
  /// - provinceCode: Province code (required)
  /// - districtCode: District code (optional, null for POST_MERGER)
  /// - wardCode: Ward code (required)
  /// - address: Specific address (required)
  ///
  /// Returns:
  /// - ResponseState chứa Address nếu thành công
  Future<ResponseState> createCustomerAddress({
    required String customerId,
    required String name,
    String? phone,
    String? email,
    required String provinceCode,
    String? districtCode,
    required String wardCode,
    required String address,
  }) async {
    try {
      final response = await userDio.post<NWResponse>(
        NetworkUrl.customerAddress.create,
        data: {
          'customerId': customerId,
          'name': name,
          if (phone != null && phone.isNotEmpty) 'phone': phone,
          if (email != null && email.isNotEmpty) 'email': email,
          'provinceCode': provinceCode,
          'districtCode': districtCode,
          'wardCode': wardCode,
          'address': address,
        },
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess) {
        final data = resultData.data;
        Address? createdAddress;

        if (data is Map<String, dynamic>) {
          createdAddress = Address.fromMap(data);
        }

        return ResponseSuccessState(
          statusCode: response.statusCode ?? -1,
          responseData: createdAddress,
        );
      }

      if (resultData is NWResponseFailed) {
        return ResponseFailedState.fromNWResponse(resultData);
      }

      return ResponseFailedState.unknownError();
    } on DioException catch (e) {
      return handleResponseFailedState(e);
    }
  }

  /// Update customer address by ID
  ///
  /// API: PUT /company/customer-address/{id}
  ///
  /// Parameters:
  /// - addressId: Address ID (required)
  /// - customerId: Customer ID (required)
  /// - name: Customer name (required)
  /// - phone: Phone number (optional)
  /// - email: Email (optional)
  /// - provinceCode: Province code (required)
  /// - districtCode: District code (optional, null for POST_MERGER)
  /// - wardCode: Ward code (required)
  /// - address: Specific address (required)
  ///
  /// Returns:
  /// - ResponseState chứa Address nếu thành công
  Future<ResponseState> updateCustomerAddress({
    required String addressId,
    required String customerId,
    required String name,
    String? phone,
    String? email,
    required String provinceCode,
    String? districtCode,
    required String wardCode,
    required String address,
  }) async {
    try {
      final response = await userDio.put<NWResponse>(
        NetworkUrl.customerAddress.update(addressId),
        data: {
          'customerId': customerId,
          'name': name,
          if (phone != null && phone.isNotEmpty) 'phone': phone,
          if (email != null && email.isNotEmpty) 'email': email,
          'provinceCode': provinceCode,
          'districtCode': districtCode,
          'wardCode': wardCode,
          'address': address,
        },
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess) {
        final data = resultData.data;
        return ResponseSuccessState<Address>(
          statusCode: response.statusCode ?? -1,
          responseData: Address.fromMap(data),
        );
      }

      if (resultData is NWResponseFailed) {
        return ResponseFailedState.fromNWResponse(resultData);
      }

      return ResponseFailedState.unknownError();
    } on DioException catch (e) {
      return handleResponseFailedState(e);
    }
  }

  /// Filter customer groups
  ///
  /// API: GET /user/api/v1/business/group-customer/filter
  ///
  /// Returns:
  /// - ResponseState chứa List<CustomerGroup> nếu thành công
  Future<ResponseState> filterGroupCustomers({
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await userDio.get<NWResponse>(
        '/business/group-customer/filter',
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess) {
        final data = resultData.data;
        List<CustomerGroup> groups = [];

        if (data is Map<String, dynamic>) {
          // Try different possible keys for groups list
          final groupsData =
              data['groups'] as List<dynamic>? ??
              data['data'] as List<dynamic>? ??
              data['listData'] as List<dynamic>? ??
              data['items'] as List<dynamic>?;
          if (groupsData != null) {
            groups = groupsData
                .map(
                  (item) => CustomerGroup.fromMap(item as Map<String, dynamic>),
                )
                .toList();
          }
        } else if (data is List) {
          // If response is directly a list
          groups = data
              .map(
                (item) => CustomerGroup.fromMap(item as Map<String, dynamic>),
              )
              .toList();
        }

        return ResponseSuccessListState<List<CustomerGroup>>(
          statusCode: response.statusCode ?? -1,
          total: groups.length,
          responseData: groups,
        );
      }

      if (resultData is NWResponseFailed) {
        return ResponseFailedState.fromNWResponse(resultData);
      }

      return ResponseFailedState.unknownError();
    } on DioException catch (e) {
      return handleResponseFailedState(e);
    }
  }

  /// Create a new customer
  ///
  /// API: POST /business/customer/create
  ///
  /// Parameters:
  /// - input: CreateCustomerInput containing customer data
  Future<ResponseState> createCustomer({
    required CreateCustomerInput input,
  }) async {
    try {
      final response = await userDio.post<NWResponse>(
        NetworkUrl.customer.createCustomer,
        data: input.toMap(),
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess) {
        final data = resultData.data;
        Customer? customer;

        if (data is Map<String, dynamic>) {
          customer = Customer.fromMap(data);
        }

        return ResponseSuccessState(
          statusCode: response.statusCode ?? -1,
          responseData: customer,
        );
      }

      if (resultData is NWResponseFailed) {
        return ResponseFailedState.fromNWResponse(resultData);
      }

      return ResponseFailedState.unknownError();
    } on DioException catch (e) {
      return handleResponseFailedState(e);
    }
  }

  /// Get active customer groups
  ///
  /// API: GET /user/api/v1/business/group-customer/active
  ///
  /// Returns:
  /// - ResponseState chứa List<CustomerGroup> nếu thành công
  Future<ResponseState> getActiveCustomerGroups() async {
    try {
      final response = await userDio.get<NWResponse>(
        NetworkUrl.customer.activeCustomerGroups,
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess) {
        final data = resultData.data;
        int total = 0;
        List<CustomerGroup> groups = [];

        if (data is Map<String, dynamic>) {
          total = data['total'] ?? 0;
          final listData = data['listData'] as List<dynamic>?;
          if (listData != null) {
            groups = listData
                .map(
                  (item) => CustomerGroup.fromMap(item as Map<String, dynamic>),
                )
                .toList();
          }
        }

        return ResponseSuccessListState<List<CustomerGroup>>(
          statusCode: response.statusCode ?? -1,
          total: total,
          responseData: groups,
        );
      }

      if (resultData is NWResponseFailed) {
        return ResponseFailedState.fromNWResponse(resultData);
      }

      return ResponseFailedState.unknownError();
    } on DioException catch (e) {
      return handleResponseFailedState(e);
    }
  }

  /// Get customer by ID
  ///
  /// API: GET /user/api/v1/business/customer/{id}
  ///
  /// Parameters:
  /// - id: Customer ID
  ///
  /// Returns:
  /// - ResponseState chứa Customer nếu thành công
  Future<ResponseState> getCustomerById(String id) async {
    try {
      final response = await userDio.get<NWResponse>(
        NetworkUrl.customer.getCustomerById(id),
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess) {
        final data = resultData.data;
        Customer? customer;

        if (data is Map<String, dynamic>) {
          // Response có thể wrapped trong 'data' key
          final customerData = data['data'] as Map<String, dynamic>? ?? data;
          customer = Customer.fromMap(customerData);
        }

        if (customer != null) {
          return ResponseSuccessState<Customer>(
            statusCode: response.statusCode ?? -1,
            responseData: customer,
          );
        }
      }

      if (resultData is NWResponseFailed) {
        return ResponseFailedState.fromNWResponse(resultData);
      }

      return ResponseFailedState.unknownError();
    } on DioException catch (e) {
      return handleResponseFailedState(e);
    }
  }

  /// Get customer group by ID
  ///
  /// API: GET /user/api/v1/business/group-customer/{groupId}
  ///
  /// Parameters:
  /// - groupId: Customer Group ID
  ///
  /// Returns:
  /// - ResponseState chứa CustomerGroup nếu thành công
  Future<ResponseState> getCustomerGroupById(String groupId) async {
    try {
      final response = await userDio.get<NWResponse>(
        NetworkUrl.customer.getCustomerGroupById(groupId),
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess) {
        final data = resultData.data;
        CustomerGroup? customerGroup;

        if (data is Map<String, dynamic>) {
          // Response có thể wrapped trong 'data' key
          final groupData = data['data'] as Map<String, dynamic>? ?? data;
          customerGroup = CustomerGroup.fromMap(groupData);
        }

        if (customerGroup != null) {
          return ResponseSuccessState<CustomerGroup>(
            statusCode: response.statusCode ?? -1,
            responseData: customerGroup,
          );
        }
      }

      if (resultData is NWResponseFailed) {
        return ResponseFailedState.fromNWResponse(resultData);
      }

      return ResponseFailedState.unknownError();
    } on DioException catch (e) {
      return handleResponseFailedState(e);
    }
  }

  /// Create a new customer group
  ///
  /// API: POST /user/api/v1/business/group-customer/create
  ///
  /// Parameters:
  /// - data: Map<String, dynamic> containing customer group data
  ///
  /// Returns:
  /// - ResponseState chứa CustomerGroup nếu thành công
  Future<ResponseState> createCustomerGroup({
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await userDio.post<NWResponse>(
        NetworkUrl.customer.createCustomerGroup,
        data: data,
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess) {
        final data = resultData.data;
        CustomerGroup? customerGroup;

        if (data is Map<String, dynamic>) {
          // Response có thể wrapped trong 'data' key
          final groupData = data['data'] as Map<String, dynamic>? ?? data;
          customerGroup = CustomerGroup.fromMap(groupData);
        }

        if (customerGroup != null) {
          return ResponseSuccessState<CustomerGroup>(
            statusCode: response.statusCode ?? -1,
            responseData: customerGroup,
          );
        }
      }

      if (resultData is NWResponseFailed) {
        return ResponseFailedState.fromNWResponse(resultData);
      }

      return ResponseFailedState.unknownError();
    } on DioException catch (e) {
      return handleResponseFailedState(e);
    }
  }

  /// Get customer transactions (orders) by customer ID
  ///
  /// API: GET /enterprise/order/{customerId}/filter
  /// Service: Core
  ///
  /// Parameters:
  /// - customerId: Customer ID (required)
  /// - limit: Number of items per page (default: 20)
  /// - offset: Pagination offset (default: 0)
  ///
  /// Returns:
  /// - ResponseSuccessListState chứa List<Order> nếu thành công
  Future<ResponseState> getCustomerTransactions({
    required String customerId,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final response = await coreDio.get<NWResponse>(
        '/enterprise/order/$customerId/filter',
        queryParameters: {'limit': limit, 'offset': offset},
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess) {
        final data = resultData.data;
        int total = 0;
        List<Order> orders = [];

        if (data is Map<String, dynamic>) {
          total = data['total'] ?? data['count'] ?? 0;
          // Try different possible keys for orders list
          final ordersData =
              data['listData'] as List<dynamic>? ??
              data['orders'] as List<dynamic>? ??
              data['data'] as List<dynamic>?;
          if (ordersData != null) {
            orders = ordersData
                .map((item) => Order.fromMapNew(item as Map<String, dynamic>))
                .toList();
          }
        } else if (data is List) {
          // If response is directly a list
          orders = data
              .map((item) => Order.fromMapNew(item as Map<String, dynamic>))
              .toList();
          total = orders.length;
        }

        return ResponseSuccessListState<List<Order>>(
          statusCode: response.statusCode ?? -1,
          total: total,
          responseData: orders,
        );
      }

      if (resultData is NWResponseFailed) {
        return ResponseFailedState.fromNWResponse(resultData);
      }

      return ResponseFailedState.unknownError();
    } on DioException catch (e) {
      return handleResponseFailedState(e);
    }
  }

  /// Get customer debts (debt logs) by customer ID
  ///
  /// API: GET /company/debt-log/filter
  /// Service: Auth
  ///
  /// Parameters:
  /// - customerId: Customer ID (userId) (required)
  /// - limit: Number of items per page (default: 20)
  /// - offset: Pagination offset (default: 0)
  ///
  /// Returns:
  /// - ResponseSuccessListState chứa List<Debt> nếu thành công
  Future<ResponseState> getCustomerDebts({
    required String customerId,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final response = await authDio.get<NWResponse>(
        '/company/debt-log/filter',
        queryParameters: {
          'userId': customerId,
          'limit': limit,
          'offset': offset,
        },
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess) {
        final data = resultData.data;
        int total = 0;
        List<Debt> debts = [];

        if (data is Map<String, dynamic>) {
          total = data['total'] ?? data['count'] ?? 0;
          // Try different possible keys for debts list
          final debtsData =
              data['listData'] as List<dynamic>? ??
              data['debts'] as List<dynamic>? ??
              data['data'] as List<dynamic>?;
          if (debtsData != null) {
            debts = debtsData
                .map((item) => Debt.fromMap(item as Map<String, dynamic>))
                .toList();
          }
        } else if (data is List) {
          // If response is directly a list
          debts = data
              .map((item) => Debt.fromMap(item as Map<String, dynamic>))
              .toList();
          total = debts.length;
        }

        return ResponseSuccessListState<List<Debt>>(
          statusCode: response.statusCode ?? -1,
          total: total,
          responseData: debts,
        );
      }

      if (resultData is NWResponseFailed) {
        return ResponseFailedState.fromNWResponse(resultData);
      }

      return ResponseFailedState.unknownError();
    } on DioException catch (e) {
      return handleResponseFailedState(e);
    }
  }
}
