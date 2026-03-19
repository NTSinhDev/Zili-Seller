import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:zili_coffee/data/middlewares/base_middleware.dart';
import 'package:zili_coffee/data/models/address/customer_address.dart';
import 'package:zili_coffee/data/models/address/location.dart';
import 'package:zili_coffee/data/models/address/region.dart';
import 'package:zili_coffee/data/models/cart/deliver_price.dart';
import 'package:zili_coffee/data/network/network_response_object.dart';
import 'package:zili_coffee/data/network/network_response_state.dart';
import 'package:zili_coffee/data/network/network_url.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/enums.dart';
import 'package:zili_coffee/utils/enums/address_enum.dart';

class AddressMiddleware extends BaseMiddleware {
  Future<ResponseState> getDeliverPriceByLocation({
    required String provinceID,
    required String districtID,
  }) async {
    try {
      DeliverPrice deliverPrice = DeliverPrice(
        provinceID: provinceID,
        districtID: districtID,
      );
      final response = await dio.get<NWResponse>(
        NetworkUrl.deliverPrice,
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess<Map<String, dynamic>>) {
        deliverPrice = deliverPrice.copyWith(
          id: resultData.data['id'],
          price: resultData.data['deliver_price'],
        );
        return ResponseSuccessState(
          statusCode: response.statusCode ?? -1,
          responseData: deliverPrice,
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

  Future<ResponseState> getAddresses() async {
    try {
      final response = await dio.get<NWResponse>(
        NetworkUrl.customer.addresses,
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess<Map<String, dynamic>>) {
        final listMap = resultData.data['addresses'] as List<dynamic>;
        return ResponseSuccessState(
          statusCode: response.statusCode ?? -1,
          responseData: listMap
              .map((dataMap) => CustomerAddress.fromMap(dataMap))
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

  Future<ResponseState> updateAddress(CustomerAddress address) async {
    try {
      final response = await dio.put<NWResponse>(
        NetworkUrl.customer.address(id: address.id),
        data: address.mapToJson(address.toMapLitleData()),
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess<Map<String, dynamic>>) {
        return ResponseSuccessState(
          statusCode: response.statusCode ?? -1,
          responseData: CustomerAddress.fromMap(resultData.data['address']),
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

  Future<ResponseState> deleteAddress(CustomerAddress address) async {
    try {
      final response = await dio.delete<NWResponse>(
        NetworkUrl.customer.address(id: address.id),
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess<Map<String, dynamic>>) {
        return ResponseSuccessState(
          statusCode: response.statusCode ?? -1,
          responseData:
              resultData.data["message"] == AppConstant.strings.success,
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

  Future<ResponseState> createAddress(CustomerAddress address) async {
    final jsonData = json.encode(address.toMapLitleData());
    try {
      final response = await dio.post<NWResponse>(
        NetworkUrl.customer.address(),
        data: jsonData,
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess<Map<String, dynamic>>) {
        return ResponseSuccessState(
          statusCode: response.statusCode ?? -1,
          responseData: CustomerAddress.fromMap(resultData.data['address']),
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

  Future<ResponseState> getProvinces() async {
    try {
      final response = await authDio.get<NWResponse>(
        NetworkUrl.address.provinces,
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess<Map<String, dynamic>>) {
        final listMap = resultData.data['provinces'] as List<dynamic>;
        return ResponseSuccessState(
          statusCode: response.statusCode ?? -1,
          responseData: listMap
              .map(
                (dataMap) => Location.fromMap(
                  dataMap,
                  level: LocationLevel.Province_City,
                ),
              )
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

  Future<ResponseState> getDistricts(String provinceID) async {
    try {
      final response = await authDio.get<NWResponse>(
        NetworkUrl.address.districts(provinceID),
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess<Map<String, dynamic>>) {
        final listMap = resultData.data['districts'] as List<dynamic>;
        return ResponseSuccessState(
          statusCode: response.statusCode ?? -1,
          responseData: listMap
              .map(
                (dataMap) =>
                    Location.fromMap(dataMap, level: LocationLevel.District),
              )
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

  /// Get provinces by type (PRE_MERGER or POST_MERGER)
  ///
  /// API: GET /administrative/provinces
  ///
  /// Parameters:
  /// - type: RegionType enum (preMerger or postMerger)
  ///
  /// Returns:
  /// - ResponseState chứa List<Region> nếu thành công
  Future<ResponseState> getProvincesByType({required RegionType type}) async {
    try {
      final typeString = type.toConstant;
      final response = await systemDio.get<NWResponse>(
        '/administrative/provinces',
        queryParameters: {'type': typeString},
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess) {
        final data = resultData.data;
        List<Region> provinces = [];

        if (data is List) {
          provinces = data
              .map((dataMap) => Region.fromMap(dataMap as Map<String, dynamic>))
              .toList();
        } else if (data is Map<String, dynamic>) {
          final listData =
              data['provinces'] as List<dynamic>? ??
              data['data'] as List<dynamic>? ??
              data['listData'] as List<dynamic>?;
          if (listData != null) {
            provinces = listData
                .map(
                  (dataMap) => Region.fromMap(dataMap as Map<String, dynamic>),
                )
                .toList();
          }
        }

        return ResponseSuccessState(
          statusCode: response.statusCode ?? -1,
          responseData: provinces,
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

  /// Filter districts by type (PRE_MERGER or POST_MERGER)
  ///
  /// API: GET /administrative/districts/filter
  ///
  /// Parameters:
  /// - type: RegionType enum (preMerger or postMerger)
  ///
  /// Returns:
  /// - ResponseState chứa List<Region> nếu thành công
  Future<ResponseState> filterDistrictsByType({
    required RegionType type,
  }) async {
    final typeString = type.toConstant;
    try {
      final response = await systemDio.get<NWResponse>(
        NetworkUrl.administrative.filterDistricts,
        queryParameters: {'type': typeString},
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess) {
        final data = resultData.data;
        List<Region> regions = [];

        if (data is List) {
          // Parse từ Region model
          final regions = data
              .map((dataMap) => Region.fromMap(dataMap as Map<String, dynamic>))
              .toList();
          return ResponseSuccessState(
            statusCode: response.statusCode ?? -1,
            responseData: regions,
          );
        } else if (data is Map<String, dynamic>) {
          final listData =
              data['districts'] as List<dynamic>? ??
              data['data'] as List<dynamic>? ??
              data['listData'] as List<dynamic>?;
          if (listData != null) {
            final regions = listData
                .map(
                  (dataMap) => Region.fromMap(dataMap as Map<String, dynamic>),
                )
                .toList();
            return ResponseSuccessState(
              statusCode: response.statusCode ?? -1,
              responseData: regions,
            );
          }
        }

        return ResponseSuccessState(
          statusCode: response.statusCode ?? -1,
          responseData: regions,
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

  Future<ResponseState> getWards(String districtsID) async {
    try {
      final response = await authDio.get<NWResponse>(
        NetworkUrl.address.wards(districtsID),
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess<Map<String, dynamic>>) {
        final listMap = resultData.data['wards'] as List<dynamic>;
        return ResponseSuccessState(
          statusCode: response.statusCode ?? -1,
          responseData: listMap
              .map(
                (dataMap) =>
                    Location.fromMap(dataMap, level: LocationLevel.Ward_Town),
              )
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

  /// Get wards by district code and type (PRE_MERGER or POST_MERGER)
  ///
  /// API: GET /administrative/wards/{districtCode}
  ///
  /// Parameters:
  /// - districtCode: Mã quận/huyện (required)
  /// - type: RegionType enum (preMerger or postMerger)
  ///
  /// Returns:
  /// - ResponseState chứa List<Location> nếu thành công
  Future<ResponseState> getRegionWardsByType({
    required String districtCode,
    required RegionType type,
  }) async {
    try {
      final typeString = type.toConstant;
      final response = await systemDio.get<NWResponse>(
        '/administrative/wards/$districtCode',
        queryParameters: {'type': typeString},
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess) {
        final data = resultData.data;
        List<Region> regions = [];

        if (data is List) {
          regions = data
              .map((dataMap) => Region.fromMap(dataMap as Map<String, dynamic>))
              .toList();
        } else if (data is Map<String, dynamic>) {
          final listData =
              data['wards'] as List<dynamic>? ??
              data['data'] as List<dynamic>? ??
              data['listData'] as List<dynamic>?;
          if (listData != null) {
            regions = listData
                .map(
                  (dataMap) => Region.fromMap(dataMap as Map<String, dynamic>),
                )
                .toList();
          }
        }

        return ResponseSuccessState(
          statusCode: response.statusCode ?? -1,
          responseData: regions,
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
