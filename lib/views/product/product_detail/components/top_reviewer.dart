part of '../product_detail_screen.dart';

class _TopReviewer extends StatelessWidget {
  final List<Review> reviews;
  const _TopReviewer({required this.reviews});

  @override
  Widget build(BuildContext context) {
    double spacing = -25;
    final topReviews = (reviews.length > 4 ? reviews.getRange(0, 4) : reviews);
    return Container(
      constraints: BoxConstraints(maxHeight: 40.h, maxWidth: 115.w),
      child: Stack(
        children: topReviews.map((review) {
          spacing += 25;
          if (spacing == 75) return reviewer(spacing: 75.w, more: true);
          return reviewer(avatar: review.customer.avatar, spacing: spacing.w);
        }).toList(),
      ),
    );
  }

  Widget reviewer({double? spacing, String? avatar, bool? more}) {
    return Positioned(
      left: spacing ?? 0,
      child: CircleAvatar(
        backgroundImage:
            avatar != null ? CachedNetworkImageProvider(avatar) : null,
        backgroundColor: AppColors.white,
        radius: 19.w,
        child: avatar == null
            ? more != null
                ? _moreView()
                : Icon(Icons.person, size: 24.sp, color: AppColors.primary)
            : null,
      ),
    );
  }

  Widget _moreView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 3.w,
          height: 3.w,
          decoration: const BoxDecoration(
            color: AppColors.black,
            shape: BoxShape.circle,
          ),
        ),
        width(width: 1),
        Container(
          width: 3.w,
          height: 3.w,
          decoration: const BoxDecoration(
            color: AppColors.black,
            shape: BoxShape.circle,
          ),
        ),
        width(width: 1),
        Container(
          width: 3.w,
          height: 3.w,
          decoration: const BoxDecoration(
            color: AppColors.black,
            shape: BoxShape.circle,
          ),
        )
      ],
    );
  }
}
