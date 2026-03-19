import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/data/models/address/location.dart';
import 'package:zili_coffee/data/repositories/auth_repository.dart';
import 'package:zili_coffee/di/dependency_injection.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/enums.dart';
import 'package:zili_coffee/utils/extension/build_context.dart';
import 'package:zili_coffee/utils/widgets/widgets.dart';
import 'package:zili_coffee/views/home/home_screen.dart';

part 'components/form_input.dart';

class FillInStoreinformationScreen extends StatefulWidget {
  const FillInStoreinformationScreen({super.key});

  @override
  State<FillInStoreinformationScreen> createState() =>
      _FillInStoreinformationScreenState();
}

class _FillInStoreinformationScreenState
    extends State<FillInStoreinformationScreen> {
  String storeNamed = '';
  String storeOwner = '';
  String storeRegion = '';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      clipBehavior: Clip.none,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          height(height: 32),
          Container(
            height: 68.h,
            width: Spaces.screenWidth(context),
            alignment: Alignment.topCenter,
            child: storeNamed.isEmpty
                ? Text(
                    'Tạo thông tin cửa hàng',
                    style: AppStyles.text.bold(
                      fSize: 23.sp,
                      color: AppColors.primary,
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Tạo thông tin cửa hàng',
                        style: AppStyles.text.mediumItalic(
                          fSize: 14.sp,
                          color: AppColors.primary.withOpacity(0.6),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10.h, bottom: 20.h),
                        alignment: Alignment.center,
                        child: Text(
                          storeNamed.toUpperCase(),
                          style: AppStyles.text.bold(
                            fSize: 23.sp,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
          _FormInput(
            onInputStoreOwner: (storeOwner) {
              setState(() {
                this.storeOwner = storeOwner;
              });
            },
            onInputStoreNamed: (storeNamed) {
              setState(() {
                this.storeNamed = storeNamed;
              });
            },
            onInputStoreRegion: (Location location) {
              setState(() {
                storeRegion = location.name;
              });
            },
          ),
          height(height: 20),
          CustomButtonWidget(
            label: 'Tạo cửa hàng'.toUpperCase(),
            onTap: () => _createStore(context),
          ),
        ],
      ),
    );
  }

  void _createStore(BuildContext context) {
    context.navigator.pushReplacementNamed(HomeScreen.keyName);
  }
}
