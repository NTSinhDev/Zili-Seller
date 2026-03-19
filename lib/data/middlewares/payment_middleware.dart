import 'package:dio/dio.dart';
import 'package:zili_coffee/data/middlewares/base_middleware.dart';
import 'package:zili_coffee/data/models/order/payment_detail/seller_payment_method.dart';
import 'package:zili_coffee/data/models/payment/collaborator.dart';
import 'package:zili_coffee/data/network/network_response_object.dart';
import 'package:zili_coffee/data/network/network_response_state.dart';
import 'package:zili_coffee/data/network/network_url.dart';

import '../models/order/payment_detail/bank_info.dart';

class PaymentMiddleware extends BaseMiddleware {
  /// Get payment methods (synthetic/active)
  ///
  /// API: GET /system/api/v1/seller/payment-method/synthetic/active
  ///
  /// Parameters:
  /// - notMethods: List<String> (optional) - Exclude payment methods (e.g., ['PAYMENT_ON_DELIVERY'])
  ///
  /// Returns:
  /// - ResponseState chứa List<SellerPaymentMethod> nếu thành công
  Future<ResponseState> getPaymentMethods({
    bool? isActive,
    List<String>? notMethods,
  }) async {
    try {
      final response = await systemDio.get<NWResponse>(
        NetworkUrl.seller.paymentMethodSyntheticActive(
          notMethods: notMethods,
        ),
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess) {
        final data = resultData.data;
        List<SellerPaymentMethod> paymentMethods = [];

        if (data is List) {
          // Nếu response là array trực tiếp
          paymentMethods = data
              .map<SellerPaymentMethod>((item) => SellerPaymentMethod.fromMap(item))
              .toList();
        } else if (data is Map<String, dynamic>) {
          // Nếu response là object có key 'data' hoặc 'listData'
          final items = data['data'] ?? data['listData'] ?? data;
          if (items is List) {
            paymentMethods = items
                .map<SellerPaymentMethod>((item) => SellerPaymentMethod.fromMap(item))
                .toList();
          }
        }

        return ResponseSuccessState(
          statusCode: response.statusCode ?? -1,
          responseData: paymentMethods,
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

  /// Filter collaborators (payment methods)
  ///
  /// API: GET /company/collaborator/filter
  ///
  /// Parameters:
  /// - offset: int (default: 0)
  /// - limit: int (default: 10)
  /// - status: List<String> (e.g., ['COMPLETED'])
  ///
  /// Returns:
  /// - ResponseState chứa List<Collaborator> nếu thành công
  Future<ResponseState> filterCollaborators({
    int offset = 0,
    int limit = 10,
    List<String>? status,
  }) async {
    try {
      final response = await userDio.get<NWResponse>(
        NetworkUrl.collaborator.filter(
          offset: offset,
          limit: limit,
          status: status,
        ),
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess) {
        final data = resultData.data;
        List<Collaborator> collaborators = [];

        if (data is Map<String, dynamic>) {
          // Nếu response là object có key 'data' hoặc 'items'
          final items = data['data'] ?? data['items'] ?? data;
          if (items is List) {
            collaborators = items
                .map<Collaborator>((item) => Collaborator.fromMap(item))
                .toList();
          }
        } else if (data is List) {
          // Nếu response là array trực tiếp
          collaborators = data
              .map<Collaborator>((item) => Collaborator.fromMap(item))
              .toList();
        }

        return ResponseSuccessState(
          statusCode: response.statusCode ?? -1,
          responseData: collaborators,
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

  /// Get banking methods (active)
  ///
  /// API: GET /core/api/v1/company-payment/bank-info/active
  ///
  /// Returns:
  /// - ResponseState chứa List<BankInfo> nếu thành công
  Future<ResponseState> getBankingMethods() async {
    try {
      final response = await coreDio.get<NWResponse>(
        '/company-payment/bank-info/active',
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess) {
        final data = resultData.data;
        List<BankInfo> paymentMethods = [];
        
        final listDynamic = data['listData'] as List<dynamic>?;
        if (listDynamic != null) {
          paymentMethods = List<BankInfo>.from(
            listDynamic
                .map<BankInfo>((item) => BankInfo.fromMap(item))
                .toList(),
          ) ;
        }

        return ResponseSuccessState<List<BankInfo>>(
          statusCode: response.statusCode ?? -1,
          responseData: paymentMethods,
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
