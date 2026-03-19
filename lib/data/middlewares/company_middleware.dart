import 'package:dio/dio.dart';
import 'package:zili_coffee/data/middlewares/base_middleware.dart';
import 'package:zili_coffee/data/models/sevenue.dart';
import 'package:zili_coffee/data/network/network_response_object.dart';
import 'package:zili_coffee/data/network/network_response_state.dart';

import '../models/template_mail_data.dart';

class CompanyMiddleware extends BaseMiddleware {
  /// Get revenues report for a date range
  ///
  /// API: GET /company/order-report/revenues
  /// Service: Core
  ///
  /// Parameters:
  /// - month: Month number (1-12) - REQUIRED để tránh hardcode bug
  /// - startDate: Start date in ISO format (e.g., "2026-01-01T00:00:00+07:00")
  /// - endDate: End date in ISO format (e.g., "2026-01-31T23:59:59+07:00")
  ///
  /// Returns:
  /// - ResponseSuccessState chứa RevenueByMonth nếu thành công
  Future<ResponseState> getRevenues({
    required int month,
    required String startDate,
    required String endDate,
  }) async {
    try {
      final response = await coreDio.get<NWResponse>(
        '/company/order-report/revenues',
        queryParameters: {'startDate': startDate, 'endDate': endDate},
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess) {
        final data = resultData.data;

        // Sử dụng month parameter đã truyền vào (không hardcode)
        // Convert int month (1-12) sang String format "01"-"12"
        final monthStr = month.toString().padLeft(2, '0');

        if (data is Map<String, dynamic>) {
          final revenueByMonth = RevenueByMonth.fromMap(data, monthStr);
          return ResponseSuccessState<RevenueByMonth>(
            statusCode: response.statusCode ?? -1,
            responseData: revenueByMonth,
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

  // /// Get revenues report for a date range
  // ///
  // /// API: GET /company/order-report/revenues
  // /// Service: Core
  // ///
  // /// Parameters:
  // /// - month: Month number (1-12) - REQUIRED để tránh hardcode bug
  // /// - startDate: Start date in ISO format (e.g., "2026-01-01T00:00:00+07:00")
  // /// - endDate: End date in ISO format (e.g., "2026-01-31T23:59:59+07:00")
  // ///
  // /// Returns:
  // /// - ResponseSuccessState chứa RevenueByMonth nếu thành công
  // Future<ResponseState> getOrderReport({
  //   required String startDate,
  //   required String endDate,
  // }) async {
  //   try {
  //     final response = await coreDio.get<NWResponse>(
  //       '/company/order-report/pending-count',
  //       queryParameters: {'startDate': startDate, 'endDate': endDate},
  //       cancelToken: cancelToken,
  //     );

  //     final resultData = response.data;
  //     if (resultData is NWResponseSuccess) {
  //       final data = resultData.data;
  //       if (data is Map<String, dynamic>) {
  //         final revenueByMonth = RevenueByMonth.fromMap(data, monthStr);
  //         return ResponseSuccessState<RevenueByMonth>(
  //           statusCode: response.statusCode ?? -1,
  //           responseData: revenueByMonth,
  //         );
  //       }

  //       return ResponseFailedState.unknownError();
  //     }

  //     if (resultData is NWResponseFailed) {
  //       return ResponseFailedState.fromNWResponse(resultData);
  //     }

  //     return ResponseFailedState.unknownError();
  //   } on DioException catch (e) {
  //     return handleResponseFailedState(e);
  //   }
  // }

  Future<ResponseState> getActiveTemplateMails(String type) async {
    try {
      final response = await systemDio.get<NWResponse>(
        '/company/template-mail/active',
        queryParameters: {'type': type},
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess) {
        final listDynamic = resultData.data["listData"] as List<dynamic>;
        final listTemplate = List<TemplateMailData>.from(
          listDynamic.map(
            (e) => TemplateMailData.fromMap(e as Map<String, dynamic>),
          ),
        );
        return ResponseSuccessListState<List<TemplateMailData>>(
          statusCode: response.statusCode ?? -1,
          responseData: listTemplate,
          total: listTemplate.length,
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

  Future<ResponseState> sendQuotationByMail(String code) async {
    try {
      final response = await coreDio.post<NWResponse>(
        '/company/quotation-order/send',
        data: {'code': code},
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
}
