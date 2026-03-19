part of '../product_detail_screen.dart';

class _ProductInformation extends StatelessWidget {
  const _ProductInformation();

  @override
  Widget build(BuildContext context) {
    final ProductRepository productRepository = di<ProductRepository>();
    return StreamBuilder<Product?>(
        stream: productRepository.productDetailStreamData.stream,
        builder: (context, snapshot) {
          Product? product;
          if (snapshot.hasData) {
            product = snapshot.data!;
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PlaceholderWidget(
                      borderRadius: false,
                      width: Spaces.screenWidth(context) - 40.w,
                      height: 20.h,
                      condition: product != null,
                      child: Text(
                        "${product?.nameDisplay ?? ""} - ${product?.brand ?? ''}",
                        style: AppStyles.text.semiBold(
                          fSize: 18.sp,
                          height: 1.18,
                        ),
                      ),
                    ),
                    height(height: 12),
                    PlaceholderWidget(
                      borderRadius: false,
                      width: 150.w,
                      height: 20.h,
                      condition: product != null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (product?.promotion != null) ...[
                            Text(
                              'Giá:\t\t',
                              style: AppStyles.text
                                  .bold(fSize: 18.sp, height: 1.18),
                            ),
                            Text(
                              product!.price.toPrice(),
                              style: AppStyles.text
                                  .medium(fSize: 14.sp)
                                  .copyWith(
                                      decoration: TextDecoration.lineThrough),
                            ),
                            width(width: 3),
                            Text(
                              (product.promotionPrice ?? 000000).toPrice(),
                              style: AppStyles.text
                                  .bold(fSize: 18.sp, height: 1.18),
                            )
                          ] else
                            Text(
                              'Giá: ${(product?.price ?? 0).toPrice()}',
                              style: AppStyles.text
                                  .bold(fSize: 18.sp, height: 1.18),
                            ),
                        ],
                      ),
                    ),
                    height(height: 24),
                    if (product?.detail == null)
                      ...productOptionsPlaceholder()
                    else
                      ...productOptionsWidgets(product!.detail!),
                  ],
                ),
              ),
              height(height: 10),
              isShowImageDesc(
                product,
                widget: ImageLoadingWidget(
                  url: product?.detail?.imgDescription ?? '',
                  width: Spaces.screenWidth(context),
                  height: 248.h,
                  color: AppColors.white,
                  resize: true,
                  // fit: BoxFit.w,
                ),
              ),
            ],
          );
        });
  }

  List<Widget> productOptionsWidgets(ProductDetail productDetail) {
    return productDetail.productOptions.options
        .map((productOption) => Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${productOption.name.capitalize}:',
                  style: AppStyles.text.semiBold(fSize: 16.sp, height: 1.18),
                ),
                height(height: 15),
                Options(
                  option: productOption,
                  productOptions: productDetail.productOptions,
                ),
                height(height: 25)
              ],
            ))
        .toList();
  }

  List<Widget> productOptionsPlaceholder() {
    return List.generate(
      3,
      (index) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PlaceholderWidget(borderRadius: false, width: 106.w, height: 20.h),
          height(height: 15),
          Wrap(
            runSpacing: 13.w,
            spacing: 13.w,
            children: List.generate(
              3,
              (index) => ClipRRect(
                borderRadius: BorderRadius.circular(5.r),
                child: PlaceholderWidget(
                  width: 106.w,
                  height: 36.h,
                  borderRadius: false,
                ),
              ),
            ),
          ),
          height(height: 25),
        ],
      ),
    );
  }

  Widget isShowImageDesc(Product? product, {required Widget widget}) {
    if (product != null) {
      if (product.detail != null) {
        if (product.detail!.imgDescription == null) {
          return Container();
        }
      }
    }
    return widget;
  }
}
