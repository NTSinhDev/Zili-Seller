import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/views/common/product_variant_title.dart';
import 'package:zili_coffee/views/order/details/order_detail_screen.dart';

import '../../data/models/order/order_line_item.dart';
import '../../res/res.dart';
import '../../utils/extension/extension.dart';
import '../../utils/widgets/widgets.dart';

class OrderLineItemCard extends StatelessWidget {
  final OrderLineItem data;
  const OrderLineItemCard({super.key, required this.data});

  // Define dimensions.
  double get _productImageSize => 80.w;
  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name ?? '';

    return ColumnWidget(
      gap: 4.h,
      children: [
        RowWidget(
          mainAxisAlignment: .start,
          crossAxisAlignment: .start,
          gap: 12.w,
          children: [
            ImageLoadingWidget(
              width: _productImageSize,
              height: _productImageSize,
              borderRadius: false,
              hasPlaceHolder: data.isService,
              color: data.isService ? AppColors.lightGrey : null,
              highlightColor: data.isService ? AppColors.lightGrey : null,
              url: data.productVariant.imageVariant ?? '',
            ),
            // Product info
            Expanded(
              child: ColumnWidget(
                mainAxisAlignment: .start,
                crossAxisAlignment: .start,
                mainAxisSize: .min,
                gap: 4.h,
                children: [
                  // Section 1: common info (product info)
                  Row(
                    children: [
                      Expanded(
                        child: ProductVariantTitleWidget(
                          data: data.productVariant,
                          titleStyle: AppStyles.text.medium(
                            fSize: 12.sp,
                            height: 15 / 12,
                            color: AppColors.black3,
                          ),
                          skuStyle: AppStyles.text.medium(
                            fSize: 12.sp,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  RowWidget(
                    mainAxisAlignment: .start,
                    gap: 8.w,
                    margin: .only(top: 4.h),
                    children: [
                      Expanded(
                        child: CustomRichTextWidget(
                          defaultStyle: AppStyles.text.medium(
                            fSize: 14.sp,
                            color: AppColors.black5,
                          ),
                          texts: [
                            double.tryParse(data.price)?.toUSD ?? '0',
                            if (data.measureUnit != null &&
                                data.measureUnit!.isNotEmpty)
                              TextSpan(
                                text: "/${data.measureUnit}",
                                style: AppStyles.text.medium(
                                  fSize: 12.sp,
                                  color: AppColors.grey84,
                                ),
                              ),
                          ],
                        ),
                      ),
                      CustomRichTextWidget(
                        defaultStyle: AppStyles.text.medium(
                          fSize: 12.sp,
                          color: AppColors.grey84,
                        ),
                        texts: [
                          "SL:\t",
                          TextSpan(
                            text: (num.tryParse(data.quantity) ?? 1).toUSD,
                            style: AppStyles.text.medium(
                              fSize: 14.sp,
                              color: AppColors.black3,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // ----------------------------------------------------------------
                  Divider(
                    color: AppColors.grayEA,
                    height: 8.h,
                    thickness: 1.sp,
                  ),
                  // ----------------------------------------------------------------

                  // Section 2: Price & Discount info
                  RowWidget(
                    gap: 4.w,
                    children: [
                      Expanded(
                        child: ColumnWidget(
                          crossAxisAlignment: .start,
                          gap: 4.h,
                          children: [
                            CustomRichTextWidget(
                              defaultStyle: AppStyles.text.semiBold(
                                fSize: 14.sp,
                                color: AppColors.primary,
                              ),
                              texts: [
                                data.calculateTotalAmount.toUSD,
                                '\t',
                                if (((data.discountPercent ?? 0) > 0.0 ||
                                        (data.doubleDiscount) > 0.0) &&
                                    num.tryParse(data.totalAmount) != 0)
                                  TextSpan(
                                    text:
                                        num.tryParse(data.totalAmount)?.toUSD ??
                                        "",
                                    style: AppStyles.text
                                        .medium(
                                          fSize: 11.sp,
                                          color: AppColors.black5,
                                        )
                                        .copyWith(
                                          decoration:
                                              TextDecoration.lineThrough,
                                          decorationColor: AppColors.black5,
                                          decorationThickness: 1,
                                        ),
                                  ),
                              ],
                            ),
                            if (((data.discountPercent ?? 0) > 0.0 ||
                                    data.doubleDiscount > 0.0) &&
                                num.tryParse(data.totalAmount) != 0)
                              CustomRichTextWidget(
                                defaultStyle: AppStyles.text.medium(
                                  fSize: 12.sp,
                                  color: AppColors.black5,
                                ),
                                texts: [
                                  currentRoute == OrderDetailScreen.keyName
                                      ? "Chiết khấu:\t"
                                      : "Điều chỉnh:\t",
                                  TextSpan(
                                    text: data.doubleDiscount.toUSD,
                                    style: AppStyles.text.medium(
                                      fSize: 12.sp,
                                      color: AppColors.black3,
                                    ),
                                  ),
                                  if ((data.discountPercent ?? 0) > 0.0)
                                    TextSpan(
                                      text:
                                          '\t(${data.discountPercent?.toUSD}%)',
                                      style: AppStyles.text.medium(
                                        fSize: 12.sp,
                                        color: AppColors.scarlet,
                                      ),
                                    ),
                                ],
                              ),
                          ],
                        ),
                      ),
                      // Text(
                      //   data.calculateTotalAmount.toUSD,
                      //   style: AppStyles.text.semiBold(
                      //     fSize: 14.sp,
                      //     color: AppColors.primary,
                      //   ),
                      // ),
                      // if (data.doubleDiscount > 0.0) ...[
                      //   // Text(
                      //   //   double.tryParse(data.totalAmount)?.toUSD ?? '0',
                      //   //   style: AppStyles.text
                      //   //       .medium(fSize: 12.sp, color: AppColors.grey84)
                      //   //       .copyWith(
                      //   //         decoration: TextDecoration.lineThrough,
                      //   //         decorationColor: AppColors.grey84,
                      //   //       ),
                      //   // ),
                      //   if ((data.doubleDiscount) > 0.0)
                      //     Text(
                      //       '(-${data.doubleDiscount.toUSD})',
                      //       style: AppStyles.text.medium(
                      //         fSize: 12.sp,
                      //         color: AppColors.scarlet,
                      //       ),
                      //     )
                      //   else
                      //     Text(
                      //       '(-${data.discountPercent?.removeTrailingZero}%)',
                      //       style: AppStyles.text.medium(
                      //         fSize: 12.sp,
                      //         color: AppColors.scarlet,
                      //       ),
                      //     ),
                      // ],
                    ],
                  ),
                  // width(width: 20),
                ],
              ),
            ),
          ],
        ),
        if ((data.productVariant.note ?? "").isNotEmpty)
          ColumnWidget(
            crossAxisAlignment: .start,
            gap: 4.h,
            children: [
              Text(
                "Ghi chú:",
                style: AppStyles.text.medium(
                  fSize: 12.sp,
                  color: AppColors.black3,
                ),
              ),
              Container(
                width: .infinity,
                padding: .all(10.w),
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: .circular(8.r),
                ),
                child: Text(
                  data.productVariant.note!,
                  style: AppStyles.text.medium(
                    fSize: 10.sp,
                    color: AppColors.black3,
                  ),
                  maxLines: 10,
                  overflow: .ellipsis,
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class QuantityQuoteLineItemCard extends StatelessWidget {
  final List<String> quantityOpts;
  final OrderLineItem data;
  const QuantityQuoteLineItemCard({
    super.key,
    required this.quantityOpts,
    required this.data,
  });

  // Define dimensions.
  double get _productImageSize => 48.w;

  @override
  Widget build(BuildContext context) {
    return ColumnWidget(
      gap: 4.h,
      children: [
        RowWidget(
          mainAxisAlignment: .start,
          crossAxisAlignment: .start,
          gap: 12.w,
          children: [
            ImageLoadingWidget(
              width: _productImageSize,
              height: _productImageSize,
              borderRadius: false,
              hasPlaceHolder: data.isService,
              color: data.isService ? AppColors.lightGrey : null,
              highlightColor: data.isService ? AppColors.lightGrey : null,
              url: data.productVariant.imageVariant ?? '',
            ),

            // Product info
            Expanded(
              child: ColumnWidget(
                mainAxisAlignment: .start,
                crossAxisAlignment: .start,
                mainAxisSize: .min,
                gap: 4.h,
                children: [
                  // Section 1: common info (product info)
                  Row(
                    children: [
                      Expanded(
                        child: ProductVariantTitleWidget(
                          data: data.productVariant,
                          titleStyle: AppStyles.text.medium(
                            fSize: 12.sp,
                            height: 15 / 12,
                            color: AppColors.black3,
                          ),
                          skuStyle: AppStyles.text.medium(
                            fSize: 12.sp,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  RowWidget(
                    mainAxisAlignment: .start,
                    gap: 8.w,
                    margin: .only(top: 4.h),
                    children: [
                      Text(
                        'Đơn vị/Số lượng:',
                        style: AppStyles.text.medium(
                          fSize: 12.sp,
                          color: AppColors.black5,
                        ),
                      ),
                      if (data.measureUnit != null &&
                          data.measureUnit!.isNotEmpty)
                        Text(
                          data.measureUnit ?? "",
                          style: AppStyles.text.medium(
                            fSize: 14.sp,
                            color: AppColors.black3,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        DottedBorder(
          color: AppColors.primary.withValues(alpha: 0.2),
          strokeWidth: 1.w,
          radius: .circular(4),
          dashPattern: const [4, 4, 4, 4],
          padding: .symmetric(horizontal: 16.w, vertical: 8.h),
          borderType: .RRect,
          child: GridView.builder(
            shrinkWrap: true,
            padding: .zero,
            itemCount: quantityOpts.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // số cột
              crossAxisSpacing: 20, // khoảng cách ngang
              mainAxisSpacing: 4.h, // khoảng cách dọc
              childAspectRatio: (0.5.sw - 10.w) / 20, // width / height
            ),
            itemBuilder: (_, i) => _qtyOptGenerator(
              i,
              data.priceList != null && i < data.priceList!.length
                  ? data.priceList![i].toUSD
                  : AppConstant.strings.DEFAULT_EMPTY_VALUE,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        if ((data.productVariant.note ?? "").isNotEmpty)
          ColumnWidget(
            crossAxisAlignment: .start,
            gap: 4.h,
            children: [
              Text(
                "Ghi chú:",
                style: AppStyles.text.medium(
                  fSize: 12.sp,
                  color: AppColors.black3,
                ),
              ),
              Container(
                width: .infinity,
                padding: .all(10.w),
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: .circular(8.r),
                ),
                child: Text(
                  data.productVariant.note!,
                  style: AppStyles.text.medium(
                    fSize: 10.sp,
                    color: AppColors.black3,
                  ),
                  maxLines: 10,
                  overflow: .ellipsis,
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _qtyOptGenerator(int idx, String value) {
    return CustomRichTextWidget(
      defaultStyle: AppStyles.text.semiBold(
        fSize: 14.sp,
        color: AppColors.primary,
        height: 20 / 14,
      ),
      textAlign: idx % 2 == 0 ? TextAlign.start : TextAlign.end,
      texts: [
        TextSpan(
          text: quantityOpts[idx],
          style: AppStyles.text.medium(fSize: 12.sp, color: AppColors.black3),
        ),
        ":\t",
        value,
      ],
    );
  }
}
