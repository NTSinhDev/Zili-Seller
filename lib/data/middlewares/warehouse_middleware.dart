import 'package:dio/dio.dart';
import 'package:zili_coffee/data/middlewares/base_middleware.dart';
import 'package:zili_coffee/data/models/product/product_variant.dart';
import 'package:zili_coffee/data/models/warehouse/roasting_slip.dart';
import 'package:zili_coffee/data/models/warehouse/packing_slip.dart';
import 'package:zili_coffee/data/models/warehouse/roasting_slip_detail.dart';
import 'package:zili_coffee/data/models/warehouse/packing_slip_detail.dart';
import 'package:zili_coffee/data/models/warehouse/packing_slip_item.dart';
import 'package:zili_coffee/data/network/network_response_object.dart';
import 'package:zili_coffee/data/network/network_response_state.dart';

import '../../utils/enums.dart';
import '../../utils/enums/warehouse_enum.dart';
import '../../utils/extension/extension.dart';
import '../models/warehouse/warehouse.dart';

class WarehouseMiddleware extends BaseMiddleware {
  /// Get list of warehouses (chi nhánh)
  ///
  /// API: GET /seller/warehouse
  ///
  /// Query Parameters:
  /// - limit: int (optional, default: 10)
  /// - offset: int (optional, default: 0)
  ///
  /// Returns: `ResponseState<List<Warehouse>>`
  Future<ResponseState> getSellerWarehouses({
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      // Use authDio for seller API
      final response = await authDio.get<NWResponse>(
        '/seller/warehouse',
        queryParameters: {'limit': limit, 'offset': offset},
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess) {
        final data = resultData.data;
        final warehousesData = data['listData'] as List<dynamic>;
        return ResponseSuccessState<List<Warehouse>>(
          statusCode: response.statusCode ?? -1,
          responseData: warehousesData
              .map((item) => Warehouse.fromMap(item))
              .toList(),
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

  Future<ResponseState> filterWarehouseVariants({
    int limit = 20,
    int offset = 0,
    String? keyword,
    DateTime? createdAtFrom,
    DateTime? createdAtTo,
  }) async {
    try {
      final response = await coreDio.get<NWResponse>(
        '/coffee-variant/green-bean/filter',
        queryParameters: {
          'limit': limit,
          'offset': offset,
          if (keyword != null && keyword.isNotEmpty) 'keyword': keyword,
          if (createdAtFrom != null)
            'createdAtFrom': createdAtFrom.toIso8601StringWithTimezone(),
          if (createdAtTo != null)
            'createdAtTo': createdAtTo.toIso8601StringWithTimezone(),
        },
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess) {
        final raw = resultData.data;
        List<dynamic> list = [];
        int total = 0;

        if (raw is Map<String, dynamic>) {
          list = (raw['listData']) as List<dynamic>;
          total = (raw['total'] ?? list.length) as int;
        } else if (raw is List) {
          list = raw;
          total = raw.length;
        }

        final items = list
            .whereType<Map<String, dynamic>>()
            .map(ProductVariant.fromMap)
            .toList();

        return ResponseSuccessListState<List<ProductVariant>>(
          statusCode: response.statusCode ?? -1,
          responseData: items,
          total: total,
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

  /// Filter variant special (sản phẩm đặc biệt)
  /// API: GET /company/product/variant-special/filter
  /// Params: limit, offset, keyword (optional)
  Future<ResponseState> filterVariantSpecial({
    int limit = 20,
    int offset = 0,
    String? keyword,
    DateTime? createdAtFrom,
    DateTime? createdAtTo,
  }) async {
    try {
      final response = await coreDio.get<NWResponse>(
        '/company/product/variant-special/filter',
        queryParameters: {
          'limit': limit,
          'offset': offset,
          if (keyword != null && keyword.isNotEmpty) 'keyword': keyword,
          if (createdAtFrom != null)
            'createdAtFrom': createdAtFrom.toIso8601StringWithTimezone(),
          if (createdAtTo != null)
            'createdAtTo': createdAtTo.toIso8601StringWithTimezone(),
        },
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess) {
        final raw = resultData.data;
        List<dynamic> list = [];
        int total = 0;

        if (raw is Map<String, dynamic>) {
          list =
              (raw['listData'] ??
                      raw['data'] ??
                      raw['items'] ??
                      raw['rows'] ??
                      raw['variants'] ??
                      [])
                  as List<dynamic>;
          total = (raw['count'] ?? raw['total'] ?? list.length) as int;
        } else if (raw is List) {
          list = raw;
          total = raw.length;
        }

        final items = list
            .whereType<Map<String, dynamic>>()
            .map(ProductVariant.fromMap)
            .toList();

        return ResponseSuccessListState<List<ProductVariant>>(
          statusCode: response.statusCode ?? -1,
          responseData: items,
          total: total,
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

  /// Filter packing list
  /// API: GET /company/packing/filter
  Future<ResponseState> filterPacking({
    int limit = 20,
    int offset = 0,
    String? keyword,
    List<String>? statuses,
    DateTime? createdAtFrom,
    DateTime? createdAtTo,
  }) async {
    try {
      final response = await coreDio.get<NWResponse>(
        '/company/packing/filter',
        queryParameters: {
          'limit': limit,
          'offset': offset,
          if (keyword != null && keyword.isNotEmpty) 'keyword': keyword,
          if (statuses != null && statuses.isNotEmpty) 'status[]': statuses,
          if (createdAtFrom != null)
            'createdAtFrom': createdAtFrom.toIso8601StringWithTimezone(),
          if (createdAtTo != null)
            'createdAtTo': createdAtTo.toIso8601StringWithTimezone(),
        },
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess) {
        final raw = resultData.data;
        List<dynamic> list = [];
        int total = 0;

        if (raw is Map<String, dynamic>) {
          list =
              (raw['listData'] ??
                      raw['data'] ??
                      raw['items'] ??
                      raw['rows'] ??
                      [])
                  as List<dynamic>;
          total = (raw['count'] ?? raw['total'] ?? list.length) as int;
        } else if (raw is List) {
          list = raw;
          total = raw.length;
        }

        final items = list
            .whereType<Map<String, dynamic>>()
            .map(PackingSlip.fromMap)
            .toList();

        return ResponseSuccessListState<List<PackingSlip>>(
          statusCode: response.statusCode ?? -1,
          responseData: items,
          total: total,
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

  Future<ResponseState> filterRoastingSlips({
    int limit = 20,
    int offset = 0,
    String? keyword,
    List<RoastingSlipStatus>? statusList,
    DateTime? createdAtFrom,
    DateTime? createdAtTo,
  }) async {
    try {
      final response = await coreDio.get<NWResponse>(
        '/coffee-variant/roasting-slip/filter',
        queryParameters: {
          'limit': limit,
          'offset': offset,
          if (keyword != null && keyword.isNotEmpty) 'keyword': keyword,
          if (statusList != null && statusList.isNotEmpty)
            'status[]': statusList.map((e) => e.toConstant).toList(),
          if (createdAtFrom != null)
            'createdAtFrom': createdAtFrom.toIso8601StringWithTimezone(),
          if (createdAtTo != null)
            'createdAtTo': createdAtTo.toIso8601StringWithTimezone(),
        },
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess) {
        final raw = resultData.data;
        List<dynamic> list = [];
        int total = 0;

        if (raw is Map<String, dynamic>) {
          list =
              (raw['listData'] ??
                      raw['data'] ??
                      raw['items'] ??
                      raw['rows'] ??
                      raw['variants'] ??
                      [])
                  as List<dynamic>;
          total = (raw['count'] ?? raw['total'] ?? list.length) as int;
        } else if (raw is List) {
          list = raw;
          total = raw.length;
        }

        final items = list
            .whereType<Map<String, dynamic>>()
            .map(RoastingSlip.fromMap)
            .toList();

        return ResponseSuccessListState<List<RoastingSlip>>(
          statusCode: response.statusCode ?? -1,
          responseData: items,
          total: total,
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

  /// Filter roasting slips by roasted bean id
  ///
  /// API: GET /coffee-variant/roasting-slip/filter?roastedBeanId={roastedBeanId}
  Future<ResponseState> getRoastingSlipsById(String roastedBeanId) async {
    try {
      final response = await coreDio.get<NWResponse>(
        '/coffee-variant/roasting-slip/filter',
        queryParameters: {'roastedBeanId': roastedBeanId},
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess) {
        final raw = resultData.data;
        List<dynamic> list = [];
        int total = 0;

        if (raw is Map<String, dynamic>) {
          list = (raw['listData'] ?? []) as List<dynamic>;
          total = (raw['total'] ?? 0) as int;
        } else if (raw is List) {
          list = raw;
          total = raw.length;
        }

        final List<RoastingSlip> items = list
            .whereType<Map<String, dynamic>>()
            .map(RoastingSlip.fromMap)
            .toList();

        return ResponseSuccessListState<List<RoastingSlip>>(
          statusCode: response.statusCode ?? -1,
          responseData: items,
          total: total,
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

  /// Get total roasting slips with status
  ///
  /// API: GET /coffee-variant/roasting-slip/total
  Future<ResponseState> getTotalRoastingSlips() async {
    try {
      final response = await coreDio.get<NWResponse>(
        '/coffee-variant/roasting-slip/total',
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess) {
        final pending = resultData.data["totalNewRequest"] != null
            ? int.tryParse(resultData.data["totalNewRequest"].toString()) ?? 0
            : 0;
        final processing = resultData.data["totalRoasting"] != null
            ? int.tryParse(resultData.data["totalRoasting"].toString()) ?? 0
            : 0;
        final completed = resultData.data["totalCompleted"] != null
            ? int.tryParse(resultData.data["totalCompleted"].toString()) ?? 0
            : 0;
        return ResponseSuccessState<List<int>>(
          statusCode: response.statusCode ?? -1,
          responseData: [pending, processing, completed],
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

  /// Get total roasting slips with status
  ///
  /// API: GET /company/packing//total
  Future<ResponseState> getTotalPackingSlips() async {
    try {
      final response = await coreDio.get<NWResponse>(
        '/company/packing//total',
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess) {
        final pending = resultData.data["totalNewRequest"] != null
            ? int.tryParse(resultData.data["totalNewRequest"].toString()) ?? 0
            : 0;
        final processing = resultData.data["totalProcessing"] != null
            ? int.tryParse(resultData.data["totalProcessing"].toString()) ?? 0
            : 0;
        final completed = resultData.data["totalCompleted"] != null
            ? int.tryParse(resultData.data["totalCompleted"].toString()) ?? 0
            : 0;
        return ResponseSuccessState<List<int>>(
          statusCode: response.statusCode ?? -1,
          responseData: [pending, processing, completed],
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

  /// Filter roasted beans
  ///
  /// API: GET /coffee-variant/roasted-bean/filter
  /// Params: limit, offset, keyword (optional)
  Future<ResponseState> filterRoastedBeans({
    int limit = 20,
    int offset = 0,
    String? keyword,
    DateTime? createdAtFrom,
    DateTime? createdAtTo,
  }) async {
    try {
      final response = await coreDio.get<NWResponse>(
        '/coffee-variant/roasted-bean/filter',
        queryParameters: {
          'limit': limit,
          'offset': offset,
          if (keyword != null && keyword.isNotEmpty) 'keyword': keyword,
          if (createdAtFrom != null)
            'createdAtFrom': createdAtFrom.toIso8601StringWithTimezone(),
          if (createdAtTo != null)
            'createdAtTo': createdAtTo.toIso8601StringWithTimezone(),
        },
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess) {
        final raw = resultData.data;
        List<dynamic> list = [];
        int total = 0;

        if (raw is Map<String, dynamic>) {
          list =
              (raw['listData'] ??
                      raw['data'] ??
                      raw['items'] ??
                      raw['rows'] ??
                      [])
                  as List<dynamic>;
          total = (raw['count'] ?? raw['total'] ?? list.length) as int;
        } else if (raw is List) {
          list = raw;
          total = raw.length;
        }

        final items = list
            .whereType<Map<String, dynamic>>()
            .map(ProductVariant.fromMap)
            .toList();

        return ResponseSuccessListState<List<ProductVariant>>(
          statusCode: response.statusCode ?? -1,
          responseData: items,
          total: total,
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

  Future<ResponseState> getRoastingSlipDetail(String code) async {
    try {
      final response = await coreDio.get<NWResponse>(
        '/coffee-variant/roasting-slip/$code',
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess) {
        final raw = resultData.data;
        if (raw is Map<String, dynamic>) {
          final detail = RoastingSlipDetail.fromMap(raw);
          return ResponseSuccessState(
            statusCode: response.statusCode ?? -1,
            responseData: detail,
          );
        }
        return ResponseFailedState.unknownError();
      }

      if (resultData is NWResponseFailed) {
        return ResponseFailedState.fromNWResponse(resultData);
      }

      return ResponseFailedState.unknownError();
    } on DioException catch (e) {
      return handleResponseFailedState(e);
    }
  }

  /// Get packing slip detail by code
  ///
  /// API: GET /company/packing/code/{code}
  /// Service: Core
  ///
  /// Returns:
  /// - ResponseSuccessState<PackingSlipDetail> on success
  /// - ResponseFailedState on error
  Future<ResponseState> getPackingSlipDetail(String code) async {
    try {
      final response = await coreDio.get<NWResponse>(
        '/company/packing/code/$code',
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess) {
        final raw = resultData.data;
        if (raw is Map<String, dynamic>) {
          final detail = PackingSlipDetail.fromMap(raw);
          return ResponseSuccessState(
            statusCode: response.statusCode ?? -1,
            responseData: detail,
          );
        }
        return ResponseFailedState.unknownError();
      }

      if (resultData is NWResponseFailed) {
        return ResponseFailedState.fromNWResponse(resultData);
      }

      return ResponseFailedState.unknownError();
    } on DioException catch (e) {
      return handleResponseFailedState(e);
    }
  }

  /// Get packing slip item detail by code
  ///
  /// API: GET /company/packing/item-code/{code}
  /// Service: Core
  ///
  /// Returns:
  /// - ResponseSuccessState<PackingSlipDetailItem> on success
  /// - ResponseFailedState on error
  Future<ResponseState> getPackingSlipItemDetail(String code) async {
    try {
      final response = await coreDio.get<NWResponse>(
        '/company/packing/item-code/$code',
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess) {
        final raw = resultData.data;
        if (raw is Map<String, dynamic>) {
          final detail = PackingSlipDetailItem.fromMap(raw);
          return ResponseSuccessState<PackingSlipDetailItem>(
            statusCode: response.statusCode ?? -1,
            responseData: detail,
          );
        }
        return ResponseFailedState.unknownError();
      }

      if (resultData is NWResponseFailed) {
        return ResponseFailedState.fromNWResponse(resultData);
      }

      return ResponseFailedState.unknownError();
    } on DioException catch (e) {
      return handleResponseFailedState(e);
    }
  }

  /// Export green bean from roasting slip
  ///
  /// API: POST /coffee-variant/roasting-slip/export-green-bean
  /// Body: weight, roastingSlipId, note (optional)
  Future<ResponseState> exportRoastingSlipGreenBean({
    required double weight,
    required String roastingSlipId,
    String? note,
  }) async {
    try {
      final response = await coreDio.post<NWResponse>(
        '/coffee-variant/roasting-slip/export-green-bean',
        data: {
          'weight': weight,
          'roastingSlipId': roastingSlipId,
          if (note != null && note.isNotEmpty) 'note': note,
        },
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess) {
        return ResponseSuccessState<bool>(
          statusCode: response.statusCode ?? -1,
          responseData: resultData.data["status"] == 1,
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

  /// Export green bean from roasting slip
  ///
  /// API: POST /coffee-variant/roasting-slip/cancel
  /// Body: reason, roastingSlipId
  Future<ResponseState> cancelRoastingSlip({
    required String roastingSlipId,
    required String note,
  }) async {
    try {
      final response = await coreDio.post<NWResponse>(
        '/coffee-variant/roasting-slip/cancel',
        data: {'roastingSlipId': roastingSlipId, 'reason': note},
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess) {
        return ResponseSuccessState<bool>(
          statusCode: response.statusCode ?? -1,
          responseData: resultData.data["status"] == 1,
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

  /// Export green bean from roasting slip
  ///
  /// API: POST /coffee-variant/roasting-slip/complete
  /// Body: reason, roastingSlipId
  Future<ResponseState> completeRoastingSlip({
    required double weight,
    required String roastingSlipId,
    String? note,
  }) async {
    try {
      final response = await coreDio.post<NWResponse>(
        '/coffee-variant/roasting-slip/complete',
        data: {
          'weight': weight,
          'roastingSlipId': roastingSlipId,
          if (note != null && note.isNotEmpty) 'note': note,
        },
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess) {
        return ResponseSuccessState<bool>(
          statusCode: response.statusCode ?? -1,
          responseData: resultData.data["status"] == 1,
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

  /// Filter packing items by item code
  ///
  /// API: GET /company/packing/item/{itemCode}/filter
  /// Service: Core
  ///
  /// Query Parameters:
  /// - limit: int (optional, default: 20)
  /// - offset: int (optional, default: 0)
  ///
  /// Returns:
  /// - ResponseSuccessListState<List<PackingSlipItem>> on success
  /// - ResponseFailedState on error
  Future<ResponseState> filterPackingItemsByItemCode({
    required String itemCode,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final response = await coreDio.get<NWResponse>(
        '/company/packing/item/$itemCode/filter',
        queryParameters: {'limit': limit, 'offset': offset},
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess) {
        final raw = resultData.data;
        List<dynamic> list = [];
        int total = 0;

        if (raw is Map<String, dynamic>) {
          list =
              (raw['listData'] ??
                      raw['data'] ??
                      raw['items'] ??
                      raw['rows'] ??
                      [])
                  as List<dynamic>;
          total = (raw['total'] ?? raw['count'] ?? list.length) as int;
        } else if (raw is List) {
          list = raw;
          total = raw.length;
        }

        final items = list
            .whereType<Map<String, dynamic>>()
            .map(PackingSlipDetailItem.fromMap)
            .toList();

        return ResponseSuccessListState<List<PackingSlipDetailItem>>(
          statusCode: response.statusCode ?? -1,
          responseData: items,
          total: total,
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

  /// Confirm packaging mix
  ///
  /// API: POST /company/packing/confirm-mix
  /// Service: Core
  ///
  /// Body:
  /// - products (List<Map<String, dynamic>>)
  /// - itemId (String)
  /// - note (String)
  Future<ResponseState> confirmPackagingMix(Map<String, dynamic> body) async {
    try {
      final response = await coreDio.post<NWResponse>(
        '/company/packing/confirm-mix',
        data: body,
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess) {
        return ResponseSuccessState<bool>(
          statusCode: response.statusCode ?? -1,
          responseData: resultData.data["status"] == 1,
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

  /// Confirm packaging
  ///
  /// API: POST /company/packing/confirm-packaging
  /// Service: Core
  ///
  /// Body:
  /// - products (List<Map<String, dynamic>>)
  /// - itemId (String)
  /// - note (String)
  Future<ResponseState> confirmPackaging(Map<String, dynamic> body) async {
    try {
      final response = await coreDio.post<NWResponse>(
        '/company/packing/confirm-packaging',
        data: body,
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess) {
        return ResponseSuccessState<bool>(
          statusCode: response.statusCode ?? -1,
          responseData: resultData.data["status"] == 1,
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

  /// Complete packaging slip
  ///
  /// API: POST /company/packing/complete-mix
  /// Service: Core
  ///
  /// Body:
  /// - itemId (String)
  /// - actualQuantity (double)
  /// - note (String)
  Future<ResponseState> completePackagingSlip(Map<String, dynamic> body) async {
    try {
      final response = await coreDio.post<NWResponse>(
        '/company/packing/complete-mix',
        data: body,
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess) {
        return ResponseSuccessState<bool>(
          statusCode: response.statusCode ?? -1,
          responseData: resultData.data["status"] == 1,
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

  /// get inventory of variant by branch
  ///
  /// API: GET /company/product/variant/total-warehouse/:variantId
  /// Service: Core
  ///
  /// Query Parameters:
  /// - branchId (String)
  ///
  Future<ResponseState> getInventoryOfVariantByBranch(
    String branchId,
    String variantId,
  ) async {
    try {
      final response = await coreDio.get<NWResponse>(
        '/company/product/variant/total-warehouse/$variantId',
        queryParameters: {'branchId': branchId},
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess) {
        final inventory = resultData.data["slotBuy"] != null
            ? num.tryParse('${resultData.data["slotBuy"]}')
            : null;
        return ResponseSuccessState<num?>(
          statusCode: response.statusCode ?? -1,
          responseData: inventory,
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

  /// get total of new request packing slip
  ///
  /// API: GET /company/packing/new-request/total
  /// Service: Core
  ///
  Future<ResponseState> getTotalOfNewRequestPackingSlip() async {
    try {
      final response = await coreDio.get<NWResponse>(
        '/company/packing/new-request/total',
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess) {
        final totalNewRequest = resultData.data["data"] != null
            ? int.tryParse('${resultData.data["data"]}') ?? 0
            : 0;
        return ResponseSuccessState<int>(
          statusCode: response.statusCode ?? -1,
          responseData: totalNewRequest,
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

  /// get total of new request roasting slip
  ///
  /// API: GET /coffee-variant/roasting-slip/new-request/total
  /// Service: Core
  ///
  Future<ResponseState> getTotalOfNewRequestRoastingSlip() async {
    try {
      final response = await coreDio.get<NWResponse>(
        '/coffee-variant/roasting-slip/new-request/total',
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess) {
        final totalNewRequest = resultData.data["data"] != null
            ? int.tryParse('${resultData.data["data"]}') ?? 0
            : 0;
        return ResponseSuccessState<int>(
          statusCode: response.statusCode ?? -1,
          responseData: totalNewRequest,
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

  Future<ResponseState> cancelMixPacking(
    String itemId,
    String cancelReason,
  ) async {
    try {
      final response = await coreDio.post<NWResponse>(
        '/company/packing/cancel-mix',
        data: {'itemId': itemId, 'cancelReason': cancelReason},
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess) {
        return ResponseSuccessState<bool>(
          statusCode: response.statusCode ?? -1,
          responseData: (resultData.data["status"] ?? 0) == 1,
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

  /// Filter packing items by item code
  ///
  /// API: GET /company/packing/item/filter
  /// Service: Core
  ///
  /// Query Parameters:
  /// - limit: int (optional, default: 20)
  /// - offset: int (optional, default: 0)
  ///
  /// Returns:
  /// - ResponseSuccessListState<List<PackingSlipItem>> on success
  /// - ResponseFailedState on error
  Future<ResponseState> filterPackingItems({
    int limit = 20,
    int offset = 0,
    PackingSlipStatus? status,
  }) async {
    try {
      final response = await coreDio.get<NWResponse>(
        '/company/packing/item/filter',
        queryParameters: {
          'limit': limit,
          'offset': offset,
          if (status != null) 'status[]': [status.toConstant],
        },
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess) {
        final raw = resultData.data;
        List<dynamic> list = [];
        int total = 0;

        if (raw is Map<String, dynamic>) {
          list = (raw['listData'] ?? []) as List<dynamic>;
          total = (raw['total'] ?? list.length) as int;
        } else if (raw is List) {
          list = raw;
          total = raw.length;
        }

        final items = list
            .whereType<Map<String, dynamic>>()
            .map(PackingSlipDetailItem.fromMap)
            .toList();

        return ResponseSuccessListState<List<PackingSlipDetailItem>>(
          statusCode: response.statusCode ?? -1,
          responseData: items,
          total: total,
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
