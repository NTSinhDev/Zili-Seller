import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/views/company_products/edit_service/edit_service_screen.dart';

import '../../../../data/dto/product_variant_form_dto.dart';
import '../../../../data/dto/quotation/create_quotation.dart';
import '../../../../data/models/product/product_variant.dart';
import '../../../../res/res.dart';
import '../../../../utils/extension/extension.dart';
import '../../../../utils/widgets/widgets.dart';
import '../../../company_products/config_variant/config_variant_by_opts_screen.dart';
import '../../../company_products/config_variant/config_variant_screen.dart';
import '../../../order/create_order/create_order_screen.dart';
import '../../product_variant_title.dart';

class _ItemView extends StatelessWidget {
  final ProductVariantFormDto data;
  final VoidCallback onRemove;
  final Function(num) onUpdateQuantity;
  final Function(ProductVariantFormDto) onUpdateProductVariant;
  final Function(OrderQuotationProducts) onUpdateByOpts;
  final bool manageByQuantity;
  final List<(String qtyOpts, num price)> quantityPrices;
  const _ItemView({
    required this.data,
    required this.onRemove,
    required this.onUpdateQuantity,
    required this.onUpdateProductVariant,
    required this.onUpdateByOpts,
    this.manageByQuantity = false,
    this.quantityPrices = const [],
  });

