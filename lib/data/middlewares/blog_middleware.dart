import 'package:dio/dio.dart';
import 'package:zili_coffee/data/middlewares/base_middleware.dart';
import 'package:zili_coffee/data/models/blog/blog.dart';
import 'package:zili_coffee/data/models/blog/blog_category.dart';
import 'package:zili_coffee/data/network/network_response_object.dart';
import 'package:zili_coffee/data/network/network_response_state.dart';
import 'package:zili_coffee/data/network/network_url.dart';

class BlogMiddleware extends BaseMiddleware {
  Future<ResponseState> getAllBlogs() async {
    try {
      final response = await authDio.get<NWResponse>(
        NetworkUrl.blog.blog,
        queryParameters: {reviewConstant.perPage: 5, reviewConstant.page: 1},
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess<Map<String, dynamic>>) {
        final List<dynamic> listCategoryData = resultData.data['rows'];
        return ResponseSuccessState(
          statusCode: response.statusCode ?? -1,
          responseData:
              listCategoryData.map((map) => Blog.fromMap(map)).toList(),
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

  Future<ResponseState> getBlogCategories() async {
    try {
      final response = await authDio.get<NWResponse>(
        NetworkUrl.blog.blogCategory,
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess<Map<String, dynamic>>) {
        final List<dynamic> listCategoryData = resultData.data['data'];
        return ResponseSuccessState(
          statusCode: response.statusCode ?? -1,
          responseData:
              listCategoryData.map((map) => BlogCategory.fromMap(map)).toList(),
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
