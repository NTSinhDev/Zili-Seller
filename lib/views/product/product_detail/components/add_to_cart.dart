part of '../product_detail_screen.dart';

class _AddToCart extends StatelessWidget {
  const _AddToCart();

  @override
  Widget build(BuildContext context) {
    int productQty = 1;
    final ProductRepository productRepository = di<ProductRepository>();
    return StreamBuilder<Product?>(
        stream: productRepository.productDetailStreamData.stream,
        builder: (context, snapshot) {
          Product? product;
          if (snapshot.hasData) {
            product = snapshot.data!;
          }
          return BottomViewWidget(
            children: [
              height(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  width(width: 10),
                  PlaceholderWidget(
                    width: 100.w,
                    height: 27.h,
                    condition: product != null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (product?.promotion != null) ...[
                          Text(
                            (product?.price ?? 000000).toPrice(),
                            style: AppStyles.text.medium(fSize: 14.sp).copyWith(
                                decoration: TextDecoration.lineThrough),
                          ),
                          width(width: 3),
                          Text(
                            (product?.promotionPrice ?? 000000).toPrice(),
                            style: AppStyles.text.bold(
                              fSize: 23.sp,
                              color: AppColors.primary,
                            ),
                          )
                        ] else
                          Text(
                            (product?.price ?? 000000).toPrice(),
                            style: AppStyles.text.bold(
                              fSize: 23.sp,
                              color: AppColors.primary,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  QuantityWidget(
                    defaultValue: productQty,
                    onChangedQty: (qty) => productQty = qty.toInt(),
                  ),
                  width(width: 4),
                ],
              ),
              height(height: 18),
              StreamBuilder<ProductVariant>(
                  stream: productRepository.variantStreamData.stream,
                  builder: (context, snapshot) {
                    int qtyInStock =
                        snapshot.data != null ? int.parse(snapshot.data?.availableQuantity ?? '0') : 0;
                    return CustomButtonWidget(
                      onTap: () {
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
                  })
            ],
          );
        });
  }
}
