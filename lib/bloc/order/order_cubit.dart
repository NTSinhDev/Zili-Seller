import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:zili_coffee/bloc/base_cubit.dart';
import 'package:zili_coffee/data/models/cart/product_cart.dart';
import 'package:zili_coffee/data/models/order/order.dart';
import 'package:zili_coffee/data/models/order/order_detail_data.dart';
import 'package:zili_coffee/data/models/order/order_info.dart';
import 'package:zili_coffee/data/models/order/order_invoice.dart';
import 'package:zili_coffee/data/models/user/customer.dart';
import 'package:zili_coffee/data/models/warehouse/warehouse.dart';
import 'package:zili_coffee/data/network/network_response_state.dart';
import 'package:zili_coffee/data/repositories/order_repository.dart';
import 'package:zili_coffee/di/dependency_injection.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/extension/extension.dart';

import '../../data/dto/order/create_order.dart';
import '../../data/dto/quotation/create_quotation.dart';
import '../../data/dto/quotation/review_quotation.dart';
import '../../data/middlewares/middlewares.dart';
import '../../data/models/address/address.dart';
import '../../data/models/order/delivery_group.dart';
import '../../data/models/order/order_delivery.dart';
import '../../data/models/order/payment_detail/bank_info.dart';
import '../../data/models/product/product_variant.dart';
import '../../data/models/quotation/quotation.dart';
import '../../data/models/user/base_person.dart';
import '../../data/models/user/company.dart';
import '../../data/models/user/staff.dart';
import '../../data/repositories/warehouse_repository.dart';
import '../../services/common_service.dart';
import '../../utils/enums.dart';
import '../../utils/enums/order_enum.dart';
import '../../utils/enums/product_enum.dart';
part 'order_state.dart';

class OrderCubit extends BaseCubit<OrderState> {
  OrderCubit() : super(OrderInitial());
  final OrderRepository _orderRepository = di<OrderRepository>();
  final OrderMiddleware _orderMiddleware = di<OrderMiddleware>();
  final WarehouseMiddleware _warehouseMiddleware = di<WarehouseMiddleware>();
  final CommonService _commonService = di<CommonService>();
  final WarehouseRepository _warehouseRepository = di<WarehouseRepository>();

  Future<Order?> getOrderByID({required String id}) async {
    final result = await _orderMiddleware.getDetailOrderByID(id: id);
    if (result is ResponseSuccessState<Order>) {
      return result.responseData;
    } else if (result is ResponseFailedState) {
      log(
        'Error when call getDetailOrder method',
        error: result.errorMessage,
        name: 'OrderCubit',
      );
    }
    return null;
  }

  Future getDetailOrder({required Order order}) async {
    _orderRepository.currentOrder = order;
    final result = await _orderMiddleware.getDetailOrderByID(id: order.id);
    if (result is ResponseSuccessState<Order>) {
      _orderRepository.currentOrder = result.responseData;
    } else if (result is ResponseFailedState) {
      log(
        'Error when call getDetailOrder method',
        error: result.errorMessage,
        name: 'OrderCubit',
      );
    }
  }

  Future getAllOrders({required String userID, bool paging = false}) async {
    final result = await _orderMiddleware.getAllOrders(
      userID: userID,
      page: paging ? _calcPage() : null,
      status: _getStatus(_orderRepository.toolbarIndex),
      receivedStatus: _orderRepository.toolbarIndex == 2 ? "received" : null,
    );
    if (result is ResponseSuccessState<Map<String, dynamic>>) {
      List<Order> orders = result.responseData["orders"];
      if (paging) {
        // add data orders into current orders
        orders = [..._orderRepository.behaviorOrders.value, ...orders];
        _orderRepository.behaviorOrders.sink.add(orders);
        _orderRepository.orders = orders;
      } else {
        final totalOrders = result.responseData["totalRecords"];
        _orderRepository.behaviorOrders.sink.add(orders);
        _orderRepository.orders = orders;
        _orderRepository.totalOrders = totalOrders;
      }
    } else if (result is ResponseFailedState) {
      _orderRepository.behaviorOrders.sink.add([]);
      _orderRepository.orders = [];
      _orderRepository.totalOrders = 0;
    }
  }

