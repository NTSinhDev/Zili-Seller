part of '../store_reviews_screen.dart';

class _ListViewLoading extends StatelessWidget {
  final ReviewRepository reviewRepository;
  final List<Review>? reviews;
  const _ListViewLoading({
    required this.reviewRepository,
    required this.reviews,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Rating?>(
        stream: reviewRepository.behaviorRating.stream,
        builder: (context, ratingSnapshot) {
          bool visible = false;
          if (ratingSnapshot.hasData) {
            visible = !((ratingSnapshot.data?.totalRecords ?? -1) ==
                (reviews?.length ?? 0));
          }
          return Visibility(
            visible: visible,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 24.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20.w,
                    height: 20.w,
                    child: const CircularProgressIndicator(
                      color: AppColors.primary,
                      strokeWidth: 2.0,
                      backgroundColor: AppColors.grayEA,
                    ),
                  ),
                  width(width: 7),
                  Text(
                    'Loading...',
                    style: AppStyles.text.semiBold(
                      fSize: 13.sp,
                      color: AppColors.primary,
                    ),
                  )
                ],
              ),
            ),
          );
        },);
  }
}
