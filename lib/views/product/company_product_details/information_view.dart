import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:zili_coffee/views/common/radio_button.dart';

import '../../../bloc/product/product_cubit.dart';
import '../../../data/models/product/company_product.dart';
import '../../../data/repositories/product_repository.dart';
import '../../../di/dependency_injection.dart';
import '../../../res/res.dart';
import '../../../utils/extension/extension.dart';
import '../../../utils/functions/product_functions.dart';
import '../../../utils/widgets/widgets.dart';
import '../../common/shimmer_view.dart';
import '../../common/status_badge.dart';

class InformationView extends StatelessWidget {
  final int tabIndex;
  const InformationView({super.key, required this.tabIndex});

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: tabIndex != 0,
      child: StreamBuilder<CompanyProduct?>(
        stream: di<ProductRepository>().companyProductDetailStreamData.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == .waiting) {
            return const ShimmerView(type: .normal);
          }

          final CompanyProduct? data = snapshot.data;
          return CommonLoadMoreRefreshWrapper.refresh(
            context,
            onRefresh: data?.id != null
                ? () async => await di<ProductCubit>()
                      .fetchCompanyProductDetail(productId: data!.id)
                : () async {},
            child: SingleChildScrollView(
              child: ColumnWidget(
                margin: .symmetric(vertical: 16.h),
                gap: 12.h,
                children: [
                  _buildProductInformation(context, data),
                  _buildImagesDescriptionInfo(context, data),
                  _buildDescriptionInfo(context, data),
                  _buildCostInformation(context, data),
                  _buildAdditionalInfo(context, data),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDescriptionInfo(BuildContext context, CompanyProduct? data) {
    return ColumnWidget(
      crossAxisAlignment: .start,
      padding: .symmetric(horizontal: 20.w, vertical: 16.h),
      backgroundColor: AppColors.white,
      mainAxisSize: .min,
      gap: 12.h,
      children: [
        Row(
          children: [
            Text(
              'Mô tả sản phẩm',
              style: AppStyles.text.semiBold(fSize: 16.sp),
            ),
          ],
        ),
        if ((data?.descriptionVi ?? data?.descriptionEn) != null)
          HtmlWidget(data?.descriptionVi ?? data?.descriptionEn ?? ""),
        if ((data?.imageDescriptionVi ?? data?.imageDescriptionEn ?? [])
            .isNotEmpty)
          ...(data?.imageDescriptionVi ?? data?.imageDescriptionEn ?? []).map(
            (e) => ImageLoadingWidget(
              url: e,
              width: .infinity,
              height: 200.h,
              fit: .contain,
            ),
          ),
      ],
    );
  }

  Widget _buildImagesDescriptionInfo(
    BuildContext context,
    CompanyProduct? data,
  ) {
    return ColumnWidget(
      crossAxisAlignment: .start,
      padding: .symmetric(horizontal: 20.w, vertical: 16.h),
      backgroundColor: AppColors.white,
      mainAxisSize: .min,
      gap: 12.h,
      children: [
        Row(
          children: [
            Text(
              'Ảnh chi tiết sản phẩm',
              style: AppStyles.text.semiBold(fSize: 16.sp),
            ),
          ],
        ),
        if ((data?.imageDetail ?? []).isNotEmpty)
          ...(data?.imageDetail ?? []).map(
            (e) => ImageLoadingWidget(
              url: e,
              width: .infinity,
              height: 200.h,
              fit: .contain,
            ),
          ),
      ],
    );
  }

  Widget _buildAdditionalInfo(BuildContext context, CompanyProduct? data) {
    return ColumnWidget(
      crossAxisAlignment: .start,
      padding: .only(top: 16.h),
      backgroundColor: AppColors.white,
      mainAxisSize: .min,
      children: [
        Container(
          padding: .symmetric(horizontal: 20.w),
          child: Text(
            'Thông tin bổ sung',
            style: AppStyles.text.semiBold(fSize: 16.sp),
          ),
        ),
        ColumnWidget(
          padding: .symmetric(horizontal: 20.w),
          crossAxisAlignment: .start,
          margin: .symmetric(vertical: 12.h),
          gap: 12.h,
          children: [
            CommonRadioButtonItem(
              canExpand: true,
              label: 'Cho phép sản phẩm được tìm kiếm và tạo đơn hàng',
              isSelected: data?.isSaleAllowed ?? false,
            ),
            CommonRadioButtonItem(
              canExpand: false,
              label: 'Hiển thị ở website bán hàng',
              isSelected: data?.isOnWebsite ?? false,
            ),
            CommonRadioButtonItem(
              canExpand: false,
              label: 'Có thể đóng gói',
              isSelected: data?.isCanPacking ?? false,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCostInformation(BuildContext context, CompanyProduct? data) {
    final Map<String, dynamic> purchaseInformationMaps = {
      "Giá bán lẻ": data?.price.toUSD,
      "Giá bán buôn": data?.wholesalePrice.toUSD,
      "Giá nhập": data?.costPrice.toUSD,
      "Hoa hồng CTV": (data?.calculateByUnit ?? "").isNotEmpty
          ? '${data?.commission.toUSD}(${data?.calculateByUnit == "WEIGHT" ? "kg" : "Túi"})'
          : '${data?.commission.toUSD}',
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
            'Giá sản phẩm',
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

  Widget _buildProductInformation(BuildContext context, CompanyProduct? data) {
    final Map<String, dynamic> informationMaps = {
      "Avatar sản phẩm": data?.avatar != null
          ? ImageLoadingWidget(
              url: data!.avatar!,
              width: 100.w,
              height: 100.h,
              hasPlaceHolder: false,
              fit: .contain,
            )
          : null as String?,
      "Tiêu đề": data?.titleVi ?? data?.titleEn,
      "Tên viết tắt": data?.shortName,
      "Mã SKU": data?.sku,
      "Mã vạch": data?.barcode,
      "Khối lượng": convertProductWeight(data?.weight),
      "Đơn vị tính": data?.measureUnit,
      "Loại sản phẩm":
          data?.categoryInternal?.nameVi ?? data?.categoryInternal?.nameEn,
      "Danh mục": data?.category?.nameVi ?? data?.category?.nameEn,
      "Thương hiệu": data?.brand?.name,
      "Thời gian tạo": data?.createdAt.csToString("HH:mm dd/MM/yyyy"),
      "Ngày cập nhật": data?.updatedAt.csToString("HH:mm dd/MM/yyyy"),
    };
    return ColumnWidget(
      crossAxisAlignment: .start,
      padding: .only(top: 16.h),
      backgroundColor: AppColors.white,
      mainAxisSize: .min,
      children: [
        RowWidget(
          mainAxisAlignment: .spaceBetween,
          padding: .symmetric(horizontal: 20.w),
          children: [
            Text(
              'Thông tin sản phẩm',
              style: AppStyles.text.semiBold(fSize: 16.sp),
            ),
            StatusBadge(
              label:
                  renderProductStatus(data?.status ?? "") ??
                  AppConstant.strings.DEFAULT_EMPTY_VALUE,
              color: renderProductStatusColor(data?.status) ?? AppColors.lightF,
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
                  if (data.value is String?)
                    Text(
                      "${data.value ?? AppConstant.strings.DEFAULT_EMPTY_VALUE}",
                      style: AppStyles.text.medium(fSize: 14.sp),
                    )
                  else if (data.value is Widget)
                    data.value as Widget
                  else
                    Text(
                      AppConstant.strings.DEFAULT_EMPTY_VALUE,
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
