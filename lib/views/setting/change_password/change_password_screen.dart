
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zili_coffee/bloc/customer/customer_cubit.dart';
import 'package:zili_coffee/data/repositories/auth_repository.dart';
import 'package:zili_coffee/di/dependency_injection.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/extension/build_context.dart';
import 'package:zili_coffee/utils/widgets/widgets.dart';
import 'package:zili_coffee/views/common/bottom_scaffold_button.dart';
part 'components/screen_scaffold.dart';
part 'components/ui_notification_failed.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});
  static String keyName = '/change-password';

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final AuthRepository _authRepo = di<AuthRepository>();
  String _oldPassword = '';
  String? _validateOldPassword;
  Color _oldPasswordColor = AppColors.black;
  String _newPassword = '';
  String? _validateNewPassword;
  Color _newPasswordColor = AppColors.black;
  String _verifyPassword = '';
  String? _validateVerifyPassword;
  Color _verifyPasswordColor = AppColors.black;

  @override
  Widget build(BuildContext context) {
    final CustomerCubit customerCubit = di<CustomerCubit>();
    return _ScreenScaffold(
      customerCubit: customerCubit,
      listener: (context, state) {
        if (state is WaitingCustomerState) {
          context.showLoading(message: 'Đổi mật khẩu...');
        } else if (state is MessageCustomerState) {
          context
            ..hideLoading()
            ..showCustomDialog(
              height: 140.h,
              barrierColor: Colors.black38,
              canDismiss: false,
              backgroundColor: AppColors.white,
              child: UINotificationProvider.common(
                context,
                title: 'Thành công',
                content: state.message == "Password was changed successfully"
                    ? "Mật khẩu đã được thay đổi!"
                    : state.message,
                leftButton: "Ở lại trang",
                rightButton: "Thoát",
                onTap: () => context.navigator.pop(),
              ),
            );
        } else if (state is FailedCustomerState) {
          context
            ..hideLoading()
            ..showCustomDialog(
              height: 160.h,
              barrierColor: Colors.black38,
              canDismiss: false,
              backgroundColor: AppColors.white,
              child: _UINotificationFailed(state: state),
            );
        }
      },
      onSubmitNewPassword: () {
        if (_oldPassword.isEmpty ||
            _verifyPassword.isEmpty ||
            _newPassword.isEmpty) {
          return;
        }
        customerCubit.changePassword(
          oldPassword: _oldPassword,
          newPassword: _verifyPassword,
        );
      },
      children: [
        CustomInputFieldWidget(
          onChanged: (oldPassword) {
            if (oldPassword.length < 6 || oldPassword.length > 25) {
              _oldPassword = '';
            } else {
              _oldPassword = oldPassword;
            }
            setState(() {
              _validateOldPassword = _handleOldPasswordNotification(
                oldPassword,
              );
              _oldPasswordColor = _handleOldPasswordColor(oldPassword);
            });
            _handleNewPasswordByOldPassword(
              oldPassword: oldPassword,
              newPassword: _newPassword,
            );
          },
          hint: 'Nhập mật khẩu cũ của bạn',
          label: 'Mật khẩu cũ',
          obscure: true,
          customStyleLabel: AppStyles.text.semiBold(fSize: 16.sp),
          customStyleInput: AppStyles.text.medium(
            fSize: 14.sp,
            color: AppColors.grey,
          ),
          notify: _validateOldPassword,
          color: _oldPasswordColor,
        ),
        height(height: 25),
        CustomInputFieldWidget(
          onChanged: (newPassword) {
            if (newPassword.length < 6 || newPassword.length > 25) {
              _newPassword = '';
            } else {
              _newPassword = newPassword;
            }
            _handleNewPasswordByOldPassword(
              oldPassword: _oldPassword,
              newPassword: newPassword,
            );
            _handleVerifyPasswordByNewPassword(
              newPassword: newPassword,
              verifyPassword: _verifyPassword,
            );
          },
          hint: 'Tạo mật khẩu mới cho tài khoản',
          label: 'Mật khẩu mới',
          obscure: true,
          customStyleLabel: AppStyles.text.semiBold(fSize: 16.sp),
          customStyleInput: AppStyles.text.medium(
            fSize: 14.sp,
            color: AppColors.grey,
          ),
          notify: _validateNewPassword,
          color: _newPasswordColor,
        ),
        height(height: 25),
        CustomInputFieldWidget(
          onChanged: (verifyPassword) => _handleVerifyPasswordByNewPassword(
            newPassword: _newPassword,
            verifyPassword: verifyPassword,
          ),
          hint: 'Nhập lại mật khẩu mới để xác nhận',
          label: 'Xác nhận mật khẩu',
          obscure: true,
          customStyleLabel: AppStyles.text.semiBold(fSize: 16.sp),
          customStyleInput: AppStyles.text.medium(
            fSize: 14.sp,
            color: AppColors.grey,
          ),
          notify: _validateVerifyPassword,
          color: _verifyPasswordColor,
        ),
        height(height: Spaces.screenHeight(context) / 2.67),
      ],
    );
  }

  void _handleNewPasswordByOldPassword({
    required String oldPassword,
    required String newPassword,
  }) {
    // _newPassword = newPassword == oldPassword ? '' : newPassword;
    setState(() {
      _validateNewPassword = _handleNewPasswordNotification(newPassword);
      _newPasswordColor = _handleNewPasswordColor(newPassword);
    });
  }

  void _handleVerifyPasswordByNewPassword({
    required String newPassword,
    required String verifyPassword,
  }) {
    if (newPassword.isNotEmpty && verifyPassword != newPassword) {
      _verifyPassword = '';
    } else {
      _verifyPassword = verifyPassword;
    }

    setState(() {
      _validateVerifyPassword = _handleVerifyPasswordNotification(
        verifyPassword,
      );
      _verifyPasswordColor = _handleVerifyPasswordColor(verifyPassword);
    });
  }

  String? _handleOldPasswordNotification(String oldPassword) {
    if (oldPassword.isNotEmpty) {
      if (oldPassword.length < 6) {
        return 'Mật khẩu phải có tối thiểu 6 kí tự!';
      }
      if (oldPassword.length > 25) {
        return 'Mật khẩu có tối đa 25 kí tự!';
      }
    }
    return null;
  }

  Color _handleOldPasswordColor(String oldPassword) {
    if (oldPassword.isNotEmpty) {
      if (oldPassword.length < 6) {
        return AppColors.red;
      }
      if (oldPassword.length > 25) {
        return AppColors.red;
      }
    }
    return AppColors.black;
  }

  String? _handleNewPasswordNotification(String newPassword) {
    if (newPassword.isNotEmpty) {
      // if (newPassword == _oldPassword) {
      //   return 'Mật khẩu mới không được trùng mật khẩu cũ!';
      // }
      if (newPassword.length < 6) {
        return 'Mật khẩu phải có tối thiểu 6 kí tự!';
      }
      if (newPassword.length > 25) {
        return 'Mật khẩu có tối đa 25 kí tự!';
      }
    }
    return null;
  }

  Color _handleNewPasswordColor(String newPassword) {
    if (newPassword.isNotEmpty) {
      // if (newPassword == _oldPassword) {
      //   return AppColors.red;
      // }
      if (newPassword.length < 6) {
        return AppColors.red;
      }
      if (newPassword.length > 25) {
        return AppColors.red;
      }
    }
    return AppColors.black;
  }

  String? _handleVerifyPasswordNotification(String verifyPassword) {
    if (verifyPassword.isNotEmpty && _newPassword.isNotEmpty) {
      if (_verifyPassword != _newPassword) {
        return 'Mật khẩu không trùng khớp!';
      }
    }
    return null;
  }

  Color _handleVerifyPasswordColor(String verifyPassword) {
    if (verifyPassword.isNotEmpty && _newPassword.isNotEmpty) {
      if (_verifyPassword != _newPassword) {
        return AppColors.red;
      }
    }
    return AppColors.black;
  }
}
