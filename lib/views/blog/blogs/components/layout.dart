part of '../blogs_screen.dart';

class _Layout extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final List<Widget> body;
  const _Layout({required this.onRefresh, required this.body});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.white,
      ),
      child: Scaffold(
        body: SizedBox(
          width: Spaces.screenWidth(context),
          height: Spaces.screenHeight(context),
          child: Stack(
            children: [
              _Appbar(),
              Positioned(
                top: 126.h,
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(31.r),
                  ),
                  child: RefreshIndicator(
                    onRefresh: onRefresh,
                    color: AppColors.primary,
                    child: Scrollbar(
                      radius: Radius.circular(4.r),
                      child: Container(
                        color: AppColors.white,
                        width: Spaces.screenWidth(context),
                        height: Spaces.screenHeight(context),
                        child: SingleChildScrollView(
                          clipBehavior: Clip.none,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: body,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
