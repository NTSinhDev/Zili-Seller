import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../bloc/customer/customer_cubit.dart';
import '../../../data/models/user/customer.dart';
import '../../../data/repositories/customer_repository.dart';
import '../../../di/dependency_injection.dart';
import '../../../res/res.dart';
import '../../../utils/enums/customer_enum.dart';
import '../../../utils/extension/extension.dart';
import '../../../utils/functions/base_functions.dart';
import '../../../utils/widgets/widgets.dart';
import '../../common/shimmer_view.dart';

class InformationView extends StatelessWidget {
  final CustomerDetailsScreenTab tabIndex;
  const InformationView({super.key, required this.tabIndex});

  static CustomerDetailsScreenTab tab = .information;

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: tabIndex != tab,
      child: StreamBuilder<Customer?>(
        stream: di<CustomerRepository>().selectedCustomer.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == .waiting) {
            return const ShimmerView(type: .loadingIndicatorAtHead);
          }

          final Customer? customer = snapshot.data;
          return CommonLoadMoreRefreshWrapper.refresh(
            context,
            onRefresh: customer?.id != null
                ? () async =>
                      await di<CustomerCubit>().getCustomerById(customer!.id)
                : () async {},
            child: SingleChildScrollView(
              child: ColumnWidget(
                margin: .symmetric(vertical: 16.h),
                gap: 12.h,
                children: [
                  _buildCustomerInformation(context, customer),
                  _buildPurchaseOrders(context, customer),
                  _buildSuggestedSales(context, customer),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSuggestedSales(BuildContext context, Customer? customer) {
    final Map<String, dynamic> suggestedSalesInformationMaps = {
      "Chính sách giá mặc định":
          customer?.defaultPriceName ?? AppConstant.strings.DEFAULT_EMPTY_VALUE,
      "Chiết khấu khách hàng": customer?.discount != null
          ? "${customer?.discount}%"
          : AppConstant.strings.DEFAULT_EMPTY_VALUE,
      "Hình thức thanh toán mặc định":
          customer?.paymentMethodName ??
          AppConstant.strings.DEFAULT_EMPTY_VALUE,
    };
    return ColumnWidget(
      crossAxisAlignment: .start,
      padding: .only(top: 16.h),
      backgroundColor: AppColors.white,
      mainAxisSize: .min,
      children: [
        Container(
          padding: .symmetric(horizontal: 20.w),
          child: Text(
            'Thông tin gợi ý bán hàng',
            style: AppStyles.text.semiBold(fSize: 16.sp),
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: suggestedSalesInformationMaps.entries.length,
          separatorBuilder: (context, index) =>
              Divider(color: AppColors.background, height: 1.h),
          itemBuilder: (context, index) {
            final data = suggestedSalesInformationMaps.entries.elementAt(index);
            return Container(
              padding: .symmetric(horizontal: 20.w, vertical: 12.h),
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
                    style: AppStyles.text.medium(fSize: 14.sp),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPurchaseOrders(BuildContext context, Customer? customer) {
    final Map<String, dynamic> purchaseInformationMaps = {
      "Tổng chi tiêu": formatCurrency(customer?.totalSpending ?? 0),
      "Tổng đơn hàng": "${formatCurrency(customer?.totalOrder ?? 0)} đơn",
      "Ngày cuối cùng mua hàng": customer?.lastPurchaseAt?.toLocal().csToString(
        "HH:mm dd/MM/yyyy",
      ),
      "Tổng SL sản phẩm đã mua": formatCurrency(
        customer?.totalPurchasedProduct ?? 0,
      ),
      "Tổng SL sản phẩm hoàn trả":
          "${formatCurrency(customer?.returnedProductQuantity ?? 0)} Sản phẩm",
      "Công nợ hiện tại": formatCurrency(customer?.currentDebt ?? 0),
    };
    return ColumnWidget(
      crossAxisAlignment: .start,
      padding: .only(top: 16.h),
      backgroundColor: AppColors.white,
      mainAxisSize: .min,
      children: [
        Container(
          padding: .symmetric(horizontal: 20.w),
          child: Text(
            'Thông tin mua hàng',
            style: AppStyles.text.semiBold(fSize: 16.sp),
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: purchaseInformationMaps.entries.length,
          separatorBuilder: (context, index) =>
              Divider(color: AppColors.background, height: 1.h),
          itemBuilder: (context, index) {
            final data = purchaseInformationMaps.entries.elementAt(index);
            return Container(
              padding: .symmetric(horizontal: 20.w, vertical: 12.h),
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
                    style: AppStyles.text.medium(fSize: 14.sp),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCustomerInformation(BuildContext context, Customer? customer) {
    final Map<String, dynamic> informationMaps = {
      "Tên": customer?.fullName,
      "Mã khách hàng": customer?.code,
      "Số điện thoại": customer?.phone,
      "email": customer?.email,
      "Ngày sinh": customer?.birthday?.csToString("dd/MM/yyyy"),
      "Giới tính": customer?.gender == 1 ? "Nam" : "Nữ",
      "Mã số thuế": customer?.taxCode?.isEmpty == true
          ? AppConstant.strings.DEFAULT_EMPTY_VALUE
          : customer?.taxCode,
      "website": customer?.website?.isEmpty == true
          ? AppConstant.strings.DEFAULT_EMPTY_VALUE
          : customer?.website,
      "Nhóm khách hàng": customer?.customerGroup?.nameVi,
      "Nhân viên phụ trách": customer?.personInCharge?.name,
      "Cộng tác viên phụ trách": customer?.collaboratorInCharge?.name,
      "Mô tả": customer?.note?.isEmpty == true
          ? AppConstant.strings.DEFAULT_EMPTY_VALUE
          : customer?.note,
    };
    return ColumnWidget(
      crossAxisAlignment: .start,
      padding: .only(top: 16.h),
      backgroundColor: AppColors.white,
      mainAxisSize: .min,
      children: [
        Container(
          padding: .symmetric(horizontal: 20.w),
          child: Text(
            'Thông tin khách hàng',
            style: AppStyles.text.semiBold(fSize: 16.sp),
          ),
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
              padding: .symmetric(horizontal: 20.w, vertical: 12.h),
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
                    style: AppStyles.text.medium(fSize: 14.sp),
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
