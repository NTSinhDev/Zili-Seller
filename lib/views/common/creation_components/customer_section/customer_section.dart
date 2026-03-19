import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../data/models/address/address.dart';
import '../../../../data/models/user/customer.dart';
import '../../../../res/res.dart';
import '../../../../utils/extension/extension.dart';
import '../../../../utils/functions/address_functions.dart';
import '../../../../utils/widgets/widgets.dart';
import '../../../customer/config_customer_address/config_customer_address_screen.dart';
import '../../../customer/select_customers/select_customer_screen.dart';
import '../../../module_common/avatar.dart';

part 'components/expandable_customer_view.dart';
part 'components/customer_cards.dart';

class CustomerSection extends StatelessWidget {
  final Customer? customer;
  final Function(Customer?) updateCustomer;
  final bool ignoreChangeCustomer;
  final (bool showContact, bool showPurchase, bool showBilling) showOptions;
  const CustomerSection({
    super.key,
    required this.customer,
    required this.updateCustomer,
    this.showOptions = (true, true, true),
    this.ignoreChangeCustomer = false,
  });

  void _selectCustomer(BuildContext context) {
    context.navigator
        .pushNamed(
          SelectCustomersScreen.keyName,
          arguments: {'currentSelected': customer},
        )
        .then((result) {
          if (result != null && result is Customer) {
            // Defer update to next frame to avoid FocusScope assertion after route pop
            WidgetsBinding.instance.addPostFrameCallback((_) {
              updateCustomer(result);
            });
          }
        });
  }

  void _editAddress(
    BuildContext context,
    String title,
    Address? address,
    Function(Address) onCallBack,
  ) {
    context.navigator
        .pushNamed(
          ConfigCustomerAddressScreen.updateRoute,
          arguments: {
            'title': title,
            'customer': customer,
            'initialAddress': address,
          },
        )
        .then((result) {
          if (result != null && result is Address) {
            // Defer callback to next frame to avoid FocusScope assertion after route pop
            WidgetsBinding.instance.addPostFrameCallback((_) {
              onCallBack(result);
            });
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w).copyWith(bottom: 4.h),
      color: AppColors.white,
      child: ColumnWidget(
        crossAxisAlignment: .start,
        gap: 12.h,
        children: [
          RowWidget(
            mainAxisAlignment: .spaceBetween,
            children: [
              Text('Khách hàng', style: AppStyles.text.semiBold(fSize: 16.sp)),
              if (!ignoreChangeCustomer)
                InkWell(
                  onTap: () => _selectCustomer(context),
                  child: RowWidget(
                    gap: 4.w,
                    children: [
                      if (customer.isNull)
                        Text(
                          'Chọn khách hàng',
                          style: AppStyles.text.medium(
                            fSize: 14.sp,
                            color: AppColors.primary,
                          ),
                        )
                      else ...[
                        Icon(
                          Icons.mode_edit_outline_rounded,
                          size: 16.sp,
                          color: AppColors.primary,
                        ),
                        Text(
                          'Thay đổi',
                          style: AppStyles.text.medium(
                            fSize: 14.sp,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
            ],
          ),
          if (customer.isNull) ...[
            _buildEmptyState(context),
            const SizedBox.shrink(),
          ] else ...[
            Divider(height: 1, color: AppColors.grayEA, thickness: 1.sp),
            _ExpandableCustomerView(
              customer: customer!,
              showOptions: showOptions,
              onRemoveCustomer: ignoreChangeCustomer ? null : () => updateCustomer(null),
              onEditPurchaseAddress: () {
                if (customer == null) return;
                _editAddress(
                  context,
                  'Địa chỉ giao hàng',
                  customer?.purchaseAddress,
                  (result) {
                    final newCustomer = customer;
                    newCustomer?.purchaseAddress = result;
                    if (newCustomer?.billingAddress?.id == result.id) {
                      newCustomer?.billingAddress = result;
                    } else {
                      newCustomer?.billingAddress ??= result;
                    }
                    updateCustomer(newCustomer);
                  },
                );
              },
              onEditBillingAddress: () {
                if (customer.isNotNull) {
                  _editAddress(
                    context,
                    'Địa chỉ nhận hóa đơn',
                    customer?.purchaseAddress,
                    (result) {
                      final newCustomer = customer;
                      newCustomer?.billingAddress = result;
                      if (newCustomer?.purchaseAddress?.id == result.id) {
                        newCustomer?.purchaseAddress = result;
                      } else {
                        newCustomer?.purchaseAddress ??= result;
                      }
                      updateCustomer(newCustomer);
                    },
                  );
                }
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      width: .infinity,
      padding: .symmetric(vertical: 40.h),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: .circular(8.r),
        border: .all(color: AppColors.greyC0),
      ),
      child: GestureDetector(
        onTap: ignoreChangeCustomer ? null : () => _selectCustomer(context),
        child: ColumnWidget(
          gap: 12.h,
          children: [
            Icon(Icons.person_outline, size: 48.sp, color: AppColors.grey84),
            Text(
              'Chưa chọn khách hàng',
              style: AppStyles.text.medium(
                fSize: 14.sp,
                color: AppColors.grey84,
              ),
            ),
            Text(
              'Nhấn để chọn khách hàng',
              style: AppStyles.text.medium(
                fSize: 12.sp,
                color: AppColors.grey97,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
