part of '../../custom_card_widget.dart';

class _LayoutBlogVertical extends StatelessWidget {
  final Blog? blog;
  final bool fullView;
  const _LayoutBlogVertical({required this.blog, this.fullView = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (blog == null) return;
        context.navigator.push(
          MaterialPageRoute(
            builder: (context) => BlogDetailScreen(blog: blog!),
          ),
        );
      },
      child: Container(
        width: 252.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.r),
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.15),
              offset: const Offset(0.0, 0.0),
              blurRadius: 3.r,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(6.r),
              ),
              child: ImageLoadingWidget(
                width: 252.w,
                height: 131.w,
                borderRadius: false,
                url: blog?.thumbnail ?? '',
              ),
            ),
            height(height: 12),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                width(width: 12),
                PlaceholderWidget(
                  width: 78.w,
                  height: 15.w,
                  condition: blog != null,
                  child: Text(
                    blog?.postDate ?? '',
                    style: AppStyles.text.semiBold(
                      fSize: 14.sp,
                      color: AppColors.black.withOpacity(0.5),
                    ),
                  ),
                ),
              ],
            ),
            height(height: 5),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                width(width: 12),
                PlaceholderWidget(
                  width: 224.w,
                  height: 20.h,
                  condition: blog != null,
                  child: Expanded(
                    child: Text(
                      blog?.title ?? '',
                      maxLines: 2,
                      style:
                          AppStyles.text.semiBold(fSize: 16.sp, height: 1.35),
                    ),
                  ),
                ),
              ],
            ),
            if (fullView) ...[
              height(height: 5),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  width(width: 12),
                  PlaceholderWidget(
                    width: 224.w,
                    height: 20.h,
                    condition: blog != null,
                    child: Expanded(
                      child: Text(
                        blog?.description ?? '',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style:
                            AppStyles.text.medium(fSize: 14.sp, height: 1.35),
                      ),
                    ),
                  ),
                ],
              ),
            ],
            height(height: 16),
          ],
        ),
      ),
    );
  }
}
