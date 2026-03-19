part of '../product_detail_screen.dart';

class _ProductRating extends StatelessWidget {
  const _ProductRating();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Rating?>(
      stream: di<ReviewRepository>().behaviorRating.stream,
      builder: (context, snapshot) {
        Rating? rating;
        if (snapshot.hasData) {
          rating = snapshot.data;
        }
        return Container(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _productRating(rating),
                  const Spacer(),
                  _sendReviewProduct(context),
                ],
              ),
              height(height: 17),
              if (rating?.total != 0)
                PlaceholderWidget(
                  width: Spaces.screenWidth(context) - 40.w,
                  height: 53.h,
                  condition: rating != null,
                  child: _ratingDetail(rating, context),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _ratingDetail(Rating? rating, BuildContext context) {
    return InkWell(
      onTap: () {
        // final ReviewRepository reviewRepository = di<ReviewRepository>();
        // if (reviewRepository.behaviorReviews.valueOrNull == null) return;
        // if (reviewRepository.behaviorReviews.value.isEmpty) {
        //   di<ReviewCubit>().getProductRatingReviews();
        // }
        // context.navigator.pushNamed(ReviewsScreen.keyName);
      },
      child: Container(
        padding: EdgeInsets.all(10.w),
        width: Spaces.screenWidth(context) - 40.w,
        decoration: BoxDecoration(
          color: AppColors.greyFx,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: AppColors.black.withOpacity(0.2),
              offset: const Offset(0.0, 0.0),
              blurRadius: 2.r,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _TopReviewer(reviews: rating?.reviews ?? []),
            width(width: 21),
            Text(
              '${rating?.total ?? 0} bài đánh giá',
              style: AppStyles.text.semiBold(fSize: 16.sp, height: 1.35),
            ),
            const Spacer(),
            Container(
              width: 33.w,
              height: 33.w,
              padding: EdgeInsets.only(left: 2.w, top: 2.w),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white,
              ),
              child: Center(
                child: CustomIconStyle(
                  icon: CupertinoIcons.chevron_right,
                  style: AppStyles.text.semiBold(fSize: 16.sp),
                  align: TextAlign.center,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _sendReviewProduct(BuildContext context) {
    return InkWell(
      // onTap: () => context.navigator.pushNamed(ReviewDetailsScreen.keyName),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Viết đánh giá',
            style: AppStyles.text.semiBold(fSize: 14.sp),
          ),
          width(width: 8),
          CustomIconStyle(
            icon: CupertinoIcons.chevron_right,
            style: AppStyles.text.semiBold(fSize: 14.sp),
          ),
        ],
      ),
    );
  }

  Widget _productRating(Rating? rating) {
    return PlaceholderWidget(
      width: 195.w,
      height: 24.h,
      condition: rating != null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RatingBarWidget(value: rating?.avgStar ?? 0.0),
          width(width: 4),
          Text(
            '${(rating?.avgStar ?? 0.0).toStringAsFixed(1)}/5.0',
            style: AppStyles.text.semiBold(
              fSize: 16.sp,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}
