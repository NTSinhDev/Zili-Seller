import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zili_coffee/res/res.dart';

class TagWidget extends StatefulWidget {
  final bool isActive;
  final String label;
  final Function() onTap;
  const TagWidget({
    super.key,
    this.isActive = false,
    required this.label,
    required this.onTap,
  });

  @override
  State<TagWidget> createState() => _TagWidgetState();
}

class _TagWidgetState extends State<TagWidget> {
  late bool isActive;

  @override
  void initState() {
    super.initState();
    isActive = widget.isActive;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isActive = !isActive;
        });
        widget.onTap();
      },
      splashColor: Colors.transparent,
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 5.h),
            padding: EdgeInsets.symmetric(vertical: 9.h, horizontal: 12.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              border: Border.all(
                  color: isActive ? AppColors.primary : AppColors.black),
              color: isActive ? AppColors.primary : AppColors.white,
            ),
            child: Text(
              widget.label,
              style: AppStyles.text.medium(
                fSize: 12.sp,
                color: isActive ? AppColors.white : AppColors.black,
              ),
            ),
          ),
          if (isActive) _deleteBtn(),
        ],
      ),
    );
  }

  Widget _deleteBtn() {
    return Positioned(
      top: 0,
      right: 0,
      child: Container(
        width: 15.w,
        height: 15.w,
        decoration: BoxDecoration(
          color: AppColors.white,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.black),
        ),
        child: Center(child: SvgPicture.asset(AppConstant.svgs.icXmark)),
      ),
    );
  }
}
