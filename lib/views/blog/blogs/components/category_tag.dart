part of '../blogs_screen.dart';

class _CategoryTag extends StatelessWidget {
  final String category;
  const _CategoryTag({required this.category});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(48.r),
      child: PlaceholderWidget(
        width: 104.w,
        height: 29.h,
        condition: category.isNotEmpty,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          width: category.isEmpty ? 104.w : null,
          height: category.isEmpty ? 29.h : null,
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(0.1),
                blurRadius: 2.r,
              ),
            ],
          ),
          child: Text(category, style: AppStyles.text.semiBold(fSize: 14.sp)),
        ),
      ),
    );
  }
}
