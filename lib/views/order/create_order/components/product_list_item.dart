part of '../select_products_screen.dart';

class _ProductListItem extends StatelessWidget {
  final ProductVariant variant;
  const _ProductListItem(this.variant);

  @override
  Widget build(BuildContext context) {
    final OrderRepository orderRepository = di<OrderRepository>();
    final displayPrice = variant.price.toInt().toPrice();
    final displayUnit = variant.product?.measureUnit;
    final displayImage = variant.imageVariant;

    return Container(
      margin: .only(bottom: 12.w),
      child: StreamBuilder<List<ProductVariant>>(
        stream: orderRepository.selectedProductVariants.stream,
        builder: (context, snapshot) {
          final selectedProductVariant = snapshot.data ?? [];
          final isSelected = selectedProductVariant.any(
            (element) => element.id == variant.id,
          );

          return InkWell(
            onTap: () {
              final newSelectedProductVariant = [...selectedProductVariant];
              if (isSelected) {
                newSelectedProductVariant.removeWhere(
                  (element) => element.id == variant.id,
                );
              } else {
                newSelectedProductVariant.add(variant);
              }
              orderRepository.selectedProductVariants.sink.add(
                newSelectedProductVariant,
              );
            },
            borderRadius: .circular(12.r),
            child: Stack(
              children: [
                Container(
                  padding: .all(8.w),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: .circular(12.r),
                  ),
                  clipBehavior: .none,
                  child: RowWidget(
                    crossAxisAlignment: .start,
                    gap: 12.w,
                    clipBehavior: .none,
                    children: [
                      Container(
                        width: 72.w,
                        height: 72.w,
                        decoration: BoxDecoration(
                          borderRadius: .circular(8.r),
                          color: AppColors.lightGrey,
                        ),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child:
                                  displayImage != null &&
                                      displayImage.isNotEmpty
                                  ? ImageLoadingWidget(
                                      hasPlaceHolder: false,
                                      url: displayImage,
                                      width: 72.w,
                                      height: 72.w,
                                      borderRadius: false,
                                    )
                                  : Icon(
                                      Icons.image_outlined,
                                      size: 36.sp,
                                      color: AppColors.grey84,
                                    ),
                            ),
                            if (variant.quantity > 1)
                              Positioned(
                                top: -4.w,
                                right: -4.w,
                                child: Container(
                                  width: 20.w,
                                  height: 20.w,
                                  alignment: .center,
                                  decoration: BoxDecoration(
                                    border: .all(
                                      color: AppColors.background,
                                      width: 2.sp,
                                    ),
                                    shape: .circle,
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.primary.withValues(
                                          alpha: 0.7,
                                        ),
                                        AppColors.primary.withValues(
                                          alpha: 0.9,
                                        ),
                                        AppColors.primary.withValues(alpha: 1),
                                      ],
                                    ),
                                  ),
                                  child: Text(
                                    variant.quantity.removeTrailingZero,
                                    style: AppStyles.text.semiBold(
                                      fSize: 12.sp,
                                      color: AppColors.white,
                                    ),
                                    textAlign: .center,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ColumnWidget(
                          mainAxisAlignment: .center,
                          crossAxisAlignment: .start,
                          gap: 1.h,
                          children: [
                            Text(
                              renderProductVariantName(
                                variant,
                                variant.options,
                              ),
                              style: AppStyles.text.semiBold(
                                fSize: 14.sp,
                                color: AppColors.black3,
                                height: 18 / 14,
                              ),
                              maxLines: 2,
                              overflow: .ellipsis,
                            ),
                            height(height: 4),
                            Text(
                              'SKU: ${variant.sku}',
                              style: AppStyles.text.medium(
                                fSize: 12.sp,
                                color: AppColors.grey84,
                              ),
                            ),
                            height(height: 4),
                            Wrap(
                              spacing: 12.w,
                              runSpacing: 4.h,
                              crossAxisAlignment: .end,
                              alignment: .start,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: displayPrice,
                                        style: AppStyles.text.bold(
                                          fSize: 14.sp,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      if (displayUnit != null &&
                                          displayUnit.isNotEmpty)
                                        TextSpan(
                                          text: '/$displayUnit',
                                          style: AppStyles.text.medium(
                                            fSize: 12.sp,
                                            color: AppColors.black3,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                RowWidget(
                                  mainAxisSize: .min,
                                  gap: 8.w,
                                  children: [
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Tồn kho: ',
                                            style: AppStyles.text.medium(
                                              fSize: 12.sp,
                                              color: AppColors.grey84,
                                            ),
                                          ),
                                          TextSpan(
                                            text: num.tryParse(
                                              variant.slotBuy,
                                            ).toUSD,
                                            style: AppStyles.text.medium(
                                              fSize: 12.sp,
                                              color: AppColors.black3,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Có thể bán: ',
                                            style: AppStyles.text.medium(
                                              fSize: 12.sp,
                                              color: AppColors.grey84,
                                            ),
                                          ),
                                          TextSpan(
                                            text: num.tryParse(
                                              variant.availableQuantity,
                                            ).toUSD,
                                            style: AppStyles.text.medium(
                                              fSize: 12.sp,
                                              color: AppColors.black3,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Overlay layer khi selected
                if (isSelected)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: .circular(12.r),
                      ),
                    ),
                  ),
                if (isSelected)
                  Positioned(
                    top: 8.h,
                    right: 8.w,
                    child: Container(
                      width: 24.w,
                      height: 24.w,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: .circle,
                        border: .all(color: AppColors.background, width: 2.sp),
                      ),
                      child: Icon(
                        Icons.check,
                        size: 16.sp,
                        color: AppColors.white,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