  Future createOrder(List<ProductCart> productCarts) async {
    emit(CreatingOrderState());
    final result = await _orderMiddleware.createOrder(prods: productCarts);
    if (result is ResponseSuccessState<Order>) {
      _orderRepository.currentOrder = result.responseData;
      emit(CreatedOrderState());
    } else if (result is ResponseFailedState) {
      emit(CreateFailedOrderState(result));
    }
  }

  // /// Fetch chi tiết đơn hàng bằng code (song song 4 endpoint)
  // Future<ResponseState<OrderDetailData>> fetchOrderDetailByCode({
  //   required String code,
  // }) async {
  //   try {
  //     final results = await Future.wait([
  //       _orderMiddleware.getOrderBase(code: code),
  //       _orderMiddleware.getOrderShipment(code: code),
  //       _orderMiddleware.getOrderCustomer(code: code),
  //       _orderMiddleware.getOrderAdditional(code: code),
  //     ]);

  //     Order? order;
  //     OrderDelivery? orderDelivery;
  //     Map<String, dynamic>? deliveryOrderRaw;
  //     Customer? customer;
  //     OrderInvoice? orderInvoice;
  //     OrderInfo? orderInfo;
  //     Warehouse? warehouse;
  //     Staff? staff;
  //     Company? company;

  //     // base
  //     final baseRes = results[0];
  //     if (baseRes is ResponseSuccessState<Order>) {
  //       order = baseRes.responseData;
  //     } else if (baseRes is ResponseFailedState) {
  //       return ResponseFailedState(
  //         statusCode: baseRes.statusCode,
  //         errorMessage: baseRes.errorMessage,
  //         apiError: baseRes.apiError,
  //       );
  //     }

  //     // shipment
  //     final shipmentRes = results[1];
  //     if (shipmentRes is ResponseSuccessState<Map<String, dynamic>>) {
  //       final data = shipmentRes.responseData;
  //       if (data['orderDelivery'] != null) {
  //         orderDelivery = OrderDelivery.fromMap(
  //           Map<String, dynamic>.from(data['orderDelivery'] as Map),
  //         );
  //       }
  //       if (data['deliveryOrder'] != null) {
  //         deliveryOrderRaw =
  //             Map<String, dynamic>.from(data['deliveryOrder'] as Map);
  //       }
  //     }

  //     // customer
  //     final customerRes = results[2];
  //     if (customerRes is ResponseSuccessState<Map<String, dynamic>>) {
  //       final data = customerRes.responseData;
  //       if (data['customer'] != null) {
  //         customer = Customer.fromMap(
  //           Map<String, dynamic>.from(data['customer'] as Map),
  //         );
  //       }
  //       if (data['orderInvoice'] != null) {
  //         orderInvoice = OrderInvoice.fromMap(
  //           Map<String, dynamic>.from(data['orderInvoice'] as Map),
  //         );
  //       }
  //       if (data['orderInfo'] != null) {
  //         orderInfo = OrderInfo.fromMap(
  //           Map<String, dynamic>.from(data['orderInfo'] as Map),
  //         );
  //       }
  //       if (data['delivery'] != null && orderDelivery == null) {
  //         orderDelivery = OrderDelivery.fromMap(
  //           Map<String, dynamic>.from(data['delivery'] as Map),
  //         );
  //       }
  //     }

