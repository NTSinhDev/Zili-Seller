part of '../packing_slip_item_details_screen.dart';

class _PackagingCard extends StatelessWidget {
  final PackingSlipItemPackaging item;
  const _PackagingCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final ProductVariant variant = ProductVariant(
      id: item.variantId,
      sku: item.sku,
      imageVariant: item.variantImage,
      product: ProductInfo(
        id: item.productId,
        titleVi: item.productNameVi,
        titleEn: item.productNameEn,
        avatar: item.productImage,
        measureUnit: item.measureUnit,
      ),
      price: 0,
      quantity: item.quantity,
      options: item.options,
      originalPrice: 0,
      costPrice: 0,
      wholesalePrice: 0,
      inventory: 0,
      length: 0,
      weight: 0,
      height: 0,
      width: 0,
      slotBuy: '',
      transactionCount: '',
      inTransitCount: '',
      deliveryCount: '',
      availableQuantity: '',
      status: '',
      commission: 0,
      calculateByUnit: '',
    );
    return WarehouseProductCard(
      variant: variant,
      extraRows: [MapEntry('Số lượng:', '${item.totalQuantity.removeTrailingZero.toString()} ${variant.displayUnit}')],
    );
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: AppColors.greyC0,
          width: 1,
        ),
      ),
      child: RowWidget(
        crossAxisAlignment: CrossAxisAlignment.start,
        gap: 12.w,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: ImageUrlWidget(
              url: item.productImage ?? item.variantImage,
              width: 60.w,
              height: 60.w,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: ColumnWidget(
              crossAxisAlignment: CrossAxisAlignment.start,
              gap: 8.h,
              children: [
                Text(
                  (item.productNameVi ?? '').trim(),
                  style: AppStyles.text.semiBold(
                    fSize: 12.sp,
                    color: AppColors.green,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Số lượng',
                      style: AppStyles.text.medium(
                        fSize: 12.sp,
                        color: AppColors.black3,
                      ),
                    ),
                    Text(
                      '${item.totalQuantity.toInt()}',
                      style: AppStyles.text.medium(
                        fSize: 12.sp,
                        color: AppColors.black3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            item.sku ?? AppConstant.strings.DEFAULT_EMPTY_VALUE,
            style: AppStyles.text.medium(
              fSize: 12.sp,
              color: AppColors.black3,
            ),
          ),
        ],
      ),
    );
  }
}

