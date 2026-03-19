part of '../../custom_card_widget.dart';

class _CartItem extends StatelessWidget {
  final ProductCart? productCart;
  final Function()? removeItem;
  final bool readOnly;
  const _CartItem({
    required this.productCart,
    this.removeItem,
    required this.readOnly,
  });

  @override
  Widget build(BuildContext context) {
    final CartCubit cartCubit = di<CartCubit>();
    return Stack(
      children: [
        InkWell(
          onTap: () {
            if (productCart == null) return;
            cartCubit.getDetailProduct(productCart!);
            context.navigator.pushNamed(ProductDetailScreen.keyName);
          },
          child: Container(
            margin: removeItem != null
                ? EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h)
                : null,
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(7.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 84.w,
                  height: 84.w,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(3.r),
                    child: productCart != null && productCart?.img != null
                        ? ImageLoadingWidget(
                            width: 84.w,
                            height: 84.w,
                            color: AppColors.white,
                            highlightColor: AppColors.lightGrey,
                            borderRadius: false,
                            url: productCart!.img!,
                          )
                        : PlaceholderWidget(
                            width: 84.w,
                            height: 84.w,
                            borderRadius: false,
                            color: AppColors.white,
                            highlightColor: AppColors.lightGrey,
                          ),     
                  ),
                ),
                width(width: 15),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PlaceholderWidget(
                        width: 200.w,
                        height: 15.h,
                        condition:
                            productCart != null && productCart?.name != null,
                        color: AppColors.white,
                        highlightColor: AppColors.lightGrey,
                        borderRadius: false,
                        child: Text(
                          productCart?.name ?? '',
                          style: AppStyles.text.semiBold(fSize: 14.sp),
                        ),
                      ),
                      height(height: 7),
                      PlaceholderWidget(
                        width: 200.w,
                        height: 13.h,
                        condition:
                            productCart != null && productCart?.name != null,
                        color: AppColors.white,
                        highlightColor: AppColors.lightGrey,
                        borderRadius: false,
                        child: productCartOptions(),
                      ),
                      height(height: 24),
                      PlaceholderWidget(
                        width: 230.w,
                        height: 20.h,
                        condition:
                            productCart != null && productCart?.name != null,
                        color: AppColors.white,
                        highlightColor: AppColors.lightGrey,
                        borderRadius: false,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (productCart?.pricePromotion != null) ...[
                              Container(
                                margin: EdgeInsets.only(bottom: 2.h),
                                child: Text(
                                  (productCart?.price ?? 0).toPrice(),
                                  style: AppStyles.text
                                      .bold(
                                        fSize: 10.sp,
                                        color: AppColors.gray4B,
                                      )
                                      .copyWith(
                                          decoration:
                                              TextDecoration.lineThrough),
                                ),
                              ),
                              width(width: 4.w),
                              Text(
                                (productCart?.pricePromotion ?? 0).toPrice(),
                                style: AppStyles.text.bold(fSize: 16.sp),
                              )
                            ] else
                              Text(
                                (productCart?.price ?? 0).toPrice(),
                                style: AppStyles.text.bold(fSize: 16.sp),
                              ),
                            const Spacer(),
                            QuantityWidget(
                              sizeBtn: 20.w,
                              fSize: 14.sp,
                              defaultValue: productCart?.qty ?? 1,
                              readOnly: readOnly,
                              onChangedQty: (qty) {
                                if (productCart == null) return;
                                cartCubit.updateQty(productCart!, qty.toInt());
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        if (removeItem != null)
          Positioned(
            top: 5,
            right: 10,
            child: InkWell(
              onTap: removeItem,
              child: Container(
                padding: EdgeInsets.all(5.w),
                decoration: BoxDecoration(
                  color: AppColors.red,
                  shape: BoxShape.circle,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: AppColors.red.withOpacity(0.25),
                      offset: const Offset(0.0, 5.0),
                      blurRadius: 4.r,
                    ),
                  ],
                ),
                child: SvgPicture.asset(
                  AppConstant.svgs.icXmarkXl,
                  width: 15.w,
                  height: 15.h,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget productCartOptions() {
    if (productCart?.variantID == null) return Container();
    String result = '';
    String space = '\t\t';
    String divider = '|';
    result += productCart?.option2 != null ? '${productCart?.option2} ' : '';
    result += '(${productCart?.option1})';
    result += productCart?.option3 != null
        ? ' $space$divider${space}túi ${productCart?.option3}'
        : '';

    return Text(result, style: AppStyles.text.medium(fSize: 12.sp));
  }
}
