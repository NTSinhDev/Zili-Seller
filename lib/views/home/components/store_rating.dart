part of '../home_screen.dart';

class _StoreRating extends StatefulWidget {
  const _StoreRating();

  @override
  State<_StoreRating> createState() => _StoreRatingState();
}

class _StoreRatingState extends State<_StoreRating> {
  // final ProductRepository _productRepo = di<ProductRepository>();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 24.w,
                height: 24.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.r),
                  color: AppColors.yellow,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withOpacity(0.1),
                      offset: const Offset(1, 1),
                      blurRadius: 4.r,
                    ),
                  ],
                ),
                child: SvgPicture.asset(
                  AppConstant.svgs.icStar,
                  width: 14.w,
                  height: 14.w,
                  fit: BoxFit.fill,
                  colorFilter: const ColorFilter.mode(
                    AppColors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              width(width: 10),
              Text(
                'Đánh giá cửa hàng',
                style: AppStyles.text.semiBold(fSize: 16.sp),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(12.w),
            margin: EdgeInsets.symmetric(vertical: 20.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: AppColors.white,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: AppColors.black.withOpacity(0.2),
                  offset: const Offset(0, 0),
                  blurRadius: 5.r,
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
                            spacing: 7.68),
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
                    _detail(Rating.rating),
                  ],
                ),
              ],
            ),
          ),
          Text(
            'Mới nhất',
            style: AppStyles.text.semiBold(fSize: 16.sp),
          ),
          height(height: 8),
          ...newestRating(),
        ],
      ),
    );
  }

  List<Widget> newestRating() {
    return List.generate(
      3,
      (index) => Container(
        padding: EdgeInsets.all(10.w),
        margin: EdgeInsets.symmetric(vertical: 5.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.15),
              offset: const Offset(0, 0),
              blurRadius: 4.r,
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            width(width: 5),
            Avatar(avatar: null, size: 40.r),
            width(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Joby John",
                        style: AppStyles.text.semiBold(fSize: 14.sp),
                      ),
                      const Spacer(),
                      const RatingBarWidget(
                        value: 4,
                        size: 11,
                        spacing: 3,
                      ),
                    ],
                  ),
                  height(height: 6),
                  Text(
                    '''Lorem Ipsum is simply dummy text of the printing and typesetting industry.''',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyles.text.medium(
                      fSize: 12.5.sp,
                      height: 1.25,
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

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

  Widget _detail(Rating rating) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _processRating(
            label: '5',
            reviewByStar: rating.totalStar5,
            totalRecords: rating.total,
          ),
          height(height: 8),
          _processRating(
            label: '4',
            reviewByStar: rating.totalStar4,
            totalRecords: rating.total,
          ),
          height(height: 8),
          _processRating(
            label: '3',
            reviewByStar: rating.totalStar3,
            totalRecords: rating.total,
          ),
          height(height: 8),
          _processRating(
            label: '2',
            reviewByStar: rating.totalStar2,
            totalRecords: rating.total,
          ),
          height(height: 8),
          _processRating(
            label: '1',
            reviewByStar: rating.totalStar1,
            totalRecords: rating.total,
          ),
        ],
      ),
    );
  }
}
