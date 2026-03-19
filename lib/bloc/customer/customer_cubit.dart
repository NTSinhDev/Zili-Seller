import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:zili_coffee/bloc/app/app_cubit.dart';
import 'package:zili_coffee/bloc/base_cubit.dart';
import 'package:zili_coffee/data/middlewares/middlewares.dart';
import 'package:zili_coffee/data/models/user/customer.dart';
import 'package:zili_coffee/data/models/user/user.dart';
import 'package:zili_coffee/data/models/user/debt.dart';
import 'package:zili_coffee/data/models/address/address.dart';
import 'package:zili_coffee/data/models/media_file.dart';
import 'package:zili_coffee/data/models/order/order.dart';
import 'package:zili_coffee/data/network/network_response_state.dart';
import 'package:zili_coffee/data/repositories/auth_repository.dart';
import 'package:zili_coffee/di/dependency_injection.dart';

import '../../data/dto/customer/create_customer_address_input.dart';
import '../../data/dto/customer/filter_customers_input.dart';
import '../../data/dto/customer/create_customer_input.dart';
import '../../data/dto/customer_group/create_customer_group_input.dart';
import '../../data/models/user/customer_group.dart';
import '../../data/models/user/staff.dart';
import '../../data/repositories/customer_repository.dart';

part 'customer_state.dart';

class CustomerCubit extends BaseCubit<CustomerState> {
  CustomerCubit() : super(CustomerInitial());

  final _authMiddleware = di<AuthMiddleware>();
  final _customerMiddleware = di<CustomerMiddleware>();
  final _uploadMiddleware = di<UploadMiddleware>();
  final _authRepo = di<AuthRepository>();
  final _customerRepo = di<CustomerRepository>();
  final _appCubit = di<AppCubit>();

