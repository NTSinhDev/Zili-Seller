import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/res/res.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Spaces.screenWidth(context),
      height: 48.h,
      margin: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.h),
      decoration: BoxDecoration(
        color: AppColors.beige,
        borderRadius: BorderRadius.circular(60.r),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.black24.withOpacity(0.1),
            offset: const Offset(0, 1),
            blurRadius: 3.r,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(60.r),
        child: Row(
          children: [
            width(width: 20),
            Expanded(
              child: TextField(
                cursorColor: AppColors.primary,
                onChanged: (value) {},
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.search,
                textCapitalization: TextCapitalization.sentences,
                scrollPadding: const EdgeInsets.all(0),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(0),
                  hintText: "Nhập tên sản phẩm cần tìm...",
                  hintStyle: AppStyles.text.medium(
                    fSize: 14.sp,
                    color: AppColors.black24.withOpacity(0.7),
                  ),
                ),
                style: AppStyles.text.medium(fSize: 16.sp),
              ),
            ),
            width(width: 12),
            Container(
              height: 48.h,
              width: 50.w,
              color: AppColors.primary,
              alignment: Alignment.center,
              child: const Icon(CupertinoIcons.search, color: AppColors.beige),
            ),
          ],
        ),
      ),
    );
  }
}
