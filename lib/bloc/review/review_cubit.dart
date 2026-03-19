import 'dart:io';

import 'package:equatable/equatable.dart';
// import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:zili_coffee/bloc/base_cubit.dart';
import 'package:zili_coffee/data/middlewares/middlewares.dart';
import 'package:zili_coffee/data/models/media_file.dart';

import 'package:zili_coffee/data/models/review/rating.dart';
import 'package:zili_coffee/data/models/review/review.dart';
import 'package:zili_coffee/data/network/network_response_state.dart';
import 'package:zili_coffee/data/repositories/auth_repository.dart';
import 'package:zili_coffee/data/repositories/review_repository.dart';
import 'package:zili_coffee/di/dependency_injection.dart';
import 'package:zili_coffee/utils/enums.dart';
part 'review_state.dart';

class ReviewCubit extends BaseCubit<ReviewState> {
  ReviewCubit() : super(ReviewInitial());

  final UploadMiddleware _uploadMiddleware = di<UploadMiddleware>();
  final ReviewMiddleware _reviewMiddleware = di<ReviewMiddleware>();
  final AuthRepository _authRepository = di<AuthRepository>();
  final ReviewRepository _reviewRepository = di<ReviewRepository>();
  final String imageKey = "images";
  final String videoKey = "videos";

  Future<void> sendFeedback({required String message}) async {
    _reviewRepository.yourFeedback = message;
  }

  Future<bool> sendReview({
    String? message,
    List<File> images = const [],
    List<File> videos = const [],
    required int star,
  }) async {
    // Upload media files
    final files = await _uploadFiles(images: images, videos: videos);

    // Send review and waiting for admin browse
    final user = _authRepository.currentUser!;
    final result = await _reviewMiddleware.createReview(
      productID: _reviewRepository.currentProduct!.id,
      name: user.name,
      emailPhone: user.email ?? user.phone!,
      message: message,
      star: star,
      images: files[imageKey] ?? [],
      videos: files[videoKey] ?? [],
    );
    if (result is ResponseSuccessState<bool>) {
      return result.responseData;
    } else if (result is ResponseFailedState) {}
    return false;
  }

  Future getProductRatingReviews() async {
    final ratingResponse = await _reviewMiddleware.getProductRating(
      productID: _reviewRepository.currentProduct!.id,
    );
    if (ratingResponse is ResponseSuccessState<Rating>) {
      _reviewRepository.behaviorRating.sink.add(ratingResponse.responseData);
      final resultReviews = await _reviewMiddleware.getProductReviews(
        productID: _reviewRepository.currentProduct!.id,
        rating: ratingResponse.responseData,
      );
      if (resultReviews is ResponseSuccessState<Rating>) {
        _reviewRepository.behaviorRating.sink.add(resultReviews.responseData);
        _reviewRepository.behaviorReviews.sink.add(
          resultReviews.responseData.reviews,
        );
      }
    }
  }

  Future filterReviews({
    MediaType? type,
    int star = 0,
    bool paging = false,
  }) async {
    emit(GettingReviewsState());
    final resultRating = await _reviewMiddleware.getProductReviews(
      productID: _reviewRepository.currentProduct!.id,
      rating: _reviewRepository.behaviorRating.value!,
      type: type?.parseToStr(),
      star: star,
      page: paging ? _calcPage() : null,
    );
    if (resultRating is ResponseSuccessState<Rating>) {
      // Update totalRecords field of Rating
      final Rating currentRating = _reviewRepository.behaviorRating.value!;
      _reviewRepository.behaviorRating.sink.add(
        currentRating.copyWith(
          totalRecords: resultRating.responseData.totalRecords,
        ),
      );

      // Update review data
      List<Review> reviews = [];
      if (paging) {
        // If paging is true, trigging event loadmore
        // Add all result(new reviews) into current reviews list
        reviews = List.from(_reviewRepository.behaviorReviews.value);
        reviews.addAll(resultRating.responseData.reviews);
      } else {
        // If paging is false, the reviews list is empty.
        // Add result(new reviews) to streamReviews
        reviews = resultRating.responseData.reviews;
      }

      _reviewRepository.behaviorReviews.sink.add(reviews);
      emit(GotReviewsState());
    } else if (resultRating is ResponseFailedState) {
      emit(FailedGotReviewsState());
    }
  }

  Future<Map<String, List<MediaFile>>> _uploadFiles({
    required List<File> images,
    required List<File> videos,
  }) async {
    List<MediaFile> imageFiles = [];
    List<MediaFile> videoFiles = [];
    // Upload images
    if (images.isNotEmpty) {
      final result = await _uploadMiddleware.uploadMultiImages(files: images);
      if (result is ResponseSuccessState<List<MediaFile>>) {
        imageFiles = result.responseData;
      }
    }

    // Upload videos
    if (videos.isNotEmpty) {
      for (File video in videos) {
        final MediaFile? videoMediaFile = await _uploadVideo(file: video);
        if (videoMediaFile != null) {
          videoFiles.add(videoMediaFile);
        }
      }
    }

    return {imageKey: imageFiles, videoKey: videoFiles};
  }

  Future<MediaFile?> _uploadVideo({required File file}) async {
    // final result = await _uploadMiddleware.uploadVideos(file: file);
    // if (result is ResponseSuccessState<MediaFile>) {
    //   // Make thumbnail for video
    //   final fileName = await VideoThumbnail.thumbnailFile(
    //     video: result.responseData.url,
    //     thumbnailPath: (await getTemporaryDirectory()).path,
    //     imageFormat: ImageFormat.PNG,
    //     maxHeight: 200,
    //     quality: 100,
    //   );
    //   final File thumbnailFile = File(fileName!);
    //   final thumbnail = await _uploadMiddleware.uploadBlob(file: thumbnailFile);

    //   return result.responseData.copyWith(urlThumb: thumbnail);
    // }
    return null;
  }

  int _calcPage() {
    int page = 1;
    if (_reviewRepository.behaviorReviews.hasValue) {
      page += _reviewRepository.behaviorReviews.value.length ~/ 5;
    }
    return page;
  }
}
