import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/utils/extension/extension.dart';

import '../../data/models/address/address.dart';
import '../../data/models/user/customer.dart';
import '../../res/res.dart';
import '../../utils/functions/address_functions.dart';
import '../../utils/widgets/widgets.dart';
import '../module_common/avatar.dart';

class ExpandableCustomerInfo extends StatefulWidget {
  final Customer customer;
  final VoidCallback? fetchData;
  final VoidCallback? onRemoveCustomer;
  final VoidCallback? onEditPurchaseAddress;
  final VoidCallback? onEditBillingAddress;
  final (bool showSpending, bool showPurchase, bool showBilling) viewMode;
  const ExpandableCustomerInfo({
    super.key,
    required this.customer,
    this.fetchData,
    this.onRemoveCustomer,
    this.onEditPurchaseAddress,
    this.onEditBillingAddress,
    this.viewMode = (true, true, true),
  });

  @override
  State<ExpandableCustomerInfo> createState() => _ExpandableCustomerInfoState();
}

class _ExpandableCustomerInfoState extends State<ExpandableCustomerInfo> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return ColumnWidget(
      gap: 8.h,
      children: [
        GestureDetector(
          onTap: widget.fetchData,
          child: _CustomerCard(
            customer: widget.customer,
            onRemove: widget.onRemoveCustomer,
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: _isExpanded
                ? ColumnWidget(
                    gap: 16.h,
                    margin: .only(top: 8.h),
                    children: [
                      if (widget.onRemoveCustomer != null)
                        Divider(
                          color: AppColors.greyC0,
                          height: 1.sp,
                          thickness: 1.sp,
                        ),
                      if (widget.viewMode.$1) _PurchasedCard(widget.customer),
                      if (widget.viewMode.$2)
                        _AddressCard(
                          title: 'Địa chỉ giao hàng',
                          address: widget.customer.purchaseAddress,
                          onEdit: widget.onEditPurchaseAddress,
                        ),
                      if (widget.viewMode.$3)
                        _AddressCard(
                          title: 'Địa chỉ nhận hóa đơn',
                          address: widget.customer.billingAddress,
                          onEdit: widget.onEditBillingAddress,
                        ),
                      const SizedBox.shrink(),
                    ],
                  )
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
                padding: .symmetric(horizontal: 16.w, vertical: 4.h),
                child: Row(
                  mainAxisSize: .min,
                  children: [
                    Text(
                      _isExpanded ? 'Thu gọn' : 'Xem thêm',
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
    );
  }
}

class _CustomerCard extends StatelessWidget {
  final Customer customer;
  final VoidCallback? onRemove;
  const _CustomerCard({required this.customer, this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .all(12.w),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: .circular(8.r),
      ),
      child: RowWidget(
        crossAxisAlignment: .center,
        gap: 12.w,
        children: [
          Avatar(avatar: customer.avatar, size: 32.w),
          Expanded(
            child: ColumnWidget(
              crossAxisAlignment: .start,
              gap: 4.h,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        customer.displayName,
                        style: AppStyles.text.semiBold(fSize: 14.sp),
                        maxLines: 1,
                        overflow: .ellipsis,
                      ),
                    ),
                    if ((customer.phone ?? "").isNotEmpty)
                      Expanded(
                        child: Text(
                          ' - ${customer.phone}',
                          style: AppStyles.text.medium(
                            fSize: 12.sp,
                            color: AppColors.black5,
                          ),
                        ),
                      ),
                  ],
                ),
                if ((customer.email ?? "").isNotEmpty)
                  Text(
                    customer.email!,
                    style: AppStyles.text.medium(
                      fSize: 12.sp,
                      color: AppColors.black5,
                    ),
                  ),
              ],
            ),
          ),
          // Icon X để xóa
          if (onRemove != null)
            InkWell(
              onTap: onRemove,
              child: Icon(Icons.close, size: 20.sp, color: AppColors.black3),
            ),
        ],
      ),
    );
  }
}

