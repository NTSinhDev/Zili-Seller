import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/bloc/address/address_cubit.dart';
import 'package:zili_coffee/data/models/address/customer_address.dart';
import 'package:zili_coffee/data/models/user/user.dart';
import 'package:zili_coffee/data/repositories/auth_repository.dart';
import 'package:zili_coffee/di/dependency_injection.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/extension/build_context.dart';
import 'package:zili_coffee/utils/widgets/widgets.dart';
import 'package:zili_coffee/views/module_common/address_form/components/input_district.dart';
import 'package:zili_coffee/views/module_common/address_form/components/input_email.dart';
import 'package:zili_coffee/views/module_common/address_form/components/input_name.dart';
import 'package:zili_coffee/views/module_common/address_form/components/input_phone.dart';
import 'package:zili_coffee/views/module_common/address_form/components/input_province_city.dart';
import 'package:zili_coffee/views/module_common/address_form/components/input_specific_address.dart';
import 'package:zili_coffee/views/module_common/address_form/components/input_ward_town.dart';

class AddressForm extends StatefulWidget {
  final Function(CustomerAddress address) onCreatedAddress;
  final Function(CustomerAddress address)? onUpdatedAddress;
  final Function(CustomerAddress address)? onDeleteAddress;
  final EdgeInsetsGeometry? padding;
  final String? labelSubmitBtn;
  final CustomerAddress? address;
  const AddressForm({
    super.key,
    required this.onCreatedAddress,
    this.onUpdatedAddress,
    this.padding,
    this.labelSubmitBtn,
    this.address,
    this.onDeleteAddress,
  });

  @override
  State<AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  final AuthRepository authRepo = di<AuthRepository>();
  final AddressCubit addressCubit = di<AddressCubit>();
  late CustomerAddress address;

  bool test = false;

  @override
  void initState() {
    super.initState();
    final User customter = authRepo.currentUser!;
    if (widget.address != null) {
      address = widget.address!;
    } else {
      address = CustomerAddress(
        customerId: customter.id,
        name: customter.name,
        phone: customter.phone,
        email: customter.email,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: widget.padding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputName(
            name: address.name,
            hint: 'Họ và tên của bạn',
            label: 'Họ và tên*',
            changedName: (name) {
              setState(() => address = address.copyWith(name: name));
            },
          ),
          height(height: 25),
          InputPhone(
            phone: address.phone,
            hint: 'Nhập số điện thoại của bạn',
            label: 'Số điện thoại*',
            changedPhone: (phone) {
              setState(() => address = address.copyWith(phone: phone));
            },
          ),
          height(height: 25),
          InputEmail(
            email: address.email,
            hint: 'Nhập Email của bạn',
            changedEmail: (email) {
              setState(() => address = address.copyWith(email: email));
            },
          ),
          height(height: 25),
          InputProvinceCity(
            cubit: addressCubit,
            address: address,
            changedProvinceCity: (province) {
              if (province == address.province) return;
              setState(() => address = address.copyWith(province: province));
              address.clearDistrict();
              address.clearWard();
            },
          ),
          height(height: 25),
          InputDistrict(
            cubit: addressCubit,
            address: address,
            changedDistrict: (district) {
              if (district == address.district) return;
              setState(() => address = address.copyWith(district: district));
              address.clearWard();
            },
          ),
          height(height: 25),
          InputWardTown(
            cubit: addressCubit,
            address: address,
            changedDistrict: (ward) {
              if (ward == address.ward) return;
              setState(() => address = address.copyWith(ward: ward));
            },
          ),
          height(height: 25),
          InputSpecificAddress(
            address: address.specificAddress,
            changedSpecificAddress: (specific) {
              address = address.copyWith(specificAddress: specific);
            },
          ),
          height(height: 8),
          if (widget.address == null || !widget.address!.isDefaultAddress)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Đặt làm địa chỉ mặc định",
                  style: AppStyles.text.semiBold(fSize: 16.sp),
                ),
                Switch(
                  value: address.isDefaultAddress,
                  onChanged: (value) {
                    setState(() => address = address.copyWith(
                        isDefaultAddress: !address.isDefaultAddress));
                  },
                  activeThumbColor: AppColors.primary,
                  activeTrackColor: AppColors.primary.withOpacity(0.3),
                  inactiveThumbColor: AppColors.grey,
                  inactiveTrackColor: AppColors.grey.withOpacity(0.3),
                )
              ],
            ),
          height(height: 25),
          if (widget.address != null && widget.onDeleteAddress != null)
            CustomButtonWidget(
              onTap: () => widget.onDeleteAddress!(address),
              color: AppColors.white,
              boxShadows: const [],
              radius: 8.r,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomIconStyle(
                    icon: CupertinoIcons.trash,
                    style: AppStyles.text
                        .semiBold(fSize: 15.sp, color: AppColors.primary),
                  ),
                  width(width: 10),
                  Text(
                    'Xóa địa chỉ',
                    style: AppStyles.text
                        .semiBold(fSize: 15.sp, color: AppColors.primary),
                  )
                ],
              ),
            ),
          height(height: 15),
          CustomButtonWidget(
            onTap: widget.address != null
                ? updateCustomerAddress
                : addCustomerAddress,
            radius: 8.r,
            label: widget.labelSubmitBtn ?? 'Thêm địa chỉ',
          ),
          height(height: 8),
        ],
      ),
    );
  }

  dynamic updateCustomerAddress() {
    return widget.onUpdatedAddress != null
        ? widget.onUpdatedAddress!(address)
        : null;
  }

  void addCustomerAddress() {
    if (address.checkData()) {
      widget.onCreatedAddress(address);
    } else {
      context.showNotificationDialog(
        title: "Thông báo",
        message: "Vui lòng điền đầy đủ thông tin!",
      );
    }
  }
}
