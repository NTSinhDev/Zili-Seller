import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/extension/build_context.dart';
import 'package:zili_coffee/views/auth/authentication/login/login_screen.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.beige,
      body: GestureDetector(
        onTap: () => context.focus.unfocus(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: .only(top: 24.h),
                width: Spaces.screenWidth(context),
                height: 200.h,
                alignment: .center,
                color: AppColors.beige,
                child: Image.asset(AssetLogos.baseLogoPng, width: 220.w),
              ),
              Container(
                width: Spaces.screenWidth(context),
                height: Spaces.screenHeight(context) - 200.h,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: .vertical(top: Radius.circular(26.r)),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0, -1),
                      blurRadius: 20,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: .vertical(top: .circular(26.r)),
                  child: const LoginScreen(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