  //     // additional
  //     final additionalRes = results[3];
  //     if (additionalRes is ResponseSuccessState<Map<String, dynamic>>) {
  //       final data = additionalRes.responseData;
  //       if (data['orderInfo'] != null) {
  //         orderInfo = OrderInfo.fromMap(
  //           Map<String, dynamic>.from(data['orderInfo'] as Map),
  //         );
  //       }
  //       if (data['warehouse'] != null) {
  //         warehouse = Warehouse.fromMap(
  //           Map<String, dynamic>.from(data['warehouse'] as Map),
  //         );
  //       }
  //       if (data['staff'] != null) {
  //         staff = Staff.fromMap(
  //           Map<String, dynamic>.from(data['staff'] as Map),
  //         );
  //       }
  //       if (data['company'] != null) {
  //         company = Company.fromMap(
  //           Map<String, dynamic>.from(data['company'] as Map),
  //         );
  //       }
  //       if (data['orderInvoice'] != null) {
  //         orderInvoice = OrderInvoice.fromMap(
  //           Map<String, dynamic>.from(data['orderInvoice'] as Map),
  //         );
  //       }
  //     }

  //     if (order == null) {
  //       return ResponseFailedState(
  //         statusCode: -1,
  //         errorMessage: 'Không tìm thấy đơn hàng',
  //         apiError: 'order is null',
  //       );
  //     }

  //     return ResponseSuccessState<OrderDetailData>(
  //       statusCode: 200,
  //       responseData: OrderDetailData(
  //         order: order,
  //         orderDelivery: orderDelivery,
  //         deliveryOrderRaw: deliveryOrderRaw,
  //         customer: customer,
  //         orderInvoice: orderInvoice,
  //         orderInfo: orderInfo,
  //         warehouse: warehouse,
  //         staff: staff,
  //         company: company,
  //       ),
  //     );
  //   } catch (e) {
  //     return ResponseFailedState(
  //       statusCode: -1,
  //       errorMessage: e.toString(),
  //       apiError: e.toString(),
  //     );
  //   }
  // }

  Future<void> fetchOrderBaseByCode({required String code}) async {
    if ((_warehouseRepository.warehouseSubject.valueOrNull ?? []).isEmpty) {
      final resultw = await _warehouseMiddleware.getSellerWarehouses(
        limit: 100,
        offset: 0,
      );
      if (resultw is ResponseSuccessState<List<Warehouse>>) {
        final warehouses = resultw.responseData;
        _warehouseRepository.warehouseSubject.sink.add(warehouses);
      }
    }
    final res = await _orderMiddleware.getOrderBase(code: code);
    if (res is ResponseSuccessState<Order>) {
      final data = res.responseData;
      final findWH = (_warehouseRepository.warehouseSubject.valueOrNull ?? [])
          .valueBy((w) => w.id == data.orderInfo?.infoAdditional?.branchId);
      _orderRepository.orderDetailData.add(
        OrderDetailData<Order>(order: data, warehouse: findWH),
      );
    } else if (res is ResponseSuccessState<Quotation>) {
      final data = res.responseData;
      _orderRepository.orderDetailData.add(
        OrderDetailData<Quotation>(order: data),
      );
    }
  }

  Future<void> fetchOrderShipmentByCode({required String code}) async {
    final res = await _orderMiddleware.getOrderShipment(code: code);
    if (res is ResponseSuccessState<Map<String, dynamic>>) {
      final data = res.responseData;
      final currentDetail = _orderRepository.orderDetailData.valueOrNull;
      if (currentDetail != null) {
        Map<String, dynamic>? deliveryOrderRaw;
        OrderDelivery? orderDelivery;
        if (data['deliveryOrder'] != null &&
            data['deliveryOrder']?['status'] != null) {
          deliveryOrderRaw = Map<String, dynamic>.from(
            data['deliveryOrder'] as Map,
          );
          if (data['orderDelivery'] != null) {
            orderDelivery = OrderDelivery.fromMap(
              Map<String, dynamic>.from(data['orderDelivery'] as Map),
              data['deliveryOrder']?['status']?.toString() ?? "",
            );
          }
          _orderRepository.orderDetailData.add(
            currentDetail.copyWith(
              orderDelivery: orderDelivery,
              deliveryOrderRaw: deliveryOrderRaw,
            ),
          );
        }
      }
    }
  }

