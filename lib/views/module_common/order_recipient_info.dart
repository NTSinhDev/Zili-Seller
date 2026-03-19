import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/data/models/address/customer_address.dart';
import 'package:zili_coffee/data/repositories/address_repository.dart';
import 'package:zili_coffee/data/repositories/order_repository.dart';
import 'package:zili_coffee/di/dependency_injection.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/extension/build_context.dart';
import 'package:zili_coffee/utils/extension/string.dart';
import 'package:zili_coffee/utils/widgets/widgets.dart';
import 'package:zili_coffee/views/address/user_addresses_management/user_addresses_screen.dart';

class OrderRecipientInfo extends StatelessWidget {
  final CustomerAddress? address;
  final bool readOnly;
  const OrderRecipientInfo({super.key, this.readOnly = true, this.address});

  @override
  Widget build(BuildContext context) {
    final AddressRepository addressRepo = di<AddressRepository>();
    CustomerAddress? address = this.address;
    return Stack(
      children: [
        StreamBuilder<CustomerAddress>(
            stream: addressRepo.addressPaymentStream,
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                address = snapshot.data!;
              } else {
                address = addressRepo.addresses.hasValue
                    ? addressRepo.addresses.value[0]
                    : address;
              }
              final OrderRepository orderRepository = di<OrderRepository>();
              // orderRepository.currentOrder = orderRepository.currentOrder!
              //     .copyWith(shippingAddress: address);

              return Container(
                width: Spaces.screenWidth(context),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 23.h),
                color: AppColors.lightGrey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PlaceholderWidget(
                      width: 157.w,
                      height: 17.h,
                      condition: address != null,
                      color: AppColors.white,
                      highlightColor: AppColors.lightGrey,
                      child: Text(
                        'Thông tin người nhận',
                        style: AppStyles.text.semiBold(fSize: 16.sp),
                      ),
                    ),
                    height(height: 12),
                    PlaceholderWidget(
                      width: 157.w,
                      height: 15.h,
                      condition: address != null,
                      color: AppColors.white,
                      highlightColor: AppColors.lightGrey,
                      child: Text(
                        address?.name ?? '',
                        style: AppStyles.text.medium(
                          fSize: 14.sp,
                          color: AppColors.black3,
                        ),
                      ),
                    ),
                    height(height: 6),
                    PlaceholderWidget(
                      width: 157.w,
                      height: 15.h,
                      condition: address != null,
                      color: AppColors.white,
                      highlightColor: AppColors.lightGrey,
                      child: Text(
                        'Số điện thoại: ${(address?.phone ?? "").toNumberPhone}',
                        style: AppStyles.text.medium(
                          fSize: 14.sp,
                          color: AppColors.black3,
                        ),
                      ),
                    ),
                    height(height: 6),
                    PlaceholderWidget(
                      width: Spaces.screenWidth(context) - 40.w,
                      height: 15.h,
                      condition: address != null,
                      color: AppColors.white,
                      highlightColor: AppColors.lightGrey,
                      child: Text(
                        'Địa chỉ: ${address?.address() ?? ""}',
                        style: AppStyles.text.medium(
                          fSize: 14.sp,
                          color: AppColors.black3,
                          height: 1.1,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
        if (!readOnly)
          Positioned(
            top: 6.h,
            right: 16.w,
            child: TextButton(
              onPressed: () {
                context.navigator.pushNamed(
                  UserAddressesScreen.keyName,
                  arguments: NavArgsKey.fromPayment,
                );
              },
              clipBehavior: Clip.none,
              child: Text(
                'Thay đổi',
                style: AppStyles.text.medium(
                  fSize: 14.sp,
                  color: AppColors.primary,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ),
      ],
    );
  }
}
