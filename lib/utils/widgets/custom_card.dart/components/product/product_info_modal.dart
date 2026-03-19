part of '../../custom_card_widget.dart';

class _ProductInfoModal extends StatefulWidget {
  final GlobalKey widgetKey;
  const _ProductInfoModal({required this.widgetKey});

  @override
  State<_ProductInfoModal> createState() => _ProductInfoModalState();
}

class _ProductInfoModalState extends State<_ProductInfoModal> {
  int productQty = 1;
  final ProductRepository productRepository = di<ProductRepository>();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
      child: StreamBuilder<Product?>(
        stream: productRepository.productDetailStreamData.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              !snapshot.hasData) {
            return Container(
              height: 547.w,
              color: AppColors.white,
              width: Spaces.screenWidth(context),
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            );
          }
          final prod = snapshot.data!;
          return Container(
            height: 250.h + (prod.detail!.productOptions.options.length * 99.h),
            padding: EdgeInsets.all(20.w),
            color: AppColors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _productImgInfo(prod),
                    width(width: 15),
                    _information(prod),
                  ],
                ),
                height(height: 15),
                Divider(color: AppColors.grayEA, height: 1.h, thickness: 1.sp),
                height(height: 20),
                ...prod.detail!.productOptions.options
                    .map((productOption) => Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${productOption.name.capitalize}:',
                              style: AppStyles.text.semiBold(fSize: 16.sp),
                            ),
                            height(height: 12),
                            Options(
                              option: productOption,
                              productOptions: prod.detail!.productOptions,
                            ),
                            height(height: 15),
                            Divider(
                              color: AppColors.grayEA,
                              height: 1.h,
                              thickness: 1.sp,
                            ),
                            height(height: 20),
                          ],
                        ))
                    ,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Số lượng',
                      style: AppStyles.text.semiBold(fSize: 16.sp),
                    ),
                    const Spacer(),
                    QuantityWidget(
                      onChangedQty: (qty) {
                        setState(() => productQty = qty.toInt());
                      },
                    ),
                    width(width: 4),
                  ],
                ),
                const Spacer(),
                StreamBuilder<ProductVariant>(
                  stream: productRepository.variantStreamData.stream,
                  builder: (context, snapshot) {
                    int qtyInStock =
                        snapshot.data != null ? int.parse(snapshot.data!.availableQuantity) : 0;
                    return CustomButtonWidget(
                      onTap: () async {
                        if (qtyInStock == 0) return;
                        context.navigator.pop();
                        // await productRepository
                        //     .runAddToCartAnimation!(widget.widgetKey);
                        // productRepository.cartKey.currentState!
                        //     .runCartAnimation('1');
                      },
                      color: qtyInStock == 0
                          ? AppColors.gray4A.withOpacity(0.1)
                          : null,
                      borderColor: qtyInStock == 0
                          ? AppColors.gray4A.withOpacity(0.1)
                          : null,
                      boxShadows: qtyInStock == 0 ? const [] : null,
                      labelColor: qtyInStock == 0
                          ? AppColors.black5.withOpacity(0.5)
                          : null,
                      label: qtyInStock == 0
                          ? "Sản phẩm đã bán hết"
                          : 'Thêm vào giỏ hàng',
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _information(Product prod) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            prod.nameDisplay,
            overflow: TextOverflow.ellipsis,
            style: AppStyles.text.semiBold(
              fSize: 12.sp,
              color: AppColors.gray4A,
            ),
          ),
          height(height: 8),
          if (prod.promotion != null && prod.promotion! > 0) ...[
            Text(
              prod.price.toPrice(),
              style: AppStyles.text
                  .medium(fSize: 12.sp, color: Colors.grey)
                  .copyWith(decoration: TextDecoration.lineThrough),
            ),
            Text(
              (prod.promotionPrice ?? 0).toPrice(),
              style: AppStyles.text.bold(
                fSize: 23.sp,
                color: Colors.amber,
              ),
            )
          ] else ...[
            height(height: 12),
            Text(
              (prod.price).toPrice(),
              style: AppStyles.text.semiBold(fSize: 23.sp),
            ),
          ],
          height(height: 11),
          quantityInStock(),
        ],
      ),
    );
  }

  Widget quantityInStock() {
    return StreamBuilder<ProductVariant>(
        stream: productRepository.variantStreamData.stream,
        builder: (context, snapshot) {
          return Text(
            "kho: ${snapshot.data != null ? int.parse(snapshot.data!.availableQuantity) : 0}",
            style: AppStyles.text.semiBold(
              fSize: 12.sp,
              color: AppColors.gray4A,
            ),
          );
        });
  }

  Widget _productImgInfo(Product prod) {
    return Container(
      width: 80.w,
      height: 80.w,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grayEA),
        borderRadius: BorderRadius.circular(4.r),
        image: DecorationImage(
          image: CachedNetworkImageProvider(prod.imageBaseUrlThumb ?? prod.imageBaseUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
