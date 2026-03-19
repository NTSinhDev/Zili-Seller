part of "../review_details_screen.dart";

class _SendFeedback extends StatefulWidget {
  final Review review;
  const _SendFeedback({required this.review});

  @override
  State<_SendFeedback> createState() => _SendFeedbackState();
}

class _SendFeedbackState extends State<_SendFeedback> {
  String _yourFeedback = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              _yourFeedback.isEmpty
                  ? 'Viết phản hồi đến khách hàng'
                  : 'Phản hồi',
              style: AppStyles.text.semiBold(
                fSize: 16.sp,
                color: AppColors.black24,
              ),
            ),
          ],
        ),
        height(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: InkWell(
            onTap: () async {
              context.navigator
                  .push(MaterialPageRoute(
                      builder: (context) =>
                          ReviewFeedbackScreen(review: widget.review)))
                  .then((value) {
                final ReviewRepository reviewRepository =
                    di<ReviewRepository>();
                setState(() {
                  _yourFeedback = reviewRepository.yourFeedback ?? '';
                });
              });
            },
            child: Container(
              width: Spaces.screenWidth(context),
              height: _yourFeedback.isEmpty ? 80.h : null,
              padding: EdgeInsets.all(16.w),
              color: AppColors.lightF,
              child: Text(
                _yourFeedback.isEmpty ? "..." : _yourFeedback,
                style: AppStyles.text.semiBold(
                  fSize: 16.sp,
                  color: AppColors.gray6A,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
