part of '../../custom_card_widget.dart';

class _LayoutBlogHorizontal extends StatelessWidget {
  final Blog? blog;
  const _LayoutBlogHorizontal({required this.blog});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Spaces.screenWidth(context) - 40.w,
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(5.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.25),
            blurRadius: 4.r,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(9.r),
            child: ImageLoadingWidget(
              url: blog?.thumbnail ?? '',
              width: 105.w,
              height: 70.h,
            ),
          ),
          width(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PlaceholderWidget(
                width: 67.w,
                height: 13.h,
                condition: blog != null,
                child: Text(
                  blog?.postDate ?? '',
                  style: AppStyles.text.medium(
                    fSize: 12.sp,
                    color: AppColors.black24,
                  ),
                ),
              ),
              height(height: 5),
              PlaceholderWidget(
                width: 215.w,
                height: 21.h,
                condition: blog != null,
                child: SizedBox(
                  width: 214.w,
                  child: Text(
                    blog?.title ?? '',
                    overflow: TextOverflow.ellipsis,
                    style: AppStyles.text.semiBold(
                      fSize: 14.sp,
                      color: AppColors.black24,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
              height(height: 3),
              PlaceholderWidget(
                width: 215.w,
                height: 28.h,
                condition: blog != null,
                child: SizedBox(
                  width: 214.w,
                  child: Text(
                    blog?.description ?? '',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: AppStyles.text.medium(
                      fSize: 12.sp,
                      color: AppColors.black24,
                      height: 1.205,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
