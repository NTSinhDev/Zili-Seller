part of '../change_information_screen.dart';

class _CaffoldScreen extends StatelessWidget {
  final List<Widget> body;
  final Future<bool> Function()? onWillPop;
  final Function()? onBack;
  const _CaffoldScreen({required this.body, this.onWillPop, this.onBack});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBarWidget.lightAppBar(
          context,
          label: 'thông tin cá nhân',
          onBack: onBack,
        ),
        backgroundColor: AppColors.white,
        body: Stack(
          children: [
            Positioned(
              top: 45,
              left: 0,
              child: SvgPicture.asset(AppConstant.svgs.bgScreen),
            ),
            GestureDetector(
              onTap: () => context.focus.unfocus(),
              child: SizedBox(
                width: Spaces.screenWidth(context),
                height: Spaces.screenHeight(context),
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: body,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
