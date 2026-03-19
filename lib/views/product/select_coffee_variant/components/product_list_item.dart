part of '../select_coffee_variant_screen.dart';

class _ProductListItem extends StatelessWidget {
  final PurchaseOrderProduct item;
  const _ProductListItem(this.item);

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

    return InkWell(
      onTap: () => context.navigator.pop(variant),
      borderRadius: .circular(12.r),
      child: Stack(
        children: [
          Container(
            padding: .all(12.w),
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
                        child: displayImage != null && displayImage.isNotEmpty
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
                              shape: BoxShape.circle,
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
                        overflow: TextOverflow.ellipsis,
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
                          overflow: TextOverflow.ellipsis,
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
                          Text(
                            'Tồn kho: ${num.tryParse(variant.slotBuy)?.toUSD}',
                            style: AppStyles.text.medium(
                              fSize: 12.sp,
                              color: AppColors.grey84,
                            ),
                          ),
                          Text(
                            'Có thể bán: ${availableQty.toUSD}',
                            style: AppStyles.text.medium(
                              fSize: 12.sp,
                              color: AppColors.grey84,
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
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (item.productVariants.isEmpty) return const SizedBox.shrink();
    final variants = item.productVariants;
    return Container(
      margin: EdgeInsets.only(bottom: 12.w),
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
