import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zili_coffee/data/models/review/review.dart';
import 'package:zili_coffee/data/repositories/review_repository.dart';
import 'package:zili_coffee/di/dependency_injection.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/extension/build_context.dart';
import 'package:zili_coffee/utils/widgets/widgets.dart';
import 'package:zili_coffee/views/module_common/avatar.dart';
import 'package:zili_coffee/views/review/review_feedback/review_feedback_screen.dart';
part "components/send_feedback.dart";

class ReviewDetailsScreen extends StatelessWidget {
  final Review review;
  const ReviewDetailsScreen({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          SizedBox(
            width: Spaces.screenWidth(context),
            height: Spaces.screenHeight(context),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 44.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //* User information
                  Avatar(avatar: review.customer.avatar, size: 120.r),
                  height(height: 14),
                  Text(
                    review.customer.name,
                    style: AppStyles.text.semiBold(fSize: 20.sp),
                  ),
                  height(height: 4),
                  Text(
                    review.customer.email!,
                    style: AppStyles.text.mediumItalic(
                      fSize: 14.sp,
                      color: AppColors.gray6A,
                    ),
                  ),
                  //
                  height(height: 20),
                  Divider(
                    color: AppColors.lightGrey,
                    height: 1.5.h,
                    thickness: 1.5,
                  ),
                  height(height: 20),
                  //* Review details
                  Text(
                    "${review.score}",
                    style: AppStyles.text.bold(
                      fSize: 60.sp,
                      color: AppColors.black3,
                    ),
                  ),
                  height(height: 8),
                  RatingBarWidget(value: review.score, size: 28, spacing: 8),
                  height(height: 16),
                  Text(
                    "đã gửi đánh giá 2 ngày trước",
                    style: AppStyles.text.medium(
                      fSize: 16.sp,
                      color: AppColors.gray6A,
                    ),
                  ),
                  height(height: 13),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _agreedContainter(isAgreed: true),
                      width(width: 36.w),
                      _agreedContainter(isAgreed: false),
                    ],
                  ),
                  height(height: 32),
                  Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(10.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black24.withOpacity(0.3),
                          offset: const Offset(-1, 3),
                          blurRadius: 5.r,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '''" ${review.topicSentence!} "''',
                          style: AppStyles.text
                              .bold(
                                fSize: 18.sp,
                                color: AppColors.black24,
                              )
                              .copyWith(fontStyle: FontStyle.italic),
                        ),
                        height(height: 8),
                        Text(
                          review.content!,
                          maxLines: 1000,
                          style: AppStyles.text.mediumItalic(
                            fSize: 15.sp,
                            height: 1.39,
                            color: AppColors.black24,
                          ),
                        ),
                      ],
                    ),
                  ),
                  height(height: 32),
                  _SendFeedback(review: review),
                ],
              ),
            ),
          ),
          _backButton(context),
        ],
      ),
    );
  }

  Widget _backButton(BuildContext context) {
    return Positioned(
      top: 48.h,
      left: 20.w,
      child: InkWell(
        onTap: () => context.navigator.pop(),
        borderRadius: BorderRadius.circular(100.r),
        child: Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.grey.withOpacity(0.3),
          ),
          alignment: Alignment.center,
          child: const Icon(Icons.arrow_back, color: AppColors.white),
        ),
      ),
    );
  }

  Widget _agreedContainter({required bool isAgreed}) {
    return Container(
      width: 96.w,
      height: 36.h,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.gray6A),
        borderRadius: BorderRadius.circular(100.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            isAgreed ? AppConstant.svgs.icLike : AppConstant.svgs.icDisLike,
            width: 20.w,
            colorFilter: const ColorFilter.mode(
              AppColors.black24,
              BlendMode.srcIn,
            ),
          ),
          width(width: 8),
          Text(
            "|",
            style: AppStyles.text.medium(fSize: 14.sp, color: AppColors.gray6A),
          ),
          width(width: 8),
          Text(
            "${isAgreed ? review.likeCount ?? 0 : review.disLikeCount ?? 0}",
            style: AppStyles.text.semiBold(
              fSize: 16.sp,
              color: AppColors.black24,
            ),
          ),
        ],
      ),
    );
  }
}