  Future<void> fetchOrderCustomerByCode({required String code}) async {
    final res = await _orderMiddleware.getOrderCustomer(code: code);
    if (res is ResponseSuccessState<Map<String, dynamic>>) {
      final data = res.responseData;
      final currentDetail = _orderRepository.orderDetailData.valueOrNull;
      if (currentDetail != null) {
        Customer? customer;
        if (data['customer'] != null) {
          customer = Customer.fromMap(
            Map<String, dynamic>.from(data['customer'] as Map),
          );
        }

        Address? billingAddress;
        if (data['orderInvoice'] != null) {
          billingAddress = Address.fromMap(
            Map<String, dynamic>.from(data['orderInvoice'] as Map),
          );
        }
        Address? purchaseAddress;
        if (data['orderDelivery'] != null) {
          purchaseAddress = Address.fromMap(
            Map<String, dynamic>.from(data['orderDelivery'] as Map),
          );
        }
        if (customer != null) {
          customer = customer.copyWith(
            purchaseAddress: purchaseAddress,
            billingAddress: billingAddress,
          );
        }
        _orderRepository.orderDetailData.add(
          currentDetail.copyWith(customer: customer),
        );
      }
    }
  }

  Future<void> fetchOrderAdditionalByCode({required String code}) async {
    final res = await _orderMiddleware.getOrderAdditional(code: code);
    if (res is ResponseSuccessState<Map<String, dynamic>>) {
      final data = res.responseData;
      final currentDetail = _orderRepository.orderDetailData.valueOrNull;
      if (currentDetail != null) {
        OrderInfo? orderInfo = currentDetail.orderInfo;
        if (data['orderInfo'] != null) {
          orderInfo = OrderInfo.fromMap(
            Map<String, dynamic>.from(data['orderInfo'] as Map),
          );
        }
        Warehouse? warehouse;
        if (data['warehouse'] != null) {
          warehouse = Warehouse.fromMap(
            Map<String, dynamic>.from(data['warehouse'] as Map),
          );
        }
        Staff? staff;
        if (data['staff'] != null) {
          staff = Staff.fromMap(
            Map<String, dynamic>.from(data['staff'] as Map),
          );
        }
        BasePerson? personCreated;
        if (data['createdByInfo'] != null) {
          personCreated = BasePerson.fromMap(
            Map<String, dynamic>.from(data['createdByInfo'] as Map),
          );
        }
        Company? company;
        if (data['company'] != null) {
          company = Company.fromMap(
            Map<String, dynamic>.from(data['company'] as Map),
          );
        }
        OrderInvoice? orderInvoice = currentDetail.orderInvoice;
        if (data['orderInvoice'] != null) {
          orderInvoice = OrderInvoice.fromMap(
            Map<String, dynamic>.from(data['orderInvoice'] as Map),
          );
        }
        _orderRepository.orderDetailData.add(
          currentDetail.copyWith(
            orderInfo: orderInfo,
            warehouse: warehouse,
            staff: staff,
            company: company,
            orderInvoice: orderInvoice,
            personCreated: personCreated,
          ),
        );
      }
    }
  }

  Future updateOrder() async {
    emit(UpdatingOrderState());
    if (_orderRepository.currentOrder == null) {
      return emit(
        UpdateFailedOrderState(
          ResponseFailedState(
            statusCode: -1,
            errorMessage: "Không tìm thấy đơn hàng của bạn!",
            apiError: 'Current order is null value.',
          ),
        ),
      );
    }
  }

  String? _getStatus(int index) {
    switch (index) {
      case 0:
        return OrderConstant.waitingConfirmation;
      case 1:
        return OrderConstant.finalized;
      case 2:
        return OrderConstant.completed;
      case 3:
        return OrderConstant.cancelled;
      default:
        return null;
    }
  }

  int _calcPage() {
    int page = 1;
    if (_orderRepository.totalOrders == 0) return page;
    page += _orderRepository.orders.length ~/ 5;
    return page;
  }

