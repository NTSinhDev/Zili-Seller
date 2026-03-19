import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zili_coffee/bloc/address/address_cubit.dart';
import 'package:zili_coffee/data/models/address/customer_address.dart';
import 'package:zili_coffee/di/dependency_injection.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/extension/build_context.dart';
import 'package:zili_coffee/utils/widgets/widgets.dart';
import 'package:zili_coffee/views/module_common/address_form/address_form.dart';

class AddAddressScreen extends StatelessWidget {
  final CustomerAddress? address;
  final String? title;
  const AddAddressScreen({super.key, this.address, this.title});
  static const String keyName = '/add-address';

  @override
  Widget build(BuildContext context) {
    final AddressCubit addressCubit = di<AddressCubit>();
    return BlocListener<AddressCubit, AddressState>(
      bloc: addressCubit,
      listener: (context, state) async {
        if (state is CreatingAddressState) {
          context.showLoading(message: state.label);
        } else if (state is CreatedAddressState) {
          await addressCubit.getAllAddress();
          context
            ..hideLoading()
            ..navigator.pop();
        } else if (state is CreatedFailedAddressState) {
          context
            ..hideLoading()
            ..showNotificationDialog(
              message: state.error.errorMessage,
              cancelWidget: Container(),
              action: "Đóng",
            );
        } else if (state is DeletedFailedAddressState) {
          context.showNotificationDialog(
            title: 'Không thể xóa địa chỉ',
            message: "Hệ thống gặp lỗi trong khi thực hiện tác vụ trên!",
          );
        }
      },
      child: Scaffold(
        appBar: AppBarWidget.lightAppBar(
          context,
          label: title ?? 'Thêm địa chỉ nhận hàng',
        ),
        backgroundColor: AppColors.white,
        body: GestureDetector(
          onTap: () => context.focus.unfocus(),
          child: Stack(
            children: [
              Positioned(
                top: 45,
                left: 0,
                child: SvgPicture.asset(AppConstant.svgs.bgScreen),
              ),
              SizedBox(
                width: Spaces.screenWidth(context),
                height: Spaces.screenHeight(context),
                child: AddressForm(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 30.h,
                  ),
                  address: address,
                  labelSubmitBtn: "Lưu thông tin  ",
                  onCreatedAddress: (address) async {
                    await addressCubit.createAddress(address: address);
                  },
                  onUpdatedAddress: (address) async {
                    await addressCubit.updateAddress(address: address);
                  },
                  onDeleteAddress: (address) {
                    context.showNotificationDialog(
                      title: 'Xác nhận xóa?',
                      message: 'Bạn có chắc muốn xóa địa chỉ này?',
                      action: "Xác nhận",
                      ontap: () async {
                        await addressCubit.deleteAddress(address: address);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
