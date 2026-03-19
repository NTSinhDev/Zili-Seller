import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/widgets/widgets.dart';
import 'package:zili_coffee/views/voucher/components/voucher.dart';

class VouchersScreen extends StatelessWidget {
  const VouchersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget.lightAppBar(context, label: 'Mã giảm giá'),
      backgroundColor: AppColors.white,
      body: SizedBox(
        width: Spaces.screenWidth(context),
        height: Spaces.screenHeight(context),
        child: Stack(
          children: [
            Positioned(
                top: 45.h,
                left: 0,
                child: SvgPicture.asset(AppConstant.svgs.bgScreen)),
            SingleChildScrollView(
              child: Column(
                children: [
                  Voucher(code: 1234567, expiry: DateTime.now()),
                  Voucher(code: 1234567, expiry: DateTime.now()),
                  Voucher(code: 1234567, expiry: DateTime.now()),
                  Voucher(code: 1234567, expiry: DateTime.now()),
                  Voucher(code: 1234567, expiry: DateTime.now()),
                  Voucher(code: 1234567, expiry: DateTime.now()),
                  Voucher(code: 1234567, expiry: DateTime.now()),
                  Voucher(code: 1234567, expiry: DateTime.now()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
