// ignore_for_file: depend_on_referenced_packages, implementation_imports
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/src/media_type.dart';

import 'package:zili_coffee/data/middlewares/base_middleware.dart';
import 'package:zili_coffee/data/models/media_file.dart';
import 'package:zili_coffee/data/network/network_response_object.dart';
import 'package:zili_coffee/data/network/network_response_state.dart';
import 'package:zili_coffee/data/network/network_url.dart';
import 'package:zili_coffee/utils/enums.dart' as app_enum;

class UploadMiddleware extends BaseMiddleware {
  Future<ResponseState> uploadImage({required File imgFile}) async {
    try {
      final bytes = await imgFile.readAsBytes();
      final response = await systemDio.post<NWResponse>(
        '/setting/file/upload',
        data: FormData.fromMap({
          "file": MultipartFile.fromBytes(bytes, filename: imgFile.path),
        }),
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess<Map<String, dynamic>>) {
        final dataSource = resultData.data;
        final mediaFile = MediaFile(
          type: app_enum.MediaType.image,
          url: dataSource['fileUrl'] != null
              ? dataSource['fileUrl'].toString()
              : '',
          urlThumb: dataSource['fileUrl'] != null
              ? dataSource['fileUrl'].toString()
              : '',
          sizeInBytes: dataSource['size'] != null
              ? int.tryParse("${dataSource['size']}")
              : null,
          fileName: dataSource['fileName']?.toString(),
        );

        return ResponseSuccessState<MediaFile?>(
          statusCode: response.statusCode ?? -1,
          responseData: mediaFile,
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

  Future<ResponseState> uploadMultiImages({required List<File> files}) async {
    try {
      // Prepare data for the request
      List<dynamic> images = [];
      for (final file in files) {
        images.add(
          await MultipartFile.fromFile(
            file.path,
            filename: file.path,
            contentType: MediaType('image', file.path.split('.')[1]),
          ),
        );
      }

      // Send request to server
      final response = await dio.post<NWResponse>(
        NetworkUrl.upload.images,
        data: FormData.fromMap({'images': images}),
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess<Map<String, dynamic>>) {
        // Convert data from response
        final listMap = resultData.data["data"] as List<dynamic>;
        final List<MediaFile> medias = listMap
            .map((map) => MediaFile.fromMap2(map))
            .toList();

        return ResponseSuccessState(
          statusCode: response.statusCode ?? -1,
          responseData: medias,
        );
      }

      // Failed cases
      if (resultData is NWResponseFailed) {
        return ResponseFailedState.fromNWResponse(resultData);
      }
      return ResponseFailedState.unknownError();
    } on DioException catch (e) {
      return handleResponseFailedState(e);
    }
  }

  Future<ResponseState> uploadVideos({required File file}) async {
    try {
      final videoData = await MultipartFile.fromFile(
        file.path,
        filename: file.path,
      );
      // Send request to server
      final response = await dio.post<NWResponse>(
        NetworkUrl.upload.video,
        data: FormData.fromMap({'video': videoData}),
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess<Map<String, dynamic>>) {
        // Convert data from response
        final mediaFile = MediaFile(
          type: app_enum.MediaType.video,
          url: resultData.data['url'],
          urlThumb: '',
        );

        return ResponseSuccessState(
          statusCode: response.statusCode ?? -1,
          responseData: mediaFile,
        );
      }

      // Failed cases
      if (resultData is NWResponseFailed) {
        return ResponseFailedState.fromNWResponse(resultData);
      }
      return ResponseFailedState.unknownError();
    } on DioException catch (e) {
      return handleResponseFailedState(e);
    }
  }

  Future<String> uploadBlob({required File file}) async {
    try {
      final videoData = await MultipartFile.fromFile(
        file.path,
        filename: file.path,
      );
      // Send request to server
      final response = await dio.post<NWResponse>(
        NetworkUrl.upload.blob,
        data: FormData.fromMap({'file': videoData}),
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess<Map<String, dynamic>>) {
        return resultData.data['url'];
      }

      // Failed cases
      if (resultData is NWResponseFailed) {
        return '';
      }
      return '';
    } on DioException {
      return '';
    }
  }
}