  Future<void> getProductVariants({
    int limit = 20,
    int offset = 0,
    String? keyword,
    String? branchId,
    ProductVariantCategoryCode? categoryCode,
    bool isInitialLoad = false, // Thêm parameter để xác định initial load
  }) async {
    // Phân biệt initial load và search để hiển thị loading phù hợp
    // Initial load: dùng modal dialog (user chưa nhập)
    // Search: dùng inline loading indicator (không ẩn keyboard)
    if (isInitialLoad) {
      emit(const OrderLoadingState()); // Modal loading
    } else {
      emit(const OrderLoadingState(event: "search")); // Inline loading
    }

    final result = await _orderMiddleware.getProductVariantsFilter(
      limit: limit,
      offset: offset,
      keyword: keyword,
      branchId: branchId,
      categoryCodes: categoryCode == .brandProduct
          ? [categoryCode!.toConstant]
          : null,
      coffeeCodes:
          <ProductVariantCategoryCode>[
            .greenBean,
            .roastedBean,
          ].contains(categoryCode)
          ? [categoryCode!.toConstant]
          : null,
    );

    if (result is ResponseSuccessListState<List<ProductVariant>>) {
      final variants = result.responseData;
      _orderRepository.productVariants.sink.add(variants);
      _orderRepository.productVariantsTotal = result.total;
      emit(OrderLoadedState());
    } else if (result is ResponseFailedState) {
      emit(OrderErrorState(error: result.errorMessage));
    }
  }

  Future<void> loadMoreProductVariants({
    int? offset,
    String? keyword,
    String? branchId,
    ProductVariantCategoryCode? categoryCode,
  }) async {
    emit(const OrderLoadingState(event: "loadMore"));
    final currentVariants = _orderRepository.productVariants.value;

    final result = await _orderMiddleware.getProductVariantsFilter(
      limit: 20,
      offset: offset ?? currentVariants.length,
      keyword: keyword,
      branchId: branchId,
      categoryCodes: categoryCode == .brandProduct
          ? [categoryCode!.toConstant]
          : null,
      coffeeCodes:
          [
            ProductVariantCategoryCode.greenBean,
            ProductVariantCategoryCode.roastedBean,
          ].contains(categoryCode)
          ? [categoryCode!.toConstant]
          : null,
    );
    if (result is ResponseSuccessListState<List<ProductVariant>>) {
      final variants = result.responseData;
      _orderRepository.productVariants.sink.add([
        ...currentVariants,
        ...variants,
      ]);
      emit(OrderLoadedState());
    } else if (result is ResponseFailedState) {
      emit(OrderErrorState(error: result.errorMessage));
    }
  }

  Future<void> sellerCreateOrder(CreateOrderDTO input) async {
    emit(LoadingOrderState());
    final result = await _orderMiddleware.sellerCreateOrder(input.toMap());
    if (result is ResponseSuccessState<String?>) {
      await getSellerOrders();
      emit(LoadedOrderState<String?>(data: result.responseData));
    } else if (result is ResponseFailedState) {
      emit(ErrorOrderState(error: result.errorMessage, detail: result));
    } else {
      emit(const ErrorOrderState(error: 'Có lỗi xảy ra khi tạo đơn hàng'));
    }
  }

  /// Get seller orders list with pagination
  ///
  /// Lấy danh sách đơn hàng của seller với pagination
  ///
  /// Parameters:
  /// - keyword: Từ khóa tìm kiếm (optional)
  /// - limit: Số lượng đơn hàng mỗi trang (default: 20)
  /// - offset: Vị trí bắt đầu (default: 0)
  /// - isInitialLoad: Có phải lần load đầu tiên không (default: true)
  /// - event: Event type ("", "search", "refresh")
  Future<void> getSellerOrders({
    String? keyword,
    int limit = 20,
    int offset = 0,
    String event = "",
    String? status,
    String? createdAtFrom,
    String? createdAtTo,
  }) async {
    emit(OrderLoadingState(event: event));

    final result = await _orderMiddleware.getSellerOrders(
      keyword: keyword,
      status: status,
      limit: limit,
      offset: offset,
      createdAtFrom: createdAtFrom,
      createdAtTo: createdAtTo,
    );

    if (result is ResponseSuccessListState<List<Order>>) {
      _orderRepository.sellerOrders.sink.add(result.responseData);
      _orderRepository.totalSellerOrders = result.total;
      emit(OrderLoadedState());
    } else if (result is ResponseFailedState) {
      emit(OrderErrorState(error: result.errorMessage, detail: result));
    } else {
      emit(
        const OrderErrorState(
          error: 'Có lỗi xảy ra khi tải danh sách đơn hàng',
        ),
      );
    }
  }

