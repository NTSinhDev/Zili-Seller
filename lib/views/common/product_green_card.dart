import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/models/order_packing_item.dart';
import '../../res/res.dart';
import '../../utils/widgets/widgets.dart';

class ProductGreenCard extends StatelessWidget {
  final OrderPackingItem data;
  const ProductGreenCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: .infinity,
      padding: .all(12.w),
      decoration: BoxDecoration(
        color: AppColors.green.withValues(alpha: 0.1),
        border: Border.all(
          color: AppColors.green.withValues(alpha: 0.3),
          width: 1,
        ),
        borderRadius: .circular(8.r),
      ),
      child: RowWidget(
        crossAxisAlignment: .start,
        children: [
          Expanded(
            child: ColumnWidget(
              crossAxisAlignment: .start,
              gap: 8.h,
              children: [
                Text(
                  data.productNameVi?.trim() ??
                      AppConstant.strings.DEFAULT_EMPTY_VALUE,
                  style: AppStyles.text.semiBold(
                    fSize: 12.sp,
                    color: AppColors.black5,
                  ),
                  maxLines: 1,
                  overflow: .ellipsis,
                ),
                if (data.options.isNotEmpty)
                  Text(
                    data.options.map((e) => e.value).join(' - '),
                    style: AppStyles.text.medium(
                      fSize: 10.sp,
                      color: AppColors.grey84,
                    ),
                  ),
              ],
            ),
          ),
          ColumnWidget(
            crossAxisAlignment: .end,
            gap: 8.h,
            children: [
              Text(
                data.sku ?? AppConstant.strings.DEFAULT_EMPTY_VALUE,
                style: AppStyles.text.medium(
                  fSize: 12.sp,
                  color: AppColors.primary,
                ),
              ),
              Text(
                'Số lượng: ${data.quantity}${(data.measureUnit ?? "").isNotEmpty ? ' (${data.measureUnit})' : ''}',
                style: AppStyles.text.medium(fSize: 12.sp),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
