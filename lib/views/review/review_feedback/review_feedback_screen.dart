import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/bloc/review/review_cubit.dart';
import 'package:zili_coffee/data/models/review/review.dart';
import 'package:zili_coffee/di/dependency_injection.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/extension/build_context.dart';
import 'package:zili_coffee/utils/widgets/widgets.dart';
import 'package:zili_coffee/views/module_common/avatar.dart';

class ReviewFeedbackScreen extends StatefulWidget {
  final Review review;
  const ReviewFeedbackScreen({super.key, required this.review});

  @override
  State<ReviewFeedbackScreen> createState() => _ReviewFeedbackScreenState();
}

class _ReviewFeedbackScreenState extends State<ReviewFeedbackScreen> {
  String? _feedback;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightF,
      appBar: AppBarWidget.lightAppBar(
        context,
        label: "Gửi phản hồi",
        elevation: 1.5,
      ),
      body: GestureDetector(
        onTap: () => context.focus.unfocus(),
        child: SingleChildScrollView(
          child: SizedBox(
            width: Spaces.screenWidth(context),
            height: Spaces.screenHeight(context) - 100.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _reviewInformation(),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 24.h,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        height(height: 14),
                        Text(
                          "Viết phản hồi",
                          style: AppStyles.text.semiBold(fSize: 18.sp),
                        ),
                        height(height: 20),
                        MultilineInputFieldWidget(
                          hint: 'Viết phản hồi gửi đến khách hàng...',
                          onChanged: (feedback) {
                            _feedback = feedback;
                          },
                          textStyle: AppStyles.text.medium(
                            fSize: 15.sp,
                            height: 1.3,
                          ),
                          hintColor: AppColors.grey.withOpacity(0.8),
                          inputColor: AppColors.lightF,
                          borderWeight: 0.8.sp,
                          radius: 10.r,
                          line: 15,
                        ),
                        height(height: 10),
                        const Spacer(),
                        CustomButtonWidget(
                          onTap: () async {
                            await di<ReviewCubit>()
                                .sendFeedback(message: _feedback ?? '');
                            if (mounted) {
                              context.navigator.pop(_feedback);
                            }
                          },
                          label: 'Gửi phản hồi'.toUpperCase(),
                          radius: 6.r,
                        ),
                        height(height: 14),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container _reviewInformation() {
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Avatar(avatar: widget.review.customer.avatar, size: 80.r),
          width(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PlaceholderWidget(
                  width: 162.w,
                  height: 17.h,
                  condition: true,
                  borderRadius: false,
                  child: Text(
                    widget.review.customer.name,
                    style: AppStyles.text.semiBold(fSize: 16.sp, height: 1.18),
                  ),
                ),
                height(height: 4),
                RatingBarWidget(
                    value: widget.review.score, size: 11, spacing: 3),
                height(height: 8),
                Text(
                  widget.review.content!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.text.medium(
                    fSize: 14.sp,
                    color: const Color(0xFF303030),
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
