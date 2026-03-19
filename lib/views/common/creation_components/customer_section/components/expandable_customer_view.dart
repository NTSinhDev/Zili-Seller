part of '../customer_section.dart';

class _ExpandableCustomerView extends StatefulWidget {
  final Customer customer;
  final VoidCallback? onRemoveCustomer;
  final VoidCallback? onEditPurchaseAddress;
  final VoidCallback? onEditBillingAddress;
  final (bool showContact, bool showPurchase, bool showBilling) showOptions;
  const _ExpandableCustomerView({
    required this.customer,
    this.onRemoveCustomer,
    this.onEditPurchaseAddress,
    this.onEditBillingAddress,
    required this.showOptions,
  });

  @override
  State<_ExpandableCustomerView> createState() =>
      _ExpandableCustomerViewState();
}

class _ExpandableCustomerViewState extends State<_ExpandableCustomerView> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return ColumnWidget(
      children: [
        _CustomerCard(
          customer: widget.customer,
          onRemove: widget.onRemoveCustomer,
        ),
        SizedBox(
          width: .infinity,
          child: AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: _isExpanded
                ? ColumnWidget(
                    gap: 12.h,
                    children: [
                      SizedBox.shrink(),
                      if (widget.showOptions.$1)
                        _ContactCard(
                          email: widget.customer.email ?? '',
                          phone: widget.customer.phone ?? '',
                        ),
                      _PurchasedCard(widget.customer),
                      if (widget.showOptions.$2)
                        _AddressCard(
                          title: 'Địa chỉ giao hàng',
                          address: widget.customer.purchaseAddress,
                          onEdit: widget.onEditPurchaseAddress,
                        ),
                      if (widget.showOptions.$3)
                        _AddressCard(
                          title: 'Địa chỉ nhận hóa đơn',
                          address: widget.customer.billingAddress,
                          onEdit: widget.onEditBillingAddress,
                        ),
                      const SizedBox.shrink(),
                    ],
                  )
                : const SizedBox(height: 4),
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
                      _isExpanded ? 'Đóng' : 'Chi tiết',
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
