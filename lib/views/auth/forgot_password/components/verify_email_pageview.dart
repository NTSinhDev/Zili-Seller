part of '../forgot_password_screen.dart';

class _VerifyEmailPageView extends StatefulWidget {
  final String email;
  final String message;
  final Function(String) next;
  const _VerifyEmailPageView(
      {required this.next, required this.email, required this.message});

  @override
  State<_VerifyEmailPageView> createState() => _VerifyEmailPageViewState();
}

class _VerifyEmailPageViewState extends State<_VerifyEmailPageView> {
  String code = '';
  final authCubit = di<AuthCubit>();
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      bloc: authCubit,
      listener: (context, state) {
        if (state is ForgotPasswordState) {
          if (state.step == ForgotPasswordSteps.inputNewPassword) {
            widget.next(code);
          } else if (state.step == ForgotPasswordSteps.error) {
            context.showNotificationDialog(
              message: state.message!,
              cancelWidget: Container(),
              action: "Đóng",
            );
          }
        } else if (state is AuthFailedState) {
          context.showNotificationDialog(
            message: state.error.errorMessage,
            cancelWidget: Container(),
            action: "Đóng",
          );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          height(height: 74),
          Text(
            'XÁC NHẬN EMAIL CỦA BẠN',
            style: AppStyles.text.bold(
              fSize: 23.sp,
              color: AppColors.primary,
            ),
          ),
          height(height: 9),
          width(
            width: Spaces.screenWidth(context) - 40.w,
            child: Text(
              widget.message,
              style: AppStyles.text.medium(
                fSize: 14.sp,
                color: AppColors.primary,
                height: 1.18,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          height(height: 26),
          Container(
            padding: EdgeInsets.all(53.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withOpacity(0.1),
            ),
            child: SvgPicture.asset(AppConstant.svgs.icVerifyEmailLarge),
          ),
          height(height: 26),
          width(
            width: Spaces.screenWidth(context) - 164.w,
            child: _VerificationCode(onSubmit: _verifyCode),
          ),
          height(height: 42),
          width(
            width: Spaces.screenWidth(context) - 40.w,
            child: CustomButtonWidget(
              label: 'NHẬP MÃ XÁC NHẬN',
              onTap: () => _verifyCode(code),
            ),
          ),
        ],
      ),
    );
  }

  void _verifyCode(String codeInput) {
    setState(() => code = codeInput);
    authCubit.verifyCode(email: widget.email, code: code);
  }
}

class _VerificationCode extends StatefulWidget {
  final Function(String) onSubmit;
  const _VerificationCode({required this.onSubmit});

  @override
  State<_VerificationCode> createState() => _VerificationCodeState();
}

class _VerificationCodeState extends State<_VerificationCode> {
  late List<FocusNode> focusNodes;
  late List<TextEditingController> controllers;

  @override
  void initState() {
    super.initState();
    focusNodes = List.generate(6, (index) => FocusNode());
    controllers = List.generate(6, (index) => TextEditingController());
  }

  @override
  void dispose() {
    for (var i = 0; i < 6; i++) {
      focusNodes[i].dispose();
      controllers[i].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => focusNodes[0].requestFocus(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          6,
          (index) => _InputCodeField(
            controller: controllers[index],
            node: focusNodes[index],
            onChanged: (value) {
              if (value.isNotEmpty) {
                focusNodes[index].unfocus();
                if (index < 5) {
                  focusNodes[index + 1].requestFocus();
                } else {
                  _submitCode();
                }
              } else if (index > 0) {
                focusNodes[index].unfocus();
                setState(() {
                  controllers[index - 1].text = value;
                });
                focusNodes[index - 1].requestFocus();
              }
            },
          ),
        ),
      ),
    );
  }

  void _submitCode() {
    String code = '';
    for (var i = 0; i < controllers.length; i++) {
      code = '$code${controllers[i].value.text}';
    }
    widget.onSubmit(code);
  }
}

class _InputCodeField extends StatelessWidget {
  final FocusNode node;
  final TextEditingController controller;
  final Function(String) onChanged;
  const _InputCodeField({
    required this.node,
    required this.onChanged,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32.w,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.primary, width: 2.h),
        ),
      ),
      child: RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: (RawKeyEvent event) {
          if (event.runtimeType == RawKeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.backspace) {
            onChanged('');
          }
        },
        child: TextField(
          cursorColor: AppColors.primary,
          onChanged: onChanged,
          focusNode: node,
          controller: controller,
          keyboardType: TextInputType.multiline,
          textAlign: TextAlign.center,
          decoration: const InputDecoration(border: InputBorder.none),
          style: AppStyles.text.semiBold(
            fSize: 23.sp,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
