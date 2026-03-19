part of '../store_reviews_screen.dart';

class _StoreRating extends StatelessWidget {
  const _StoreRating();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      margin: EdgeInsets.fromLTRB(20.w, 20.w, 20.w, 74.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: AppColors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.black24.withOpacity(0.2),
            offset: const Offset(0, 1),
            blurRadius: 6.r,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    (Rating.rating.avgStar ?? 0.0).toStringAsFixed(1),
                    style: AppStyles.text.bold(fSize: 45.sp),
                    textAlign: TextAlign.center,
                  ),
                  height(height: 12),
                  RatingBarWidget(
                    value: Rating.rating.avgStar ?? 0.0,
                    size: 18,
                    spacing: 7.68,
                  ),
                  height(height: 12),
                  Text(
                    '${Rating.rating.total} đánh giá',
                    style: AppStyles.text.medium(fSize: 16.sp),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              width(width: 10),
              Container(
                width: 1.w,
                height: 122.h,
                color: AppColors.lightGrey,
              ),
              width(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _processRating(
                      label: '5',
                      reviewByStar: Rating.rating.totalStar5,
                      totalRecords: Rating.rating.total,
                    ),
                    height(height: 8),
                    _processRating(
                      label: '4',
                      reviewByStar: Rating.rating.totalStar4,
                      totalRecords: Rating.rating.total,
                    ),
                    height(height: 8),
                    _processRating(
                      label: '3',
                      reviewByStar: Rating.rating.totalStar3,
                      totalRecords: Rating.rating.total,
                    ),
                    height(height: 8),
                    _processRating(
                      label: '2',
                      reviewByStar: Rating.rating.totalStar2,
                      totalRecords: Rating.rating.total,
                    ),
                    height(height: 8),
                    _processRating(
                      label: '1',
                      reviewByStar: Rating.rating.totalStar1,
                      totalRecords: Rating.rating.total,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // List<Widget> _ratingByStars() {
  //   List<Widget> ratingsDetail = [];
  //   for (var i = 5; i < 1; i--) {}
  //   return ratingsDetail;
  // }

  Widget _processRating({
    required String label,
    int reviewByStar = 0,
    required int totalRecords,
  }) {
    Widget processBar() {
      Widget bar(Color color, double width) => Container(
            width: width < 1 && width > 0 ? 1 : width,
            height: 5.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(48.r),
              color: color,
            ),
          );

      return SizedBox(
        width: 140.w,
        height: 5.h,
        child: Stack(
          children: [
            bar(const Color(0xFFF2F0F0), 140.w),
            bar(
              const Color(0xFFFFC80B),
              reviewByStar / totalRecords * 140.w,
            ),
          ],
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 8.w,
          child: Text(label, style: AppStyles.text.medium(fSize: 14.sp)),
        ),
        width(width: 4),
        SvgPicture.asset(AppConstant.svgs.icStar, width: 9.w, height: 9.w),
        width(width: 6),
        Expanded(child: processBar()),
        width(width: 6),
        SizedBox(
          width: 12.w,
          child:
              Text('$reviewByStar', style: AppStyles.text.medium(fSize: 12.sp)),
        ),
      ],
    );
  }
}
