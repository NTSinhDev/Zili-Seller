import 'package:dio/dio.dart';
import 'package:zili_coffee/data/middlewares/base_middleware.dart';
import 'package:zili_coffee/data/models/media_file.dart';
import 'package:zili_coffee/data/models/review/rating.dart';
import 'package:zili_coffee/data/models/review/review.dart';
import 'package:zili_coffee/data/network/network_response_object.dart';
import 'package:zili_coffee/data/network/network_response_state.dart';
import 'package:zili_coffee/data/network/network_url.dart';
import 'package:zili_coffee/utils/extension/list.dart';

class ReviewMiddleware extends BaseMiddleware {
  Future<ResponseState> createReview({
    required String? message,
    required List<MediaFile> images,
    required List<MediaFile> videos,
    required int star,
    required String name,
    required String emailPhone,
    required String productID,
  }) async {
    try {
      final response = await dio.post<NWResponse>(
        NetworkUrl.review.create,
        data: {
          "message": message,
          "images": images.formatToStringForAPI,
          "videos": videos.formatToStringForAPI,
          "totalStar": star,
          "name": name,
          "email_phone": emailPhone,
          "product_id": productID,
        },
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess<Map<String, dynamic>>) {
        return ResponseSuccessState(
          statusCode: response.statusCode ?? -1,
          responseData: resultData.data['status'] &&
                  resultData.data['message'] == "success" &&
                  resultData.data['data']
              ? false
              : true,
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

  Future<ResponseState> getProductReviews({
    required String productID,
    required Rating rating,
    int? page,
    String? type,
    int? star,
  }) async {
    try {
      final response = await authDio.get<NWResponse>(
        NetworkUrl.review.productReviews(productID: productID),
        queryParameters: {
          reviewConstant.type: type,
          reviewConstant.star: star == 0? null:star,
          reviewConstant.page: page ?? 1,
          reviewConstant.perPage: 5,
        },
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess<Map<String, dynamic>>) {
        final List reviewsMap = resultData.data["reviews"];
        final reviews = reviewsMap.map((map) => Review.fromMap(map)).toList();
        return ResponseSuccessState(
          statusCode: response.statusCode ?? -1,
          responseData: rating.copyWith(
            reviews: reviews,
            totalRecords: resultData.data["totalRecords"],
          ),
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

  Future<ResponseState> getProductRating({required String productID}) async {
    try {
      final response = await authDio.get<NWResponse>(
        NetworkUrl.review.productRating(productID: productID),
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess<Map<String, dynamic>>) {
        return ResponseSuccessState(
          statusCode: response.statusCode ?? -1,
          responseData: Rating.fromMap(resultData.data),
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
