import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../bloc/order/order_cubit.dart';
import '../../../data/models/order/order_detail_data.dart';
import '../../../data/repositories/order_repository.dart';
import '../../../di/dependency_injection.dart';
import '../../../res/res.dart';
import '../../../utils/functions/order_function.dart';
import '../../../utils/widgets/widgets.dart';
import '../../common/expandable_customer_info.dart';
import '../../common/status_badge.dart';

import 'components/additional_section.dart';
import 'components/payment_list.dart';
import 'components/price_summary.dart';
import 'components/product_list.dart';
import 'components/section_card.dart';
import 'components/shipment_section.dart';
import 'components/timeline_list.dart';

class OrderDetailScreen extends StatefulWidget {
  final String code;
  const OrderDetailScreen({super.key, required this.code});
  static const String keyName = '/order/detail';

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  late final OrderCubit _cubit;
  late final OrderRepository _repository;

  @override
  void initState() {
    super.initState();
    _cubit = di<OrderCubit>();
    _repository = di<OrderRepository>();

    _cubit.fetchOrderBaseByCode(code: widget.code).then((_) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Future.wait([
          _cubit.fetchOrderCustomerByCode(code: widget.code),
          _cubit.fetchOrderShipmentByCode(code: widget.code),
          _cubit.fetchOrderAdditionalByCode(code: widget.code),
        ]);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget.lightAppBar(
        context,
        label: widget.code,
        elevation: 1,
        shadowColor: AppColors.black.withValues(alpha: 0.5),
      ),
      backgroundColor: AppColors.background,
      body: StreamBuilder<OrderDetailData?>(
        stream: _repository.orderDetailData.stream,
        builder: (context, snapshot) {
          final data = snapshot.data;
          if (data == null) {
            return const Scaffold(
              backgroundColor: AppColors.lightGrey,
              body: Center(child: CircularProgressIndicator()),
            );
          }

          final order = data.order;
          return CommonLoadMoreRefreshWrapper.refresh(
            context,
            onRefresh: () async {
              await _cubit.fetchOrderBaseByCode(code: widget.code).then((
                _,
              ) async {
                await Future.wait([
                  _cubit.fetchOrderCustomerByCode(code: widget.code),
                  _cubit.fetchOrderShipmentByCode(code: widget.code),
                  _cubit.fetchOrderAdditionalByCode(code: widget.code),
                ]);
              });
            },
            child: SingleChildScrollView(
              padding: .only(bottom: 24.h),
              child: ColumnWidget(
                crossAxisAlignment: .start,
                margin: .symmetric(vertical: 16.h),
                gap: 12.h,
                children: [
                  SectionCard(
                    title: 'Thông tin đơn hàng',
                    statusWidget: StatusBadge(
                      label:
                          renderOrderStatus(order.statusEnum) ??
                          AppConstant.strings.DEFAULT_EMPTY_VALUE,
                      color:
                          orderStatusColor(order.statusEnum) ??
                          AppColors.grey84,
                    ),
                    child: ColumnWidget(
                      crossAxisAlignment: .start,
                      gap: 12.h,
                      children: [
                        TimelineList(order: order),
                        Divider(
                          height: 1,
                          color: AppColors.grayEA,
                          thickness: 1.sp,
                        ),
                        ProductList(order: order),
                        Divider(
                          height: 1,
                          color: AppColors.grayEA,
                          thickness: 1.sp,
                        ),
                        PriceSummary(order: order),
                      ],
                    ),
                  ),
                  SectionCard(
                    title: 'Thanh toán',
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [PaymentList(order: order)],
                    ),
                  ),
                  SectionCard(
                    title: 'Khách hàng',
                    loadingState: data.customer == null,
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        if (data.customer != null)
                          ExpandableCustomerInfo(customer: data.customer!),
                      ],
                    ),
                  ),
                  SectionCard(
                    title: 'Đóng gói và giao hàng',
                    statusWidget: data.orderDelivery != null
                        ? StatusBadge(
                            label: renderOrderShipmentStatus(
                              data.orderDelivery?.deliveryStatus,
                            ),
                            color:
                                renderOrderShipmentStatusColor(
                                  data.orderDelivery?.deliveryStatus,
                                ) ??
                                AppColors.grey84,
                          )
                        : null,
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        if (data.orderDelivery != null)
                          ShipmentSection(
                            orderDelivery: data.orderDelivery,
                            delivery: order.delivery,
                            deliveryOrderRaw: data.deliveryOrderRaw,
                          )
                        else
                          Text(
                            'Chưa có thông tin giao hàng',
                            style: AppStyles.text.medium(
                              fSize: 13.sp,
                              color: AppColors.grey84,
                            ),
                          ),
                      ],
                    ),
                  ),
                  SectionCard(
                    title: 'Cộng tác viên',
                    child: ColumnWidget(
                      crossAxisAlignment: .start,
                      gap: 6.h,
                      children: [
                        if (data.order.collaborator != null) ...[
                          CustomRichTextWidget(
                            defaultStyle: AppStyles.text.medium(
                              fSize: 13.sp,
                              color: AppColors.grey84,
                            ),
                            texts: [
                              "Tên:\t\t",
                              TextSpan(
                                text:
                                    data.order.collaborator?.name ??
                                    AppConstant.strings.DEFAULT_EMPTY_VALUE,
                                style: AppStyles.text.medium(
                                  fSize: 13.sp,
                                  color: AppColors.black,
                                ),
                              ),
                            ],
                          ),
                          CustomRichTextWidget(
                            defaultStyle: AppStyles.text.medium(
                              fSize: 13.sp,
                              color: AppColors.grey84,
                            ),
                            texts: [
                              "Mã CTV:\t\t",
                              TextSpan(
                                text:
                                    data.order.collaborator?.code ??
                                    AppConstant.strings.DEFAULT_EMPTY_VALUE,
                                style: AppStyles.text.medium(
                                  fSize: 13.sp,
                                  color: AppColors.black,
                                ),
                              ),
                            ],
                          ),
                        ] else
                          Text(
                            'Không có thông tin cộng tác viên',
                            style: AppStyles.text.medium(
                              fSize: 13.sp,
                              color: AppColors.grey84,
                            ),
                          ),
                      ],
                    ),
                  ),
                  SectionCard(
                    title: 'Thông tin bổ sung',
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        if (data.orderInfo != null ||
                            data.warehouse != null ||
                            data.staff != null ||
                            data.company != null)
                          AdditionalSection(
                            orderInfo: data.orderInfo,
                            warehouse: data.warehouse,
                            staff: data.staff,
                            company: data.company,
                            saleChannel: order.saleChannel,
                            personCreated: data.personCreated,
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
