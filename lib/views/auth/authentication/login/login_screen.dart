import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zili_coffee/bloc/auth/auth_cubit.dart';
import 'package:zili_coffee/bloc/auth/auth_state.dart';
import 'package:zili_coffee/di/dependency_injection.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/enums.dart';
import 'package:zili_coffee/utils/enums/user_enum.dart';
import 'package:zili_coffee/utils/extension/build_context.dart';
import 'package:zili_coffee/utils/validator.dart';
// import 'package:zili_coffee/utils/validator.dart';
import 'package:zili_coffee/utils/widgets/widgets.dart';
import 'package:zili_coffee/views/auth/forgot_password/forgot_password_screen.dart';
import 'package:zili_coffee/views/home/home_screen.dart';

import '../../../../app/app_flavor_config.dart';
import '../../../../services/local_storage_service.dart';
part 'components/form_input.dart';
part 'components/social_auth.dart';
part 'components/choose_store.dart';

final _data = [
  {"name_store": "Cửa hàng 01", "host_store": "store-01.zilitea.com"},
  {"name_store": "Cửa hàng 02", "host_store": "store-02.zilitea.com"},
  {"name_store": "Cửa hàng 03", "host_store": "store-03.zilitea.com"},
  {"name_store": "Cửa hàng 04", "host_store": "store-04.zilitea.com"},
];

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static String keyName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? _initialEmail = '';
  String _username = '';
  String _password = '';
  final authCubit = di<AuthCubit>();
  final _localStoreService = di<LocalStoreService>();

  @override
  initState() {
    super.initState();
    if (kDebugMode) {
      _autoFillUsernamePassWordOnDebugMode();
    } else {
      _initialEmail = _localStoreService.lastUsername ?? '';
      _username = _initialEmail!;
    }
  }

  @override
  void didUpdateWidget(LoginScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (kDebugMode) {
      _autoFillUsernamePassWordOnDebugMode();
    }
  }

  /// Note: Please wrap this method in a condition to check if it is in debug mode
  void _autoFillUsernamePassWordOnDebugMode() {
    // _initialEmail = 'dg.nhanviendonggoi@wstore.vn';
    // _initialEmail = 'xkhr.nhanvienkythuat@wstore.vn';
    // _initialEmail = 'nvkd1@yopmail.com';
    _initialEmail = 'tranlieu@wowi.vn';
    _username = _initialEmail!;
    _password = "123456a@";
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      bloc: authCubit,
      listener: (context, state) {
        if (state is AuthProcessingState) {
          context.showLoading(message: 'Đang đăng nhập...');
        } else if (state is AuthReadyState) {
          context
            ..hideLoading()
            ..navigator.pushReplacementNamed(HomeScreen.keyName);
          // ..showBottomSheet(child: const _ChooseStore());
        } else if (state is AuthFailedState) {
          String message;
          if (state.error.statusCode == -1) {
            return context.hideLoading();
          } else if (state.error.apiError ==
              AuthFailedType.notFoundUser.toConstant) {
            message = "Email không tồn tại!";
          } else if (state.error.apiError ==
              AuthFailedType.incorrectPassword.toConstant) {
            message = "Mật khẩu không chính xác!";
          } else {
            message = "Thông tin đăng nhập không hợp lệ!";
          }
          context
            ..hideLoading()
            ..showNotificationDialog(
              title: 'Đăng nhập thất bại',
              message: message,
              cancelWidget: Container(),
              action: "Đóng",
            );
        }
      },
      child: SingleChildScrollView(
        clipBehavior: .none,
        padding: .symmetric(horizontal: 20.w, vertical: 32.h),
        child: Column(
          mainAxisAlignment: .start,
          crossAxisAlignment: .center,
          children: [
            Text(
              'Chào mừng bạn đến với',
              style: AppStyles.text.mediumItalic(
                fSize: 13.sp,
                color: AppColors.primary.withValues(alpha: 0.6),
              ),
            ),
            height(height: 10),
            Text(
              FlavorConfig.instance.env.appName.toUpperCase(),
              style: AppStyles.text.bold(
                fSize: 23.sp,
                color: AppColors.primary,
              ),
            ),
            height(height: 20),
            _FormInput(
              initialEmail: _initialEmail,
              initialPassword: _password,
              onInputEmail: (email) => _username = email,
              onInputPassword: (password) => _password = password,
              login: _handleLogin,
            ),
            height(height: 20),
            CustomButtonWidget(onTap: _handleLogin, label: 'ĐĂNG NHẬP'),
            height(height: 48),
            // _SocialAuthentication(authCubit: authCubit),
            // height(height: 48),
            // const HasAccountView(hasAccount: false),
            // _backToHome(context) ?? Container(),
          ],
        ),
      ),
    );
  }

  void _handleLogin() async {
    if (_username.isEmpty || _password.isEmpty) return;
    await authCubit.login(username: _username, password: _password);
  }

  // Widget? _backToHome(BuildContext context) {
  //   final arguments = context.route!.settings.arguments;
  //   return arguments != null
  //       ? arguments == NavArgsKey.fromRegister
  //           ? null
  //           : RoundedBackBtn(
  //               label: 'Quay lại ${arguments as String}',
  //               onBack: () => context.navigator.pop(),
  //             )
  //       : null;
  // }
}
