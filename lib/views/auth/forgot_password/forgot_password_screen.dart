import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zili_coffee/bloc/auth/auth_cubit.dart';
import 'package:zili_coffee/bloc/auth/auth_state.dart';
import 'package:zili_coffee/di/dependency_injection.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/enums.dart';
import 'package:zili_coffee/utils/extension/build_context.dart';
import 'package:zili_coffee/utils/widgets/widgets.dart';

part 'components/input_email_pageview.dart';
part 'components/create_new_password_pageview.dart';
part 'components/verify_email_pageview.dart';
part 'components/turn_back_to_login.dart';
part 'components/background.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  static String keyName = '/forgot-password';

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final controller = PageController(initialPage: 0);
  String email = '';
  String message = '';
  String code = '';

  bool _showBackButton = true;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final arguments = context.route!.settings.arguments;
    return Scaffold(
      body: GestureDetector(
        onTap: context.focus.unfocus,
        child: SingleChildScrollView(
          child: Stack(
            children: [
              ..._Background.build(),
              SizedBox(
                width: Spaces.screenWidth(context),
                height: Spaces.screenHeight(context),
                child: Column(
                  mainAxisAlignment: .start,
                  crossAxisAlignment: .center,
                  children: [
                    Expanded(
                      child: PageView(
                        controller: controller,
                        pageSnapping: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          _InputEmailPageView(
                            next: (mail, msg) {
                              _showBackButton = false;
                              setState(() {
                                email = mail;
                                message = msg;
                              });
                              controller.jumpToPage(1);
                            },
                          ),
                          _TurnBackToLoginPageView(),
                          _VerifyEmailPageView(
                            email: email,
                            message: message,
                            next: (verifyCode) {
                              setState(() {
                                code = verifyCode;
                              });
                              controller.jumpToPage(2);
                            },
                          ),
                          _CreateNewPasswordPageView(code: code),
                        ],
                      ),
                    ),
                    height(height: 16),
                    if (_showBackButton)
                      RoundedBackBtn(
                        label:
                            'Quay lại ${arguments != null ? arguments as String : ""}',
                        onBack: () => context.navigator.pop(),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
