import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../data/models/order/order.dart';
import '../../../../../res/res.dart';
import '../../../../../utils/widgets/widgets.dart';
import '../../../common/order_line_item_card.dart';

class ProductList extends StatelessWidget {
  final Order order;
  const ProductList({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    if (order.orderLineItems.isEmpty) {
      return Text(
        'Chưa có sản phẩm',
        style: AppStyles.text.medium(fSize: 13.sp, color: AppColors.grey84),
      );
    }
    return ColumnWidget(
      crossAxisAlignment: .start,
      gap: 12.h,
      children: [
        // Container(
        //   padding: .symmetric(horizontal: 8.w, vertical: 4.h),
        //   decoration: BoxDecoration(
        //     color: AppColors.background,
        //     borderRadius: .circular(4.r),
        //   ),
        //   child: RowWidget(
        //     gap: 4.w,
        //     mainAxisSize: .min,
        //     children: [
        //       Icon(Icons.list_alt_rounded, size: 18.sp, color: AppColors.black3),
        //       Text(
        //         'Sản phẩm',
        //         style: AppStyles.text.semiBold(
        //           fSize: 14.sp,
        //           color: AppColors.black3,
        //         ),
        //       ),
        //       SizedBox.shrink(),
        //     ],
        //   ),
        // ),
        ...order.orderLineItems.map((e) => OrderLineItemCard(data: e)),
      ],
    );
  }
}
