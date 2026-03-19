part of '../products_screen.dart';

class _CustomScaffold extends StatelessWidget {
  final List<Widget> body;
  final Function(ScrollMetrics metrics) onEndScroll;
  final Future<void> Function() onRefresh;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Function() afterFilter;
  const _CustomScaffold({
    required this.scaffoldKey,
    required this.body,
    required this.onEndScroll,
    required this.onRefresh,
    required this.afterFilter,
  });

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
        key: scaffoldKey,
        endDrawer: _FilterView(callBack: afterFilter),
        body: SizedBox(
          width: Spaces.screenWidth(context),
          height: Spaces.screenHeight(context),
          child: Stack(
            children: [
              const _Appbar(),
              Positioned(
                top: 106.h,
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(31.r),
                  ),
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (scrollNotification) {
                      if (scrollNotification is ScrollEndNotification) {
                        onEndScroll(scrollNotification.metrics);
                      }
                      return true;
                    },
                    child: RefreshIndicator(
                      onRefresh: onRefresh,
                      color: AppColors.primary,
                      child: Scrollbar(
                        radius: Radius.circular(4.r),
                        child: Container(
                          color: AppColors.white,
                          width: Spaces.screenWidth(context),
                          height: Spaces.screenHeight(context) - 106.h,
                          child: SingleChildScrollView(
                            clipBehavior: Clip.none,
                            child: Column(children: body),
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
