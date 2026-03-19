part of '../orders_management_screen.dart';

class _SearchBar extends StatelessWidget {
  final bool hideShadow;
  final TextEditingController controller;
  const _SearchBar({
    this.hideShadow = false,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Spaces.screenWidth(context),
      height: 44.h,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      margin: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.h),
      decoration: BoxDecoration(
        color:
            !hideShadow ? AppColors.white : AppColors.lightF.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12.r),
        border: hideShadow
            ? Border.all(color: AppColors.black.withOpacity(0.1))
            : null,
        boxShadow: <BoxShadow>[
          if (!hideShadow)
            BoxShadow(
              color: AppColors.black.withOpacity(0.25),
              offset: const Offset(0, 3),
              blurRadius: 8.r,
            ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              cursorColor: AppColors.primary,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.search,
              scrollPadding: const EdgeInsets.all(0),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(0),
                hintText: "Mã đơn, tên, sđt người nhận/khách hàng",
                hintStyle: AppStyles.text.medium(
                  fSize: 14.sp,
                  color: AppColors.black24.withOpacity(0.7),
                ),
              ),
              style: AppStyles.text.medium(fSize: 16.sp),
            ),
          ),
          width(width: 12),
          const Icon(CupertinoIcons.search),
        ],
      ),
    );
  }
}
