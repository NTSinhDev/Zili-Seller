import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/data/models/order/order.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/enums.dart';

import '../../../../data/models/order/payment_detail/order_payment.dart';
import '../../../../utils/enums/payment_enum.dart';
import '../../../../utils/extension/extension.dart';
import '../../../../utils/functions/order_function.dart';
import '../../../../utils/widgets/widgets.dart';

class PaymentList extends StatefulWidget {
  final Order order;
  const PaymentList({super.key, required this.order});

  @override
  State<PaymentList> createState() => _PaymentListState();
}

class _PaymentListState extends State<PaymentList> {
  List<String> _expandedItems = [];
  @override
  Widget build(BuildContext context) {
    final payments = widget.order.orderPayments ?? [];
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
        //       Icon(Icons.payment_rounded, size: 18.sp, color: AppColors.black3),
        //       Text(
        //         'Thanh toán',
        //         style: AppStyles.text.semiBold(
        //           fSize: 14.sp,
        //           color: AppColors.black3,
        //         ),
        //       ),
        //       SizedBox.shrink(),
        //     ],
        //   ),
        // ),
        ColumnWidget(
          gap: 8.h,
          children: [
            RowWidget(
              mainAxisAlignment: .spaceBetween,
              children: [
                Text(
                  'Khách hàng phải trả',
                  style: AppStyles.text.medium(
                    fSize: 12.sp,
                    color: AppColors.black5,
                  ),
                ),
                Text(
                  widget.order.totalCustomerMustPay?.toUSD ?? '0',
                  style: AppStyles.text.medium(
                    fSize: 14.sp,
                    color: AppColors.black3,
                  ),
                ),
              ],
            ),
            RowWidget(
              mainAxisAlignment: .spaceBetween,
              children: [
                Text(
                  'Đã thanh toán',
                  style: AppStyles.text.medium(
                    fSize: 12.sp,
                    color: AppColors.black5,
                  ),
                ),
                Text(
                  widget.order.totalCustomerPaid?.toUSD ?? '0',
                  style: AppStyles.text.medium(
                    fSize: 14.sp,
                    color: AppColors.black3,
                  ),
                ),
              ],
            ),
            RowWidget(
              mainAxisAlignment: .spaceBetween,
              children: [
                Text(
                  'Còn phải trả',
                  style: AppStyles.text.medium(
                    fSize: 12.sp,
                    color: AppColors.black5,
                  ),
                ),
                Text(
                  widget.order.totalCustomerRemainingPayable?.toUSD ?? '0',
                  style:
                      (widget.order.totalCustomerRemainingPayable ?? 0.0) > 0.0
                      ? AppStyles.text.semiBold(
                          fSize: 14.sp,
                          color: AppColors.cancel,
                        )
                      : AppStyles.text.medium(
                          fSize: 14.sp,
                          color: AppColors.black3,
                        ),
                ),
              ],
            ),
          ],
        ),
        ...payments.map((OrderPayment op) {
          final paymentStatus = op.status == PaymentStatus.completed.toConstant
              ? 1
              : 0;

          final paymentMethodName = renderPaymentMethodName(
            op,
            op.isCODCollect,
          );
          return GestureDetector(
            onTap: () {
              if (_expandedItems.contains(op.id)) {
                _expandedItems.remove(op.id);
              } else {
                _expandedItems.add(op.id);
              }
              setState(() {});
            },
            child: Container(
              width: .infinity,
              margin: .only(bottom: 8.h),
              padding: .all(10.w),
              decoration: BoxDecoration(
                color: AppColors.greyFx,
                borderRadius: .circular(8.r),
              ),
              child: ColumnWidget(
                crossAxisAlignment: .start,
                gap: 8.h,
                children: [
                  RowWidget(
                    gap: 12.w,
                    children: [
                      if (paymentStatus == 1 || paymentStatus == 0)
                        Container(
                          width: 12.w,
                          height: 12.w,
                          decoration: BoxDecoration(
                            color: paymentStatus == 1
                                ? AppColors.success
                                : AppColors.warning,
                            shape: BoxShape.circle,
                          ),
                        ),
                      Expanded(
                        child: Text(
                          paymentMethodName,
                          style: AppStyles.text.semiBold(
                            fSize: 13.sp,
                            color: paymentColorByCOD(
                              op.isCODCollect,
                              op.status == PaymentStatus.completed.toConstant,
                            ),
                          ),
                          maxLines: 1,
                          overflow: .ellipsis,
                        ),
                      ),
                      Icon(
                        _expandedItems.contains(op.id)
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        size: 18.sp,
                        color: AppColors.black3,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Số tiền: ${op.totalAmount.toUSD}',
                          maxLines: 1,
                          overflow: .ellipsis,
                          style: AppStyles.text.semiBold(
                            fSize: 14.sp,
                            color: AppColors.black3,
                          ),
                        ),
                      ),
                      Text(
                        'Thời gian: ${(op.receivedAt ?? op.createdAt)?.csToString('HH:mm dd/MM/yyyy') ?? AppConstant.strings.DEFAULT_EMPTY_VALUE}',
                        style: AppStyles.text.medium(
                          fSize: 12.sp,
                          color: AppColors.grey84,
                        ),
                      ),
                    ],
                  ),
                  ExpandableWidget(
                    initiallyExpanded: _expandedItems.contains(op.id),
                    gap: 8.h,
                    denseWidget: SizedBox.shrink(),
                    expandedChildren: [
                      SizedBox.shrink(),
                      Divider(
                        color: AppColors.greyC0,
                        height: 1.h,
                        thickness: 1.sp,
                      ),
                      RowWidget(
                        gap: 4.w,
                        children: [
                          Text(
                            'Người thanh toán: ',
                            style: AppStyles.text.medium(
                              fSize: 12.sp,
                              color: AppColors.grey84,
                            ),
                          ),
                          Text(
                            op.createdBy?.fullName ??
                                AppConstant.strings.DEFAULT_EMPTY_VALUE,
                            style: AppStyles.text.semiBold(
                              fSize: 12.sp,
                              color: AppColors.black3,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: .spaceBetween,
                        children: [
                          Expanded(
                            child: CustomRichTextWidget(
                              defaultStyle: AppStyles.text.medium(
                                fSize: 12.sp,
                                color: AppColors.grey84,
                              ),
                              maxLines: 1,
                              texts: [
                                'Ghi chú: ',
                                TextSpan(
                                  text:
                                      op.note ??
                                      AppConstant.strings.DEFAULT_EMPTY_VALUE,
                                  style: AppStyles.text.semiBold(
                                    fSize: 12.sp,
                                    color: AppColors.black3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: CustomRichTextWidget(
                              defaultStyle: AppStyles.text.medium(
                                fSize: 12.sp,
                                color: AppColors.grey84,
                              ),
                              maxLines: 1,
                              textAlign: .right,
                              texts: [
                                'Tham chiếu: ',
                                TextSpan(
                                  text:
                                      op.reference ??
                                      AppConstant.strings.DEFAULT_EMPTY_VALUE,
                                  style: AppStyles.text.semiBold(
                                    fSize: 12.sp,
                                    color: AppColors.black3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
