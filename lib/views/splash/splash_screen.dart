import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../res/assets.dart';
import '../../utils/widgets/widgets.dart';
import '../common/shimmer_view.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          ColumnWidget(
            mainAxisAlignment: .center,
            crossAxisAlignment: .center,
            gap: 20.h,
            children: [
              const SizedBox.shrink(),
              Image.asset(
                AssetLogos.logoLauncherPng,
                width: 1.sw,
                filterQuality: .medium,
              ),
              const ShimmerView(type: .onlyLoadingIndicator),
            ],
          ),
        ],
      ),
    );
  }
}

