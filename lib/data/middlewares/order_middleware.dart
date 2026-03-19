import 'package:dio/dio.dart';
import 'package:zili_coffee/data/middlewares/base_middleware.dart';
import 'package:zili_coffee/data/models/cart/product_cart.dart';
import 'package:zili_coffee/data/models/order/create_order_input.dart';
import 'package:zili_coffee/data/models/order/delivery_group.dart';
import 'package:zili_coffee/data/models/order/order.dart';
import 'package:zili_coffee/data/models/product/order_product.dart';
import 'package:zili_coffee/data/network/network_response_object.dart';
import 'package:zili_coffee/data/network/network_response_state.dart';
import 'package:zili_coffee/data/network/network_url.dart';
import 'package:zili_coffee/data/models/product/product_variant.dart';

import '../../utils/app_logger.dart';
import '../dto/quotation/create_quotation.dart';
import '../dto/quotation/review_quotation.dart';
import '../models/quotation/quotation.dart';

class OrderMiddleware extends BaseMiddleware {
  Future<ResponseState> getDetailOrderByID({required String id}) async {
    try {
      final response = await dio.get<NWResponse>(
        NetworkUrl.order.get(id: id),
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess<Map<String, dynamic>>) {
        return ResponseSuccessState(
          statusCode: response.statusCode ?? -1,
          responseData: Order.fromMap(resultData.data['order']),
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

  Future<ResponseState> getAllOrders({
    required String userID,
    int? page,
    String? status,
    String? receivedStatus,
  }) async {
    try {
      final response = await dio.get<NWResponse>(
        NetworkUrl.order.getAll,
        queryParameters: {
          orderConstant.perPage: 5,
          orderConstant.page: page ?? 1,
          orderConstant.customerId: userID,
          orderConstant.status: status,
          orderConstant.receivedStatus: receivedStatus,
        },
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess<Map<String, dynamic>>) {
        final List<dynamic> ordersData = resultData.data['orders'];
        return ResponseSuccessState(
          statusCode: response.statusCode ?? -1,
          responseData: {
            "orders": ordersData.map((data) => Order.fromMap(data)).toList(),
            "totalRecords": resultData.data["totalRecords"],
          },
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

  Future<ResponseState> createOrder({required List<ProductCart> prods}) async {
    final items = prods
        .map(
          (prodCart) => {
            "fulfillment_status": "new",
            "gift_card": false,
            "product_id": prodCart.productID,
            "quantity": prodCart.qty,
            "variant_id": prodCart.variantID,
          },
        )
        .toList();
    try {
      final response = await dio.post<NWResponse>(
        NetworkUrl.order.create,
        data: {"is_box": false, "is_free_ship": false, "items": items},
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess<Map<String, dynamic>>) {
        return ResponseSuccessState(
          statusCode: response.statusCode ?? -1,
          responseData: Order.fromMap(resultData.data['order']),
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

  Future<ResponseState> updateOrder({required Order order}) async {
    try {
      final response = await dio.put<NWResponse>(
        NetworkUrl.order.update,
        data: order.toJson(),
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess<Map<String, dynamic>>) {
        return ResponseSuccessState(
          statusCode: response.statusCode ?? -1,
          responseData: Order.fromMap(resultData.data['order']),
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

  /// Get list of products for order creation
  Future<ResponseState> getProductsForOrder({
    int limit = 10,
    int offset = 0,
    String? keyword,
    String? branchId,
  }) async {
    try {
      final response = await coreDio.get<NWResponse>(
        NetworkUrl.orderProduct.filter,
        queryParameters: {
          'limit': limit,
          'offset': offset,
          if (keyword != null && keyword.isNotEmpty) 'keyword': keyword,
          if (branchId != null && branchId.isNotEmpty) 'branchId': branchId,
        },
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess) {
        final data = resultData.data;
        int count = 0;
        List<OrderProduct> products = [];

        if (data is Map<String, dynamic>) {
          count = data['count'] ?? 0;
          final productsData = data['products'] as List<dynamic>?;
          if (productsData != null) {
            products = productsData
                .map(
                  (item) => OrderProduct.fromMap(item as Map<String, dynamic>),
                )
                .toList();
          }
        }

        return ResponseSuccessState(
          statusCode: response.statusCode ?? -1,
          responseData: {'count': count, 'products': products},
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

  /// Get list of product variants filtered by keyword
  ///
  /// API: GET /company/product/variant/filter
  ///
  /// Parameters:
  /// - keyword: Search keyword (optional)
  /// - branchId: Branch/Warehouse ID to filter (optional)
  /// - categoryCode: Category code to filter (optional)
  /// - limit: Number of items per page (default: 20)
  /// - offset: Pagination offset (default: 0)
  Future<ResponseState> getProductVariantsFilter({
    int limit = 20,
    int offset = 0,
    String? keyword,
    String? branchId,
    List<String>? categoryCodes, // Use categoryCode just only for brand product
    List<String>?
    coffeeCodes, // Use coffeeCodes for green bean and roasted bean
  }) async {
    try {
      final response = await coreDio.get<NWResponse>(
        '/company/product/variant/filter',
        queryParameters: {
          'limit': limit,
          'offset': offset,
          if (keyword != null && keyword.isNotEmpty) 'keyword': keyword,
          if (branchId != null && branchId.isNotEmpty) 'branchId': branchId,
          if (categoryCodes != null && categoryCodes.isNotEmpty)
            'categoryCodes[]': categoryCodes.join(','),
          if (coffeeCodes != null && coffeeCodes.isNotEmpty)
            'coffeeCodes[]': coffeeCodes.join(','),
        },
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess) {
        final data = resultData.data;
        int count = 0;
        List<ProductVariant> variants = [];

        if (data is Map<String, dynamic>) {
          count = data['count'] ?? data['total'] ?? 0;

          // Try different possible response structures
          final variantsData =
              data['variants'] ??
              data['data'] ??
              data['listData'] ??
              (data['results'] as List<dynamic>?);

          if (variantsData != null && variantsData is List) {
            variants = variantsData
                .map((item) {
                  if (item is Map<String, dynamic>) {
                    return ProductVariant.fromMap(item);
                  }
                  return null;
                })
                .whereType<ProductVariant>()
                .toList();
          }
        }

        return ResponseSuccessListState<List<ProductVariant>>(
          statusCode: response.statusCode ?? -1,
          total: count,
          responseData: variants,
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

  /// Create order by seller
  ///
  /// Tạo đơn hàng bởi seller với CreateOrderInput
  ///
  /// API: POST /enterprise/order/create
  /// Service: Core
  ///
  /// Parameters:
  /// - input: CreateOrderInput object chứa thông tin đơn hàng
  ///
  /// Returns:
  /// - ResponseSuccessState<Order> nếu thành công
  /// - ResponseFailedState nếu có lỗi
  Future<ResponseState> sellerCreateOrder(Map<String, dynamic> body) async {
    try {
      AppLogger.d('sellerCreateOrder: ${body.toString()}');
      final response = await coreDio.post<NWResponse>(
        '/enterprise/order/create',
        data: body,
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess<Map<String, dynamic>>) {
        return ResponseSuccessState<String?>(
          statusCode: response.statusCode ?? -1,
          responseData: (resultData.data['code'])?.toString(),
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

  /// Get active delivery groups
  ///
  /// Lấy danh sách delivery groups đang active
  ///
  /// API: GET /company/delivery-group/active
  /// Service: Core
  ///
  /// Returns:
  /// - ResponseSuccessState<List<DeliveryGroup>> nếu thành công
  /// - ResponseFailedState nếu có lỗi
  Future<ResponseState> getActiveDeliveryGroups() async {
    try {
      final response = await coreDio.get<NWResponse>(
        '/company/delivery-group/active',
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess) {
        final data = resultData.data;
        List<DeliveryGroup> deliveryGroups = [];

        if (data is List) {
          deliveryGroups = data
              .map<DeliveryGroup>(
                (item) => DeliveryGroup.fromMap(item as Map<String, dynamic>),
              )
              .toList();
        } else if (data is Map<String, dynamic>) {
          // Nếu response là object, thử extract từ các keys phổ biến
          final items =
              data['data'] ??
              data['listData'] ??
              data['deliveryGroups'] ??
              data;
          if (items is List) {
            deliveryGroups = items
                .map<DeliveryGroup>(
                  (item) => DeliveryGroup.fromMap(item as Map<String, dynamic>),
                )
                .toList();
          } else if (items is Map<String, dynamic>) {
            // Nếu là single object, wrap trong list
            deliveryGroups = [DeliveryGroup.fromMap(items)];
          }
        }

        return ResponseSuccessState(
          statusCode: response.statusCode ?? -1,
          responseData: deliveryGroups,
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

  /// Get seller orders list
  ///
  /// Lấy danh sách đơn hàng của seller với pagination
  ///
  /// API: GET /company/order-app/filter
  /// Service: Core
  ///
  /// Parameters:
  /// - limit: Số lượng đơn hàng mỗi trang (default: 20)
  /// - offset: Vị trí bắt đầu (default: 0)
  ///
  /// Returns:
  /// - ResponseSuccessState với structure:
  ///   {
  ///     "orders": List<Order>,
  ///     "total": int,
  ///   }
  /// - ResponseFailedState nếu có lỗi
  Future<ResponseState> getSellerOrders({
    int limit = 20,
    int offset = 0,
    String? keyword,
    String? status,
    String? createdAtFrom,
    String? createdAtTo,
  }) async {
    try {
      final response = await coreDio.get<NWResponse>(
        '/company/order-app/filter',
        queryParameters: {
          'limit': limit,
          'offset': offset,
          if (keyword != null && keyword.isNotEmpty) 'keyword': keyword,
          if (status != null && status.isNotEmpty) 'orderStatus[]': status,
          if (createdAtFrom != null && createdAtFrom.isNotEmpty)
            'createdAtFrom': createdAtFrom,
          if (createdAtTo != null && createdAtTo.isNotEmpty)
            'createdAtTo': createdAtTo,
        },
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess<Map<String, dynamic>>) {
        final data = resultData.data;

        final List<dynamic> ordersData = data['listData'] ?? [];
        final List<Order> orders = ordersData
            .map((item) => Order.fromMapNew(item as Map<String, dynamic>))
            .toList();

        return ResponseSuccessListState<List<Order>>(
          statusCode: response.statusCode ?? -1,
          total: data['total'] as int? ?? 0,
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

  Future<ResponseState> getQuotations({
    int limit = 20,
    int offset = 0,
    String? keyword,
    String? status,
    String? createdAtFrom,
    String? createdAtTo,
  }) async {
    try {
      final response = await coreDio.get<NWResponse>(
        '/company/quotation-order/filter',
        queryParameters: {
          'limit': limit,
          'offset': offset,
          if (keyword != null && keyword.isNotEmpty) 'keyword': keyword,
          if (status != null && status.isNotEmpty) 'arrayStatus[]': status,
          if (createdAtFrom != null && createdAtFrom.isNotEmpty)
            'createdAtFrom': createdAtFrom,
          if (createdAtTo != null && createdAtTo.isNotEmpty)
            'createdAtTo': createdAtTo,
        },
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess<Map<String, dynamic>>) {
        final data = resultData.data;

        final List<dynamic> quotationsData = data['listData'] ?? [];
        final List<Quotation> quotations = quotationsData
            .map((item) => Quotation.fromMap(item as Map<String, dynamic>))
            .toList();

        return ResponseSuccessListState<List<Quotation>>(
          statusCode: response.statusCode ?? -1,
          total: data['total'] as int? ?? 0,
          responseData: quotations,
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

  /// Lấy thông tin cơ bản đơn hàng theo code (base)
  Future<ResponseState> getOrderBase({required String code}) async {
    try {
      final response = await coreDio.get<NWResponse>(
        '/company/order-app/$code/base',
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess<Map<String, dynamic>>) {
        final data = resultData.data;
        // final hasQuotationCode = data['quotationCode'] != null;
        // if (hasQuotationCode) {
        //   return ResponseSuccessState<Quotation>(
        //     statusCode: response.statusCode ?? -1,
        //     responseData: Quotation.fromMap(data),
        //   );
        // }
        return ResponseSuccessState<Order>(
          statusCode: response.statusCode ?? -1,
          responseData: Order.fromMapNew(data),
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

  /// Lấy thông tin vận đơn hiện tại
  Future<ResponseState> getOrderShipment({required String code}) async {
    try {
      final response = await coreDio.get<NWResponse>(
        '/company/order-app/$code/shipment',
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess<Map<String, dynamic>>) {
        return ResponseSuccessState<Map<String, dynamic>>(
          statusCode: response.statusCode ?? -1,
          responseData: Map<String, dynamic>.from(resultData.data),
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

  /// Lấy thông tin khách hàng của đơn hàng
  Future<ResponseState> getOrderCustomer({required String code}) async {
    try {
      final response = await coreDio.get<NWResponse>(
        '/company/order-app/$code/customer',
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess<Map<String, dynamic>>) {
        return ResponseSuccessState<Map<String, dynamic>>(
          statusCode: response.statusCode ?? -1,
          responseData: Map<String, dynamic>.from(resultData.data),
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

  /// Lấy thông tin bổ sung vận hành
  Future<ResponseState> getOrderAdditional({required String code}) async {
    try {
      final response = await coreDio.get<NWResponse>(
        '/company/order-app/$code/additional',
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess<Map<String, dynamic>>) {
        return ResponseSuccessState<Map<String, dynamic>>(
          statusCode: response.statusCode ?? -1,
          responseData: Map<String, dynamic>.from(resultData.data),
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

  /// Create quotation by sales
  ///
  /// Tạo phiếu báo giá bởi sales với CreateQuotationInput
  ///
  /// API: POST /company/quotation-order
  /// Service: Core
  ///
  /// Parameters:
  /// - input: CreateQuotationInput object chứa thông tin phiếu báo giá
  ///
  /// Returns:
  /// - ResponseSuccessState<String?> nếu thành công
  /// - ResponseFailedState nếu có lỗi
  Future<ResponseState> createQuotation(CreateQuotationInput input) async {
    try {
      final response = await coreDio.post<NWResponse>(
        '/company/quotation-order',
        data: input.toMap(),
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess<Map<String, dynamic>>) {
        return ResponseSuccessState<String?>(
          statusCode: response.statusCode ?? -1,
          responseData: (resultData.data['code'])?.toString(),
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

  /// Create quotation by sales
  ///
  /// Tạo phiếu báo giá bởi sales với CreateQuotationInput
  ///
  /// API: PUT /company/quotation-order/info/{code}
  /// Service: Core
  ///
  /// Parameters:
  /// - input: CreateQuotationInput object chứa thông tin phiếu báo giá
  ///
  /// Returns:
  /// - ResponseSuccessState<String?> nếu thành công
  /// - ResponseFailedState nếu có lỗi
  Future<ResponseState> editQuotation(String code, CreateQuotationInput input) async {
    try {
      final response = await coreDio.put<NWResponse>(
        '/company/quotation-order/info/$code',
        data: input.toMap(),
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess<Map<String, dynamic>>) {
        return ResponseSuccessState<String?>(
          statusCode: response.statusCode ?? -1,
          responseData: (resultData.data['code'])?.toString(),
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

  Future<ResponseState> getQuotationByCode(String code) async {
    try {
      final response = await coreDio.get<NWResponse>(
        '/company/quotation-order/$code',
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess<Map<String, dynamic>>) {
        return ResponseSuccessState<Quotation>(
          statusCode: response.statusCode ?? -1,
          responseData: Quotation.fromMap(resultData.data),
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

  Future<ResponseState> updateQuotationPayment(
    String code,
    String bankingCode,
  ) async {
    try {
      final response = await coreDio.put<NWResponse>(
        '/company/quotation-order/$code',
        data: {'bankingCode': bankingCode},
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess<Map<String, dynamic>>) {
        return ResponseSuccessState<bool>(
          statusCode: response.statusCode ?? -1,
          responseData: (resultData.data['status']) == 1,
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

  Future<ResponseState> cancelQuotation(String code) async {
    try {
      final response = await coreDio.post<NWResponse>(
        '/company/quotation-order/cancel',
        data: {'code': code},
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess<Map<String, dynamic>>) {
        return ResponseSuccessState<bool>(
          statusCode: response.statusCode ?? -1,
          responseData: (resultData.data['status']) == 1,
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

  /// Review quotation by accountant
  ///
  /// Xét duyệt phiếu báo giá bởi sales với ReviewQuotationInput
  ///
  /// API: POST /company/quotation-order/review
  /// Service: Core
  ///
  /// Parameters:
  /// - Input:
  /// ```
  /// code: String
  /// status: REJECTED | APPROVED
  /// reasonNote: String?
  /// reasonId: int?
  /// ```
  ///
  /// Returns:
  /// - [ResponseSuccessState] nếu thành công
  /// - [ResponseFailedState] nếu có lỗi
  Future<ResponseState> reviewQuotation(ReviewQuotationInput input) async {
    try {
      final response = await coreDio.post<NWResponse>(
        '/company/quotation-order/review',
        data: input.toMap(),
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess<Map<String, dynamic>>) {
        return ResponseSuccessState<bool>(
          statusCode: response.statusCode ?? -1,
          responseData: (resultData.data['status']) == 1,
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