class _PurchasedCard extends StatelessWidget {
  final Customer customer;
  const _PurchasedCard(this.customer);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: .start,
      children: [
        Expanded(
          child: ColumnWidget(
            crossAxisAlignment: .start,
            gap: 8.h,
            children: [
              Text(
                'Thông tin mua hàng',
                style: AppStyles.text.semiBold(fSize: 14.sp),
              ),
              CustomRichTextWidget(
                defaultStyle: AppStyles.text.medium(
                  fSize: 12.sp,
                  color: AppColors.black5,
                ),
                texts: [
                  'Tổng chi tiêu:\t\t',
                  TextSpan(
                    text: customer.totalSpending.toUSD,
                    style: AppStyles.text.semiBold(
                      fSize: 12.sp,
                      color: SystemColors.primaryBlue,
                    ),
                  ),
                  TextSpan(
                    text: '\t\t(${customer.totalOrder.toInt()} đơn hàng)',
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
                texts: [
                  'Công nợ hiện tại:\t\t',
                  TextSpan(
                    text: customer.currentDebt.toUSD,
                    style: AppStyles.text.semiBold(
                      fSize: 12.sp,
                      color: SystemColors.tertiaryRed,
                    ),
                  ),
                ],
              ),
              CustomRichTextWidget(
                defaultStyle: AppStyles.text.medium(
                  fSize: 12.sp,
                  color: AppColors.black5,
                ),
                texts: [
                  'Trả hàng:\t\t',
                  TextSpan(
                    text: customer.returnedTotalAmount.toUSD,
                    style: AppStyles.text.semiBold(
                      fSize: 12.sp,
                      color: SystemColors.tertiaryRed,
                    ),
                  ),
                  TextSpan(
                    text:
                        '\t\t(${customer.returnedProductQuantity.toInt()} sản phẩm)',
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
                texts: [
                  'Giao thất bại:\t\t',
                  TextSpan(
                    text: customer.failedDeliveryTotalAmount.toUSD,
                    style: AppStyles.text.semiBold(
                      fSize: 12.sp,
                      color: SystemColors.tertiaryRed,
                    ),
                  ),
                  TextSpan(
                    text:
                        '\t\t(${customer.failedDeliveryOrderCount.toInt()} đơn hàng)',
                    style: AppStyles.text.medium(
                      fSize: 12.sp,
                      color: AppColors.black3,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AddressCard extends StatelessWidget {
  final String title;
  final Address? address;
  final VoidCallback? onEdit;

  const _AddressCard({required this.title, required this.address, this.onEdit});

  @override
  Widget build(BuildContext context) {
    final renderAddress = address != null
        ? renderCustomerAddress(address)
        : 'Chưa có địa chỉ';
    return Row(
      crossAxisAlignment: .start,
      children: [
        Expanded(
          child: ColumnWidget(
            crossAxisAlignment: .start,
            gap: 8.h,
            children: [
              Text(title, style: AppStyles.text.semiBold(fSize: 14.sp)),
              if (address != null) ...[
                Text(
                  address?.name ?? AppConstant.strings.DEFAULT_EMPTY_VALUE,
                  style: AppStyles.text.medium(
                    fSize: 13.sp,
                    color: address != null
                        ? AppColors.black3
                        : AppColors.grey84,
                  ),
                ),
                Text(
                  address?.phone ?? AppConstant.strings.DEFAULT_EMPTY_VALUE,
                  style: AppStyles.text.medium(
                    fSize: 13.sp,
                    color: address != null
                        ? AppColors.black3
                        : AppColors.grey84,
                  ),
                ),
              ],
              Text(
                renderAddress,
                style: AppStyles.text.medium(
                  fSize: 13.sp,
                  color: address != null ? AppColors.black3 : AppColors.grey84,
                ),
              ),
            ],
          ),
        ),
        // Icon bút chì để edit
        if (onEdit != null)
          InkWell(
            onTap: onEdit,
            child: Icon(
              Icons.edit_outlined,
              size: 20.sp,
              color: AppColors.primary,
            ),
          ),
      ],
    );
  }
}
