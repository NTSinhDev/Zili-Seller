import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/app/app_wireframe.dart';
import 'package:zili_coffee/data/models/product/company_product.dart';

import '../../res/res.dart';
import '../../utils/extension/extension.dart';
import '../../utils/widgets/widgets.dart';

class CompanyProductCard extends StatelessWidget {
  final CompanyProduct data;
  const CompanyProductCard({super.key, required this.data});

  // Define dimensions.
  double get _productImageSize => 80.w;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => AppWireFrame.navigateToCompanyProductDetails(
        context,
        productId: data.id,
      ),
      child: RowWidget(
        mainAxisAlignment: .start,
        crossAxisAlignment: .start,
        padding: .symmetric(horizontal: 16.w, vertical: 12.h),
        backgroundColor: Colors.white,
        gap: 12.w,
        children: [
          ImageLoadingWidget(
            width: _productImageSize,
            height: _productImageSize,
            borderRadius: false,
            hasPlaceHolder: false,
            fit: .contain,
            url: data.primaryImage ?? "",
          ),
          Expanded(
            child: ColumnWidget(
              mainAxisAlignment: .start,
              crossAxisAlignment: .start,
              mainAxisSize: .min,
              gap: 4.h,
              children: [
                Row(
                  mainAxisAlignment: .spaceBetween,
                  crossAxisAlignment: .end,
                  children: [
                    Expanded(
                      child: Text(
                        data.displayName,
                        style: AppStyles.text.medium(
                          fSize: 14.sp,
                          color: AppColors.black3,
                        ),
                        maxLines: 1,
                        overflow: .ellipsis,
                      ),
                    ),
                  ],
                ),
                Text(
                  data.sku ?? AppConstant.strings.DEFAULT_EMPTY_VALUE,
                  style: AppStyles.text.semiBold(
                    fSize: 12.sp,
                    color: AppColors.primary,
                  ),
                ),
                RowWidget(
                  gap: 8.w,
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        data.price.toPrice(),
                        style: AppStyles.text.semiBold(
                          fSize: 13.sp,
                          color: AppColors.black3,
                        ),
                      ),
                    ),
                    // Text(
                    //   data.priceDisplay,
                    //   style: AppStyles.text.medium(
                    //     fSize: 12.sp,
                    //     color: AppColors.primary,
                    //   ),
                    // ),
                  ],
                ),
                Divider(color: AppColors.grayEA, height: 5.h, thickness: 1.sp),
                if (data.categoryInternal != null)
                  Text(
                    data.categoryInternal?.displayName ??
                        AppConstant.strings.DEFAULT_EMPTY_VALUE,
                    style: AppStyles.text.semiBold(
                      fSize: 12.sp,
                      color: AppColors.gray7,
                    ),
                  ),
                RowWidget(
                  gap: 16.w,
                  children: [
                    Text(
                      "Có thể bán: ${data.availableQuantity}",
                      style: AppStyles.text.medium(
                        fSize: 12.sp,
                        color: AppColors.grey84,
                      ),
                    ),
                    Text(
                      "Tồn kho: ${data.slotBuy}",
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
    );
  }
}