  Future<void> getQuotations({
    String? keyword,
    int limit = 20,
    int offset = 0,
    String event = "",
    String? status,
  }) async {
    emit(OrderLoadingState(event: event));

    final result = await _orderMiddleware.getQuotations(
      keyword: keyword,
      status: status,
      limit: limit,
      offset: offset,
    );

    if (result is ResponseSuccessListState<List<Quotation>>) {
      _orderRepository.quotations.sink.add(result.responseData);
      _orderRepository.totalQuotations = result.total;
      emit(OrderLoadedState());
    } else if (result is ResponseFailedState) {
      emit(OrderErrorState(error: result.errorMessage, detail: result));
    } else {
      emit(
        const OrderErrorState(
          error: 'Có lỗi xảy ra khi tải danh sách đơn hàng',
        ),
      );
    }
  }

  /// Load more seller orders
  Future<void> loadMoreQuotations({
    String? keyword,
    int limit = 20,
    int offset = 0,
    String? status,
  }) async {
    emit(OrderLoadingState(event: BaseEvent.loadMore.name));
    final result = await _orderMiddleware.getQuotations(
      keyword: keyword,
      status: status,
      limit: limit,
      offset: offset,
    );
    if (result is ResponseSuccessListState<List<Quotation>>) {
      final currentQuotations = _orderRepository.quotations.valueOrNull ?? [];
      _orderRepository.quotations.sink.add([
        ...currentQuotations,
        ...result.responseData,
      ]);
      _orderRepository.totalQuotations = result.total;
      emit(OrderLoadedState());
    } else if (result is ResponseFailedState) {
      emit(OrderErrorState(error: result.errorMessage, detail: result));
    } else {
      emit(
        const OrderErrorState(
          error: 'Có lỗi xảy ra khi tải danh sách phiếu báo giá',
        ),
      );
    }
  }

  /// Load more seller orders
  Future<void> loadMoreSellerOrders({
    String? keyword,
    int limit = 20,
    int offset = 0,
    String? status,
    String? createdAtFrom,
    String? createdAtTo,
  }) async {
    // await getSellerOrders(
    //   keyword: keyword,
    //   offset: offset,
    //   isInitialLoad: false,
    //   event: "",
    // );

    emit(OrderLoadingState(event: BaseEvent.loadMore.name));
    final result = await _orderMiddleware.getSellerOrders(
      keyword: keyword,
      status: status,
      limit: limit,
      offset: offset,
      createdAtFrom: createdAtFrom,
      createdAtTo: createdAtTo,
    );
    if (result is ResponseSuccessListState<List<Order>>) {
      final currentOrders = _orderRepository.sellerOrders.valueOrNull ?? [];
      _orderRepository.sellerOrders.sink.add([
        ...currentOrders,
        ...result.responseData,
      ]);
      _orderRepository.totalSellerOrders = result.total;
      emit(OrderLoadedState());
    } else if (result is ResponseFailedState) {
      emit(OrderErrorState(error: result.errorMessage, detail: result));
    } else {
      emit(
        const OrderErrorState(
          error: 'Có lỗi xảy ra khi tải danh sách đơn hàng',
        ),
      );
    }
  }

  Future<void> getDeliveryMethods() async {
    emit(LoadingOrderState());
    final result = await _orderMiddleware.getActiveDeliveryGroups();
    if (result is ResponseSuccessState<List<DeliveryGroup>>) {
      _orderRepository.deliveryMethods.sink.add(result.responseData);
      emit(LoadedOrderState());
    } else if (result is ResponseFailedState) {
      emit(ErrorOrderState(error: result.errorMessage, detail: result));
    }
  }

