part of '../select_material_variants_screen.dart';

class _ProductListItem extends StatelessWidget {
  final PurchaseOrderProduct item;
  final ProductRepository productRepository;
  const _ProductListItem(this.item, this.productRepository);

  Widget buildTile(BuildContext context, ProductVariant variant) {
    final displayPrice = variant.price.toInt().toPrice();
    final displayUnit = item.measureUnit;
    final displayImage =
        item.avatar ??
        (item.images.isNotEmpty ? item.images.first : null) ??
        variant.imageVariant;
    final availableQty = num.tryParse(variant.availableQuantity) ?? 0;

    final title = renderProductVariantName(variant, variant.options);
    final skuText = (variant.sku ?? AppConstant.strings.DEFAULT_EMPTY_VALUE);

    return StreamBuilder<List<ProductVariant>>(
      stream: productRepository.materialVariants.stream,
      builder: (context, asyncSnapshot) {
        final selectedProductVariant = asyncSnapshot.data ?? [];
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
            productRepository.materialVariants.sink.add(
              newSelectedProductVariant,
            );
          },
          borderRadius: .circular(12.r),
          child: Stack(
            children: [
              Container(
                padding: .all(12.w),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: .circular(12.r),
                ),
                clipBehavior: Clip.none,
                child: RowWidget(
                  crossAxisAlignment: .start,
                  gap: 12.w,
                  clipBehavior: .none,
                  children: [
                    Container(
                      width: 80.w,
                      height: 80.w,
                      decoration: BoxDecoration(
                        borderRadius: .circular(8.r),
                        color: AppColors.lightGrey,
                      ),
                      child: Stack(
                        clipBehavior: .none,
                        children: [
                          ClipRRect(
                            borderRadius: .circular(8.r),
                            child:
                                displayImage != null && displayImage.isNotEmpty
                                ? ImageLoadingWidget(
                                    hasPlaceHolder: false,
                                    url: displayImage,
                                    width: 80.w,
                                    height: 80.w,
                                    borderRadius: false,
                                  )
                                : Icon(
                                    Icons.image_outlined,
                                    size: 40.sp,
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
                                      AppColors.primary.withValues(alpha: 0.7),
                                      AppColors.primary.withValues(alpha: 0.9),
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
                            title,
                            style: AppStyles.text.semiBold(
                              fSize: 15.sp,
                              color: AppColors.black3,
                            ),
                            maxLines: 2,
                            overflow: .ellipsis,
                          ),
                          if ((variant.product?.shortName?.isNotEmpty ??
                              false)) ...[
                            height(height: 2),
                            Text(
                              '(${item.shortName})',
                              style: AppStyles.text.medium(
                                fSize: 12.sp,
                                color: AppColors.primary,
                              ),
                              maxLines: 1,
                              overflow: .ellipsis,
                            ),
                          ],
                          height(height: 4),
                          Text(
                            'SKU: $skuText',
                            style: AppStyles.text.medium(
                              fSize: 12.sp,
                              color: AppColors.grey84,
                            ),
                          ),
                          height(height: 4),
                          Row(
                            children: [
                              Text(
                                displayPrice,
                                style: AppStyles.text.bold(
                                  fSize: 16.sp,
                                  color: AppColors.primary,
                                ),
                              ),
                              if (displayUnit != null &&
                                  displayUnit.isNotEmpty) ...[
                                Text(
                                  '/$displayUnit',
                                  style: AppStyles.text.medium(
                                    fSize: 12.sp,
                                    color: AppColors.black3,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          height(height: 4),
                          RowWidget(
                            gap: 12.w,
                            children: [
                              Expanded(
                                child: Text(
                                  'Tồn kho: ${variant.inventory.twoDecimal}',
                                  maxLines: 1,
                                  overflow: .ellipsis,
                                  style: AppStyles.text.medium(
                                    fSize: 12.sp,
                                    color: AppColors.grey84,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Có thể bán: ${availableQty.toUSD}',
                                  maxLines: 1,
                                  overflow: .ellipsis,
                                  style: AppStyles.text.medium(
                                    fSize: 12.sp,
                                    color: AppColors.grey84,
                                  ),
                                ),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    if (item.productVariants.isEmpty) return const SizedBox.shrink();

    final variants = item.productVariants;

    return Container(
      margin: .only(bottom: 12.w),
      child: variants.length == 1
          ? buildTile(
              context,
              variants[0]
                ..product = ProductInfo(
                  id: item.id,
                  titleVi: item.titleVi,
                  titleEn: item.titleEn,
                  shortName: item.shortName,
                  avatar: item.avatar,
                  sku: item.sku,
                ),
            )
          : ColumnWidget(
              gap: 12.h,
              children: variants
                  .map(
                    (variant) => buildTile(
                      context,
                      variant
                        ..product = ProductInfo(
                          id: item.id,
                          titleVi: item.titleVi,
                          titleEn: item.titleEn,
                          shortName: item.shortName,
                          avatar: item.avatar,
                          sku: item.sku,
                        ),
                    ),
                  )
                  .toList(),
            ),
    );
  }
}