  // Define dimensions.
  double get _productImageSize => !manageByQuantity ? 60.w : 48.w;

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name ?? '';
    return InkWell(
      onTap: () {
        _onTapProductVariant(
          context,
          data.productVariant!,
          data.qty,
          data.price,
          data.discount,
          data.discountPercent,
          data.discountUnit,
          data.note,
        );
      },
      child: ColumnWidget(
        // gap: 8.h,
        children: [
          RowWidget(
            mainAxisAlignment: .start,
            crossAxisAlignment: .start,
            gap: 12.w,
            children: [
              // Product image
              ImageLoadingWidget(
                width: _productImageSize,
                height: _productImageSize,
                borderRadius: false,
                hasPlaceHolder: data.isService,
                color: data.isService ? AppColors.lightGrey : null,
                highlightColor: data.isService ? AppColors.lightGrey : null,
                url: data.productVariant?.imageVariant ?? '',
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
                    if (data.productVariant.isNotNull)
                      RowWidget(
                        crossAxisAlignment: .start,
                        children: [
                          Expanded(
                            child: AbsorbPointer(
                              absorbing: true,
                              child: ProductVariantTitleWidget(
                                data: data.productVariant!,
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
                          ),
                          InkWell(
                            onTap: onRemove,
                            child: Icon(
                              Icons.close,
                              size: 20.sp,
                              color: AppColors.black3,
                            ),
                          ),
                        ],
                      ),
                    RowWidget(
                      mainAxisAlignment: .start,
                      gap: 8.w,
                      children: [
                        if (!manageByQuantity)
                          CustomRichTextWidget(
                            defaultStyle: AppStyles.text.medium(
                              fSize: 13.sp,
                              color: AppColors.black3,
                            ),
                            texts: [
                              TextSpan(
                                text: "Đơn giá:\t",
                                style: AppStyles.text.medium(
                                  fSize: 12.sp,
                                  color: AppColors.black5,
                                ),
                              ),
                              data.price.toUSD,
                            ],
                          )
                        else
                          Text(
                            "Đơn vị: ${data.measureUnit ?? data.productVariant?.product?.measureUnit ?? 'KG'}",
                            style: AppStyles.text.medium(
                              fSize: 13.sp,
                              color: AppColors.black3,
                            ),
                          ),
                        if ((data.note ?? "").isNotEmpty)
                          Expanded(
                            child: CustomRichTextWidget(
                              defaultStyle: AppStyles.text.medium(
                                fSize: 11.sp,
                                height: 14 / 12,
                                color: AppColors.grey84,
                              ),
                              textAlign: .end,
                              texts: [
                                'Ghi chú: ',
                                TextSpan(
                                  text: data.note,
                                  style: AppStyles.text.medium(
                                    fSize: 11.sp,
                                    height: 14 / 12,
                                    color: AppColors.black5,
                                  ),
                                ),
                              ],
                              maxLines: 1,
                            ),
                          ),
                      ],
                    ),
                    // ----------------------------------------------------------------
                    if (!manageByQuantity)
                      Divider(
                        color: AppColors.grayEA,
                        height: 4.h,
                        thickness: 1.sp,
                      ),
                    // ----------------------------------------------------------------
                    // Section 2: Price & Discount info
                    if (!manageByQuantity)
                      RowWidget(
                        mainAxisAlignment: .spaceBetween,
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
                                    TextSpan(
                                      text: "Giá:\t",
                                      style: AppStyles.text.medium(
                                        fSize: 12.sp,
                                        color: AppColors.black5,
                                      ),
                                    ),
                                    data.totalAmount.toUSD,
                                    '\t',
                                    if (((data.discountPercent ?? 0) > 0.0 ||
                                            data.discount > 0.0) &&
                                        data.totalPrice != 0)
                                      TextSpan(
                                        text: '(${data.totalPrice.toUSD})',
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
                                        data.discount > 0.0) &&
                                    data.totalPrice != 0)
                                  CustomRichTextWidget(
                                    defaultStyle: AppStyles.text.medium(
                                      fSize: 12.sp,
                                      color: AppColors.black5,
                                    ),
                                    texts: [
                                      currentRoute == CreateOrderScreen.keyName
                                          ? "Chiết khấu:\t"
                                          : "Điều chỉnh:\t",
                                      TextSpan(
                                        text: data.discount.toUSD,
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
                          QuantityWidget(
                            defaultValue: data.qty,
                            minValue: 0,
                            onChangedQty: (newQty) {
                              onUpdateQuantity(newQty);
                            },
                            sizeBtn: 26.w,
                          ),
                        ],
                      ),
                    // width(width: 20),
                  ],
                ),
              ),
            ],
          ),
          if (manageByQuantity) ...[
            SizedBox(height: 8.h),
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
                physics: const NeverScrollableScrollPhysics(),
                itemCount: quantityPrices.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // số cột
                  crossAxisSpacing: 20, // khoảng cách ngang
                  mainAxisSpacing: 4.h, // khoảng cách dọc
                  childAspectRatio: (0.5.sw - 10.w) / 20, // width / height
                ),
                itemBuilder: (_, i) => _qtyOptGenerator(i),
              ),
            ),
            SizedBox(height: 8.h),
          ] else if (data.measureUnit.isNotNull) ...[
            SizedBox(height: 8.h),
            Row(
              children: [
                Text(
                  "ĐVT:",
                  style: AppStyles.text.medium(
                    fSize: 12.sp,
                    color: AppColors.black5,
                  ),
                ),
                SizedBox(width: 8.w),
                if ((data.measureUnit ?? "").isEmpty ||
                    data.productVariant?.product?.measureUnit?.toUpperCase() ==
                        "KG")
                  Text(
                    "KG",
                    style: AppStyles.text.medium(
                      fSize: 14.sp,
                      color: AppColors.black3,
                    ),
                  )
                else ...[
                  _dvtContainer(
                    data.productVariant?.product?.measureUnit ?? "KG",
                    data.measureUnit ==
                        data.productVariant?.product?.measureUnit,
                  ),
                  SizedBox(width: 8.w),
                  _dvtContainer("KG", data.measureUnit == "KG"),
                ],
              ],
            ),
          ] else
            SizedBox(height: 12.h),
          Align(
            alignment: .bottomRight,
            child: RowWidget(
              mainAxisAlignment: .end,
              mainAxisSize: .min,
              border: Border(
                bottom: BorderSide(color: Colors.blue, width: 1.sp),
              ),
              children: [
                Text(
                  "Điều chỉnh",
                  style: AppStyles.text.semiBold(
                    fSize: 14.sp,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dvtContainer(String dvt, bool isSelected) {
    return Container(
      padding: .symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.r),
        border: .all(color: isSelected ? AppColors.primary : AppColors.grey84),
      ),
      child: Text(
        dvt,
        style: isSelected
            ? AppStyles.text.semiBold(fSize: 12.sp, color: AppColors.primary)
            : AppStyles.text.medium(fSize: 12.sp, color: AppColors.grey84),
      ),
    );
  }

  Widget _qtyOptGenerator(int idx) {
    return CustomRichTextWidget(
      defaultStyle: AppStyles.text.semiBold(
        fSize: 14.sp,
        color: AppColors.primary,
        height: 20 / 14,
      ),
      textAlign: idx % 2 == 0 ? TextAlign.start : TextAlign.end,
      texts: [
        TextSpan(
          text: quantityPrices[idx].$1,
          style: AppStyles.text.medium(fSize: 12.sp, color: AppColors.black3),
        ),
        ":\t",
        quantityPrices[idx].$2.toUSD,
      ],
    );
  }

  void _onTapProductVariant(
    BuildContext context,
    ProductVariant? product,
    num quantity,
    num unitPrice,
    num discount,
    num? discountPercent,
    String discountUnit,
    String? note,
  ) {
    if (product == null) return;
    if (data.isService) {
      context.navigator
          .push(
            MaterialPageRoute(
              builder: (context) => EditServiceScreen(
                serviceProduct: ServiceProduct(
                  price: product.price,
                  originalPrice: product.price,
                  quantity: quantity,
                  discount: discount.toDouble(),
                  discountUnit: discountUnit,
                  totalPrice: 0,
                  note: note,
                  product: product.product,
                ),
              ),
            ),
          )
          .then((result) {
            if (result != null && result is ServiceProduct) {
              onUpdateProductVariant(
                ProductVariantFormDto(
                  productVariant: result.toProductVariant,
                  qty: result.quantity,
                  price: result.price,
                  discount: result.discountUnit == 'đ'
                      ? result.discount ?? discount
                      : (result.discount ?? discount) * result.price / 100,
                  discountPercent: result.discountUnit == '%'
                      ? result.discount
                      : null,
                  discountUnit: result.discountUnit ?? 'đ',
                  note: result.note,
                ),
              );
            }
          });
    } else {
      context.navigator
          .push(
            MaterialPageRoute(
              builder: (context) => manageByQuantity
                  ? ConfigOptsVariantScreen(
                      productVariant: product,
                      props: ConfigOptsVariantProps(
                        note: data.note,
                        options: quantityPrices,
                      ),
                    )
                  : ConfigVariantScreen(
                      productVariant: product,
                      props: ConfigVariantProps(
                        qty: quantity,
                        price: unitPrice,
                        discount: discountUnit == 'đ'
                            ? discount
                            : discountPercent ?? 0,
                        discountUnit: discountUnit,
                        note: data.note,
                        measureUnit: data.measureUnit,
                        isService: data.isService,
                      ),
                    ),
            ),
          )
          .then((result) {
            if (result != null) {
              if (result is ConfigVariantProps) {
                onUpdateProductVariant(
                  ProductVariantFormDto(
                    productVariant: product,
                    qty: result.qty,
                    price: result.price,
                    discount: result.discountUnit == 'đ'
                        ? result.discount
                        : result.discount * result.price / 100,
                    discountPercent: result.discountUnit == '%'
                        ? result.discount
                        : null,
                    discountUnit: result.discountUnit,
                    measureUnit: result.measureUnit,
                    note: result.note,
                  ),
                );
              } else if (result is ConfigOptsVariantProps) {
                onUpdateByOpts(
                  OrderQuotationProducts(
                    productVariant: data.productVariant,
                    qty: data.qty,
                    price: data.price,
                    discount: data.discount,
                    discountPercent: data.discountPercent,
                    discountUnit: data.discountUnit,
                    note: result.note,
                    priceList: result.options.map((e) => e.$2).toList(),
                  ),
                );
              }
            }
          });
    }
  }
}

class ProductItem extends StatelessWidget {
  final ProductVariantFormDto data;
  final VoidCallback onRemove;
  final Function(num) onUpdateQuantity;
  final Function(ProductVariantFormDto) onUpdateProductVariant;
  final bool manageByQuantity;
  final List<(String qtyOpts, num price)> quantityPrices;
  const ProductItem({
    super.key,
    required this.data,
    required this.onRemove,
    required this.onUpdateQuantity,
    required this.onUpdateProductVariant,
    this.manageByQuantity = false,
    this.quantityPrices = const [],
  });

  @override
  Widget build(BuildContext context) {
    return _ItemView(
      data: data,
      onRemove: onRemove,
      onUpdateQuantity: onUpdateQuantity,
      onUpdateProductVariant: onUpdateProductVariant,
      manageByQuantity: manageByQuantity,
      quantityPrices: quantityPrices,
      onUpdateByOpts: (_) {},
    );
  }
}

class QuotationVariantItem extends StatelessWidget {
  final ProductVariantFormDto data;
  final VoidCallback onRemove;
  final Function(num) onUpdateQuantity;
  final Function(OrderQuotationProducts) onUpdateByOpts;
  final bool manageByQuantity;
  final List<(String qtyOpts, num price)> quantityPrices;
  const QuotationVariantItem({
    super.key,
    required this.data,
    required this.onRemove,
    required this.onUpdateQuantity,
    required this.onUpdateByOpts,
    this.manageByQuantity = false,
    this.quantityPrices = const [],
  });

  @override
  Widget build(BuildContext context) {
    return _ItemView(
      data: data,
      onRemove: onRemove,
      onUpdateQuantity: onUpdateQuantity,
      onUpdateProductVariant: (_) {},
      manageByQuantity: manageByQuantity,
      quantityPrices: quantityPrices,
      onUpdateByOpts: onUpdateByOpts,
    );
  }
}
