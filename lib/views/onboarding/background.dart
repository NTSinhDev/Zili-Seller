part of 'onboarding_screen.dart';

class _Background extends StatelessWidget {
  final Widget child;
  final Brightness themeMode;
  const _Background({required this.child, required this.themeMode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          themeMode == Brightness.dark ? AppColors.primary : AppColors.white,
      body: SizedBox(
        width: Spaces.screenWidth(context),
        height: Spaces.screenHeight(context),
        child: Stack(
          children: [
            Positioned(
              bottom: 225.h,
              right: -2.w,
              child: SvgPicture.asset(
                AppConstant.svgs.onboarding(themeMode).bgRightMount,
              ),
            ),
            Positioned(
              bottom: 141.h,
              left: 0,
              child: SvgPicture.asset(
                AppConstant.svgs.onboarding(themeMode).bgLeftMount,
              ),
            ),
            Positioned(
              bottom: 31.h,
              right: -4.w,
              child: SvgPicture.asset(
                AppConstant.svgs.onboarding(themeMode).bgBottomMount,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: SvgPicture.asset(
                AppConstant.svgs.onboarding(themeMode).bgBottomRightCoffee,
              ),
            ),
            Positioned(
              bottom: -4,
              left: 162.w,
              child: SvgPicture.asset(
                AppConstant.svgs.onboarding(themeMode).bgBottomCenterCoffee,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: SvgPicture.asset(
                AppConstant.svgs.onboarding(themeMode).bgBottomLeftCoffee,
              ),
            ),
            Positioned(
              bottom: 31.h,
              right: -4.w,
              child: SvgPicture.asset(
                AppConstant.svgs.onboarding(themeMode).bgBottomMount,
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}
