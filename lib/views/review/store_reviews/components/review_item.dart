part of '../store_reviews_screen.dart';

class _ReviewItem extends StatelessWidget {
  final Review review;
  const _ReviewItem(this.review);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          onTap: () => context.navigator.push(
            MaterialPageRoute(
              builder: (_) => ReviewDetailsScreen(review: review),
            ),
          ),
          child: Container(
            padding: EdgeInsets.all(20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Avatar(avatar: review.customer.avatar, size: 40.r),
                width(width: 15),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                review.customer.name,
                                style: AppStyles.text.semiBold(fSize: 16.sp),
                              ),
                              height(height: 5),
                              Text(
                                review.postDate.dateByFormat(
                                    format: DateTimeFormat.ddMMyyyy),
                                style: AppStyles.text.semiBold(
                                  fSize: 13.5.sp,
                                  color: AppColors.greyB3,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          RatingBarWidget(
                              value: review.score, size: 14, spacing: 4),
                        ],
                      ),
                      height(height: 16),
                      if (review.topicSentence != null)
                        Text(
                          '''" ${review.topicSentence!} "''',
                          style: AppStyles.text.bold(fSize: 18.sp),
                        ),
                      height(height: 8),
                      if (review.content != null)
                        Text(
                          review.content ?? '',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: AppStyles.text.medium(
                            fSize: 14.sp,
                            height: 1.39,
                            color: AppColors.black24,
                          ),
                        ),
                      height(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ..._likeComp(),
                          width(width: 20),
                          ..._disLikeComp(),
                          if (review.replyReviews.isNotEmpty)
                            ..._isRepliedComp(),
                          const Spacer(),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            margin: EdgeInsets.only(bottom: 11.5.h, right: 8.w),
            child: InkWell(
              onTap: () => context.navigator.push(
                MaterialPageRoute(
                  builder: (_) => ReviewDetailsScreen(review: review),
                ),
              ),
              borderRadius: BorderRadius.circular(30.r),
              splashColor: AppColors.primary.withOpacity(0.3),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.w),
                child: Text(
                  "Chi tiết",
                  style: AppStyles.text.semiBold(
                    fSize: 14.sp,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  // Components
  List<Widget> _likeComp() => [
        Text(
          "${review.likeCount ?? 0}",
          style: AppStyles.text.medium(fSize: 13.sp, color: AppColors.gray6A),
        ),
        width(width: 4),
        SvgPicture.asset(
          AppConstant.svgs.icLike,
          width: 20.w,
          colorFilter: const ColorFilter.mode(
            AppColors.gray6A,
            BlendMode.srcIn,
          ),
        ),
      ];

  List<Widget> _disLikeComp() => [
        Text(
          "${review.disLikeCount ?? 0}",
          style: AppStyles.text.medium(fSize: 13.sp, color: AppColors.gray6A),
        ),
        width(width: 4),
        SvgPicture.asset(
          AppConstant.svgs.icDisLike,
          width: 20.w,
          colorFilter: const ColorFilter.mode(
            AppColors.gray6A,
            BlendMode.srcIn,
          ),
        ),
      ];

  List<Widget> _isRepliedComp() => [
        width(width: 20),
        Text(
          "Bạn đã trở lời",
          style: AppStyles.text.medium(fSize: 13.sp, color: AppColors.gray6A),
        ),
        width(width: 4),
        SvgPicture.asset(
          AppConstant.svgs.icReplied,
          width: 20.w,
          colorFilter: const ColorFilter.mode(
            AppColors.gray6A,
            BlendMode.srcIn,
          ),
        ),
      ];
}
