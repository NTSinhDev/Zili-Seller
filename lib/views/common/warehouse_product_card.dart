import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../app/app_wireframe.dart';
import '../../data/models/product/product_variant.dart';
import '../../res/res.dart';
import '../../utils/widgets/widgets.dart';

class WarehouseProductCard extends StatelessWidget {
  final ProductVariant variant;
  final List<MapEntry<String, String>> extraRows;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  const WarehouseProductCard({
    super.key,
    required this.variant,
    this.extraRows = const [],
    this.onTap,
    this.backgroundColor,
  });

  String get _productTitle {
    return (variant.product?.titleVi?.trim()) ??
        AppConstant.strings.DEFAULT_EMPTY_VALUE;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:
          onTap ??
          () {
            if (variant.productId == null) return;
            AppWireFrame.navigateToCompanyProductDetails(
              context,
              productId: variant.productId!,
            );
          },
      child: Container(
        padding: .all(10.w),
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.lightGrey,
          borderRadius: .circular(10.r),
        ),
        child: Row(
          crossAxisAlignment: .center,
          children: [
            ClipRRect(
              borderRadius: .circular(4.r),
              child: ImageUrlWidget(
                url: variant.displayAvatar,
                width: 48.w,
                height: 48.w,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: ColumnWidget(
                crossAxisAlignment: .start,
                gap: 8.h,
                children: [
                  RowWidget(
                    crossAxisAlignment: .start,
                    children: [
                      Expanded(
                        child: ColumnWidget(
                          crossAxisAlignment: .start,
                          children: [
                            Text(
                              _productTitle,
                              style: AppStyles.text.semiBold(
                                fSize: 12.sp,
                                color: AppColors.black5,
                              ),
                              maxLines: 1,
                              overflow: .ellipsis,
                            ),
                            RowWidget(
                              gap: 4.w,
                              crossAxisAlignment: .start,
                              margin:
                                  variant.options.isNotEmpty ||
                                      (variant.product?.shortName?.isNotEmpty ??
                                          false)
                                  ? .only(top: 4.h)
                                  : null,
                              children: [
                                if (variant.options.isNotEmpty)
                                  Text(
                                    variant.options
                                        .map((e) => e.value)
                                        .join(' - '),
                                    style: AppStyles.text.medium(
                                      fSize: 10.sp,
                                      color: AppColors.grey84,
                                    ),
                                  ),
                                if ((variant.product?.shortName?.isNotEmpty ??
                                    false)) ...[
                                  Text(
                                    '(${variant.product?.shortName})',
                                    style: AppStyles.text.medium(
                                      fSize: 10.sp,
                                      color: AppColors.black5,
                                    ),
                                    maxLines: 1,
                                    overflow: .ellipsis,
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                      Text(
                        variant.sku ?? AppConstant.strings.DEFAULT_EMPTY_VALUE,
                        style: AppStyles.text.medium(
                          fSize: 12.sp,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: .spaceBetween,
                    children: extraRows
                        .map((e) => _Metric(label: e.key, value: e.value))
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  final String label;
  final String value;
  const _Metric({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: AppStyles.text.medium(
            fSize: 11.sp,
            color: AppColors.black5,
            height: 14 / 11,
          ),
        ),
        SizedBox(width: 6.w),
        Text(
          value,
          style: AppStyles.text.medium(
            fSize: 12.sp,
            color: AppColors.black3,
            height: 14 / 12,
          ),
        ),
      ],
    );
  }
}
