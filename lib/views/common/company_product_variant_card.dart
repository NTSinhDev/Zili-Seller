import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/data/models/product/company_product.dart';
import 'package:zili_coffee/views/common/status_badge.dart';

import '../../res/res.dart';
import '../../utils/extension/extension.dart';
import '../../utils/functions/product_variant_functions.dart';
import '../../utils/widgets/widgets.dart';

class CompanyProductVariantCard extends StatefulWidget {
  final CompanyProductVariant data;
  const CompanyProductVariantCard({super.key, required this.data});

  @override
  State<CompanyProductVariantCard> createState() =>
      _CompanyProductVariantCardState();
}

class _CompanyProductVariantCardState extends State<CompanyProductVariantCard> {
  bool _isExpanded = false;
  // Define dimensions.
  double get _productImageSize => _isExpanded ? 64.w : 40.w;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: .symmetric(horizontal: 16.w),
      width: .infinity,
      padding: .all(12.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: .circular(8.r),
      ),
      child: ColumnWidget(
        gap: 8.h,
        crossAxisAlignment: .stretch,
        children: [
          RowWidget(
            crossAxisAlignment: .start,
            gap: 16.w,
            children: [
              ClipRRect(
                borderRadius: .circular(4.r),
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: ImageUrlWidget(
                    url: widget.data.imageVariant ?? "",
                    width: _productImageSize,
                    height: _productImageSize,
                    fit: .contain,
                  ),
                ),
              ),
              Expanded(
                child: ColumnWidget(
                  crossAxisAlignment: .start,
                  gap: _isExpanded ? 8.h : 4.h,
                  children: [
                    RowWidget(
                      gap: 4.w,
                      crossAxisAlignment: .start,
                      children: [
                        Expanded(
                          child: Text(
                            widget.data.displayOptions ??
                                widget.data.displayName,
                            style: AppStyles.text.semiBold(
                              fSize: 14.sp,
                              color: AppColors.black3,
                              height: 18 / 14,
                            ),
                            maxLines: 2,
                            overflow: .ellipsis,
                          ),
                        ),
                        Text(
                          widget.data.sku ??
                              AppConstant.strings.DEFAULT_EMPTY_VALUE,
                          style: AppStyles.text.medium(
                            fSize: 12.sp,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    if (widget.data.displayOptions != null)
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.data.productName,
                              style: AppStyles.text.medium(
                                fSize: 12.sp,
                                color: AppColors.black5,
                              ),
                              maxLines: 1,
                              overflow: .ellipsis,
                            ),
                          ),
                        ],
                      ),
                    RowWidget(
                      gap: 24.w,
                      children: [
                        CustomRichTextWidget(
                          defaultStyle: AppStyles.text.medium(
                            fSize: 12.sp,
                            color: AppColors.black5,
                          ),
                          maxLines: 1,
                          texts: [
                            TextSpan(text: "Tồn kho: "),
                            TextSpan(
                              text: widget.data.slotBuy.toUSD,
                              style: AppStyles.text.medium(
                                fSize: 12.sp,
                                color: AppColors.black3,
                              ),
                            ),
                          ],
                        ),
                        CustomRichTextWidget(
                          defaultStyle: AppStyles.text.medium(
                            fSize: 12.sp,
                            color: AppColors.black5,
                          ),
                          maxLines: 1,
                          texts: [
                            TextSpan(text: "Có thể bán: "),
                            TextSpan(
                              text: widget.data.availableQuantity.toUSD,
                              style: AppStyles.text.medium(
                                fSize: 12.sp,
                                color: AppColors.black3,
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
          const Divider(height: 1, color: AppColors.greyC0, thickness: 1),
          SizedBox(
            width: .infinity,
            child: AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: _isExpanded
                  ? _buildExpandedInfo()
                  : const SizedBox.shrink(),
            ),
          ),
          // Nút expand/collapse
          Center(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                borderRadius: .circular(8.r),
                child: Padding(
                  padding: .symmetric(horizontal: 16.w, vertical: 8.h),
                  child: Row(
                    mainAxisSize: .min,
                    children: [
                      Text(
                        _isExpanded ? 'Thu gọn' : 'Xem chi tiết phiên bản',
                        style: AppStyles.text.medium(
                          fSize: 14.sp,
                          color: AppColors.primary,
                        ),
                      ),
                      width(width: 4),
                      AnimatedRotation(
                        turns: _isExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          size: 20.sp,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ColumnWidget _buildExpandedInfo() {
    final Map<String, dynamic> informationMaps = {
      "Tên phiên bản sản phẩm": widget.data.displayName,
      "Mã SKU": widget.data.sku,
      "Mã vạch": widget.data.barcode,
      "Khối lượng": widget.data.weight.toUSD,
      "Quy cách đóng gói": widget.data.itemsPerUnit,
      "Giá bán lẻ": widget.data.price.toUSD,
      "Giá bán buôn": widget.data.wholesalePrice.toUSD,
      "Giá nhập": widget.data.costPrice.toUSD,
      if (widget.data.commission > 0 &&
          (widget.data.measureUnit ?? "").isNotEmpty)
        "Đơn vị tính": widget.data.measureUnit,
      if (widget.data.commission > 0)
        "Hoa hồng CTV": widget.data.commission > 0
            ? '${widget.data.commission.toUSD}(${widget.data.calculateByUnit == "WEIGHT" ? "kg" : "Túi"})'
            : AppConstant.strings.DEFAULT_EMPTY_VALUE,
      if (widget.data.options.isNotEmpty)
        widget.data.options.map((e) => e["name"]).join(' - '): widget
            .data
            .options
            .map((e) => e["value"])
            .join(' - '),
    };
    return ColumnWidget(
      crossAxisAlignment: .start,
      padding: .only(top: 4.h),
      backgroundColor: AppColors.white,
      gap: 8.h,
      mainAxisSize: .min,
      children: [
        RowWidget(
          mainAxisAlignment: .spaceBetween,
          padding: .symmetric(horizontal: 8.w),
          children: [
            Text(
              'Chi tiết phiên bản',
              style: AppStyles.text.semiBold(fSize: 14.sp),
            ),
            StatusBadge(
              label:
                  renderVariantStatus(widget.data.status) ??
                  AppConstant.strings.DEFAULT_EMPTY_VALUE,
              color:
                  renderVariantStatusColor(widget.data.status) ??
                  AppColors.lightF,
            ),
          ],
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: informationMaps.entries.length,
          separatorBuilder: (context, index) =>
              Divider(color: AppColors.background, height: 1.h),
          itemBuilder: (context, index) {
            final data = informationMaps.entries.elementAt(index);
            return Container(
              padding: .symmetric(horizontal: 8.w, vertical: 12.h),
              child: ColumnWidget(
                crossAxisAlignment: .start,
                gap: 4.h,
                children: [
                  Text(
                    data.key,
                    style: AppStyles.text.medium(
                      fSize: 12.sp,
                      color: AppColors.grey84,
                    ),
                  ),
                  Text(
                    "${data.value ?? AppConstant.strings.DEFAULT_EMPTY_VALUE}",
                    style: AppStyles.text.medium(fSize: 14.sp, height: 20 / 14),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
