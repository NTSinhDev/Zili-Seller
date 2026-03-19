import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:zili_coffee/data/middlewares/base_middleware.dart';
import 'package:zili_coffee/data/network/network_response_object.dart';
import 'package:zili_coffee/data/network/network_response_state.dart';
import 'package:zili_coffee/utils/enums.dart';

import '../../utils/enums/setting_enum.dart';
import '../entity/printer.dart';

class SettingMiddleware extends BaseMiddleware {
  /// Get terms/settings by type
  ///
  /// Lấy danh sách terms/settings theo type
  ///
  /// Parameters:
  /// - type: String (required) - Loại setting (ví dụ: "SALE_CHANNELS")
  ///
  /// Returns:
  /// - ResponseSuccessState nếu thành công (parse từ ruleVi/ruleEn)
  /// - ResponseFailedState nếu có lỗi
  Future<ResponseState> getTerms(TermType type) async {
    try {
      final response = await systemDio.get<NWResponse>(
        '/setting/terms',
        queryParameters: {'type': type.toConstant},
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess) {
        if (type == TermType.saleChannels) {
          final data = resultData.data;
          List<String> terms = [];

          Map<String, dynamic>? termData;
          if (data is Map<String, dynamic>) {
            termData = data;
          } else if (data is List && data.isNotEmpty) {
            termData = data[0] as Map<String, dynamic>?;
          }

          if (termData != null) {
            final ruleVi = termData['ruleVi'] as String?;
            final ruleEn = termData['ruleEn'] as String?;

            final ruleToParse = (ruleVi != null && ruleVi.isNotEmpty)
                ? ruleVi
                : ruleEn;

            if (ruleToParse != null && ruleToParse.isNotEmpty) {
              try {
                final decoded = json.decode(ruleToParse);
                if (decoded is List) {
                  terms = decoded
                      .map<String>((item) => item.toString())
                      .toList();
                } else if (decoded is String) {
                  terms = [decoded];
                }
              } catch (e) {
                terms = [ruleToParse];
              }
            }
          }

          return ResponseSuccessState<List<String>>(
            statusCode: response.statusCode ?? -1,
            responseData: terms,
          );
        }

        if (type == TermType.printerApi) {
          final data = resultData.data;
          List<Printer> terms = [];

          Map<String, dynamic>? termData;
          if (data is Map<String, dynamic>) {
            termData = data;
          } else if (data is List && data.isNotEmpty) {
            termData = data[0] as Map<String, dynamic>?;
          }

          if (termData != null) {
            final ruleVi = termData['ruleVi'] as String?;
            final ruleEn = termData['ruleEn'] as String?;

            final ruleToParse = (ruleVi != null && ruleVi.isNotEmpty)
                ? ruleVi
                : ruleEn;

            if (ruleToParse != null && ruleToParse.isNotEmpty) {
              try {
                final decoded = json.decode(ruleToParse);
                if (decoded is List) {
                  terms = decoded
                      .map<Printer>((item) => Printer.fromMap(item))
                      .toList();
                } else if (decoded is String) {
                  terms = [];
                }
              } catch (e) {
                terms = [];
              }
            }
          }

          return ResponseSuccessState<List<Printer>>(
            statusCode: response.statusCode ?? -1,
            responseData: terms,
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
}