  Future changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    emit(WaitingCustomerState());
    final result = await _customerMiddleware.changePassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
    );
    if (result is ResponseSuccessState<bool>) {
      emit(
        MessageCustomerState(
          message: result.responseData
              ? "Mật khẩu đã được thay đổi!"
              : "Không thể thực hiện cập nhật mật khẩu!",
        ),
      );
    } else if (result is ResponseFailedState) {
      emit(FailedCustomerState(error: result));
    }
  }

  Future updateProfile({required User customer}) async {
    final result = await _customerMiddleware.updateUserProfile(
      customer: customer,
    );
    if (result is ResponseSuccessState<String>) {
      // Show a success message to client
      emit(MessageCustomerState(message: result.responseData));
      // Get new data
      final userData = await _customerMiddleware.getUserProfile();
      if (userData is ResponseSuccessState<User?>) {
        _authRepo.setCurrentUser(userData.responseData!);
        _appCubit.emit(
          AppReadyWithAuthenticationState(user: userData.responseData!),
        );
      }
    } else if (result is ResponseFailedState) {
      emit(FailedCustomerState(error: result));
    }
  }

  Future updateAvatar({required File file}) async {
    // Upload file to server to get URL
    final imageData = await _uploadMiddleware.uploadImage(imgFile: file);
    if (imageData is ResponseSuccessState<MediaFile>) {
      // Update avatar by this URL
      final result = await _customerMiddleware.updateUserAvatar(
        media: imageData.responseData,
      );
      if (result is ResponseSuccessState<String>) {
        // Show a success message
        emit(MessageCustomerState(message: result.responseData));
        // Get new data
        final userData = await _customerMiddleware.getUserProfile();
        if (userData is ResponseSuccessState<User?>) {
          _authRepo.setCurrentUser(userData.responseData!);
          _appCubit.emit(
            AppReadyWithAuthenticationState(user: userData.responseData!),
          );
        }
      } else if (result is ResponseFailedState) {
        emit(MessageCustomerState(message: result.errorMessage));
      }
    } else if (imageData is ResponseFailedState) {
      emit(MessageCustomerState(message: imageData.errorMessage));
    }
  }

  /// Filter customers by keyword
  ///
  /// Parameters:
  /// - keyword: Search keyword (optional)
  /// - limit: Number of items per page (default: 10)
  /// - offset: Pagination offset (default: 0)
  ///
  /// States:
  /// - WaitingCustomerState: Loading
  /// - CustomerFilterLoadedState: Success with data
  /// - FailedCustomerState: Error
  Future<void> filterCustomers({
    required FilterCustomersInput input,
    String? event,
    bool isInitialLoad = false, // Thêm parameter để xác định initial load
  }) async {
    if (isInitialLoad) {
      emit(const LoadingCustomerState()); // Modal loading
    } else {
      emit(LoadingCustomerState(event: event ?? "search")); // Inline loading
    }
    final result = await _customerMiddleware.filterCustomers(input);
    if (result is ResponseSuccessListState<List<Customer>>) {
      final customers = result.responseData;
      _customerRepo.customersFilter.sink.add(customers);
      _customerRepo.totalCustomers = result.total;
      emit(LoadedCustomerState());
    } else if (result is ResponseFailedState) {
      emit(FailedCustomerState(error: result));
    }
  }

  Future<void> loadMoreCustomers(FilterCustomersInput input) async {
    emit(const LoadingCustomerState(event: "loadMore"));
    final result = await _customerMiddleware.filterCustomers(input);
    if (result is ResponseSuccessListState<List<Customer>>) {
      final customers = result.responseData;
      _customerRepo.customersFilter.sink.add([
        ..._customerRepo.customersFilter.value,
        ...customers,
      ]);
      emit(LoadedCustomerState());
    } else if (result is ResponseFailedState) {
      emit(FailedCustomerState(error: result));
    }
  }

  /// Get default address for a customer
  ///
  /// Parameters:
  /// - customerId: Customer ID (required)
  ///
  /// States:
  /// - WaitingCustomerState: Loading
  /// - CustomerDefaultAddressLoadedState: Success with address
  /// - FailedCustomerState: Error
  Future<Address?> getDefaultCustomerAddress(String customerId) async {
    final result = await _customerMiddleware.getDefaultCustomerAddress(
      customerId: customerId,
    );

    if (result is ResponseSuccessState<Address?>) {
      return result.responseData;
    }

    return null;
  }

  /// Get default address for a customer
  ///
  /// Parameters:
  /// - customerId: Customer ID (required)
  ///
  Future<void> getDefaultCustomerAddressV1(Customer customer) async {
    emit(LoadingCustomerState(event: "getDefaultCustomerAddressV1"));
    final result = await _customerMiddleware.getDefaultCustomerAddress(
      customerId: customer.id,
    );

    if (result is ResponseSuccessState<Address?>) {
      final Customer output = customer;
      if (result.responseData != null) {
        _customerRepo.addressesOfCustomer.sink.add([result.responseData!]);
        output.purchaseAddress = result.responseData;
        output.billingAddress = result.responseData;
      }
      emit(LoadedCustomerState<Customer>(data: output));
    } else {
      emit(LoadedCustomerState<Customer>(data: customer));
    }
  }

  /// Filter customer addresses by customer ID
  ///
  /// Parameters:
  /// - customerId: Customer ID (required)
  ///
  /// States:
  /// - WaitingCustomerState: Loading
  /// - CustomerAddressesLoadedState: Success with addresses list
  /// - FailedCustomerState: Error
  Future<void> getCustomerAddresses(String customerId) async {
    final result = await _customerMiddleware.filterCustomerAddresses(
      customerId: customerId,
    );
    if (result is ResponseSuccessListState<List<Address>>) {
      _customerRepo.addressesOfCustomer.sink.add(result.responseData);
    }
  }

  /// Create customer address
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
  /// States:
  /// - WaitingCustomerState: Loading
  /// - MessageCustomerState: Success with message
  /// - FailedCustomerState: Error
  Future<void> createCustomerAddress({
    required String customerId,
    required String name,
    String? phone,
    String? email,
    required String provinceCode,
    String? districtCode,
    required String wardCode,
    required String address,
  }) async {
    emit(WaitingCustomerState());
    final result = await _customerMiddleware.createCustomerAddress(
      customerId: customerId,
      name: name,
      phone: phone,
      email: email,
      provinceCode: provinceCode,
      districtCode: districtCode,
      wardCode: wardCode,
      address: address,
    );
    if (result is ResponseSuccessState<Address?>) {
      emit(MessageCustomerState(message: 'Tạo địa chỉ thành công'));
    } else if (result is ResponseFailedState) {
      emit(FailedCustomerState(error: result));
    }
  }

  /// Update customer address by ID
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
  /// States:
  /// - WaitingCustomerState: Loading
  /// - MessageCustomerState: Success with message
  /// - FailedCustomerState: Error
  Future<void> updateCustomerAddress({
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
    emit(WaitingCustomerState());
    final result = await _customerMiddleware.updateCustomerAddress(
      addressId: addressId,
      customerId: customerId,
      name: name,
      phone: phone,
      email: email,
      provinceCode: provinceCode,
      districtCode: districtCode,
      wardCode: wardCode,
      address: address,
    );
    if (result is ResponseSuccessState<Address?>) {
      emit(const MessageCustomerState(message: 'Cập nhật địa chỉ thành công'));
    } else if (result is ResponseFailedState) {
      emit(FailedCustomerState(error: result));
    }
  }

  Future<void> getActiveStaffs({bool aboutMe = false}) async {
    emit(const LoadingCustomerState());
    final result = await _authMiddleware.getActiveStaffs(aboutMe: aboutMe);
    if (result is ResponseSuccessState<List<Staff>>) {
      _customerRepo.activeStaffs.sink.add(result.responseData);
      emit(LoadedCustomerState());
    } else if (result is ResponseFailedState) {
      emit(FailedCustomerState(error: result));
    }
  }

  /// Get customer groups
  ///
  /// Parameters:
  /// - queryParameters: Optional query parameters for filtering
  ///
  /// States:
  /// - LoadingCustomerState: Loading
  /// - LoadedCustomerState: Success with groups list
  /// - FailedCustomerState: Error
  Future<void> getGroupCustomers({
    Map<String, dynamic>? queryParameters,
  }) async {
    emit(const LoadingCustomerState());
    final result = await _customerMiddleware.filterGroupCustomers(
      queryParameters: queryParameters,
    );
    if (result is ResponseSuccessListState<List<CustomerGroup>>) {
      _customerRepo.customerGroups.sink.add(result.responseData);
      _customerRepo.totalCustomerGroups = result.total;
      emit(LoadedCustomerState());
    } else if (result is ResponseFailedState) {
      emit(FailedCustomerState(error: result));
    }
  }

  Future<void> loadMoreGroupCustomers(
    Map<String, dynamic>? queryParameters,
  ) async {
    final result = await _customerMiddleware.filterGroupCustomers(
      queryParameters: queryParameters,
    );
    if (result is ResponseSuccessListState<List<CustomerGroup>>) {
      final groups = result.responseData;
      _customerRepo.customerGroups.sink.add([
        ..._customerRepo.customerGroups.value,
        ...groups,
      ]);
      _customerRepo.totalCustomerGroups = result.total;
    }
  }

  /// Get active customer groups
  ///
  /// API: GET /user/api/v1/business/group-customer/active
  ///
  /// States:
  /// - LoadingCustomerState: Loading
  /// - LoadedCustomerState: Success with active groups list
  /// - FailedCustomerState: Error
  Future<void> getActiveCustomerGroups() async {
    emit(const LoadingCustomerState());
    final result = await _customerMiddleware.getActiveCustomerGroups();
    if (result is ResponseSuccessListState<List<CustomerGroup>>) {
      _customerRepo.customerGroups.sink.add(result.responseData);
      emit(LoadedCustomerState());
    } else if (result is ResponseFailedState) {
      emit(FailedCustomerState(error: result));
    }
  }

  /// Create a new customer
  ///
  /// Parameters:
  /// - input: CreateCustomerInput containing customer data
  Future<void> createCustomer({required CreateCustomerInput input}) async {
    emit(const LoadingCustomerState());
    final result = await _customerMiddleware.createCustomer(input: input);
    if (result is ResponseSuccessState<Customer?>) {
      await filterCustomers(input: FilterCustomersInput());
    } else {
      emit(FailedCustomerState(error: result));
    }
  }

  Future<void> createCustomerAddressV1({
    required CustomerAddressInputDTO input,
  }) async {
    emit(const LoadingCustomerState());
    try {
      final result = await _customerMiddleware.createCustomerAddress(
        customerId: input.customer!.customerId!,
        name: input.customer!.name!,
        phone: input.customer!.phone,
        email: input.customer!.email,
        provinceCode: input.provinceCode!,
        districtCode: input.districtCode,
        wardCode: input.wardCode!,
        address: input.customer!.specificAddress!,
      );
      if (result is ResponseSuccessState<Address?>) {
        emit(LoadedCustomerState(data: result.responseData));
      } else if (result is ResponseFailedState) {
        emit(FailedCustomerState(error: result));
      }
    } catch (e) {
      emit(FailedCustomerState(error: e));
    }
  }

  /// Update customer address
  ///
  /// Parameters:
  /// - input: CreateCustomerInput containing customer data
  Future<void> updateCustomerAddressV1({
    required CustomerAddressInputDTO input,
  }) async {
    emit(const LoadingCustomerState());
    try {
      final result = await _customerMiddleware.updateCustomerAddress(
        addressId: input.address!.id,
        customerId: input.customer!.customerId!,
        name: input.customer!.name!,
        phone: input.customer!.phone,
        email: input.customer!.email,
        address: input.customer!.specificAddress!,
        provinceCode: input.provinceCode!,
        districtCode: (input.districtCode ?? "").isNotEmpty
            ? input.districtCode
            : null,
        wardCode: input.wardCode!,
      );
      if (result is ResponseSuccessState<Address>) {
        emit(LoadedCustomerState(data: result.responseData));
      } else {
        emit(FailedCustomerState(error: result));
      }
    } catch (e) {
      emit(FailedCustomerState(error: e));
    }
  }

  /// Get customer by ID
  ///
  /// API: GET /user/api/v1/business/customer/{id}
  ///
  /// Parameters:
  /// - id: Customer ID
  ///
  /// States:
  /// - LoadingCustomerState: Loading
  /// - LoadedCustomerState: Success with customer data
  /// - FailedCustomerState: Error
  Future<void> getCustomerById(String id) async {
    emit(const LoadingCustomerState());
    final result = await _customerMiddleware.getCustomerById(id);
    if (result is ResponseSuccessState<Customer>) {
      final customer = result.responseData;
      _customerRepo.selectedCustomer.sink.add(customer);
      emit(LoadedCustomerState());
    } else if (result is ResponseFailedState) {
      emit(FailedCustomerState(error: result));
    }
  }

  /// Create a new customer group
  ///
  /// API: POST /user/api/v1/business/group-customer/create
  ///
  /// Parameters:
  /// - input: CreateCustomerGroupInput containing customer group data
  ///
  /// States:
  /// - LoadingCustomerState: Loading
  /// - MessageCustomerState: Success with message
  /// - FailedCustomerState: Error
  Future<void> createCustomerGroup({
    required CreateCustomerGroupInput input,
  }) async {
    emit(const LoadingCustomerState());
    final result = await _customerMiddleware.createCustomerGroup(
      data: input.toMap(),
    );
    if (result is ResponseSuccessState<CustomerGroup>) {
      // Refresh customer groups list after creation
      await getActiveCustomerGroups();
      emit(
        const MessageCustomerState(message: 'Tạo nhóm khách hàng thành công'),
      );
    } else if (result is ResponseFailedState) {
      emit(FailedCustomerState(error: result));
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
  /// States:
  /// - LoadingCustomerState: Loading
  /// - LoadedCustomerState: Success with orders list
  /// - FailedCustomerState: Error
  Future<void> getCustomerTransactions(
    String customerId, {
    int limit = 20,
    int offset = 0,
  }) async {
    emit(const LoadingCustomerState());
    final result = await _customerMiddleware.getCustomerTransactions(
      customerId: customerId,
      limit: limit,
      offset: offset,
    );
    if (result is ResponseSuccessListState<List<Order>>) {
      final orders = result.responseData;
      _customerRepo.customerTransactions.sink.add(orders);
      _customerRepo.totalCustomerTransactions = result.total;
      emit(LoadedCustomerState());
    } else if (result is ResponseFailedState) {
      emit(FailedCustomerState(error: result));
    }
  }

  /// Load more customer transactions
  ///
  /// Parameters:
  /// - customerId: Customer ID (required)
  /// - limit: Number of items per page (default: 20)
  /// - offset: Pagination offset (default: 0)
  Future<void> loadMoreCustomerTransactions(
    String customerId, {
    int limit = 20,
    int offset = 0,
  }) async {
    emit(const LoadingCustomerState(event: "loadMore"));
    final result = await _customerMiddleware.getCustomerTransactions(
      customerId: customerId,
      limit: limit,
      offset: offset,
    );
    if (result is ResponseSuccessListState<List<Order>>) {
      final orders = result.responseData;
      _customerRepo.customerTransactions.sink.add([
        ..._customerRepo.customerTransactions.value,
        ...orders,
      ]);
      _customerRepo.totalCustomerTransactions = result.total;
      emit(LoadedCustomerState());
    } else if (result is ResponseFailedState) {
      emit(FailedCustomerState(error: result));
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
  /// States:
  /// - LoadingCustomerState: Loading
  /// - LoadedCustomerState: Success with debts list
  /// - FailedCustomerState: Error
  Future<void> getCustomerDebts(
    String customerId, {
    int limit = 20,
    int offset = 0,
  }) async {
    emit(const LoadingCustomerState());
    final result = await _customerMiddleware.getCustomerDebts(
      customerId: customerId,
      limit: limit,
      offset: offset,
    );
    if (result is ResponseSuccessListState<List<Debt>>) {
      final debts = result.responseData;
      _customerRepo.customerDebts.sink.add(debts);
      _customerRepo.totalCustomerDebts = result.total;
      emit(LoadedCustomerState());
    } else if (result is ResponseFailedState) {
      emit(FailedCustomerState(error: result));
    }
  }

  /// Load more customer debts
  ///
  /// Parameters:
  /// - customerId: Customer ID (userId) (required)
  /// - limit: Number of items per page (default: 20)
  /// - offset: Pagination offset (default: 0)
  Future<void> loadMoreCustomerDebts(
    String customerId, {
    int limit = 20,
    int offset = 0,
  }) async {
    emit(const LoadingCustomerState(event: "loadMore"));
    final result = await _customerMiddleware.getCustomerDebts(
      customerId: customerId,
      limit: limit,
      offset: offset,
    );
    if (result is ResponseSuccessListState<List<Debt>>) {
      final debts = result.responseData;
      _customerRepo.customerDebts.sink.add([
        ..._customerRepo.customerDebts.value,
        ...debts,
      ]);
      _customerRepo.totalCustomerDebts = result.total;
      emit(LoadedCustomerState());
    } else if (result is ResponseFailedState) {
      emit(FailedCustomerState(error: result));
    }
  }

  Future<void> getCustomerGroupById(String id) async {
    final result = await _customerMiddleware.getCustomerGroupById(id);
    if (result is ResponseSuccessState<CustomerGroup>) {
      _customerRepo.selectedGroup.sink.add(result.responseData);
    } else {
      _customerRepo.selectedGroup.sink.add(null);
    }
  }
}
