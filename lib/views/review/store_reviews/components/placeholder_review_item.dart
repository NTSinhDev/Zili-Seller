part of '../store_reviews_screen.dart';

class _PlaceHolderReviewItem extends StatelessWidget {
  const _PlaceHolderReviewItem();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40.r,
            height: 40.r,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.grayEA,
            ),
          ),
          width(width: 15),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    PlaceholderWidget(
                      width: 120.w,
                      height: 17.h,
                    ),
                    PlaceholderWidget(
                      width: 86.w,
                      height: 12.h
                    ),
                  ],
                ),
                height(height: 5),
                Row(
                  children: [
                    PlaceholderWidget(
                      width: 86.w,
                      height: 11.h,
                    ),
                  ],
                ),
                height(height: 12),
                PlaceholderWidget(
                  width: 296.w,
                  height: 38.h,
                ),
                height(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    PlaceholderWidget(width: 52.w, height: 52.w),
                    width(width: 6),
                    PlaceholderWidget(width: 52.w, height: 52.w),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
