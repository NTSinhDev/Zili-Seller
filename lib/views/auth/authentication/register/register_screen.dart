import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/bloc/auth/auth_cubit.dart';
import 'package:zili_coffee/bloc/auth/auth_state.dart';
import 'package:zili_coffee/data/repositories/auth_repository.dart';
import 'package:zili_coffee/di/dependency_injection.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/extension/build_context.dart';
// import 'package:zili_coffee/utils/validator.dart';
import 'package:zili_coffee/utils/widgets/widgets.dart';
import 'package:zili_coffee/views/auth/authentication/components/has_account_view.dart';
part 'components/form_input.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  static String keyName = '/register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String _fullName = '';
  String _email = '';
  String _password = '';
  final authCubit = di<AuthCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      bloc: authCubit,
      listener: (context, state) async {
        if (state is AuthProcessingState) {
          context.showLoading(message: 'Đang xử lý...');
        } else if (state is AuthReadyState) {
          final AuthRepository authRepository = di<AuthRepository>();
          context.hideLoading();
          await authRepository.jumpToPageView(pageIndex: 2);
        } else if (state is AuthFailedState) {
          context
            ..hideLoading()
            ..showNotificationDialog(
              message: state.error.errorMessage,
              cancelWidget: Container(),
              action: "Đóng",
            );
        }
      },
      child: SingleChildScrollView(
        clipBehavior: Clip.none,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            height(height: 32),
            Text(
              'Chào mừng bạn đến với',
              style: AppStyles.text.mediumItalic(
                fSize: 13.sp,
                color: AppColors.primary.withOpacity(0.6),
              ),
            ),
            height(height: 10),
            Text(
              'Zili tea'.toUpperCase(),
              style: AppStyles.text.bold(
                fSize: 23.sp,
                color: AppColors.primary,
              ),
            ),
            height(height: 20),
            _FormInput(
              onInputName: (name) => setState(() => _fullName = name),
              onInputEmail: (email) => setState(() => _email = email),
              onInputPassword: (password) => setState(() {
                _password = password;
              }),
              register: _handleRegister,
            ),
            height(height: 20),
            CustomButtonWidget(label: 'ĐĂNG KÝ', onTap: _handleRegister),
            height(height: 40),
            const HasAccountView(hasAccount: true),
          ],
        ),
      ),
    );
  }

  Future<void> _handleRegister() async {
    // if (_fullName.isEmpty || _email.isEmpty || _password.isEmpty) return;
    await authCubit.register(
      fullname: _fullName,
      email: _email,
      password: _password,
    );
  }

  // Widget? _backToHome(BuildContext context) {
  //   final arguments = context.route!.settings.arguments;
  //   return arguments != null
  //       ? arguments == NavArgsKey.fromLogin
  //           ? null
  //           : RoundedBackBtn(
  //               label: 'Quay lại ${arguments as String}',
  //               onBack: () => context.navigator.pop(),
  //             )
  //       : null;
  // }
}
