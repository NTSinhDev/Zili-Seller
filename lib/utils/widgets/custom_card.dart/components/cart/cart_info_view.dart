part of '../../custom_card_widget.dart';

class _CartInfoView extends StatelessWidget {
  final bool lessInfo;
  final OrderLineItem? orderItem;
  final Function()? more;
  const _CartInfoView({
    this.lessInfo = false,
    this.more,
    required this.orderItem,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // SizedBox(
        //   width: lessInfo ? 52.w : 80.w,
        //   height: lessInfo ? 52.w : 80.w,
        //   child: orderItem != null
        //       ? ImageLoadingWidget(
        //           width: lessInfo ? 52.w : 80.w,
        //           height: lessInfo ? 52.w : 80.w,
        //           borderRadius: false,
        //           url: orderItem!.productVariant.thumbUrl,
        //         )
        //       : PlaceholderWidget(
        //           width: lessInfo ? 52.w : 80.w,
        //           height: lessInfo ? 52.w : 80.w,
        //           borderRadius: false,
        //         ),
        // ),
        width(width: lessInfo ? 12 : 15),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PlaceholderWidget(
                width: 130.w,
                height: 16.h,
                borderRadius: false,
                condition: orderItem != null,
                child: Text(
                  _getName(),
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.text.semiBold(
                    fSize: 14.sp,
                    height: 1.145,
                  ),
                ),
              ),
              height(height: 5),
              PlaceholderWidget(
                width: 222.w,
                height: 13.h,
                borderRadius: false,
                condition: orderItem != null,
                child: CustomRichTextWidget(
                  defaultStyle: AppStyles.text.semiBold(
                    fSize: 12.sp,
                    color: AppColors.gray4A,
                  ),
                  texts: [
                    'Dạng - kiểu pha:\t\t',
                    // TextSpan(
                    //   text:
                    //       '${orderItem?.productVariant.opt2} - ${orderItem?.productVariant.opt1}',
                    //   style: AppStyles.text.medium(
                    //     fSize: 12.sp,
                    //     color: AppColors.gray4A,
                    //   ),
                    // ),
                  ],
                ),
              ),
              height(height: 5),
              PlaceholderWidget(
                width: 115.w,
                height: 13.h,
                borderRadius: false,
                condition: orderItem != null,
                child: CustomRichTextWidget(
                  defaultStyle: AppStyles.text.semiBold(
                    fSize: 12.sp,
                    color: AppColors.gray4A,
                  ),
                  texts: [
                    'Khối lượng:\t\t',
                    // TextSpan(
                    //   text: 'Túi ${orderItem?.productVariant.opt3}',
                    //   style: AppStyles.text.medium(
                    //     fSize: 12.sp,
                    //     color: AppColors.gray4A,
                    //   ),
                    // ),
                  ],
                ),
              ),
              height(height: 12),
              if (!lessInfo)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // PlaceholderWidget(
                    //   width: 77.w,
                    //   height: 16.h,
                    //   borderRadius: false,
                    //   condition: orderItem != null,
                    //   child: Text(
                    //     '${(orderItem?.price ?? 0).toPrice()}\t\t\tx${orderItem?.quantity ?? 0}',
                    //     style: AppStyles.text.semiBold(
                    //       fSize: 14.sp,
                    //       height: 1.145,
                    //     ),
                    //   ),
                    // ),
                    if (more != null)
                      InkWell(
                        onTap: more,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                          child: Text(
                            'Xem thêm',
                            style: AppStyles.text.medium(
                                fSize: 14.sp,
                                height: 1.145,
                                color: AppColors.primary),
                          ),
                        ),
                      ),
                  ],
                ),
            ],
          ),
        )
      ],
    );
  }

  String _getName() =>
      /* orderItem?.productVariant.productName.split(' - ')[1] ?? */ '';
}
