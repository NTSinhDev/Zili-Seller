import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/data/models/address/customer_address.dart';
import 'package:zili_coffee/data/models/address/location.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/enums.dart';
import 'package:zili_coffee/utils/widgets/widgets.dart';

extension BuildContextExt on BuildContext {
  static TPLoadingDialog? _loadingDialog;

  Size get size {
    return MediaQuery.sizeOf(this);
  }

  NavigatorState get navigator {
    return Navigator.of(this);
  }

  ModalRoute<dynamic>? get route {
    return ModalRoute.of(this);
  }

  Map<String, dynamic>? get routeArguments {
    return route!.settings.arguments as Map<String, dynamic>;
  }

  FocusScopeNode get focus {
    return FocusScope.of(this);
  }

  // AppLocalizations get localization {
  //   return AppLocalizations.of(this)!;
  // }

  ScaffoldMessengerState get scaffoldMessagerState {
    return ScaffoldMessenger.of(this);
  }

  ThemeData get theme => Theme.of(this);

  void showCustomDialog({
    bool canPhysicalBack = true,
    bool canDismiss = true,
    double? height,
    Color? barrierColor,
    Color? backgroundColor,
    required Widget child,
  }) {
    showDialog(
      context: this,
      barrierDismissible: canDismiss,
      barrierColor: barrierColor,
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.all(0),
        clipBehavior: Clip.hardEdge,
        backgroundColor: backgroundColor,
        content: WillPopScope(
          onWillPop: () async => canPhysicalBack,
          child: SizedBox(
            width: 300.w,
            height: height ?? 400.h,
            child: child,
          ),
        ),
      ),
    );
  }

  void showDialogAddressData({
    required String title,
    required CustomerAddress? address,
    required Stream<List<Location>> stream,
    required Function(Location location) onSelected,
    Widget? child,
  }) {
    Widget addressItem({
      required BuildContext context,
      required Location location,
      required bool isSelected,
    }) {
      return ListTile(
        onTap: () {
          onSelected(location);
          context.navigator.pop();
        },
        title: Text(
          location.name,
          style: isSelected
              ? AppStyles.text.bold(
                  fSize: 14.sp,
                  color: AppColors.primary,
                )
              : AppStyles.text.medium(
                  fSize: 14.sp,
                ),
          textAlign: TextAlign.left,
        ),
        trailing: isSelected
            ? const Icon(
                Icons.check,
                color: AppColors.primary,
              )
            : null,
      );
    }

    bool isSelected(Location location) {
      if (address == null) return false;
      final LocationLevel locationLevel = location.levelEnum;
      final Location? currentLocation =
          locationLevel == LocationLevel.Province_City
              ? address.province
              : locationLevel == LocationLevel.District
                  ? address.district
                  : address.ward;
      if (location == currentLocation) {
        return true;
      }
      return false;
    }

    showDialog(
      context: this,
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.all(0),
        content: SizedBox(
          width: 300.w,
          height: 451.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(4.r),
                  ),
                  border: Border.all(color: AppColors.primary),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppStyles.text.semiBold(
                        fSize: 16.sp,
                        color: AppColors.beige,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      width: 300.w,
                      height: 36.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: AppColors.primary),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.search,
                            color: AppColors.primary,
                            size: 16.sp,
                          ),
                          width(width: 8),
                          Expanded(
                            child: TextField(
                              cursorColor: AppColors.primary,
                              onChanged: (value) {},
                              onSubmitted: (value) {},
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.search,
                              scrollPadding: const EdgeInsets.all(0),
                              textAlign: TextAlign.left,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.all(0),
                                hintText: "Bạn ở tỉnh/thành phố nào?",
                                hintStyle: AppStyles.text.medium(
                                  fSize: 15.sp,
                                  color: AppColors.black24.withOpacity(0.6),
                                ),
                              ),
                              style: AppStyles.text.medium(fSize: 16.sp),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 300.w,
                height: 404.h,
                child: child ??
                    StreamBuilder<List<Location>>(
                      stream: stream,
                      builder: (streamContext, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          );
                        }
                        final locations = snapshot.data!;
                        return ListView.separated(
                          itemCount: locations.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext listContext, int index) {
                            return addressItem(
                              context: context,
                              location: locations[index],
                              isSelected: isSelected(locations[index]),
                            );
                          },
                          separatorBuilder: (context, index) => Divider(
                            color: AppColors.lightGrey,
                            height: 1.h,
                            thickness: 1.sp,
                          ),
                        );
                      },
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showNotificationDialog({
    String? title,
    required String message,
    Widget? cancelWidget,
    String? action,
    Function()? ontap,
    Color? themeColor,
  }) {
    showDialog(
      context: this,
      builder: (BuildContext childContext) {
        return AlertDialog(
          title: title != null
              ? Text(
                  title,
                  style: AppStyles.text.semiBold(
                    fSize: 16.sp,
                    color: themeColor ?? AppColors.primary,
                  ),
                )
              : null,
          content: Text(
            message,
            style: AppStyles.text.medium(
              fSize: title == null ? 14.sp : 12.sp,
              color: AppColors.gray4B,
              height: 1.38,
            ),
          ),
          actions: <Widget>[
            cancelWidget ??
                CustomButtonWidget(
                  onTap: () => childContext.navigator.pop(),
                  width: 80.w,
                  height: 32.h,
                  radius: 4.r,
                  borderColor: AppColors.primary,
                  color: action == null ? AppColors.primary : AppColors.white,
                  boxShadows: const [],
                  child: Center(
                    child: Text(
                      "Hủy",
                      style: AppStyles.text.semiBold(
                        fSize: 12.sp,
                        color: action == null
                            ? AppColors.white
                            : AppColors.primary,
                      ),
                    ),
                  ),
                ),
            if (action != null)
              CustomButtonWidget(
                onTap: () {
                  if (ontap != null) ontap();
                  childContext.navigator.pop();
                },
                width: 80.w,
                height: 32.h,
                radius: 5.r,
                borderColor: themeColor ?? AppColors.primary,
                color: themeColor != null ? AppColors.white : null,
                boxShadows: const [],
                child: Center(
                  child: Text(
                    action,
                    style: AppStyles.text.semiBold(
                      fSize: 12.sp,
                      color: themeColor ?? AppColors.white,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  void showBottomSheet({required Widget child}) {
    showModalBottomSheet(
      context: this,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      enableDrag: true,
      isDismissible: true,
      builder: (_) => child,
    );
  }

  // void showBasicAlert(
  //   String title,
  //   String message, {
  //   TPAlertDialogType? type,
  //   String? button,
  //   VoidCallback? onAction,
  //   bool barrierDismissible = true,
  // }) {
  //   showDialog<dynamic>(
  //     barrierDismissible: barrierDismissible,
  //     context: this,
  //     builder: (BuildContext context) {
  //       return WillPopScope(
  //         child: TPAlertDialog(
  //           type: type ?? TPAlertDialogType.info,
  //           title: title,
  //           message: message,
  //           action: button ?? 'Close',
  //           onAction: onAction,
  //         ),
  //         onWillPop: () async {
  //           return Future<bool>.value(barrierDismissible);
  //         },
  //       );
  //     },
  //   );
  // }

  // void showSnackBarMessage(String title) {
  //   scaffoldMessagerState
  //     ..hideCurrentSnackBar()
  //     ..showSnackBar(
  //       SnackBar(
  //         backgroundColor: AppColors.white,
  //         duration: const Duration(seconds: 5),
  //         padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 4.w),
  //         content: Text(
  //           title,
  //           style: AppStyles.text.medium(fSize: 13.sp),
  //         ),
  //       ),
  //     );
  // }

  void showLoading({String? message}) {
    if (_loadingDialog == null) {
      _loadingDialog = TPLoadingDialog(message: message);
      showDialog<dynamic>(
        context: this,
        builder: (_) => WillPopScope(
          child: _loadingDialog!,
          onWillPop: () {
            return Future<bool>.value(false);
          },
        ),
        barrierDismissible: false,
      );
    }
  }

  void hideLoading() {
    if (_loadingDialog == null) return;
    navigator.pop();
    _loadingDialog = null;
  }
}
