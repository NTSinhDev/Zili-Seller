part of '../chat_screen.dart';

class _SuggestedMessage extends StatelessWidget {
  final String suggestedMsg;
  const _SuggestedMessage({required this.suggestedMsg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      margin: EdgeInsets.only(top: 10.w, right: 20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: AppColors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.black.withOpacity(0.15),
            offset: const Offset(0.0, 2.0),
            blurRadius: 5.r,
          ),
        ],
      ),
      child: SizedBox(
        width: 216.w,
        child: Text(
          suggestedMsg,
          style: AppStyles.text.medium(fSize: 14.sp),
        ),
      ),
    );
  }
}
