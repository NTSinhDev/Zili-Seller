import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../res/res.dart';
import 'app_bar.dart';

class BaseScreen extends StatelessWidget {
const BaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: 'Base Screen'),
      backgroundColor: AppColors.background,
      body: Container(),
      bottomNavigationBar: Container(
        padding: .symmetric(vertical: 12.h, horizontal: 20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.08),
              offset: const Offset(0, -1),
              blurRadius: 2,
              spreadRadius: 0,
            )
          ],
        ),
        child: Column(
          mainAxisSize: .min,
          children: [
            // CommonButton(
            //   onTap: () {
            //   },
            //   label: 'OK',
            // ),
          ],
        ),
      ),
    
    );
  }
}