  Future<void> createQuotation(CreateQuotationInput input) async {
    emit(LoadingOrderState());
    final result = await _orderMiddleware.createQuotation(input);
    if (result is ResponseSuccessState<String?>) {
      await getQuotations();
      emit(LoadedOrderState<String?>(data: result.responseData));
    } else if (result is ResponseFailedState) {
      emit(ErrorOrderState(error: result.errorMessage, detail: result));
    } else {
      emit(const ErrorOrderState(error: 'Tạo phiếu báo giá thất bại!'));
    }
  }

  Future<void> editQuotation(String code, CreateQuotationInput input) async {
    emit(LoadingOrderState());
    final result = await _orderMiddleware.editQuotation(code, input);
    if (result is ResponseSuccessState<String?>) {
      await getQuotations();
      emit(LoadedOrderState<String?>(data: result.responseData));
    } else if (result is ResponseFailedState) {
      emit(ErrorOrderState(error: result.errorMessage, detail: result));
    } else {
      emit(const ErrorOrderState(error: 'Chỉnh sửa phiếu báo giá thất bại!'));
    }
  }

  Future<Quotation?> getDetailsQuotation(String code) async {
    emit(LoadingOrderState());
    if (_warehouseRepository.warehouses.isEmpty) {
      await _commonService.loadWarehousesData();
    }
    final result = await _orderMiddleware.getQuotationByCode(code);
    if (result is ResponseSuccessState<Quotation>) {
      final whList = _warehouseRepository.warehouses;
      final findTarget = whList.valueBy(
        (wh) =>
            wh.id == (result.responseData.orderInfo?.infoAdditional?.branchId),
      );

      final quotationDetails = result.responseData..setWarehouse(findTarget);
      emit(LoadedOrderState<Quotation>(data: quotationDetails));
      return quotationDetails;
    } else if (result is ResponseFailedState) {
      emit(
        ErrorOrderState<String>(
          error: result,
          detail: AppConstant.strings.notFound,
        ),
      );
    } else {
      emit(
        ErrorOrderState<String>(
          error: result,
          detail: AppConstant.strings.notFound,
        ),
      );
    }
    return null;
  }

  Future<bool> updateQuotationPayment(String code, BankInfo payment) async {
    final result = await _orderMiddleware.updateQuotationPayment(
      code,
      payment.code,
    );
    if (result is ResponseSuccessState<bool>) {
      return result.responseData;
    } else if (result is ResponseFailedState) {
      return false;
    }
    return false;
  }

  Future<void> cancelQuotation(String code) async {
    emit(LoadingOrderState());
    final result = await _orderMiddleware.cancelQuotation(code);
    if (result is ResponseSuccessState<bool>) {
      if (result.responseData) {
        emit(LoadedOrderState<String>(data: "Hủy báo giá thành công!"));
      } else {
        emit(ErrorOrderState<String>(detail: "Hủy báo giá thất bại!"));
      }
    } else {
      emit(ErrorOrderState<String>(detail: "Hủy báo giá thất bại!"));
    }
  }

  Future<void> reviewQuotation(ReviewQuotationInput input) async {
    String messageByStatus() {
      if (input.status == QuoteStatus.approved) {
        return "Duyệt phiếu báo giá thất bại!";
      } else if (input.status == QuoteStatus.rejected) {
        return "Từ chối phiếu báo giá thất bại!";
      } else {
        return "Không thể thực hiện thao tác này!";
      }
    }

    emit(LoadingOrderState());
    final result = await _orderMiddleware.reviewQuotation(input);
    if (result is ResponseSuccessState<bool>) {
      if (result.responseData) {
        final message = input.status == QuoteStatus.approved
            ? "Duyệt phiếu báo giá thành công!"
            : "Từ chối phiếu báo giá thành công!";
        emit(LoadedOrderState<String>(data: message));
      } else {
        emit(ErrorOrderState<String>(detail: messageByStatus()));
      }
    } else {
      emit(ErrorOrderState<String>(detail: messageByStatus()));
    }
  }
}
