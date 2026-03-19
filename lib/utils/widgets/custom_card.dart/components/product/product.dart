part of '../../custom_card_widget.dart';

class _Product extends StatefulWidget {
  final Product? product;
  const _Product({this.product});

  @override
  State<_Product> createState() => _ProductState();
}

class _ProductState extends State<_Product> {
  final ProductCubit cubit = di<ProductCubit>();
  final ProductRepository productRepository = di<ProductRepository>();
  final GlobalKey widgetKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final condition =
        widget.product?.promotion != null && widget.product!.promotion! > 0;
    return InkWell(
      onTap: () => onTapProduct(context),
      child: Stack(
        children: [
          Container(
            width: 155.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withOpacity(0.15),
                  offset: const Offset(0.0, 0.0),
                  blurRadius: 3.r,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 155.w,
                  key: widgetKey,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(10.r),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(10.r),
                    ),
                    child: ImageLoadingWidget(
                      width: 165.w,
                      height: 155.w,
                      borderRadius: false,
                      url: widget.product?.imageBaseUrlThumb ??
                          widget.product?.imageBaseUrl ??
                          '',
                    ),
                  ),
                ),
                height(height: 12),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    width(width: 12),
                    PlaceholderWidget(
                      width: 130.w,
                      height: 17.h,
                      borderRadius: false,
                      condition: widget.product != null &&
                          widget.product?.nameDisplay != null,
                      child: SizedBox(
                        width: 130.w,
                        child: Text(
                          widget.product?.nameMobileDisplay ??
                              widget.product?.nameDisplay ??
                              '',
                          overflow: TextOverflow.ellipsis,
                          style: AppStyles.text.semiBold(fSize: 16.sp),
                        ),
                      ),
                    )
                  ],
                ),
                height(height: 5),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    width(width: 12),
                    PlaceholderWidget(
                      width: 82.w,
                      height: 13.h,
                      borderRadius: false,
                      condition: widget.product != null &&
                          widget.product?.brand != null,
                      child: Text(
                        widget.product?.brand ?? '',
                        style: AppStyles.text.semiBold(
                          fSize: 16.sp,
                          color: const Color(0xFFB1B1B1),
                        ),
                      ),
                    )
                  ],
                ),
                height(height: 15),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 7.w),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(76.r),
                    child: PlaceholderWidget(
                      width: 141,
                      height: 35,
                      condition: widget.product != null,
                      child: _AddToCartBtn(
                        product: widget.product,
                        condition: condition,
                        onTap: openProductModal,
                      ),
                    ),
                  ),
                ),
                height(height: 10),
              ],
            ),
          ),
          if (condition)
            _SaleBanner(
              price: widget.product!.price,
              promotionPrice: widget.product!.promotionPrice!,
              promotionType: widget.product!.promotionType ?? "",
            )
        ],
      ),
    );
  }

  void openProductModal() {
    // if (widget.product == null) return;
    // cubit.getDetailProduct(prod: widget.product!);
    // CustomModalBottomSheet.build2(
    //   context,
    //   child: _ProductInfoModal(widgetKey: widgetKey),
    // );
  }

  void onTapProduct(BuildContext context) {
    // if (widget.product == null) return;
    // if (productRepository.productDetailStreamData.hasValue &&
    //     productRepository.productDetailStreamData.value!.id ==
    //         widget.product!.id &&
    //     productRepository.productDetailStreamData.value!.detail != null) {
    //   di<ReviewRepository>().currentProduct = widget.product!;
    //   context.navigator.pushNamed(ProductDetailScreen.keyName);
    // } else {
    //   productRepository.productDetailStreamData.sink.add(null);
    //   cubit.getDetailProduct(prod: widget.product!);
    //   di<ReviewRepository>().currentProduct = widget.product!;
    //   context.navigator.pushNamed(ProductDetailScreen.keyName);
    // }
  }
}
