import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/res/res.dart';

class ProgressStepperWidget extends StatelessWidget {
  final int currentStep;
  final Color? backgroundColor;

  /// only three items
  final List<String> labels;
  const ProgressStepperWidget({
    super.key,
    required this.currentStep,
    required this.labels,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Spaces.screenWidth(context),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 23.h),
      color: backgroundColor ?? AppColors.lightGrey,
      child: Column(
        children: [
          SizedBox(
            width: Spaces.screenWidth(context) * 2 / 3 + 10.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _node(isDone: currentStep > 0, isActive: currentStep == 0),
                _processBar(
                  currentStep > 0,
                  (Spaces.screenWidth(context) / 3) - 25.w,
                ),
                _node(isDone: currentStep > 1, isActive: currentStep == 1),
                _processBar(
                  currentStep > 1,
                  (Spaces.screenWidth(context) / 3) - 25.w,
                ),
                _node(isDone: currentStep > 2, isActive: currentStep == 2),
              ],
            ),
          ),
          height(height: 9),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: labels
                .map((label) => SizedBox(
                      width: (Spaces.screenWidth(context) - 100.w) / 3,
                      child: Text(
                        label,
                        maxLines: 2,
                        style: AppStyles.text.semiBold(
                          fSize: 14.sp,
                          color: AppColors.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ))
                .toList(),
          )
        ],
      ),
    );
  }

  Widget _node({required bool isDone, required bool isActive}) {
    return Container(
      width: 20.w,
      height: 20.w,
      decoration: BoxDecoration(
        border:
            Border.all(color: AppColors.primary, width: isActive ? 2.w : 1.5.h),
        shape: BoxShape.circle,
        color: isDone ? AppColors.primary : AppColors.white,
      ),
      child: Center(
        child: Icon(
          CupertinoIcons.checkmark_alt,
          size: 16.sp,
          color: AppColors.white,
        ),
      ),
    );
  }

  Widget _processBar(bool isDone, double maxWidth) {
    return Stack(
      children: [
        Container(
          width: maxWidth,
          height: 0.8.h,
          color: AppColors.primary,
        ),
        AnimatedContainer(
          width: isDone ? maxWidth : 0,
          height: 2.h,
          duration: const Duration(milliseconds: 600),
          color: AppColors.primary,
          curve: Curves.easeInOut,
        ),
      ],
    );
  }
}
