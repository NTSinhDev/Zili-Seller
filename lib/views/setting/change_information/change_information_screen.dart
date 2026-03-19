import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:zili_coffee/bloc/customer/customer_cubit.dart';
import 'package:zili_coffee/data/models/user/user.dart';
import 'package:zili_coffee/di/dependency_injection.dart';
import 'package:zili_coffee/utils/enums.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/extension/build_context.dart';
import 'package:zili_coffee/utils/widgets/widgets.dart';
import 'package:zili_coffee/views/module_common/address_form/components/input_email.dart';
import 'package:zili_coffee/views/module_common/address_form/components/input_name.dart';
import 'package:zili_coffee/views/module_common/address_form/components/input_phone.dart';
import 'package:zili_coffee/views/setting/modules/user_avatar.dart';
part 'components/group_radio_gender.dart';
part 'components/scaffold_screen.dart';
part 'components/dialog.dart';
part 'components/input_date_of_birth/input_date_of_birth.dart';
part 'components/input_date_of_birth/components/input_day.dart';
part 'components/input_date_of_birth/components/input_month.dart';
part 'components/input_date_of_birth/components/input_year.dart';
part 'components/input_date_of_birth/components/layout_input.dart';

class ChangeInformationScreen extends StatefulWidget {
  const ChangeInformationScreen({super.key});
  static String keyName = '/change-information';
  @override
  State<ChangeInformationScreen> createState() =>
      _ChangeInformationScreenState();
}

class _ChangeInformationScreenState extends State<ChangeInformationScreen> {
  final CustomerCubit cubit = di<CustomerCubit>();
  User? customer;
  String name = '';
  String email = '';
  String? phone;
  DateTime? dateOfBirth;
  Gender? gender;
  bool hasChangedData = false;

  @override
  Widget build(BuildContext context) {
    _getDataFromRoute(context);
    return BlocListener<CustomerCubit, CustomerState>(
      bloc: cubit,
      listener: (context, state) {
        if (state is MessageCustomerState) {
          context.showCustomDialog(
            height: 160.h,
            barrierColor: Colors.black38,
            canDismiss: false,
            backgroundColor: AppColors.white,
            child: _CustomUIDialog(
              label: 'Thành công',
              message: state.message,
            ),
          );
        } else if (state is FailedCustomerState) {
          context.showNotificationDialog(
            title: 'Cập nhật thất bại',
            message: state.error.errorMessage,
            cancelWidget: Container(),
            action: "Đóng",
          );
        }
      },
      child: _CaffoldScreen(
        onWillPop: () => popScreen(context),
        onBack: () => onBack(context),
        body: [
          height(height: 20),
          UserAvatar(avatarURL: customer?.avatar),
          height(height: 30),
          InputName(
            name: customer?.name,
            hint: 'Nhập họ tên người dùng',
            changedName: (name) {
              if (name != customer?.name) {
                hasChangedData = true;
              } else {
                hasChangedData = false;
              }
              this.name = name;
            },
          ),
          height(height: 25),
          InputEmail(
            email: customer?.email,
            hint: 'Nhập địa chỉ email',
            changedEmail: (email) {
              if (email != customer?.email) {
                hasChangedData = true;
              } else {
                hasChangedData = false;
              }
              this.email = email;
            },
          ),
          height(height: 25),
          InputPhone(
            phone: customer?.phone,
            hint: 'Nhập số điện thoại',
            changedPhone: (phone) {
              hasChangedData = true;
              if (phone != customer?.phone) {
                hasChangedData = true;
              } else {
                hasChangedData = false;
              }
              this.phone = phone;
            },
          ),
          // height(height: 25),
          // _InputDateOfBirth(
          //   onChangedDate: (dob) {
          //     if (dob != customer?.dob) {
          //       hasChangedData = true;
          //     } else {
          //       hasChangedData = false;
          //     }
          //     dateOfBirth = dob;
          //   },
          //   dateOfBirth: customer?.dob,
          // ),
          height(height: 24),
          _GroupRadioGender(
            gender: customer?.gender,
            changedGender: (gender) {
              if (gender != customer?.gender) {
                hasChangedData = true;
              } else {
                hasChangedData = false;
              }
              this.gender = gender;
            },
          ),
          height(height: 40),
          CustomButtonWidget(
            onTap: () async {
              // if (name.isEmpty || email.isEmpty) return;
              // if (phone != null && phone!.isEmpty) return;
              if (!hasChangedData) return;
              customer = customer!.copyWith(
                name: name,
                email: email,
                phone: phone,
                gender: gender,
              );
              await cubit.updateProfile(customer: customer!);
              hasChangedData = false;
            },
            label: 'Cập nhật',
          )
        ],
      ),
    );
  }

  void _getDataFromRoute(BuildContext context) {
    final arguments = context.route!.settings.arguments;
    if (arguments == null) return context.navigator.pop();
    customer = arguments as User;
    name = customer?.name ?? '';
    email = customer?.email ?? '';
    phone = customer?.phone;
  }

  void showNotification(BuildContext context) {
    context.showCustomDialog(
      height: 160.h,
      barrierColor: Colors.black38,
      canDismiss: false,
      backgroundColor: AppColors.white,
      child: const _CustomUIDialog(
        label: 'Thông báo',
        message:
            "Dữ liệu đã thay đổi chưa được lưu lại, bạn có muốn thoát trang?",
      ),
    );
  }

  void onBack(BuildContext context) {
    if (hasChangedData) {
      showNotification(context);
    } else {
      context.navigator.pop();
    }
  }

  Future<bool> popScreen(BuildContext context) async {
    if (!hasChangedData) {
      return true;
    }
    showNotification(context);
    return false;
  }
}

final _textInputStyle = AppStyles.text.medium(fSize: 14.sp);
