import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/data/repositories/auth_repository.dart';
import 'package:zili_coffee/di/dependency_injection.dart';
import 'package:zili_coffee/res/res.dart';

class HasAccountView extends StatelessWidget {
  final bool hasAccount;
  const HasAccountView({super.key, required this.hasAccount});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final pageIndex = hasAccount ? 0 : 1;
        final AuthRepository authRepository = di<AuthRepository>();
        authRepository.pageViewController.animateToPage(
          pageIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 12.h),
        child: RichText(
          text: TextSpan(
            style: AppStyles.text.medium(
              fSize: 14.sp,
              color: AppColors.primary,
            ),
            children: [
              TextSpan(
                text: hasAccount
                    ? AppConstant.strings.HAS_ACCOUNT
                    : AppConstant.strings.HASNT_ACCOUNT,
              ),
              TextSpan(
                text: hasAccount
                    ? AppConstant.strings.LOGIN
                    : AppConstant.strings.REGISTER,
                style: AppStyles.text.semiBold(
                  fSize: 15 .sp,
                  color: AppColors.primary,
                  height: 1.18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
